# Antigravity AI Agent - Addon Capabilities Guide

This document describes the Godot addons available in the project and their capabilities/limitations from the perspective of the **Antigravity AI agent** (the primary coding and testing agent).

## Summary for Other AI Agents

| Addon | Antigravity Can Use | Primary Purpose |
|-------|---------------------|-----------------|
| **AutoLog** | ✅ Full Access | Read game logs after crashes via file |
| **GUT** | ✅ Full Access | Run automated unit tests via CLI |
| **CopperDC** | ⚠️ Limited | In-game console - user must interact |
| **Runtime Debug Tools** | ⚠️ Limited | F11/F12 debug camera - user must trigger |
| **Debug Camera** | ⚠️ Limited | Editor debug camera - visual only |
| **Audio Manager** | ✅ Full Access | Audio playback via GDScript |
| **Godot State Charts** | ✅ Full Access | State machine management via GDScript |
| **Godot MCP Bridge** | ❌ Not Working | TCP bridge fails to connect |
| **Editor Debugger** | ❌ Editor Only | Only works in Godot Editor GUI |

---

## Detailed Addon Documentation

### 1. AutoLog (Custom - `src/autoloads/auto_log.gd`)
**Version:** 1.0 (Custom)  
**Status:** ✅ FULLY FUNCTIONAL

**Description:**  
Custom logging autoload that writes all game events to `user://agent_log.txt`. Created specifically for Antigravity AI debugging.

**How Antigravity Uses It:**
```powershell
# Read logs after game session
type "C:\Users\Sam\AppData\Roaming\Godot\app_userdata\Hera's Garden\agent_log.txt"
```

**Features:**
- Logs game start/end timestamps
- Tracks player position every 2 seconds
- Logs node additions for key entities
- `log_info()`, `log_error()`, `log_warning()`, `log_debug()`, `log_event()` methods

**Limitations:**
- File may not exist if game crashes before `_ready()` completes
- Cannot capture Godot engine-level crashes

---

### 2. GUT - Godot Unit Testing (`addons/gut/`)
**Version:** 9.5.0  
**Status:** ✅ FULLY FUNCTIONAL

**Description:**  
Industry-standard unit testing framework for Godot. Runs GDScript tests.

**How Antigravity Uses It:**
```powershell
# Run all tests (headless mode)
.\Godot.exe --path . --headless -s addons/gut/gut_cmdln.gd

# Run specific test file
.\Godot.exe --path . --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_game_state.gd
```

**Features:**
- Full unit test framework with assertions
- Test discovery in `tests/unit/` and `tests/integration/`
- JSON output for test results
- Supports `before_each`, `after_each`, `before_all`, `after_all`

**Limitations:**
- Tests sometimes hang in headless mode (requires manual termination)
- Output is truncated in console - use JSON results file instead
- GUI mode requires user interaction

**Test Results Location:**
```
C:\Users\Sam\AppData\Roaming\Godot\app_userdata\Hera's Garden\test_results\results.json
```

---

### 3. CopperDC - Debug Console (`addons/copper_dc/`)
**Version:** 1.2.0  
**Status:** ⚠️ LIMITED USE

**Description:**  
In-game debug console for executing commands at runtime.

**How Antigravity Uses It:**
- Cannot directly interact (requires user keyboard input in-game)
- Can create custom commands in GDScript that run automatically
- Useful for user-triggered debugging

**Features:**
- In-game command line interface
- Custom command registration
- Runtime scene navigation

**Limitations:**
- **Antigravity CANNOT type in the console** - user must interact
- No remote command execution
- Only works when game is running

---

### 4. Runtime Debug Tools (`addons/runtime_debug_tools/`)
**Version:** 1.2.0  
**Status:** ⚠️ LIMITED USE

**Description:**  
Debug camera and object picker for inspecting live scenes.

**Hotkeys:**
- **F11** - Toggle 2D debug mode
- **F12** - Toggle 3D debug mode

