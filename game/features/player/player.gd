extends CharacterBody2D
## Player character controller
## Implements movement, interaction, and basic mechanics
## See docs/execution/ROADMAP.md Task 1.1 for implementation details

# ============================================
# CONSTANTS
# ============================================
const SPEED: float = 100.0

# ============================================
# NODE REFERENCES
# ============================================
# TODO (Task 1.1.2): Add @onready references after scene structure is verified
# @onready var sprite: Sprite2D = $Sprite
# @onready var interaction_zone: Area2D = $InteractionZone

# ============================================
# SIGNALS
# ============================================
# TODO (Task 1.1.3): Add interaction signal
# signal interacted_with(target: Node)

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO (Task 1.1.2): Add any initialization needed
	pass

# ============================================
# MOVEMENT
# ============================================

func _physics_process(delta: float) -> void:
	# Get input direction
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Set velocity based on SPEED constant
	velocity = direction * SPEED

	# Move the player
	move_and_slide()

	# Update sprite flip based on direction
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0

# ============================================
# INTERACTION
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	# TODO (Task 1.1.3): Implement interaction input
	# - Check for "interact" action press
	# - Call _try_interact() when pressed
	pass

func _try_interact() -> void:
	# TODO (Task 1.1.3): Implement interaction logic
	# - Get overlapping bodies from interaction_zone
	# - Check if target has interact() method
	# - Call target.interact() and emit signal
	pass
