extends Node
## VisualFeedbackController - Centralized visual effects and feedback system
## Provides reusable visual feedback: screen shake, flash effects, particles, and more

# ============================================
# SCREEN SHAKE SYSTEM
# ============================================

var _shake_tweens: Dictionary = {}  # Track active shake tweens by target

## Shake a node (usually the camera or scene root)
## intensity: How many pixels to shake (default 5.0)
## duration: How long the shake lasts (default 0.3 seconds)
## frequency: How fast the shake cycles (default 20.0 Hz)
func screen_shake(target: Node, intensity: float = 5.0, duration: float = 0.3, frequency: float = 20.0) -> void:
	if not target or not is_instance_valid(target):
		push_warning("[VisualFeedbackController] Invalid target for screen_shake")
		return

	# Cancel any existing shake for this target
	_cancel_shake(target)

	var original_offset: Vector2
	if target.has_method("get_offset"):
		original_offset = target.get_offset()
	elif target is CanvasItem:
		original_offset = target.offset

	var tween = create_tween()
	tween.set_parallel(true)

	# Store tween for cancellation
	_shake_tweens[target.get_instance_id()] = tween

	# Generate shake pattern
	var shake_count: int = int(duration * frequency)
	for i in range(shake_count):
		var shake_offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		var time_offset = float(i) / frequency
		tween.tween_property(target, "offset", shake_offset, 1.0 / frequency).set_delay(time_offset)

	# Return to original position
	tween.tween_property(target, "offset", original_offset, 0.1).set_delay(duration)
	tween.tween_callback(_remove_shake_tween.bind(target.get_instance_id()))

func _cancel_shake(target: Node) -> void:
	var target_id = target.get_instance_id()
	if _shake_tweens.has(target_id):
		_shake_tweens[target_id].kill()
		_shake_tweens.erase(target_id)

func _remove_shake_tween(target_id: int) -> void:
	_shake_tweens.erase(target_id)

# ============================================
# FLASH EFFECT SYSTEM
# ============================================

var _flash_overlays: Dictionary = {}  # Track flash overlays by scene

## Flash a color on screen (for hit effects, transitions, etc.)
## color: The flash color (default white)
## duration: How long the flash lasts (default 0.2 seconds)
## target_scene: The scene to flash (default: current scene's root)
func flash_effect(color: Color = Color.WHITE, duration: float = 0.2, target_scene: Node = null) -> void:
	var target = target_scene if target_scene else get_tree().current_scene
	if not target or not is_instance_valid(target):
		push_warning("[VisualFeedbackController] Invalid target for flash_effect")
		return

	# Create or get flash overlay
	var overlay = _get_flash_overlay(target)
	overlay.color = color
	overlay.visible = true

	# Create fade tween
	var tween = create_tween()
	tween.set_parallel(false)

	# Flash in
	overlay.modulate.a = 0.0
	tween.tween_property(overlay, "modulate:a", 0.8, duration * 0.2)

	# Hold
	tween.tween_interval(duration * 0.3)

	# Fade out
	tween.tween_property(overlay, "modulate:a", 0.0, duration * 0.5)
	tween.tween_callback(func(): overlay.visible = false)

func _get_flash_overlay(target_scene: Node) -> ColorRect:
	var scene_id = target_scene.get_instance_id()

	if not _flash_overlays.has(scene_id):
		var overlay = ColorRect.new()
		overlay.name = "FlashOverlay"
		overlay.z_index = 1000  # Above everything
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		overlay.visible = false

		# Add to target scene
		if target_scene is Window:
			target_scene.add_child(overlay)
		elif target_scene is Node2D:
			# For Node2D scenes, we need a CanvasLayer
			var canvas = CanvasLayer.new()
			canvas.name = "FlashCanvas"
			canvas.layer = 1000
			target_scene.add_child(canvas)
			canvas.add_child(overlay)
		else:
			target_scene.add_child(overlay)

		_flash_overlays[scene_id] = overlay

	return _flash_overlays[scene_id]

# ============================================
# PARTICLE EFFECT SYSTEM
# ============================================

var _particle_pool: Array[Node] = []  # Pool of particle nodes for reuse
const MAX_PARTICLE_NODES: int = 20

## Create a burst of particles at a position
## position: Where to spawn particles (global coordinates)
## color: Particle color (default gold)
## count: Number of particles (default 10)
## spread: How far particles spread (default 50 pixels)
func spawn_particles(position: Vector2, color: Color = Color.GOLD, count: int = 10, spread: float = 50.0) -> void:
	var target_scene = get_tree().current_scene
	if not target_scene:
		return

	# Use particle pool or create new
	var particle_root = _get_particle_root(target_scene)

	for i in range(count):
		var particle = _create_particle(particle_root, position, color, spread)

