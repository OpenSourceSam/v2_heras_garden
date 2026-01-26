extends Node

## Screenshot capture utility
## Press F12 to capture screenshots to temp/screenshots/

const SCREENSHOT_DIR = "user://temp/screenshots/"
const INPUT_ACTION = "screenshot"

func _ready() -> void:
	# Ensure screenshot directory exists
	var user_dir = OS.get_user_data_dir()
	var temp_path = user_dir.path_join("temp")
	var screenshots_path = temp_path.path_join("screenshots")

	# Create directories using absolute paths
	DirAccess.make_dir_absolute(temp_path)
	DirAccess.make_dir_absolute(screenshots_path)

	# Create input action if it doesn't exist
	if not InputMap.has_action(INPUT_ACTION):
		_define_screenshot_input()

	print("Screenshot capture initialized. Press F12 to capture.")
	print("Screenshots will be saved to: ", screenshots_path)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(INPUT_ACTION):
		_capture_screenshot()

func _define_screenshot_input() -> void:
	var input_event = InputEventKey.new()
	input_event.keycode = KEY_F12
	input_event.pressed = true
	InputMap.add_action(INPUT_ACTION)
	InputMap.action_add_event(INPUT_ACTION, input_event)
	print("Created screenshot input action: F12")

func _capture_screenshot() -> void:
	# Get current viewport texture
	var viewport = get_viewport()
	if not viewport:
		push_error("Failed to get viewport for screenshot")
		return

	var texture: ViewportTexture = viewport.get_texture()
	if not texture:
		push_error("Failed to get viewport texture")
		return

	var image: Image = texture.get_image()
	if not image:
		push_error("Failed to get image from viewport texture")
		return

	# Generate timestamp filename
	var datetime = Time.get_datetime_dict_from_system()
	var timestamp = "%04d%02d%02d_%02d%02d%02d" % [
		datetime.year, datetime.month, datetime.day,
		datetime.hour, datetime.minute, datetime.second
	]
	var filename = SCREENSHOT_DIR + "screenshot_" + timestamp + ".png"

	# Save screenshot
	var error = image.save_png(filename)
	if error != OK:
		push_error("Failed to save screenshot: %s" % filename)
	else:
		print("Screenshot saved: %s" % filename)
		print("User path: %s" % OS.get_user_data_dir())
