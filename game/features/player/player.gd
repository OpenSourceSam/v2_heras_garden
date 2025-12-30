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
@onready var interaction_prompt: Label = $InteractionPrompt

# ============================================
# SIGNALS
# ============================================
signal interacted_with(target: Node)

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	assert(sprite != null, "Player Sprite node missing")
	assert(interaction_zone != null, "Player InteractionZone missing")
	assert(interaction_prompt != null, "Player InteractionPrompt missing")
	interaction_prompt.visible = false

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
	_update_interaction_prompt()

# ============================================
# INTERACTION
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
		if dialogue_box != null and dialogue_box.visible:
			return
		_try_interact()

func _try_interact() -> void:
	var bodies = interaction_zone.get_overlapping_bodies()
	var areas = interaction_zone.get_overlapping_areas()
	if bodies.size() == 0 and areas.size() == 0:
		return
	var targets: Array = []
	targets.append_array(bodies)
	targets.append_array(areas)
	for target in targets:
		if target == self:
			continue
		if target.has_method("interact"):
			target.interact()
			interacted_with.emit(target)
			return
		var parent = target.get_parent()
		if parent != null and parent != self and parent.has_method("interact"):
			parent.interact()
			interacted_with.emit(parent)
			return

func _update_interaction_prompt() -> void:
	var has_target := false
	var bodies = interaction_zone.get_overlapping_bodies()
	var areas = interaction_zone.get_overlapping_areas()
	for target in bodies:
		if _is_interactable(target):
			has_target = true
			break
	if not has_target:
		for target in areas:
			if _is_interactable(target):
				has_target = true
				break
	interaction_prompt.visible = has_target

func _is_interactable(target: Node) -> bool:
	if target == self:
		return false
	if target.has_method("interact"):
		return true
	var parent = target.get_parent()
	return parent != null and parent != self and parent.has_method("interact")
