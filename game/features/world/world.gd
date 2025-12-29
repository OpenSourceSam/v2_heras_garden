extends Node2D

@onready var inventory_panel: Control = $UI/InventoryPanel
@onready var seed_selector: Control = $UI/SeedSelector
@onready var farm_plots: Node2D = $FarmPlots

var _active_plot: Node = null

func _ready() -> void:
	SceneManager.current_scene = self
	assert(inventory_panel != null, "InventoryPanel missing")
	assert(seed_selector != null, "SeedSelector missing")
	assert(farm_plots != null, "FarmPlots missing")
	inventory_panel.visible = false
	seed_selector.seed_selected.connect(_on_seed_selected)
	seed_selector.cancelled.connect(_on_seed_cancelled)
	_connect_farm_plots()

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
