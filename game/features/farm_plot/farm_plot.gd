extends Node2D
## Farm Plot Entity
## Manages crop lifecycle: till -> plant -> water -> grow -> harvest
## See docs/execution/ROADMAP.md Task 1.3.2 for full implementation

# ============================================
# ENUMS
# ============================================
enum State { EMPTY, TILLED, PLANTED, GROWING, HARVESTABLE }

# ============================================
# EXPORTS
# ============================================
@export var grid_position: Vector2i = Vector2i.ZERO

# ============================================
# NODE REFERENCES
# ============================================
@onready var soil_sprite: Sprite2D = $SoilSprite
@onready var crop_sprite: Sprite2D = $CropSprite

# ============================================
# SIGNALS
# ============================================
signal seed_requested(plot: Node)

# ============================================
# STATE
# ============================================
var current_state: State = State.EMPTY
var crop_id: String = ""
var planted_day: int = 0
var current_growth_stage: int = 0
var is_watered: bool = false

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	assert(soil_sprite != null, "SoilSprite missing")
	assert(crop_sprite != null, "CropSprite missing")
	add_to_group("farm_plots")
	GameState.day_advanced.connect(_on_day_advanced)
	sync_from_game_state()

# ============================================
# STATE TRANSITIONS
# ============================================

func till() -> void:
	if current_state != State.EMPTY:
		return
	current_state = State.TILLED
	soil_sprite.visible = true
	print("Plot tilled at %s" % grid_position)

func plant(seed_id: String) -> void:
	if current_state != State.TILLED:
		return

	var resolved_crop_id = GameState.get_crop_id_from_seed(seed_id)
	if resolved_crop_id == "":
		push_error("Unknown seed: %s" % seed_id)
		return

	GameState.plant_crop(grid_position, resolved_crop_id)
	sync_from_game_state()
	print("Planted %s at %s" % [resolved_crop_id, grid_position])

func water() -> void:
	if current_state not in [State.PLANTED, State.GROWING]:
		return
	if GameState.farm_plots.has(grid_position):
		GameState.farm_plots[grid_position]["watered_today"] = true
	is_watered = true
	# Visual feedback (sparkles, color change, etc.)
	print("Watered crop at %s" % grid_position)

func advance_growth() -> void:
	sync_from_game_state()

func harvest() -> void:
	if current_state != State.HARVESTABLE:
		return

	GameState.harvest_crop(grid_position)
	current_state = State.TILLED
	sync_from_game_state()
	print("Harvested at %s" % grid_position)

# ============================================
# INTERACTION
# ============================================

func interact() -> void:
	# Called by player interaction system
	match current_state:
		State.EMPTY:
			till()
		State.TILLED:
			# Player needs to select seed from inventory
			# This will be handled by UI later
			seed_requested.emit(self)
		State.PLANTED, State.GROWING:
			water()
		State.HARVESTABLE:
			harvest()

# ============================================
# HELPERS
# ============================================

func _update_crop_sprite() -> void:
	var crop_data = GameState.get_crop_data(crop_id)
	if not crop_data or current_growth_stage >= crop_data.growth_stages.size():
		crop_sprite.visible = false
		return

	crop_sprite.texture = crop_data.growth_stages[current_growth_stage]
	crop_sprite.visible = true

func _on_day_advanced(_new_day: int) -> void:
	sync_from_game_state()

func sync_from_game_state() -> void:
	if not GameState.farm_plots.has(grid_position):
		if current_state == State.TILLED:
			soil_sprite.visible = true
		else:
			current_state = State.EMPTY
			soil_sprite.visible = false
		crop_id = ""
		crop_sprite.visible = false
		return

	var plot_data = GameState.farm_plots[grid_position]
	crop_id = plot_data.get("crop_id", "")
	planted_day = plot_data.get("planted_day", 0)
	current_growth_stage = plot_data.get("current_stage", 0)
	is_watered = plot_data.get("watered_today", false)

	if plot_data.get("ready_to_harvest", false):
		current_state = State.HARVESTABLE
	else:
		current_state = State.GROWING if current_growth_stage > 0 else State.PLANTED

	soil_sprite.visible = true
	_update_crop_sprite()
