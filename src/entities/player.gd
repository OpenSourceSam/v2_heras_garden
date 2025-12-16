extends CharacterBody2D
## Player - Main player character controller
## See SCHEMA.md for property definitions

# ============================================
# SIGNALS
# ============================================

signal interacted_with(target: Node)

# ============================================
# CONSTANTS
# ============================================

const SPEED: float = 100.0
const TILE_SIZE: int = 32

# ============================================
# NODE REFERENCES
# ============================================

@onready var sprite: Sprite2D = $Sprite
@onready var interaction_zone: Area2D = $InteractionZone

# ============================================
# STATE
# ============================================

var facing_direction: Vector2 = Vector2.DOWN
var is_moving: bool = false

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	add_to_group("player")
	print("[Player] Initialized at %s" % global_position)
	
	# Enable telemetry tracking if available
	# _setup_telemetry()  # Disabled - PlaytestTelemetry has type compatibility issues

func _setup_telemetry() -> void:
	# Check if PlaytestTelemetry is available
	var telemetry = get_node_or_null("/root/PlaytestTelemetry")
	if telemetry and telemetry.has_method("record_properties"):
		# NOTE: Disabled due to array type mismatch with addon
		# telemetry.record_properties(self, ["global_position", "velocity", "is_moving"])
		print("[Player] Telemetry skipped - type compatibility issue")

# ============================================
# PHYSICS
# ============================================

func _physics_process(_delta: float) -> void:
	# Get input direction
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Update velocity
	velocity = input_dir * SPEED
	is_moving = velocity.length() > 0
	
	# Update facing direction and sprite
	if is_moving:
		facing_direction = velocity.normalized()
		_update_sprite_flip()
	
	# Move
	move_and_slide()

func _update_sprite_flip() -> void:
	if sprite:
		# Flip sprite based on horizontal direction
		if facing_direction.x < 0:
			sprite.flip_h = true
		elif facing_direction.x > 0:
			sprite.flip_h = false

# ============================================
# INPUT
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_try_interact()

func _try_interact() -> void:
	if not interaction_zone:
		return
	
	# Get overlapping bodies that can be interacted with
	var bodies = interaction_zone.get_overlapping_bodies()
	var areas = interaction_zone.get_overlapping_areas()
	
	# Check bodies first
	for body in bodies:
		if body == self:
			continue
		if body.has_method("interact"):
			body.interact()
			interacted_with.emit(body)
			print("[Player] Interacted with body: %s" % body.name)
			return
	
	# Then check areas (and their parents)
	for area in areas:
		# Check if area itself has interact method
		if area.has_method("interact"):
			area.interact()
			interacted_with.emit(area)
			print("[Player] Interacted with area: %s" % area.name)
			return
		
		# Check if area's parent has interact method (for entities like FarmPlot)
		var parent = area.get_parent()
		if parent and parent.has_method("interact"):
			parent.interact()
			interacted_with.emit(parent)
			print("[Player] Interacted with area parent: %s" % parent.name)
			return
	
	print("[Player] Nothing to interact with")

# ============================================
# PUBLIC METHODS
# ============================================

func get_facing_tile() -> Vector2i:
	"""Returns the grid position of the tile the player is facing"""
	var facing_offset = facing_direction * TILE_SIZE
	var target_world_pos = global_position + facing_offset
	return Vector2i(
		int(target_world_pos.x / TILE_SIZE),
		int(target_world_pos.y / TILE_SIZE)
	)

func get_grid_position() -> Vector2i:
	"""Returns the player's current grid position"""
	return Vector2i(
		int(global_position.x / TILE_SIZE),
		int(global_position.y / TILE_SIZE)
	)
