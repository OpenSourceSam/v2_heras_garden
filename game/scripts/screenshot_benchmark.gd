extends Node

## Screenshot benchmark utility
## Press F9 to capture benchmark screenshots from all locations

var screenshot_locations = [
	{"name": "world_main_map", "pos": Vector2(384, 96)},
	{"name": "scylla_cove", "pos": Vector2(640, 32)},
	{"name": "sacred_grove", "pos": Vector2(200, 150)},  # Approximate
	{"name": "aiaia_house_interior", "pos": Vector2(384, 96)}  # Will need house entry
]

var current_index = 0
var is_capturing = false

func _ready() -> void:
	# Create input action if it doesn't exist
	if not InputMap.has_action("benchmark_screenshots"):
		var input_event = InputEventKey.new()
		input_event.keycode = KEY_F9
		input_event.pressed = true
		InputMap.add_action("benchmark_screenshots")
		InputMap.action_add_event("benchmark_screenshots", input_event)
		print("Created benchmark_screenshots input action: F9")

	print("Screenshot benchmark ready. Press F9 to capture all locations.")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("benchmark_screenshots"):
		_start_benchmark()

func _start_benchmark() -> void:
	if is_capturing:
		print("Benchmark already in progress...")
		return

	is_capturing = true
	current_index = 0
	print("=== Starting Screenshot Benchmark ===")
	_capture_next()

func _capture_next() -> void:
	if current_index >= screenshot_locations.size():
		print("=== Benchmark Complete ===")
		is_capturing = false
		return

	var location = screenshot_locations[current_index]
	print("Capturing [%d/%d]: %s at %s" % [current_index + 1, screenshot_locations.size(), location.name, location.pos])

	# Special case for house interior - need to enter house
	if location.name == "aiaia_house_interior":
		print("House interior requires manual entry - skipping")
		current_index += 1
		await get_tree().create_timer(0.5).timeout
		_capture_next()
		return

	# Teleport and capture
	_teleport_and_capture(location.pos, location.name)

func _teleport_and_capture(pos: Vector2, name: String) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("Player not found")
		return

	# Clear dialogue first
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.visible:
		dialogue_box.hide()

	# Teleport
	player.global_position = pos

	# Wait for scene to settle
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	# Capture
	var viewport = get_viewport()
	var image = viewport.get_texture().get_image()

	# Save to project temp directory
	var project_path = ProjectSettings.globalize_path("res://")
	var screenshots_dir = project_path + "temp/screenshots/"
	DirAccess.make_dir_absolute(screenshots_dir)

	var filename = screenshots_dir + name + ".png"
	var error = image.save_png(filename)

	if error == OK:
		print("  Saved: ", filename)
	else:
		push_error("Failed to save: " + filename)

	# Wait before next capture
	await get_tree().create_timer(1.0).timeout
	current_index += 1
	_capture_next()
