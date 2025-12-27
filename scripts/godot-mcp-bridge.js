#!/usr/bin/env node
'use strict';

/**
 * Godot MCP Bridge
 * Bridges MCP JSON-RPC over stdio to Godot MCP WebSocket messages.
 */

const fs = require('fs');
const path = require('path');

const GODOT_WS_URL = process.env.GODOT_MCP_WS_URL || 'ws://127.0.0.1:9080';
const RECONNECT_DELAY_MS = 1000;

let WebSocketImpl = global.WebSocket;
if (!WebSocketImpl) {
  try {
    WebSocketImpl = require('ws');
  } catch (err) {
    console.error('[Bridge] WebSocket implementation not found. Install ws or use Node 20+.');
    process.exit(1);
  }
}

let ws = null;
let connected = false;
let reconnectTimer = null;
const pending = new Map();

function sendJsonRpc(message) {
  const payload = JSON.stringify(message);
  const header = `Content-Length: ${Buffer.byteLength(payload, 'utf8')}\r\n\r\n`;
  process.stdout.write(header + payload);
}

function sendError(id, message, code = -32000) {
  sendJsonRpc({
    jsonrpc: '2.0',
    id,
    error: { code, message }
  });
}

function sendResult(id, result) {
  sendJsonRpc({
    jsonrpc: '2.0',
    id,
    result
  });
}

function sendNotification(method, params) {
  sendJsonRpc({
    jsonrpc: '2.0',
    method,
    params
  });
}

function log(message) {
  console.error(`[Bridge] ${message}`);
}

function attachWebSocketHandlers(socket) {
  const onOpen = () => {
    connected = true;
    log('Connected to Godot MCP server');
  };

  const onMessage = (data) => {
    const text = typeof data === 'string' ? data : data.data ? data.data.toString() : data.toString();
    handleGodotMessage(text);
  };

  const onError = (error) => {
    log(`WebSocket error: ${error.message || error}`);
  };

  const onClose = () => {
    if (connected) {
      log('Disconnected from Godot MCP server');
    }
    connected = false;
    failPending('Godot MCP server disconnected');
    scheduleReconnect();
  };

  if (socket.on) {
    socket.on('open', onOpen);
    socket.on('message', onMessage);
    socket.on('error', onError);
    socket.on('close', onClose);
  } else {
    socket.addEventListener('open', onOpen);
    socket.addEventListener('message', onMessage);
    socket.addEventListener('error', onError);
    socket.addEventListener('close', onClose);
  }
}

function connectWebSocket() {
  if (ws && (ws.readyState === WebSocketImpl.OPEN || ws.readyState === WebSocketImpl.CONNECTING)) {
    return;
  }

  ws = new WebSocketImpl(GODOT_WS_URL);
  attachWebSocketHandlers(ws);
}

function scheduleReconnect() {
  if (reconnectTimer) {
    return;
  }
  reconnectTimer = setTimeout(() => {
    reconnectTimer = null;
    connectWebSocket();
  }, RECONNECT_DELAY_MS);
}

function failPending(message) {
  for (const [commandId, rpcId] of pending.entries()) {
    sendError(rpcId, message);
    pending.delete(commandId);
  }
}

function normalizeToolName(name) {
  if (!name) {
    return '';
  }
  let normalized = String(name).trim();
  if (normalized.startsWith('godot__')) {
    normalized = normalized.slice('godot__'.length);
  }
  const separators = ['/', '.', ':'];
  for (const sep of separators) {
    if (normalized.includes(sep)) {
      normalized = normalized.split(sep).pop();
    }
  }
  return normalized;
}

function sendGodotCommand(rpcId, commandType, params) {
  if (!connected || !ws || ws.readyState !== WebSocketImpl.OPEN) {
    sendError(rpcId, 'Godot MCP server not connected');
    return;
  }

  const commandId = `rpc_${rpcId}`;
  pending.set(commandId, rpcId);
  const payload = {
    type: commandType,
    params: params || {},
    commandId
  };

  ws.send(JSON.stringify(payload));
}

function handleGodotMessage(text) {
  let message;
  try {
    message = JSON.parse(text);
  } catch (err) {
    log(`Invalid JSON from Godot: ${text}`);
    return;
  }

  if (message && message.event) {
    sendNotification('notifications/godot_event', message);
    return;
  }

  if (!message || typeof message !== 'object') {
    return;
  }

  const commandId = message.commandId;
  if (!commandId || !pending.has(commandId)) {
    sendNotification('notifications/godot_message', message);
    return;
  }

  const rpcId = pending.get(commandId);
  pending.delete(commandId);

  if (message.status === 'error') {
    sendError(rpcId, message.message || 'Godot MCP error');
    return;
  }

  sendResult(rpcId, message.result || {});
}

