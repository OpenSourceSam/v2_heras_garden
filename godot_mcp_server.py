import socket
import json
from mcp.server.fastmcp import FastMCP

# Initialize the MCP Server
mcp = FastMCP("GodotEngine")
GODOT_PORT = 42069

def send_to_godot(payload):
    """Helper to send JSON to the Godot Editor Plugin"""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5.0)  # 5 second timeout
        s.connect(('127.0.0.1', GODOT_PORT))
        s.sendall(json.dumps(payload).encode('utf-8'))
        
        # Wait for response
        response = s.recv(4096 * 4).decode('utf-8')
        s.close()
        return response
    except Exception as e:
        return json.dumps({"error": str(e)})

@mcp.tool()
def get_scene_tree() -> str:
    """Reads the current scene hierarchy from the Godot Editor."""
    return send_to_godot({"action": "get_tree"})

@mcp.tool()
def read_godot_script(path: str) -> str:
    """Reads a script file (e.g., res://src/entities/player.gd)."""
    return send_to_godot({"action": "read_file", "path": path})

@mcp.tool()
def write_godot_script(path: str, content: str) -> str:
    """Overwrites a script file in Godot and triggers a reload."""
    return send_to_godot({"action": "write_file", "path": path, "content": content})

@mcp.tool()
def list_godot_files(path: str = "res://") -> str:
    """Lists files in a Godot directory (e.g., res://src/)."""
    return send_to_godot({"action": "list_files", "path": path})

@mcp.tool()
def run_godot_scene() -> str:
    """Runs the current scene in the Godot Editor."""
    return send_to_godot({"action": "run_scene"})

@mcp.tool()
def stop_godot_scene() -> str:
    """Stops the running scene in the Godot Editor."""
    return send_to_godot({"action": "stop_scene"})

@mcp.tool()
def get_godot_errors() -> str:
    """Gets recent error logs from Godot."""
    return send_to_godot({"action": "get_errors"})

if __name__ == "__main__":
    mcp.run()
