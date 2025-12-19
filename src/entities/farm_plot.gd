extends Node2D
## Farm Plot Entity
## Manages crop lifecycle: till → plant → water → grow → harvest
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
# TODO (Task 1.3.2): Add @onready references after scene structure verified
# @onready var soil_sprite: Sprite2D = $SoilSprite
# @onready var crop_sprite: Sprite2D = $CropSprite

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
	# TODO (Task 1.3.2): Initialize visual state
	pass

# ============================================
# STATE TRANSITIONS
# ============================================

func till() -> void:
	# TODO (Task 1.3.2): Implement tilling
	# - Check if state is EMPTY
	# - Change to TILLED state
	# - Show soil sprite
	# - Print debug message
	pass

func plant(seed_id: String) -> void:
	# TODO (Task 1.3.2): Implement planting
	# - Check if state is TILLED
	# - Get crop data from GameState.get_crop_data(seed_id)
	# - Store crop_id and planted_day
	# - Change to PLANTED state
	# - Update crop sprite
	# - Emit GameState.crop_planted signal
	pass

func water() -> void:
	# TODO (Task 1.3.2): Implement watering
	# - Check if state is PLANTED or GROWING
	# - Set is_watered = true
	# - Show visual feedback (sparkles, color change)
	# - Print debug message
	pass

func advance_growth() -> void:
	# TODO (Task 1.3.2): Implement growth advancement
	# - Check if state is PLANTED or GROWING
	# - Get crop data from GameState
	# - Calculate days elapsed since planted_day
	# - Update current_stage based on progress
	# - Check if ready to harvest (days >= days_to_mature)
	# - Update crop sprite
	# - Reset watered status
	pass

func harvest() -> void:
	# TODO (Task 1.3.2): Implement harvesting
	# - Check if state is HARVESTABLE
	# - Get crop data from GameState
	# - Call GameState.add_item() with harvest_item_id
	# - Check if crop regrows
	# - Reset to appropriate state (TILLED or GROWING)
	# - Emit GameState.crop_harvested signal
	pass

# ============================================
# INTERACTION
# ============================================

func interact() -> void:
	# TODO (Task 1.3.2): Implement interaction dispatcher
	# - Match current_state
	# - EMPTY → till()
	# - TILLED → (wait for UI to select seed)
	# - PLANTED/GROWING → water()
	# - HARVESTABLE → harvest()
	pass

# ============================================
# HELPERS
# ============================================

func _update_crop_sprite() -> void:
	# TODO (Task 1.3.2): Update crop sprite based on growth stage
	# - Get crop data from GameState
	# - Get texture from growth_stages array at current_stage index
	# - Set crop_sprite.texture
	# - Set crop_sprite visibility
	pass
