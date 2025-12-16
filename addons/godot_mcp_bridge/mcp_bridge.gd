@tool
extends EditorPlugin

var server = TCPServer.new()
var peers = []
const PORT = 42069 # The port the MCP server will talk to

func _enter_tree():
	var err = server.listen(PORT)
	if err == OK:
		print("🤖 AI Agent Bridge listening on port " + str(PORT))
	else:
		printerr("🤖 Failed to start AI Bridge on port " + str(PORT))

func _exit_tree():
	server.stop()
	for peer in peers:
		peer.disconnect_from_host()

func _process(_delta):
	if server.is_connection_available():
		var peer = server.take_connection()
		peers.append(peer)
		print("🤖 AI Connected!")

	# Process messages
	for peer in peers:
		if peer.get_status() != StreamPeerTCP.STATUS_CONNECTED:
			peers.erase(peer)
			continue
			
		if peer.get_available_bytes() > 0:
			var data = peer.get_utf8_string(peer.get_available_bytes())
			var response = _handle_command(data)
			peer.put_utf8_string(response)

func _handle_command(json_str: String) -> String:
	var json = JSON.new()
	var error = json.parse(json_str)
	if error != OK:
		return JSON.stringify({"error": "Invalid JSON"})
	
	var cmd = json.data
	var result = {}

	match cmd.get("action"):
		"get_tree":
			# Returns the current Scene Tree structure
			result["tree"] = _get_node_structure(get_tree().edited_scene_root)
		
		"read_file":
			var file = FileAccess.open(cmd["path"], FileAccess.READ)
			if file:
				result["content"] = file.get_as_text()
			else:
				result["error"] = "File not found"
			
		"write_file":
			# Writes code directly
			var file = FileAccess.open(cmd["path"], FileAccess.WRITE)
			if file:
				file.store_string(cmd["content"])
				result["status"] = "Saved"
				# Auto-reload the script in the editor
				EditorInterface.get_resource_filesystem().scan()
			else:
				result["error"] = "Write failed"

		"run_scene":
			# Run the current scene
			EditorInterface.play_current_scene()
			result["status"] = "Scene started"
			
		"stop_scene":
			# Stop the running scene
			EditorInterface.stop_playing_scene()
			result["status"] = "Scene stopped"
			
		"get_errors":
			# Get recent console output
			result["logs"] = _get_recent_logs()

		"list_files":
			# List files in a directory
			var path = cmd.get("path", "res://")
			result["files"] = _list_directory(path)

	return JSON.stringify(result)

func _get_node_structure(node: Node) -> Dictionary:
	if not node:
		return {}
	var dict = {"name": node.name, "type": node.get_class(), "children": []}
	for child in node.get_children():
		dict["children"].append(_get_node_structure(child))
	return dict

func _get_recent_logs() -> Array:
	# Note: Full debugger integration requires more setup
	# This is a placeholder that returns available info
	return ["Log capture requires debugger hook - see output panel"]

func _list_directory(path: String) -> Array:
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not file_name.begins_with("."):
				var full_path = path + "/" + file_name
				if dir.current_is_dir():
					files.append({"name": file_name, "type": "directory"})
				else:
					files.append({"name": file_name, "type": "file"})
			file_name = dir.get_next()
	return files