function handleRpc(message) {
  if (!message || typeof message !== 'object') {
    return;
  }

  if (message.method === 'initialize') {
    const protocolVersion = (message.params && message.params.protocolVersion) || '2024-11-05';
    sendResult(message.id, {
      protocolVersion,
      capabilities: {
        tools: {}
      },
      serverInfo: {
        name: 'godot-mcp-bridge',
        version: '1.0.0'
      }
    });
    return;
  }

  if (message.method === 'initialized' || message.method === 'notifications/initialized') {
    return;
  }

  if (message.method === 'ping') {
    sendResult(message.id, 'pong');
    return;
  }

  if (message.method === 'tools/list') {
    const tools = getToolList();
    sendResult(message.id, { tools });
    return;
  }

  if (message.method === 'tools/call') {
    const params = message.params || {};
    const toolName = normalizeToolName(params.name);
    if (!toolName) {
      sendError(message.id, 'Missing tool name');
      return;
    }
    sendGodotCommand(message.id, toolName, params.arguments || {});
    return;
  }

  if (message.id !== undefined) {
    sendError(message.id, `Unsupported method: ${message.method}`);
  }
}

function getToolList() {
  const names = new Set();
  const root = process.cwd();
  const addonsRoot = path.join(root, 'addons', 'godot_mcp');

  if (fs.existsSync(addonsRoot)) {
    const files = listGdFiles(addonsRoot);
    for (const file of files) {
      const content = fs.readFileSync(file, 'utf8');
      if (!content.includes('process_command')) {
        continue;
      }
      for (const name of extractCommandNames(content)) {
        names.add(name);
      }
    }
  }

  if (names.size === 0) {
    return [];
  }

  return Array.from(names).sort().map((name) => ({
    name,
    description: `Godot MCP command: ${name}`,
    inputSchema: {
      type: 'object',
      additionalProperties: true
    }
  }));
}

function listGdFiles(rootDir) {
  const results = [];
  const queue = [rootDir];
  while (queue.length) {
    const dir = queue.pop();
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        queue.push(fullPath);
      } else if (entry.isFile() && entry.name.endsWith('.gd')) {
        results.push(fullPath);
      }
    }
  }
  return results;
}

function extractCommandNames(content) {
  const names = new Set();
  const lines = content.split(/\r?\n/);
  let inMatch = false;
  let matchIndent = 0;

  for (const line of lines) {
    const matchStart = line.match(/^(\s*)match\s+command_type\s*:/);
    if (matchStart) {
      inMatch = true;
      matchIndent = matchStart[1].length;
      continue;
    }

    if (!inMatch) {
      continue;
    }

    const trimmed = line.trim();
    if (!trimmed) {
      continue;
    }

    const indent = line.match(/^(\s*)/)[1].length;
    if (indent <= matchIndent) {
      inMatch = false;
      continue;
    }

    const commandMatch = line.match(/^\s*"([^"]+)"\s*:/);
    if (commandMatch) {
      names.add(commandMatch[1]);
    }
  }

  return names;
}

let stdinBuffer = Buffer.alloc(0);

function processStdinBuffer() {
  while (stdinBuffer.length > 0) {
    const headerEnd = stdinBuffer.indexOf('\r\n\r\n');
    if (headerEnd !== -1) {
      const header = stdinBuffer.slice(0, headerEnd).toString('utf8');
      const match = header.match(/Content-Length:\s*(\d+)/i);
      if (!match) {
        log(`Invalid header: ${header}`);
        stdinBuffer = stdinBuffer.slice(headerEnd + 4);
        continue;
      }

      const length = parseInt(match[1], 10);
      const totalLength = headerEnd + 4 + length;
      if (stdinBuffer.length < totalLength) {
        return;
      }

      const body = stdinBuffer.slice(headerEnd + 4, totalLength).toString('utf8');
      stdinBuffer = stdinBuffer.slice(totalLength);
      handleStdioMessage(body);
      continue;
    }

    const newlineIndex = stdinBuffer.indexOf(0x0a);
    if (newlineIndex === -1) {
      return;
    }

    const line = stdinBuffer.slice(0, newlineIndex).toString('utf8').trim();
    stdinBuffer = stdinBuffer.slice(newlineIndex + 1);
    if (line) {
      handleStdioMessage(line);
    }
  }
}

function handleStdioMessage(text) {
  let message;
  try {
    message = JSON.parse(text);
  } catch (err) {
    log(`Invalid JSON-RPC input: ${text}`);
    return;
  }
  handleRpc(message);
}

process.stdin.on('data', (chunk) => {
  stdinBuffer = Buffer.concat([stdinBuffer, chunk]);
  processStdinBuffer();
});

process.stdin.on('end', () => {
  if (ws) {
    ws.close();
  }
  process.exit(0);
});

connectWebSocket();