**Features:**
- In-game debug camera navigation
- Object picking (click to select)
- Visual highlighting of selected nodes
- Collision shape visualization
- Wireframe mode

**Limitations:**
- **Antigravity CANNOT trigger hotkeys** - user must press F11/F12
- Selection feedback requires visual inspection
- Some features rely on undocumented Godot internals

---

### 5. Debug Camera (`addons/debug_camera/`)
**Version:** 1.2  
**Status:** ⚠️ LIMITED USE

**Description:**  
Alternative debug camera for in-game visualization.

**Limitations:**
- Similar to Runtime Debug Tools
- Requires user interaction
- Visual output not accessible to Antigravity

---

### 6. Audio Manager (`addons/audio_manager/`)
**Version:** 2.0.1  
**Status:** ✅ FULLY FUNCTIONAL

**Description:**  
Centralized audio management for AudioStreamPlayer, AudioStreamPlayer2D, and AudioStreamPlayer3D.

**How Antigravity Uses It:**
- Configure audio resources in GDScript
- Call playback functions programmatically

**Features:**
- Omnidirectional audio (AudioStreamPlayer)
- 2D/3D spatial audio support
- Audio bus management

**Limitations:**
- None for code-based usage
- Audio output requires device speakers (cannot verify programmatically)

---

### 7. Godot State Charts (`addons/godot_state_charts/`)
**Version:** 0.22.2  
**Status:** ✅ FULLY FUNCTIONAL

**Description:**  
Hierarchical state machine library for complex game logic.

**How Antigravity Uses It:**
- Create state chart nodes in scenes
- Transition between states via GDScript

**Features:**
- Hierarchical state machines
- Parallel states
- History states
- Guard conditions
- Transition events

**Limitations:**
- Visual editor requires user interaction
- State chart debugging is visual (cannot analyze programmatically)

---

### 8. Godot MCP Bridge (`addons/godot_mcp_bridge/`)
**Version:** 1.0 (Custom)  
**Status:** ❌ NOT WORKING

**Description:**  
Custom TCP bridge for AI agent communication with Godot Editor.

**Intended Use:**
- Direct scene tree queries
- Live script editing
- Scene control (run/stop)

**Current Issues:**
- Antigravity MCP extension fails to connect
- Python server works but Antigravity doesn't recognize the server name
- Requires further configuration or alternative approach

**Workaround:**
- Use AutoLog instead for post-hoc debugging
- Use GUT for automated testing

---

### 9. Editor Debugger (`addons/zylann.editor_debugger/`)
**Version:** 0.3  
**Status:** ❌ EDITOR ONLY

**Description:**  
Tools to inspect the Godot Editor itself.

**Limitations:**
- Only works within Godot Editor GUI
- Not accessible to Antigravity
- Useful for editor plugin development only

---

### 10. Debug Console (`addons/debug_console/`)
**Version:** Unknown  
**Status:** ⚠️ LIMITED USE

**Description:**  
Alternative debug console (may overlap with CopperDC).

**Limitations:**
- Requires user interaction
- Similar constraints to CopperDC

---

## Recommended Workflow for Antigravity AI

### For Testing:
1. Run GUT tests via CLI: `.\Godot.exe --headless -s addons/gut/gut_cmdln.gd`
2. Read results from `user://test_results/results.json`

### For Debugging:
1. Launch game: `.\Godot.exe --path .`
2. Wait for user to reproduce issue
3. Read AutoLog: `type "...app_userdata\Hera's Garden\agent_log.txt"`

### For Development:
1. Modify GDScript files directly
2. Run tests to verify changes
3. Read console output for errors

---

## Known Issues

| Issue | Workaround |
|-------|------------|
| MCP Bridge not connecting | Use AutoLog + GUT instead |
| GUT tests hang | Use 30s timeout and terminate |
| AutoLog file path varies | Check both "Hera's Garden" and "HerasGarden" folders |
| Debug tools require user | Request user to press F11/F12 |

---

## File Locations

