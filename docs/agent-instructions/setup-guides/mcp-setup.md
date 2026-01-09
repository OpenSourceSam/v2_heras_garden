# Godot MCP Setup Guide

## Overview
This project uses **godot-mcp-cli** to enable AI agents (Claude Code, Claude Desktop) to interact with Godot at a deep level for autonomous, iterative testing and development.

## Installation Status
✅ **Addon Installed**: `addons/godot_mcp/`
✅ **Plugin Enabled**: Added to `project.godot`
✅ **VS Code Configuration**: `.vscode/mcp.json` configured

## What is Installed

### Godot MCP CLI (v1.0.9+)
A comprehensive MCP server that provides full Godot project access through the Model Context Protocol.

**Key Capabilities:**
- **Scene & Node Operations**: Full hierarchy inspection, node creation/deletion, property management
- **Debugging Features**: Breakpoint management, execution control (pause/resume/step), call stack inspection
- **Input Simulation**: Keyboard, mouse, and action input with timing control
- **Script Management**: Read, create, edit, attach/detach scripts
- **Debug Output**: Real-time debug output streaming and stack trace capture
- **Project Access**: File enumeration, project info, settings access

### Addon Components
Located in `addons/godot_mcp/`:
- `mcp_debugger_bridge.gd` - Debugging interface with breakpoint support
- `mcp_input_handler.gd` - Input simulation for autonomous testing
- `mcp_debug_output_publisher.gd` - Real-time debug output capture
- `mcp_enhanced_commands.gd` - Extended command set
- `websocket_server.gd` - WebSocket communication layer

## Configuration

### VS Code MCP Configuration
File: `.vscode/mcp.json`

```json
{
  "mcpServers": {
    "godot-mcp": {
      "command": "npx",
      "args": ["-y", "godot-mcp-cli@latest"],
      "env": {
        "MCP_TRANSPORT": "stdio",
        "GODOT_PROJECT_PATH": "C:\\Users\\Sam\\Documents\\GitHub\\v2_heras_garden",
        "DEBUG": "false"
      }
    }
  }
}
```

**Environment Variables:**
- `MCP_TRANSPORT`: Set to `stdio` for VS Code integration
- `GODOT_PROJECT_PATH`: Absolute path to your Godot project
- `DEBUG`: Set to `true` for verbose logging

### Project Configuration
The plugin is enabled in `project.godot`:
```
[editor_plugins]
enabled=PackedStringArray(..., "res://addons/godot_mcp/plugin.cfg")
```

## How to Use

### 1. Start Godot Editor
Open your project in Godot. The MCP addon will automatically start when the editor loads.

### 2. Use with VS Code + Claude Code
With the `.vscode/mcp.json` configured, Claude Code can now:
- Query scene hierarchies
- Modify nodes and properties
- Run the game and capture output
- Set breakpoints and step through code
- Simulate player input for testing
- Read and edit scripts

### 3. Example Agent Workflows

#### Autonomous Testing
```
Agent: "Run the game, simulate pressing 'Space' after 2 seconds, and capture any errors"
- MCP starts the game via `run_project`
- Waits 2000ms
- Sends input action via `simulate_input_action`
- Captures debug output via `get_debug_output`
- Reports results back
```

#### Interactive Debugging
```
Agent: "Set a breakpoint in player.gd at line 45, run the game, and when hit, show me the call stack"
- MCP sets breakpoint via `add_breakpoint`
- Starts game via `run_project`
- Waits for breakpoint hit event
- Retrieves stack via `get_call_stack`
- Displays stack trace
```

#### Scene Modification
```
Agent: "Add a new Label node to the Main scene and set its text to 'Test'"
- MCP opens scene via `open_scene`
- Gets scene root via `get_editor_scene_structure`
- Creates node via `create_node`
- Sets property via `set_node_property`
- Saves scene via `save_current_scene`
```

## Available MCP Tools

