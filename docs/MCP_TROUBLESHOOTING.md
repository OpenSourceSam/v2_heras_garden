# MCP Server Troubleshooting Guide

**Last Updated:** 2025-12-22
**For:** Junior Engineers working on Hera's Garden project

---

## Quick Fix: MCP Server Won't Connect

### Symptom
- Client shows "Transport closed" error
- WebSocket connection fails immediately
- MCP panel shows server running but clients can't connect

### Most Common Cause
You accidentally sent raw strings or modified code that blocks the main thread during WebSocket handshake.

### Quick Fix Steps

1. **Check Godot Console** for errors:
   - Open Godot → Output tab → look for WebSocket errors
   - Common error: `WebSocket error: Transport closed`

2. **Restart MCP Server:**
   - Click "MCP Server" tab at bottom of Godot
   - Click "Stop" button
   - Wait 2 seconds
   - Click "Start" button
   - Try connecting again

3. **If Still Broken - Reset to Known Good State:**
   ```bash
   cd c:\Users\Sam\Documents\GitHub\v2_heras_garden
   git stash  # Save your changes
   git checkout docs/code-review-2025-12-18
   git pull
   # Open Godot, wait for MCP to start
   # Test connection
   # If working: git stash pop (restore your changes)
   ```

---

## Common Mistakes That Break MCP

### ❌ MISTAKE 1: Sending Raw Strings Instead of JSON-RPC

**DON'T DO THIS:**
```gdscript
# WRONG - sends raw string "starting"
websocket_server.send_text("starting")
```

**DO THIS:**
```gdscript
# CORRECT - sends proper JSON-RPC notification
var response = {
    "jsonrpc": "2.0",
    "method": "notification",
    "params": {"message": "starting"}
}
websocket_server.send_text(JSON.stringify(response))
```

### ❌ MISTAKE 2: Blocking Main Thread During Handshake

**DON'T DO THIS:**
```gdscript
# WRONG - blocks before handshake completes
func _ready():
    start_server()
    load_heavy_scene()  # Blocks!
```

**DO THIS:**
```gdscript
# CORRECT - defers heavy work
func _ready():
    start_server()
    call_deferred("_load_heavy_scene")

func _load_heavy_scene():
    # Now safe to block
    load("res://heavy_scene.tscn").instantiate()
```

### ❌ MISTAKE 3: Not Calling poll() During Handshake

**DON'T DO THIS:**
```gdscript
# WRONG - forgets to poll websocket
func _ready():
    websocket_server.start_server()
    # ... no poll() call
```

**DO THIS:**
```gdscript
# CORRECT - polls in _process
func _process(_delta):
    if websocket_server:
        websocket_server.poll()
```

---

## How to Check If You Broke MCP

### Before Committing Code:

1. **Test MCP Connection:**
   - Save your changes in Godot
   - Close Godot
   - Reopen Godot
   - Check MCP Server panel shows "Server running"
   - Try connecting from Claude Code CLI
   - If connection fails → you broke it

2. **Check What Changed:**
   ```bash
   git diff addons/godot_mcp/
   ```
   - If you see changes to MCP addon files → you probably broke it
   - If no changes → MCP should still work

3. **Test Checklist:**
   - [ ] Godot opens without errors
   - [ ] MCP Server tab shows "✓ Server running"
   - [ ] Can connect from Claude Code
   - [ ] Can send/receive commands
   - [ ] No "Transport closed" errors

---

## MCP Files You Should NEVER Edit

**DO NOT touch these files unless you're fixing an MCP bug:**

```
addons/godot_mcp/
├── mcp_server.gd          ❌ DO NOT EDIT
├── websocket_server.gd    ❌ DO NOT EDIT
├── command_handler.gd     ❌ DO NOT EDIT
├── mcp_*_commands.gd      ❌ DO NOT EDIT
└── ui/mcp_panel.gd        ❌ DO NOT EDIT
```

**If you need to add MCP commands:**
- Create a NEW file in `addons/godot_mcp/custom_commands.gd`
- Don't modify existing command files

---

## How MCP Server Works (Simple Explanation)

```
1. Godot starts → loads MCP plugin
2. MCP plugin creates WebSocket server on port 3000
3. Server waits for connections
4. Claude Code connects → sends JSON-RPC request
5. MCP server receives → parses JSON → executes command
6. Server responds with JSON-RPC response
7. Connection stays open for more commands
```

**If any step fails → "Transport closed" error**

Common failure points:
- Step 2: Port 3000 already in use
- Step 4: Network/firewall blocking connection
- Step 5: Server sends invalid JSON (most common junior eng mistake!)
- Step 6: Server blocks/crashes during command execution

---

## Detailed Troubleshooting Steps

### Issue: "Transport closed" error

