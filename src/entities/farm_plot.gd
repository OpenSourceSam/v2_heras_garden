extends Node2D
## Farm Plot - Interactive farming plot with crop lifecycle
## See DEVELOPMENT_ROADMAP.md Task 1.3.2

# ============================================
# ENUMS
# ============================================

enum State {EMPTY, TILLED, PLANTED, GROWING, HARVESTABLE}

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
	add_to_group("farm_plots")
	soil_sprite.visible = false
	crop_sprite.visible = false
	print("[FarmPlot] Ready at grid position %s" % grid_position)

# ============================================
# FARMING ACTIONS
# ============================================

func till() -> void:
	if current_state != State.EMPTY:
		return
	current_state = State.TILLED
	soil_sprite.visible = true
	print("[FarmPlot] Tilled at %s" % grid_position)

func plant(seed_id: String) -> void:
	if current_state != State.TILLED:
		print("[FarmPlot] Cannot plant - not tilled")
		return
	
	# Get crop data from GameState
	var crop_data = GameState.get_crop_data(seed_id)
	if not crop_data:
		push_error("[FarmPlot] Unknown crop: %s" % seed_id)
		return
	
	crop_id = crop_data.id
	planted_day = GameState.current_day
	current_state = State.PLANTED
	current_growth_stage = 0
	_update_crop_sprite()
	
	GameState.crop_planted.emit(grid_position, crop_id)
	print("[FarmPlot] Planted %s at %s" % [crop_id, grid_position])

func water() -> void:
	if current_state not in [State.PLANTED, State.GROWING]:
		return
	is_watered = true
	# TODO: Visual feedback (sparkles, color change, etc.)
	print("[FarmPlot] Watered crop at %s" % grid_position)

func advance_growth() -> void:
	if current_state not in [State.PLANTED, State.GROWING]:
		return
	
	var crop_data = GameState.get_crop_data(crop_id)
	if not crop_data:
		return
	
	var days_elapsed = GameState.current_day - planted_day
	var total_stages = crop_data.growth_stages.size()
	
	# Calculate stage based on days
	var stage_index = int(float(days_elapsed) / float(crop_data.days_to_mature) * float(total_stages))
	current_growth_stage = min(stage_index, total_stages - 1)
	
	if days_elapsed >= crop_data.days_to_mature:
		current_state = State.HARVESTABLE
	else:
		current_state = State.GROWING
	
	_update_crop_sprite()
	is_watered = false

func harvest() -> void:
	if current_state != State.HARVESTABLE:
		print("[FarmPlot] Crop not ready to harvest")
		return
	
	var crop_data = GameState.get_crop_data(crop_id)
	if not crop_data:
		return
	
	GameState.add_item(crop_data.harvest_item_id, 1)
	GameState.crop_harvested.emit(grid_position, crop_data.harvest_item_id, 1)
	
	if crop_data.regrows:
		# Reset to growing stage
		planted_day = GameState.current_day
		current_growth_stage = 0
		current_state = State.GROWING
		_update_crop_sprite()
	else:
		# Reset to tilled
		crop_id = ""
		current_state = State.TILLED
		crop_sprite.visible = false
	
	print("[FarmPlot] Harvested at %s" % grid_position)

# ============================================
# INTERACTION
# ============================================

func interact() -> void:
	print("[FarmPlot] Interacted - State: %s" % State.keys()[current_state])
	match current_state:
		State.EMPTY:
			till()
		State.TILLED:
			# Player needs to select seed from inventory
			# This will be handled by UI later
			# For now, auto-plant wheat if available
			if GameState.has_item("wheat_seed"):
				GameState.remove_item("wheat_seed", 1)
				plant("wheat")
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
