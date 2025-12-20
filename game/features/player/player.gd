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
@onready var sprite: Sprite2D = $Sprite
@onready var interaction_zone: Area2D = $InteractionZone

# ============================================
# SIGNALS
# ============================================
signal interacted_with(target: Node)

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
		sprite.flip_h = direction.x < 0

# ============================================
# INTERACTION
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_try_interact()

func _try_interact() -> void:
	var bodies = interaction_zone.get_overlapping_bodies()
	if bodies.size() == 0:
		return
	for body in bodies:
		if body == self:
			continue
		if body.has_method("interact"):
			body.interact()
			interacted_with.emit(body)
			return
