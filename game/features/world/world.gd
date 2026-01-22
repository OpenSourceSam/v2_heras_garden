extends Node2D

@onready var ui_layer: CanvasLayer = $UI
@onready var inventory_panel: Control = $UI/InventoryPanel
@onready var seed_selector: Control = $UI/SeedSelector
@onready var farm_plots: Node2D = $FarmPlots
@onready var quest_markers: Node2D = $QuestMarkers
@onready var boat_marker: Node2D = $QuestMarkers/BoatMarker
@onready var loom_marker: Node2D = $QuestMarkers/LoomMarker
@onready var crafting_controller: Control = get_node_or_null("UI/CraftingController")
@onready var mortar_pestle: Node = get_node_or_null("Interactables/MortarPestle")

var _active_plot: Node = null
var _quest_marker_refs: Dictionary = {}

func _ready() -> void:
	SceneManager.current_scene = self
	assert(inventory_panel != null, "InventoryPanel missing")
	assert(seed_selector != null, "SeedSelector missing")
	assert(farm_plots != null, "FarmPlots missing")
	assert(quest_markers != null, "QuestMarkers missing")
	assert(boat_marker != null, "BoatMarker missing")
	assert(loom_marker != null, "LoomMarker missing")
	assert(ui_layer != null, "UI layer missing")

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
	if not GameState.flag_changed.is_connected(_on_flag_changed):
		GameState.flag_changed.connect(_on_flag_changed)

	# Connect to dialogue system for quest 1 minigame
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_signal("dialogue_ended"):
		if not dialogue_box.dialogue_ended.is_connected(_on_dialogue_ended):
			dialogue_box.dialogue_ended.connect(_on_dialogue_ended)

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
