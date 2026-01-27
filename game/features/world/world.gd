extends Node2D

@onready var ui_layer: CanvasLayer = $UI
@onready var inventory_panel: Control = $UI/InventoryPanel
@onready var seed_selector: Control = $UI/SeedSelector
@onready var farm_plots: Node2D = $FarmPlots
@onready var ground: TileMapLayer = $Ground
@onready var quest_markers: Node2D = $QuestMarkers
@onready var boat_marker: Node2D = $QuestMarkers/BoatMarker
@onready var loom_marker: Node2D = $QuestMarkers/LoomMarker
@onready var crafting_controller: Control = get_node_or_null("UI/CraftingController")
@onready var mortar_pestle: Node = get_node_or_null("Interactables/MortarPestle")

const GRASS_SOURCE_ID := 0
const DIRT_SOURCE_ID := 1
const STONE_SOURCE_ID := 2
const WATER_SOURCE_ID := 3
const SAND_SOURCE_ID := 4
const PATH_WIDTH := 2

var _active_plot: Node = null
var _quest_marker_refs: Dictionary = {}

func _ready() -> void:
	SceneManager.current_scene = self
	assert(inventory_panel != null, "InventoryPanel missing")
	assert(seed_selector != null, "SeedSelector missing")
	assert(farm_plots != null, "FarmPlots missing")
	assert(ground != null, "Ground missing")
	assert(quest_markers != null, "QuestMarkers missing")
	assert(boat_marker != null, "BoatMarker missing")
	assert(loom_marker != null, "LoomMarker missing")
	assert(ui_layer != null, "UI layer missing")

	# Play world exploration music
	AudioController.play_music("world_exploration")

	# Cache quest marker references
	for i in range(1, 12):
		var marker = quest_markers.get_node_or_null("Quest%dMarker" % i)
		if marker:
			_quest_marker_refs["quest_%d_active" % i] = marker

	inventory_panel.visible = false
	seed_selector.seed_selected.connect(_on_seed_selected)
	seed_selector.cancelled.connect(_on_seed_cancelled)
	_connect_farm_plots()
	_ensure_crafting_controller()
	_connect_crafting_station()
	_ensure_ground_fill()
	_ensure_papershot_folder()
	if not GameState.flag_changed.is_connected(_on_flag_changed):
		GameState.flag_changed.connect(_on_flag_changed)

	# Connect to dialogue system for quest 1 minigame
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_signal("dialogue_ended"):
		if not dialogue_box.dialogue_ended.is_connected(_on_dialogue_ended):
			dialogue_box.dialogue_ended.connect(_on_dialogue_ended)
	if dialogue_box and dialogue_box.has_signal("dialogue_started"):
		if not dialogue_box.dialogue_started.is_connected(_on_dialogue_started):
			dialogue_box.dialogue_started.connect(_on_dialogue_started)

	_update_quest_markers()

	# Show Aiaia arrival dialogue on first world entry after prologue
	_check_aiaia_arrival()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_inventory"):
		if inventory_panel.visible:
			inventory_panel.close()
		else:
			inventory_panel.open()

func _connect_farm_plots() -> void:
	for plot in farm_plots.get_children():
		if plot.has_signal("seed_requested"):
			plot.seed_requested.connect(_on_seed_requested)

func _ensure_crafting_controller() -> void:
	if crafting_controller:
		return
	var controller_scene = load("res://game/features/ui/crafting_controller.tscn")
	if controller_scene:
		crafting_controller = controller_scene.instantiate()
		crafting_controller.name = "CraftingController"
		ui_layer.add_child(crafting_controller)

func _connect_crafting_station() -> void:
	if not mortar_pestle:
		return
	if not mortar_pestle.has_signal("interacted"):
		return
	if mortar_pestle.interacted.is_connected(_on_mortar_interacted):
		return
	mortar_pestle.interacted.connect(_on_mortar_interacted)

