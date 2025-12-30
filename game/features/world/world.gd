extends Node2D

@onready var inventory_panel: Control = $UI/InventoryPanel
@onready var seed_selector: Control = $UI/SeedSelector
@onready var farm_plots: Node2D = $FarmPlots
@onready var quest1_marker: Node2D = $QuestMarkers/Quest1Marker
@onready var quest2_marker: Node2D = $QuestMarkers/Quest2Marker
@onready var boat_marker: Node2D = $QuestMarkers/BoatMarker

var _active_plot: Node = null

func _ready() -> void:
	SceneManager.current_scene = self
	assert(inventory_panel != null, "InventoryPanel missing")
	assert(seed_selector != null, "SeedSelector missing")
	assert(farm_plots != null, "FarmPlots missing")
	assert(quest1_marker != null, "Quest1Marker missing")
	assert(quest2_marker != null, "Quest2Marker missing")
	assert(boat_marker != null, "BoatMarker missing")
	inventory_panel.visible = false
	seed_selector.seed_selected.connect(_on_seed_selected)
	seed_selector.cancelled.connect(_on_seed_cancelled)
	_connect_farm_plots()
	if not GameState.flag_changed.is_connected(_on_flag_changed):
		GameState.flag_changed.connect(_on_flag_changed)
	_update_quest_markers()

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
	quest1_marker.visible = GameState.get_flag("quest_1_active") and not GameState.get_flag("quest_1_complete")
	quest2_marker.visible = GameState.get_flag("quest_2_active") and not GameState.get_flag("quest_2_complete")
	boat_marker.visible = GameState.get_flag("quest_3_active") \
		or GameState.get_flag("quest_5_active") \
		or GameState.get_flag("quest_6_active") \
		or GameState.get_flag("quest_8_active") \
		or GameState.get_flag("quest_9_active") \
		or GameState.get_flag("quest_11_active")
