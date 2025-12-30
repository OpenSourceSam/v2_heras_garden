class_name InputSimulator
extends Node

## Input simulator for headless AI testing
## Uses Godot's Input singleton for action simulation

## Press and release an action immediately
func press_action(action: String) -> void:
	if not InputMap.has_action(action):
		push_warning("InputSimulator: Unknown action '" + action + "'")
		return
	Input.action_press(action)
	Input.action_release(action)

## Press an action (hold it down)
func hold_action(action: String, duration: float = 0.1) -> void:
	if not InputMap.has_action(action):
		push_warning("InputSimulator: Unknown action '" + action + "'")
		return
	Input.action_press(action)
	await Engine.get_main_loop().create_timer(duration).timeout
	Input.action_release(action)

## Press a key by keycode
func press_key(key_code: Key) -> void:
	var event = InputEventKey.new()
	event.keycode = key_code
	event.pressed = true
	Input.parse_input_event(event)
	event.pressed = false
	Input.parse_input_event(event)

## Move in a direction (-1 to 1 for each axis)
func move_direction(x: float, y: float, duration: float = 0.1) -> void:
	Input.action_press("ui_left") if x < 0 else Input.action_release("ui_left")
	Input.action_press("ui_right") if x > 0 else Input.action_release("ui_right")
	Input.action_press("ui_up") if y < 0 else Input.action_release("ui_up")
	Input.action_press("ui_down") if y > 0 else Input.action_release("ui_down")
	await Engine.get_main_loop().create_timer(duration).timeout
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_up")
	Input.action_release("ui_down")

## Simulate mouse click at screen position
func click_at(position: Vector2) -> void:
	var event = InputEventMouseButton.new()
	event.position = position
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	Input.parse_input_event(event)
	event.pressed = false
	Input.parse_input_event(event)

## Navigate D-pad (useful for menu navigation)
func nav_up() -> void:
	press_action("ui_up")

func nav_down() -> void:
	press_action("ui_down")

func nav_left() -> void:
	press_action("ui_left")

func nav_right() -> void:
	press_action("ui_right")

## Confirm/Select
func confirm() -> void:
	press_action("ui_accept")

## Cancel/Back
func cancel() -> void:
	press_action("ui_cancel")

## Wait for specified duration
func wait(seconds: float) -> void:
	await Engine.get_main_loop().create_timer(seconds).timeout

## Wait for specified number of frames
func wait_frames(frames: int) -> void:
	for i in range(frames):
		await Engine.get_main_loop().process_frame

## Press action multiple times (e.g., navigate menu)
func press_action_times(action: String, count: int, delay: float = 0.1) -> void:
	for i in range(count):
		press_action(action)
		if delay > 0:
			await wait(delay)