func _ensure_ground_fill() -> void:
	if ground == null or ground.tile_set == null:
		return

	# Expanded map size: -35 to 35 tiles in X, -45 to 45 tiles in Y
	# This gives us room for beach area (bottom), house (center), and expansion areas
	var tile_size := Constants.TILE_SIZE
	var half_w := 35  # 70 tiles wide
	var half_h := 45  # 90 tiles tall

	# Fill with grass first
	for x in range(-half_w, half_w + 1):
		for y in range(-half_h, half_h + 1):
			ground.set_cell(Vector2i(x, y), GRASS_SOURCE_ID, Vector2i.ZERO)

	# Create beach area at the bottom (y > 30)
	_paint_beach_area(-half_w, half_w, 30, half_h)

	# Border frame to define bounds
	var border_margin := 2
	var border_w := half_w - border_margin
	var border_h := half_h - border_margin

	for x in range(-border_w, border_w + 1):
		ground.set_cell(Vector2i(x, -border_h), STONE_SOURCE_ID, Vector2i.ZERO)
		ground.set_cell(Vector2i(x, border_h), WATER_SOURCE_ID, Vector2i.ZERO)  # Water at bottom
	for y in range(-border_h, border_h + 1):
		ground.set_cell(Vector2i(-border_w, y), STONE_SOURCE_ID, Vector2i.ZERO)
		ground.set_cell(Vector2i(border_w, y), STONE_SOURCE_ID, Vector2i.ZERO)

	_paint_paths()
	_paint_titan_battlefield()  # Add Titan battlefield area for pharmaka gathering
	_scatter_ground_detail(half_w, half_h)

func _paint_paths() -> void:
	# Main horizontal path across quest triggers (y=2 tiles).
	_paint_horizontal_path(-8, 16, 2, PATH_WIDTH)
	# Branches to key interactables.
	_paint_vertical_path(-4, 2, -3, PATH_WIDTH) # House door / note
	_paint_vertical_path(4, 2, -1, PATH_WIDTH)  # Boat + sundial
	_paint_vertical_path(6, 2, -2, PATH_WIDTH)  # Loom
	_paint_vertical_path(0, 2, -7, PATH_WIDTH)  # Signpost
	_paint_vertical_path(7, 2, 5, PATH_WIDTH)   # Rock landmark

	# Beach arrival path (from bottom beach to main path)
	# This is the path Circe takes when she first arrives
	_paint_vertical_path(0, 35, 2, PATH_WIDTH)  # Beach to main area
	_paint_horizontal_path(-3, 3, 35, PATH_WIDTH)  # Beach landing area

	# Path to Titan battlefield (western cliffs)
	_paint_horizontal_path(-25, -5, 0, PATH_WIDTH)  # To battlefield
	_paint_vertical_path(-25, 0, -5, PATH_WIDTH)  # Connect to main path

func _paint_horizontal_path(start_x: int, end_x: int, y: int, width: int) -> void:
	var step := 1 if end_x >= start_x else -1
	for x in range(start_x, end_x + step, step):
		for offset in range(width):
			ground.set_cell(Vector2i(x, y + offset), DIRT_SOURCE_ID, Vector2i.ZERO)
		# Path edging for readability.
		ground.set_cell(Vector2i(x, y - 1), STONE_SOURCE_ID, Vector2i.ZERO)
		ground.set_cell(Vector2i(x, y + width), STONE_SOURCE_ID, Vector2i.ZERO)

func _paint_vertical_path(x: int, start_y: int, end_y: int, width: int) -> void:
	var step := 1 if end_y >= start_y else -1
	for y in range(start_y, end_y + step, step):
		for offset in range(width):
			ground.set_cell(Vector2i(x + offset, y), DIRT_SOURCE_ID, Vector2i.ZERO)
		# Path edging for readability.
		ground.set_cell(Vector2i(x - 1, y), STONE_SOURCE_ID, Vector2i.ZERO)
		ground.set_cell(Vector2i(x + width, y), STONE_SOURCE_ID, Vector2i.ZERO)

