extends CharacterBody2D
## NPC Entity Controller
## Handles movement, schedule, dialogue triggering
## See DEVELOPMENT_ROADMAP.md Phase 2 for implementation

# ============================================
# EXPORTS
# ============================================
@export var npc_data: NPCData = null

# ============================================
# NODE REFERENCES
# ============================================
# TODO (Phase 2): Add @onready references
# @onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
# @onready var interaction_area: Area2D = $InteractionArea

# ============================================
# STATE
# ============================================
var current_schedule_index: int = 0
var is_moving: bool = false
var target_position: Vector2 = Vector2.ZERO

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO (Phase 2): Load NPC data
	# - Set sprite frames from npc_data
	# - Initialize schedule
	# - Connect to GameState.day_advanced for schedule updates
	pass

func _physics_process(delta: float) -> void:
	# TODO (Phase 2): Handle scheduled movement
	# - Check current time against schedule
	# - Move to scheduled location
	# - Play scheduled animation
	pass

# ============================================
# INTERACTION
# ============================================

func interact() -> void:
	# TODO (Phase 2): Trigger dialogue
	# - Get dialogue_id from npc_data
	# - Check for quest-specific dialogue
	# - Show dialogue via DialogueBox
	# - Handle gift giving if player has item
	pass

# ============================================
# SCHEDULE
# ============================================

func _update_schedule() -> void:
	# TODO (Phase 2): Update schedule based on time
	# - Get current time from GameState
	# - Find matching schedule entry
	# - Move to location
	# - Play animation
	pass

func _move_to_location(location: String) -> void:
	# TODO (Phase 2): Navigate to named location
	# - Look up location coordinates
	# - Set target_position
	# - Start movement
	pass

# ============================================
# GIFT HANDLING
# ============================================

func receive_gift(item_id: String) -> void:
	# TODO (Phase 2): Handle gift from player
	# - Check gift_preferences from npc_data
	# - Calculate affection change
	# - Play reaction animation
	# - Give thank you dialogue
	pass
