extends SceneTree
## Headless check for MCP runtime scene dump helper.

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var failed := false

	var handler_script = load("res://addons/godot_mcp/mcp_input_handler.gd")
	if handler_script == null:
		print("[FAIL] MCP input handler script missing")
		quit(1)
		return

	var handler = handler_script.new()
	root.add_child(handler)
	await process_frame

	if not handler.has_method("dump_scene_tree"):
		print("[FAIL] dump_scene_tree() missing on MCP input handler")
		failed = true
	else:
		var result = handler.dump_scene_tree(1)
		if typeof(result) != TYPE_DICTIONARY:
			print("[FAIL] dump_scene_tree() returned non-dictionary")
			failed = true
		elif not result.has("structure"):
			print("[FAIL] dump_scene_tree() missing structure")
			failed = true
		else:
			print("[PASS] dump_scene_tree() returned structure")

	handler.queue_free()
	if failed:
		quit(1)
	else:
		quit(0)