func _paint_beach_area(start_x: int, end_x: int, beach_y: int, max_y: int) -> void:
	# Create sandy beach area at the bottom of the map
	# Gradient from grass to sand to water
	for y in range(beach_y, max_y + 1):
		# Calculate sand depth (more sand as we go down)
		var sand_depth = y - beach_y

		for x in range(start_x, end_x + 1):
			# Create organic beach edge with some variation
			var noise = abs(int(x * 13 + y * 7)) % 7

			if y > max_y - 5:
				# Water at the very bottom
				ground.set_cell(Vector2i(x, y), WATER_SOURCE_ID, Vector2i.ZERO)
			elif y > max_y - 12:
				# Sand/water mix area
				if noise > 3:
					ground.set_cell(Vector2i(x, y), SAND_SOURCE_ID, Vector2i.ZERO)
				else:
					ground.set_cell(Vector2i(x, y), WATER_SOURCE_ID, Vector2i.ZERO)
			elif sand_depth < 3:
				# Grass/sand transition
				if noise > 2:
					ground.set_cell(Vector2i(x, y), SAND_SOURCE_ID, Vector2i.ZERO)
				else:
					ground.set_cell(Vector2i(x, y), GRASS_SOURCE_ID, Vector2i.ZERO)
			else:
				# Pure sand
				ground.set_cell(Vector2i(x, y), SAND_SOURCE_ID, Vector2i.ZERO)

func _paint_titan_battlefield() -> void:
	# Create ancient Titan battlefield area on western cliffs
	# This is where pharmaka flowers grow (Storyline.md lines 499-521)
	# Located at the western edge (negative x), elevated/cliff area

	var cliff_start_x := -30
	var cliff_end_x := -20
	var cliff_y_start := -10
	var cliff_y_end := 5

	# Create rocky cliff terrain
	for y in range(cliff_y_start, cliff_y_end + 1):
		for x in range(cliff_start_x, cliff_end_x + 1):
			# Mix of stone and some grass for ancient battlefield feel
			var noise = abs(int(x * 7 + y * 11)) % 5
			if noise < 2:
				ground.set_cell(Vector2i(x, y), STONE_SOURCE_ID, Vector2i.ZERO)
			else:
				ground.set_cell(Vector2i(x, y), GRASS_SOURCE_ID, Vector2i.ZERO)

	# Add glowing spots where Titan blood was spilled (pharmaka grows here)
	var num_glowing_spots := 5
	for i in range(num_glowing_spots):
		var spot_x = cliff_start_x + randi() % (cliff_end_x - cliff_start_x)
		var spot_y = cliff_y_start + randi() % (cliff_y_end - cliff_y_start)
		# Create a small glowing area (3x3)
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				var tx = spot_x + dx
				var ty = spot_y + dy
				if tx >= cliff_start_x and tx <= cliff_end_x and ty >= cliff_y_start and ty <= cliff_y_end:
					# Use stone for the glowing earth (pharmaka grows on sacred earth)
					ground.set_cell(Vector2i(tx, ty), STONE_SOURCE_ID, Vector2i.ZERO)

func _scatter_ground_detail(half_w: int, half_h: int) -> void:
	for x in range(-half_w + 1, half_w):
		for y in range(-half_h + 1, half_h):
			if ground.get_cell_source_id(Vector2i(x, y)) != GRASS_SOURCE_ID:
				continue
			var rand_val: int = abs(int(x * 17 + y * 29))
			if rand_val % 173 == 0:
				ground.set_cell(Vector2i(x, y), STONE_SOURCE_ID, Vector2i.ZERO)

func _ensure_papershot_folder() -> void:
	var papershot = get_node_or_null("Papershot")
	if not papershot:
		return
	if not papershot.has_method("get"):
		return
	var folder_path := str(papershot.get("folder"))
	if folder_path.is_empty():
		return
	var abs_path := ProjectSettings.globalize_path(folder_path)
	var err := DirAccess.make_dir_recursive_absolute(abs_path)
	if err != OK:
		push_warning("Failed to create Papershot folder: %s (err=%s)" % [abs_path, err])

