extends SceneTree
## Headless check for MCP runtime eval wiring.

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var failed := false

	var bridge_text := _read_text("res://addons/godot_mcp/mcp_runtime_debugger_bridge.gd")
	if bridge_text.is_empty():
		print("[FAIL] runtime bridge script missing or unreadable")
		failed = true
	elif bridge_text.find("capture == EVAL_CAPTURE_NAME") == -1:
		print("[FAIL] runtime bridge does not accept mcp_eval captures")
		failed = true
	else:
		print("[PASS] runtime bridge accepts mcp_eval captures")

	var input_text := _read_text("res://addons/godot_mcp/mcp_input_handler.gd")
	if input_text.is_empty():
		print("[FAIL] runtime input handler script missing or unreadable")
		failed = true
	elif input_text.find("register_message_capture(EVAL_CAPTURE_NAME") == -1:
		print("[FAIL] runtime eval handler not registered")
		failed = true
	else:
		print("[PASS] runtime eval handler registered")

	if failed:
		quit(1)
	else:
		quit(0)

func _read_text(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	var text := file.get_as_text()
	file.close()
	return text
