extends SceneTree
## Headless check that MCP action simulation triggers _unhandled_input via InputEventAction.

class_name InputEventProbe

class InputHandlerProbe:
	extends "res://addons/godot_mcp/mcp_input_handler.gd"
	var emit_called := false
	var last_action := ""
	var last_pressed := false

	func _emit_action_event(action_name: String, pressed: bool, _strength: float) -> void:
		emit_called = true
		last_action = action_name
		last_pressed = pressed

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var failed := false

	var handler = InputHandlerProbe.new()
	root.add_child(handler)

	# Simulate an action press via the handler.
	handler._handle_action_press([1, "ui_accept", 1.0])
	await process_frame

	if not handler.emit_called or handler.last_action != "ui_accept" or not handler.last_pressed:
		print("[FAIL] _emit_action_event not invoked for action press")
		failed = true
	else:
		print("[PASS] _emit_action_event invoked for action press")

	handler.queue_free()

	if failed:
		quit(1)
	else:
		quit(0)