func _on_mortar_interacted() -> void:
	if not crafting_controller:
		push_error("CraftingController missing")
		return
	var recipe_id = _resolve_crafting_recipe()
	if recipe_id == "":
		print("No crafting recipe available for current quest state")
		return
	if crafting_controller.has_method("start_craft"):
		crafting_controller.start_craft(recipe_id)

func _on_seed_requested(plot: Node) -> void:
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box != null and dialogue_box.visible:
		return
	_active_plot = plot
	seed_selector.open()

func _on_seed_selected(seed_id: String) -> void:
	if _active_plot and _active_plot.has_method("plant"):
		_active_plot.plant(seed_id)
		GameState.remove_item(seed_id, 1)
	_active_plot = null

func _on_seed_cancelled() -> void:
	_active_plot = null

func _on_flag_changed(_flag: String, _value: bool) -> void:
	_update_quest_markers()

func _update_quest_markers() -> void:
	# Update all quest markers based on active state
	for flag_name: String in _quest_marker_refs:
		var marker = _quest_marker_refs[flag_name]
		var quest_num = flag_name.replace("quest_", "").replace("_active", "").to_int()
		var complete_flag = "quest_%d_complete" % quest_num
		marker.visible = GameState.get_flag(flag_name) and not GameState.get_flag(complete_flag)

	# Boat marker shows for travel quests
	boat_marker.visible = GameState.get_flag("quest_3_active") \
		or GameState.get_flag("quest_5_active") \
		or GameState.get_flag("quest_6_active") \
		or GameState.get_flag("quest_8_active") \
		or GameState.get_flag("quest_9_active") \
		or GameState.get_flag("quest_11_active")

	# Loom marker shows for weaving quest (Quest 7)
	loom_marker.visible = GameState.get_flag("quest_7_active") and not GameState.get_flag("quest_8_complete")

func _resolve_crafting_recipe() -> String:
	if GameState.get_flag("quest_10_active") and not GameState.get_flag("quest_10_complete"):
		return "petrification_potion"
	if GameState.get_flag("quest_8_active") and not GameState.get_flag("quest_8_complete"):
		return "binding_ward"
	if GameState.get_flag("quest_6_active") and not GameState.get_flag("quest_6_complete"):
		return "reversal_elixir"
	if GameState.get_flag("quest_5_active") and not GameState.get_flag("quest_5_complete"):
		return "calming_draught"
	if GameState.get_flag("quest_2_active") and not GameState.get_flag("quest_2_complete"):
		return "moly_grind"
	return ""

func _on_dialogue_ended(dialogue_id: String) -> void:
	# Start herb identification minigame after quest 1 dialogue
	if dialogue_id == "act1_herb_identification":
		_start_herb_identification_minigame("normal")
	# Start saffron herb identification minigame after quest 6 dialogue
	if dialogue_id == "quest6_inprogress":
		_start_herb_identification_minigame("saffron")
	if dialogue_id == "act3_ultimate_crafting":
		_play_divine_blood_cutscene()

func _on_dialogue_started(_dialogue_id: String) -> void:
	if seed_selector.visible:
		seed_selector.close()
	_active_plot = null

func _start_herb_identification_minigame(variant: String = "normal") -> void:
	var minigame_scene = load("res://game/features/minigames/herb_identification.tscn")
	if not minigame_scene:
		push_error("Failed to load herb identification minigame")
		return

	var minigame = minigame_scene.instantiate()

	# Set variant mode (normal or saffron)
	if minigame.has_method("set_variant_mode"):
		minigame.set_variant_mode(variant)

	ui_layer.add_child(minigame)

	# Connect to minigame completion signal
	if minigame.has_signal("minigame_complete"):
		if not minigame.minigame_complete.is_connected(_on_herb_minigame_complete):
			minigame.minigame_complete.connect(_on_herb_minigame_complete)

