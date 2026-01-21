# MCP PowerShell Wrapper Usage Guide

**For:** Claude IDE Extension Agents (Cursor, VS Code)

## Overview

The MCP PowerShell Wrapper enables Claude IDE extension agents to use godot-mcp CLI commands despite subprocess execution limitations in the extension environment.

## Why This Exists

Different agent types have different tool access:
- **IDE Extension agents** (Cursor, VS Code) cannot use native `mcp__godot__*` tools
- **Terminal agents** can use direct npx CLI commands
- **Claude Desktop** agents have full MCP access

This wrapper bridges the gap for IDE extension agents by providing reliable output capture from npx commands.

## Quick Start

### 1. Check MCP Health
```bash
powershell -File "scripts/mcp-health-check.ps1" -JSON
```

Expected output (healthy):
```json
{"status":"healthy","godot_running":true,"mcp_port_listening":true,"mcp_cli_responsive":true,"game_running":true}
```

### 2. Start Godot with MCP (if needed)
```bash
powershell -ExecutionPolicy Bypass -File ".claude/skills/godot-mcp-dap-start/scripts/ensure_godot_mcp.ps1" -ForceRestart
```

### 3. Use the Wrapper

```bash
# Get project info
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_project_info'"

# Get runtime scene structure
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_runtime_scene_structure' -Quiet"

# Run the game
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'run_project --headed'"
```

## Common Commands

### Project Information
```bash
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_project_info'"
```

### Scene Structure
```bash
# Editor scene
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_editor_scene_structure' -Quiet"

# Runtime scene (game must be running)
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_runtime_scene_structure' -Quiet"
```

### Game Control
```bash
# Run game
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'run_project --headed'"

# Stop game
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'stop_running_project' -Quiet"
```

### Input Simulation
```bash
# Tap a button (ui_accept, ui_cancel, ui_left, ui_right, etc.)
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'simulate_action_tap --action ui_accept'"

# Press and hold
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'simulate_action_press --action ui_left'"

# Release
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'simulate_action_release --action ui_left'"
```

### Editor Script Execution
```bash
# Execute GDScript in editor context
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'execute_editor_script --code GameState.new_game()'"
```

## Tips

### Use Quiet Mode
Suppress "MCP Wrapper:" prefix for cleaner output:
```bash
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_runtime_scene_structure' -Quiet"
```

### Increase Timeout
For long-running operations (default is 30 seconds):
```bash
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'run_project --headed' -TimeoutSec 60"
```

### Parse JSON Output
When using `-JSON` flag with health check:
```bash
$result = powershell -File "scripts/mcp-health-check.ps1" -JSON | ConvertFrom-Json
if ($result.status -eq "healthy") { Write-Host "Ready to proceed!" }
```

## Troubleshooting

### "Connection refused" Error
**Cause:** Godot is not running or MCP addon is not enabled

**Solution:**
```bash
# Start Godot with MCP
powershell -ExecutionPolicy Bypass -File ".claude/skills/godot-mcp-dap-start/scripts/ensure_godot_mcp.ps1"
```

### "Multiple Godot processes detected"
**Cause:** Duplicate Godot instances from previous sessions

**Solution:**
```bash
# Force restart (kills duplicates)
powershell -ExecutionPolicy Bypass -File ".claude/skills/godot-mcp-dap-start/scripts/ensure_godot_mcp.ps1" -ForceRestart
```

### Wrapper Returns Empty Output
**Cause:** Command timed out or failed silently

**Solution:** Increase timeout or check Godot console for errors
```bash
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'YOUR_COMMAND' -TimeoutSec 60"
```

## Known Limitations

### CRITICAL: Quote Escaping Issues

**Problem:** Setting flags with quoted strings causes parse errors:

```bash
# This FAILS:
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'execute_editor_script --code GameState.set_flag(\"met_hermes\", true)'"
# Error: Parse Error: Expected expression.

# This also FAILS:
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'execute_editor_script --code GameState.set_flag('met_hermes', true)'"
# Error: Parse Error: Expected expression.
```

**Root Cause:** PowerShell's Invoke-Expression interprets special characters (quotes, parentheses, etc.) in embedded code strings, causing GDScript to fail parsing.

**Recommended Workarounds:**