### Scene Management
- `get_editor_scene_structure` - Get full scene hierarchy
- `get_runtime_scene_structure` - Get running game's scene tree
- `open_scene` - Open a scene file
- `save_current_scene` - Save active scene
- `create_scene` - Create new scene

### Node Operations
- `create_node` - Create new node
- `delete_node` - Remove node
- `get_node_property` - Read node property
- `set_node_property` - Modify node property
- `reparent_node` - Move node in tree

### Script Handling
- `read_script` - Get script contents
- `create_script` - Create new script
- `edit_script` - Modify script
- `attach_script` - Attach script to node
- `detach_script` - Remove script from node

### Debugging
- `add_breakpoint` - Set breakpoint
- `remove_breakpoint` - Clear breakpoint
- `get_call_stack` - Retrieve stack trace
- `pause_execution` - Pause game
- `resume_execution` - Resume game
- `step_execution` - Step through code

### Input Simulation
- `simulate_input_action` - Trigger input action
- `simulate_key_press` - Press keyboard key
- `simulate_mouse_click` - Click mouse button
- `execute_input_sequence` - Run timed input sequence

### Project Access
- `get_project_info` - Get project metadata
- `list_project_files` - Enumerate files
- `get_project_setting` - Read setting
- `search_files` - Search by pattern

## Testing the Setup

### Quick Test
1. Open Godot Editor with your project
2. In VS Code, ask Claude Code: "Can you see the Godot MCP tools?"
3. Claude should confirm access to godot-mcp tools

### Functional Test
Ask Claude Code to:
```
"Get the structure of the Main scene and tell me what nodes it contains"
```

If working correctly, Claude will use MCP to query the scene and report the hierarchy.

### Integration Test
Ask Claude Code to:
```
"Run the game for 5 seconds, press the 'interact' action after 2 seconds,
then stop the game and show me any debug output"
```

This tests: project execution, input simulation, debug capture, and project control.

## Troubleshooting

### MCP Server Won't Connect
- Ensure Godot is running with your project open
- Check that the plugin is enabled in Project Settings > Plugins
- Verify `GODOT_PROJECT_PATH` matches your actual project path
- Try setting `DEBUG=true` in mcp.json to see detailed logs

### "Missing tool" Errors
- Restart VS Code to reload MCP configuration
- Run `npx -y godot-mcp-cli@latest` manually to ensure it can install
- Check that Node.js version is recent (requires Node 18+)

### Breakpoints Not Working
- Ensure Godot Editor is in debug mode (not release)
- Check that scripts are saved and up-to-date
- Verify breakpoints are in executable code (not comments/empty lines)

### Input Simulation Not Working
- Ensure the action name exists in Project Settings > Input Map
- Check that the game is running when input is sent
- Verify timing - inputs sent too early might be ignored

## Advanced Configuration

### Custom WebSocket Port
The addon uses WebSocket for communication. To change the port, edit `addons/godot_mcp/websocket_server.gd`:
```gdscript
const DEFAULT_PORT = 8080  # Change this
```

### CLI Mode (Token Saving)
For lower context usage, you can use CLI mode instead of direct MCP integration:
```bash
godot-mcp get_editor_scene_structure
godot-mcp simulate_input_action "jump"
```

This is useful for scripted testing workflows outside of AI agent conversations.

## Security Notes

- The MCP server has **full access** to your Godot project
- It can read/write any file, execute code, and modify scenes
- Only use with trusted AI agents
- Review agent actions before confirming destructive operations
- Consider using version control (git) before autonomous testing sessions

## Next Steps

1. **Enable the Plugin**: Open Godot, go to Project > Project Settings > Plugins, and enable "Godot MCP"
2. **Test the Connection**: Use VS Code + Claude Code to verify MCP tools are accessible
3. **Start Testing**: Ask agents to run autonomous test workflows

## Resources

- [godot-mcp-cli GitHub](https://github.com/nguyenchiencong/godot-mcp-cli)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
