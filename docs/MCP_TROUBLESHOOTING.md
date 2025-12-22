# MCP Server Troubleshooting Guide

**For:** AI agents debugging MCP connection issues

---

## Quick Diagnosis

When MCP won't connect, run these checks in order:

### 1. Verify Server Running
```bash
netstat -ano | findstr :9080
```
- **No output** → Server not running. Tell user to start Godot and click "Start" in MCP Server panel
- **Has output** → Server running, proceed to step 2

### 2. Verify Correct Process
```bash
tasklist | findstr <PID>
```
- **Should be:** `Godot_v4.5.1-stable_win64`
- **If different process:** Kill it with `taskkill /PID <PID> /F`, then restart Godot

### 3. Test WebSocket Connection
```bash
curl -v --no-buffer --header "Connection: Upgrade" --header "Upgrade: websocket" --header "Sec-WebSocket-Version: 13" --header "Sec-WebSocket-Key: test" http://127.0.0.1:9080 2>&1 | head -20
```
- **Look for:** `HTTP/1.1 101 Switching Protocols`
- **If present:** Server works. Issue is client-side (VSCode extension needs reload)
- **If missing:** Server broken. Tell user to restart Godot

### 4. Client-Side Fix
If server works but you can't connect:
- Tell user to reload VSCode window (`Ctrl+Shift+P` → "Developer: Reload Window")
- `.mcp.json` must be in project root with correct `godot-mcp-cli` config

---

## Common Issues Junior Engineers Create

1. **Modified MCP addon files** → Reset with `git checkout origin/main -- addons/godot_mcp/`
2. **Sent raw strings instead of JSON-RPC** → Server crashes on handshake
3. **Blocking code in _ready()** → Server can't poll WebSocket
4. **Changed port in panel** → Must match what `godot-mcp-cli` expects (default: 9080)

---

## Quick Fix Script

For persistent issues:
```bash
cd c:\Users\Sam\Documents\GitHub\v2_heras_garden
fix_mcp.bat
```
This kills Godot, clears port 9080, and guides restart.

---

## Default Port

**Always 9080** (not 3000). If user changed it, change it back.