1. **Use headless skip scripts** (RECOMMENDED for HPV testing):
   ```bash
   # Run skip script directly with Godot
   ".\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe" --headless --script tests/skip_to_quest2.gd
   ```

2. **Use skip scripts + MCP** (For HPV workflow):
   ```bash
   # Step 1: Run skip script headless to set flags
   ".\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe" --headless --script tests/skip_to_quest3.gd

   # Step 2: Start game with MCP
   powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'run_project --headed'"

   # Step 3: Use MCP for input simulation (button presses, dialogue advance)
   powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'simulate_action_tap --action ui_accept'"
   ```

3. **Use simple expressions only** (works for parameterless methods):
   ```bash
   # This works (no parameters):
   powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'execute_editor_script --code GameState.new_game()'"
   ```

**Skip Script Pattern:**

The project includes tested skip scripts for efficient HPV testing:
- `tests/skip_to_quest2.gd` - Sets flags for Quest 2 (Hermes dialogue)
- `tests/skip_to_quest3.gd` - Sets flags for Quest 3 (Boat to Scylla)

Create additional skip scripts following this pattern for other quests.

### Runtime Expression Access Pattern Unknown

**Problem:** Cannot directly access autoloads via `evaluate_runtime_expression`:

```bash
# All of these FAIL:
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'evaluate_runtime_expression --expression GameState.new_game()'"
# Error: Invalid named index 'GameState' for base type Object

powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'evaluate_runtime_expression --expression root.GameState.new_game()'"
# Error: Invalid named index 'root' for base type Object
```

**Workaround:** Use `execute_editor_script` for simple expressions (works for methods without parameters):

```bash
# This works (no parameters):
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'execute_editor_script --code GameState.new_game()'"
```

### Other Limitations

3. **Subprocess limitations**: Some operations may be slower than direct terminal access.
4. **Nested quotes**: Complex nested quote scenarios (e.g., strings containing quotes) are not handled.

## Agent-Specific Notes

### For Cursor/VSCode Extension Agents
- **USE THIS WRAPPER** for all godot-mcp CLI commands
- Do NOT use `mcp__godot__*` tools (they don't exist in your environment)
- Documentation referencing `mcp__godot__*` tools does not apply to you

### For Terminal Agents (RooCode, GPT Codex)
- **DO NOT USE THIS WRAPPER** (you have direct subprocess access)
- Use direct npx commands: `npx -y godot-mcp-cli@latest <command>`
- You may have access to `mcp__godot__*` tools

### For Claude Desktop Agents
- **DO NOT USE THIS WRAPPER** (you have native MCP access)
- Use native `mcp__godot__*` tools directly
- You also have access to all MCP CLI commands

## File Reference

- **Wrapper script:** [scripts/mcp-wrapper.ps1](scripts/mcp-wrapper.ps1)
- **Health check:** [scripts/mcp-health-check.ps1](scripts/mcp-health-check.ps1)
- **Godot startup:** [.claude/skills/godot-mcp-dap-start/scripts/ensure_godot_mcp.ps1](.claude/skills/godot-mcp-dap-start/scripts/ensure_godot_mcp.ps1)
- **Recovery skill:** [.claude/skills/mcp-recovery/SKILL.md](.claude/skills/mcp-recovery/SKILL.md)

## External References

- **Godot Tools Extension (Cursor/VSCode):** [https://github.com/ankitpriyarup/godot-tools](https://github.com/ankitpriyarup/godot-tools)
  - Provides GDScript language features (syntax highlighting, autocomplete, LSP integration)
  - Debug configurations for Godot projects
  - **Note:** This is an LSP/language server extension, NOT related to MCP tools

- **MCP CLI Package:** [https://github.com/nguyenchiencong/godot-mcp-cli](https://github.com/nguyenchiencong/godot-mcp-cli)
  - Runtime interaction tools for Godot (input simulation, scene inspection)
  - Used by this wrapper for HPV testing

- **Alternative MCP (kooix-godot-mcp):** [https://github.com/telagod/kooix-godot-mcp](https://github.com/telagod/kooix-godot-mcp)
  - Static analysis and code generation for Godot
  - **Not suitable** for runtime HPV testing (no input simulation tools)