| Resource | Path |
|----------|------|
| GUT Config | `.gutconfig.json` |
| Test Results | `user://test_results/results.json` |
| AutoLog Output | `user://agent_log.txt` |
| Screenshots | `user://test_screenshots/` |
| Godot User Data | `C:\Users\Sam\AppData\Roaming\Godot\app_userdata\Hera's Garden\` |

---

*Document created by Antigravity AI Agent - December 2024*

---

## Appendix: MCP Bridge Troubleshooting Chronology

This section documents all attempts to establish a working MCP (Model Context Protocol) connection between the Antigravity AI agent and the Godot project. This information is provided for other AI agents (Claude Code, Gemini Review) to understand the limitations and what has already been tried.

### What is MCP?

MCP (Model Context Protocol) is a standardized way for AI agents to communicate with external tools and services. The goal was to establish a direct connection between Antigravity and the Godot Editor to enable:
- Real-time scene tree queries
- Live script reading/writing
- Game execution control (run/stop)
- Error log streaming

### Attempt Timeline

---

#### Attempt 1: MCP4Humans VS Code Extension Configuration
**Date:** December 15, 2024  
**Approach:** Configure `mcp_config.json` to use `godot-mcp-cli` npm package

**Configuration Tried:**
```json
{
    "mcpServers": {
        "godot": {
            "command": "npx",
            "args": ["-y", "godot-mcp-cli"]
        }
    }
}
```

**Error Received:**
```
CORTEX_STEP_TYPE_LIST_RESOURCES: server name godot not found
```

**Analysis:** The `godot-mcp-cli` package either doesn't exist or isn't compatible with the expected MCP protocol version.

---

#### Attempt 2: godot-mcp npm Package
**Date:** December 15, 2024  
**Approach:** Try alternative npm package `godot-mcp`

**Configuration Tried:**
```json
{
    "mcpServers": {
        "godot": {
            "command": "npx",
            "args": ["-y", "godot-mcp"]
        }
    }
}
```

**Error Received:**
```
Invalid character in JSON output
```

**Analysis:** The package was outputting Godot console text (engine initialization messages) which corrupted the JSON communication protocol. The package expects clean stdio but Godot outputs debug info.

---

#### Attempt 3: Custom Godot Editor Plugin + Python MCP Server
**Date:** December 16, 2024  
**Approach:** Create custom solution with two components:
1. **Godot Editor Plugin** (`addons/godot_mcp_bridge/`) - TCP server on port 42069
2. **Python MCP Server** (`godot_mcp_server.py`) - Bridge between Antigravity and Godot

**Files Created:**
- `addons/godot_mcp_bridge/plugin.cfg`
- `addons/godot_mcp_bridge/mcp_bridge.gd`
- `godot_mcp_server.py`

**Godot Plugin Code (mcp_bridge.gd):**
```gdscript
@tool
extends EditorPlugin

var server = TCPServer.new()
const PORT = 42069

func _enter_tree():
    var err = server.listen(PORT)
    if err == OK:
        print("🤖 AI Agent Bridge listening on port " + str(PORT))
```

**Python MCP Server:**
```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Godot Bridge")

@mcp.tool()
def get_scene_tree() -> str:
    return send_to_godot({"action": "get_tree"})