## Create item pickup effect (float up + fade + icon)
## position: Where the effect starts (usually player position)
## item_texture: Optional texture for the item icon
func item_pickup_effect(position: Vector2, item_texture: Texture2D = null) -> void:
	var target_scene = get_tree().current_scene
	if not target_scene:
		return

	# Create floating element
	var float_node = Node2D.new()
	float_node.global_position = position
	target_scene.add_child(float_node)

	# Create sprite (icon or default)
	var sprite = Sprite2D.new()
	if item_texture:
		sprite.texture = item_texture
	else:
		# Create a simple placeholder texture
		var texture = ImageTexture.new()
		var image = Image.create(32, 32, false, Image.FORMAT_RGB8)
		image.fill(Color.GOLD)
		texture.set_image(image)
		sprite.texture = texture
	sprite.modulate = Color.WHITE
	float_node.add_child(sprite)

	# Create text label
	var label = Label.new()
	label.text = "+1"
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color.GOLD)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(-20, -40)
	float_node.add_child(label)

	# Animate float up and fade
	var tween = float_node.create_tween()
	tween.set_parallel(true)

	# Float up
	tween.tween_property(float_node, "global_position:y", position.y - 80, 1.0)

	# Fade out
	tween.tween_property(float_node, "modulate:a", 0.0, 1.0)

	# Scale bounce
	tween.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.3).set_delay(0.2)

	# Cleanup
	tween.tween_callback(float_node.queue_free).set_delay(1.0)

func _create_particle(root: Node, position: Vector2, color: Color, spread: float) -> Node2D:
	var particle = Node2D.new()
	particle.global_position = position

	var sprite = ColorRect.new()
	sprite.size = Vector2(8, 8)
	sprite.position = Vector2(-4, -4)
	sprite.color = color
	particle.add_child(sprite)

	root.add_child(particle)

	# Animate particle
	var tween = particle.create_tween()
	var target_pos = position + Vector2(
		randf_range(-spread, spread),
		randf_range(-spread, spread)
	)

	tween.set_parallel(true)
	tween.tween_property(particle, "global_position", target_pos, 0.5)
	tween.tween_property(particle, "modulate:a", 0.0, 0.5)
	tween.tween_property(sprite, "rotation", randf() * PI, 0.5)
	tween.tween_callback(particle.queue_free).set_delay(0.5)

	return particle

func _get_particle_root(target_scene: Node) -> Node:
	var particle_root = target_scene.get_node_or_null("ParticleRoot")
	if not particle_root:
		particle_root = Node2D.new()
		particle_root.name = "ParticleRoot"
		target_scene.add_child(particle_root)
	return particle_root

# ============================================
# UI FEEDBACK HELPERS
# ============================================

## Button press animation (scale down + bounce back)
func button_press_animation(button: Control) -> void:
	if not button or not is_instance_valid(button):
		return

	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.05)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

## Button hover animation (scale up slightly)
func button_hover_animation(button: Control, is_hovering: bool) -> void:
	if not button or not is_instance_valid(button):
		return

	var target_scale = Vector2(1.05, 1.05) if is_hovering else Vector2(1.0, 1.0)
	var tween = create_tween()
	tween.tween_property(button, "scale", target_scale, 0.1)

## Success/failure indicator (checkmark or X mark)
func show_indicator(position: Vector2, is_success: bool) -> void:
	var target_scene = get_tree().current_scene
	if not target_scene:
		return

	var label = Label.new()
	label.text = "✓" if is_success else "✗"
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color.GREEN if is_success else Color.RED)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 3)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.global_position = position
	target_scene.add_child(label)

	# Animate
	var tween = create_tween()
	tween.set_parallel(true)

	# Float up
	tween.tween_property(label, "global_position:y", position.y - 50, 0.8)

	# Fade out
	tween.tween_property(label, "modulate:a", 0.0, 0.8)

	# Scale in
	label.scale = Vector2.ZERO
	tween.tween_property(label, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.2)

	# Cleanup
	tween.tween_callback(label.queue_free).set_delay(0.8)

# ============================================
# TRANSITION EFFECTS
# ============================================

var _transition_overlay: ColorRect = null
var _transition_tween: Tween = null

## Fade to black (for scene transitions)
func fade_to_black(duration: float = 0.5, callback: Callable = Callable()) -> void:
	_ensure_transition_overlay()
	_transition_overlay.visible = true
	_transition_overlay.color = Color.BLACK

	if _transition_tween and _transition_tween.is_valid():
		_transition_tween.kill()

	_transition_tween = create_tween()
	_transition_tween.tween_property(_transition_overlay, "modulate:a", 1.0, duration)

	if not callback.is_null():
		_transition_tween.tween_callback(callback)

## Fade from black (after scene transition)
func fade_from_black(duration: float = 0.5) -> void:
	_ensure_transition_overlay()
	_transition_overlay.visible = true
	_transition_overlay.color = Color.BLACK
	_transition_overlay.modulate.a = 1.0

	if _transition_tween and _transition_tween.is_valid():
		_transition_tween.kill()

	_transition_tween = create_tween()
	_transition_tween.tween_property(_transition_overlay, "modulate:a", 0.0, duration)
	_transition_tween.tween_callback(func(): _transition_overlay.visible = false)

func _ensure_transition_overlay() -> void:
	if not _transition_overlay or not is_instance_valid(_transition_overlay):
		var root = get_tree().root
		_transition_overlay = ColorRect.new()
		_transition_overlay.name = "TransitionOverlay"
		_transition_overlay.z_index = 9999
		_transition_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		_transition_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_transition_overlay.modulate.a = 0.0
		_transition_overlay.visible = false
		root.add_child(_transition_overlay)

# ============================================
# INITIALIZATION
# ============================================

func _ready() -> void:
	print("[VisualFeedbackController] Initialized")

func _exit_tree() -> void:
	# Cleanup all flash overlays
	for overlay in _flash_overlays.values():
		if is_instance_valid(overlay):
			overlay.queue_free()
	_flash_overlays.clear()

	# Cancel all active tweens
	for tween in _shake_tweens.values():
		if is_instance_valid(tween):
			tween.kill()
	_shake_tweens.clear()