**Step 1: Check Server Status**
```
1. Open Godot
2. Click "MCP Server" tab at bottom
3. Look for "✓ Server running on port 3000"
4. If not running → click "Start"
5. If still fails → check Step 2
```

**Step 2: Check Port Availability**
```bash
# Windows
netstat -ano | findstr :3000

# If you see output → port is in use
# Kill the process using port 3000:
# 1. Note the PID (last number in netstat output)
# 2. taskkill /PID <number> /F
```

**Step 3: Check Godot Console**
```
1. Open Godot → Output tab
2. Look for errors mentioning "WebSocket" or "MCP"
3. Common errors:
   - "Invalid JSON" → you sent raw string (see Mistake #1)
   - "Port in use" → kill existing process (see Step 2)
   - "Connection refused" → firewall blocking (see Step 4)
```

**Step 4: Check Firewall**
```bash
# Windows Firewall - allow Godot:
# 1. Windows Security → Firewall & network protection
# 2. Allow an app through firewall
# 3. Find "Godot" → check Private and Public
# 4. If not in list → click "Allow another app" → browse to Godot.exe
```

**Step 5: Nuclear Option - Restart Everything**
```bash
1. Close Godot
2. Close all terminals/command prompts
3. Restart Windows (yes, really)
4. Open Godot
5. Try again
```

---

## When to Ask for Help

**Ask senior engineer if:**
- You've tried all troubleshooting steps above
- Server still won't start after restart
- You get errors you don't understand
- You accidentally edited MCP plugin files

**Include in your request:**
- What you were doing when it broke
- Error messages from Godot console (copy/paste full error)
- Output of `git diff` showing your changes
- Steps you've already tried

---

## MCP Server Architecture (For Reference)

```
MCPServer (EditorPlugin)
├─ WebSocketServer
│  ├─ start_server()     # Binds to port 3000
│  ├─ poll()             # Processes WebSocket events
│  └─ _process_client()  # Handles incoming messages
│
├─ CommandHandler
│  ├─ _handle_command()  # Parses JSON-RPC
│  └─ _execute_*()       # Runs specific commands
│
└─ MCPPanel (UI)
   ├─ Start/Stop buttons
   └─ Status display
```

**Message Flow:**
```
Client → WebSocket → CommandHandler → Game Code → Response → WebSocket → Client
```

**If response isn't valid JSON-RPC → connection closes immediately**

---

## Known Issues & Workarounds

### Issue: Server starts but clients immediately disconnect

**Cause:** You're sending non-JSON data in response

**Fix:**
1. Find where you added print() or send_text() statements
2. Replace with proper JSON-RPC format (see Mistake #1 example)
3. Restart server

### Issue: Server won't start - "Port already in use"

**Cause:** Previous Godot instance didn't clean up

**Fix:**
```bash
# Kill all Godot processes
taskkill /IM Godot_v4.3-stable_win64.exe /F

# Or restart Windows
```

### Issue: Connection works but commands timeout

**Cause:** Your command is blocking the main thread

**Fix:**
- Use `call_deferred()` for heavy operations
- Use `await` for async operations
- Don't use infinite loops in command handlers

---

## Quick Reference: MCP Command Response Format

**Successful Response:**
```json
{
  "jsonrpc": "2.0",
  "id": 123,
  "result": {
    "success": true,
    "data": "your data here"
  }
}
```

**Error Response:**
```json
{
  "jsonrpc": "2.0",
  "id": 123,
  "error": {
    "code": -32600,
    "message": "Invalid Request"
  }
}
```

**Notification (no response expected):**
```json
{
  "jsonrpc": "2.0",
  "method": "status_update",
  "params": {
    "message": "Operation complete"
  }
}
```

---

## For Senior Engineers: Debugging MCP Issues

If junior engineer has broken MCP and can't fix it:

1. **Check their git diff:**
   ```bash
   git diff addons/godot_mcp/
   ```

2. **Common root causes:**
   - Modified websocket_server.gd send/receive logic
   - Added blocking code in _ready() or _process()
   - Changed JSON-RPC response format
   - Removed poll() call

3. **Quick fix:**
   ```bash
   git checkout origin/main -- addons/godot_mcp/
   # Restore known-good MCP code
   ```

4. **If they need MCP changes:**
   - Create wrapper/extension, don't modify core
   - Use signals to communicate with MCP
   - Test thoroughly before committing

---

## References

- **Phase 4 Prototype Plan:** See section 4.0.0 for MCP protocol requirements
- **MCP Source Code:** `addons/godot_mcp/mcp_server.gd`
- **WebSocket Docs:** https://docs.godotengine.org/en/stable/classes/class_websocketpeer.html

---

**Remember:** If you didn't touch MCP files and it stopped working, try restarting Godot first before debugging!