func _on_herb_minigame_complete(success: bool, items: Array) -> void:
	if success:
		# Check which quest this was for based on items received
		if items.has("saffron"):
			# Quest 6 saffron variant completed
			GameState.set_flag("quest_6_complete", true)
			print("Quest 6 saffron completed! Items awarded: %s" % [items])
		else:
			# Quest 1 normal variant completed
			GameState.set_flag("quest_1_complete", true)
			print("Quest 1 completed! Items awarded: %s" % [items])
	else:
		print("Herb identification minigame failed")

func _play_divine_blood_cutscene() -> void:
	CutsceneManager.play_cutscene("res://game/features/cutscenes/divine_blood_cutscene.tscn")

func _check_aiaia_arrival() -> void:
	# Show arrival dialogue after prologue if not already shown
	if GameState.get_flag("prologue_complete") and not GameState.get_flag("aiaia_arrival_shown"):
		GameState.set_flag("aiaia_arrival_shown", true)

		# Spawn player on beach for first arrival (Storyline: Circe washes up on beach)
		var player = get_tree().get_first_node_in_group("player")
		if player:
			# Beach landing position: x=0, y=35 tiles = (0, 560) pixels
			# This is the sandy beach area at the bottom of the map
			player.global_position = Vector2(0, 560)

		# Use call_deferred to let scene fully initialize
		call_deferred("_show_aiaia_arrival_dialogue")

func _show_aiaia_arrival_dialogue() -> void:
	# Wait for a frame to ensure dialogue system is ready
	await get_tree().process_frame

	var dialogue_manager = get_tree().get_first_node_in_group("dialogue_manager")
	if dialogue_manager and dialogue_manager.has_method("start_dialogue"):
		dialogue_manager.start_dialogue("aiaia_arrival")
	else:
		# Fallback: try to find dialogue box directly
		var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
		if dialogue_box and dialogue_box.has_method("show_dialogue"):
			var dialogue_res = load("res://game/shared/resources/dialogues/aiaia_arrival.tres")
			if dialogue_res:
				dialogue_box.show_dialogue(dialogue_res)

## DEBUG: Teleport player and capture screenshot
## Call this function via MCP eval to capture screenshots from different locations
## Example: get_tree().get_current_scene().debug_capture_screenshot(Vector2(640, 32), "scylla_cove")
func debug_capture_screenshot(player_pos: Vector2, location_name: String) -> String:
	# Find player
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("debug_capture_screenshot: Player not found")
		return ""

	# Teleport player
	player.global_position = player_pos
	print("Teleported to ", location_name, ": ", player_pos)

	# Wait for scene to update
	await get_tree().process_frame
	await get_tree().process_frame

	# Clear any dialogue
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.visible:
		dialogue_box.hide()

	# Capture screenshot
	var viewport = get_viewport()
	var image = viewport.get_texture().get_image()

	# Save to both user data and project temp directory
	var user_dir = OS.get_user_data_dir()
	var screenshots_path = user_dir.path_join("temp").path_join("screenshots")
	DirAccess.make_dir_absolute(screenshots_path)

	var datetime = Time.get_datetime_dict_from_system()
	var timestamp = "%04d%02d%02d_%02d%02d%02d" % [
		datetime.year, datetime.month, datetime.day,
		datetime.hour, datetime.minute, datetime.second
	]
	var filename = screenshots_path + "/screenshot_" + timestamp + ".png"
	var error = image.save_png(filename)

	if error == OK:
		print("Screenshot saved: ", filename)

		# Also copy to project temp directory
		var project_temp = "res://temp/screenshots".replace("res://", ProjectSettings.globalize_path("res://") + "/")
		DirAccess.make_dir_absolute(project_temp)
		var project_filename = project_temp + "/" + location_name + ".png"
		image.save_png(project_filename)
		print("Screenshot copied to: ", project_filename)

		return project_filename
	else:
		push_error("Failed to save screenshot: " + filename)
		return ""
