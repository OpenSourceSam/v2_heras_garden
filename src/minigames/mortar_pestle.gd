extends Control
## Mortar & Pestle Crafting Minigame
## Player follows directional sequence with d-pad
## See DEVELOPMENT_ROADMAP.md Phase 2 Task 2.3

# ============================================
# NODE REFERENCES
# ============================================
# TODO (Phase 2): Add @onready references
# @onready var mortar_sprite: Sprite2D = $MortarSprite
# @onready var pestle_sprite: Sprite2D = $PestleSprite
# @onready var progress_bar: ProgressBar = $ProgressBar
# @onready var direction_indicator: Sprite2D = $DirectionIndicator

# ============================================
# STATE
# ============================================
var target_sequence: Array[String] = []
var current_index: int = 0
var progress: float = 0.0
var recipe_data: RecipeData = null

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO (Phase 2): Initialize minigame
	# - Load recipe_data
	# - Generate target_sequence based on difficulty
	# - Show first direction indicator
	pass

func _input(event: InputEvent) -> void:
	# TODO (Phase 2): Handle directional input
	# - Check if input matches target_sequence[current_index]
	# - If correct: increase progress, advance sequence
	# - If wrong: decrease progress, play error animation
	# - If sequence complete: finish crafting
	pass

# ============================================
# MINIGAME LOGIC
# ============================================

func start_crafting(recipe: RecipeData) -> void:
	# TODO (Phase 2): Start crafting session
	# - Set recipe_data
	# - Generate sequence (easy: 4 inputs, medium: 6, hard: 8)
	# - Reset progress
	# - Show UI
	pass

func _check_input(direction: String) -> bool:
	# TODO (Phase 2): Validate player input
	# - Compare direction to target_sequence[current_index]
	# - Return true if correct
	return false

func _complete_crafting() -> void:
	# TODO (Phase 2): Finish crafting
	# - Add result_item_id to inventory
	# - Play success animation
	# - Close minigame
	# - Emit crafting_complete signal
	pass

func _fail_crafting() -> void:
	# TODO (Phase 2): Handle failure
	# - Do NOT consume ingredients (player can retry)
	# - Show failure message
	# - Close minigame
	pass