```

**Steps Completed:**
1. ✅ Installed Python `mcp` library via `pip install mcp`
2. ✅ Created Godot plugin - successfully shows "🤖 AI Agent Bridge listening on port 42069"
3. ✅ Created Python MCP server script
4. ❌ Antigravity still cannot connect

**Configuration Tried:**
```json
{
    "mcpServers": {
        "godot": {
            "command": "python",
            "args": ["C:/Users/Sam/Documents/GitHub/v2_heras_garden/godot_mcp_server.py"]
        }
    }
}
```

**Error Received:**
```
CORTEX_STEP_TYPE_LIST_RESOURCES: server name godot not found
```

---

#### Attempt 4: Full Path to Python Executable
**Date:** December 16, 2024  
**Approach:** Use absolute path to Python 3.13 since PATH issues were suspected

**Discovery:** Multiple Python versions installed:
- Python 3.11 at `C:\Users\Sam\AppData\Local\Microsoft\WindowsApps\python.exe`
- Python 3.13 at `C:\Python313\python.exe` (where `mcp` was installed)

**Configuration Tried:**
```json
{
    "mcpServers": {
        "godot": {
            "command": "C:/Python313/python.exe",
            "args": ["C:/Users/Sam/Documents/GitHub/v2_heras_garden/godot_mcp_server.py"]
        }
    }
}
```

**Result:**
- Manual test of Python script: ✅ Works (script starts without error)
- MCP panel refresh: ❌ Still not recognized
- Full Antigravity restart: ❌ Still returns "server name godot not found"

---

#### Attempt 5: Verify Python Script Execution
**Date:** December 16, 2024  
**Approach:** Manually run Python script to confirm it works

**Command Run:**
```powershell
C:\Python313\python.exe godot_mcp_server.py --help
```

**Result:** Script starts (doesn't respond to --help because it's a server), but when terminated shows proper stack trace indicating the `mcp` library is loaded correctly.

---

### Root Cause Analysis

After multiple attempts, the following issues were identified:

1. **Antigravity MCP Extension Limitation:**
   - The MCP extension in Antigravity may have specific requirements for server registration
   - The `list_resources` tool consistently returns "server name godot not found"
   - This suggests the server is either not starting or not registering correctly

2. **Possible Causes:**
   - MCP server startup timing issue
   - Antigravity expects a specific MCP protocol version
   - Configuration file location may be incorrect
   - Python server may need to be started before Antigravity launches

3. **PATH Issues:**
   - pip installed packages to Python 3.13 user directory
   - Warning: "Scripts is not on PATH"
   - Using absolute paths did not resolve the issue

---

### What Works vs What Doesn't

| Component | Status | Notes |
|-----------|--------|-------|
| Godot Plugin (TCPServer) | ✅ Works | Shows "listening on port 42069" |
| Python MCP Server | ✅ Works | Script executes without errors |
| pip mcp library | ✅ Installed | Python 3.13 has the package |
| mcp_config.json | ❓ Unknown | File exists but may not be read |
| Antigravity MCP Recognition | ❌ Fails | Always "server name godot not found" |

---

### Workarounds Implemented

Since MCP direct connection is not working, the following alternatives were implemented:

1. **AutoLog Autoload** (`src/autoloads/auto_log.gd`)
   - Writes logs to `user://agent_log.txt`
   - Antigravity can read file after game sessions
   - Captures game events, errors, player position

2. **GUT Command-Line Testing**
   - Run tests via: `.\Godot.exe --headless -s addons/gut/gut_cmdln.gd`
   - Read results from JSON file
   - Provides automated verification without MCP

3. **Console Output Capture**
   - Run game with console: `.\Godot.exe --path . 2>&1`
   - Monitor output via `command_status` tool
   - Limited but functional for error detection

---

### Files Related to MCP Attempts

| File | Purpose | Status |
|------|---------|--------|
| `addons/godot_mcp_bridge/plugin.cfg` | Plugin definition | ✅ Created |
| `addons/godot_mcp_bridge/mcp_bridge.gd` | TCP server | ✅ Created |
| `godot_mcp_server.py` | Python MCP bridge | ✅ Created |
| `C:\Users\Sam\.gemini\antigravity\mcp_config.json` | Antigravity config | ✅ Updated |

---

### Recommendations for Future Attempts

1. **Check MCP Protocol Version:**
   - Verify what MCP version Antigravity expects
   - Ensure Python `mcp` library matches

2. **Debug Antigravity Side:**
   - Check if there are logs for MCP server startup
   - Verify config file is being read from correct location

3. **Alternative Approach:**
   - Consider WebSocket instead of stdio for communication
   - Create an HTTP API that Antigravity can query

4. **User Action Required:**
   - May need to contact Antigravity support for MCP documentation
   - Different config file location may be needed

---

*Last updated: December 16, 2024 by Antigravity AI Agent*
