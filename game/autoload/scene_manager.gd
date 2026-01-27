extends Node

signal scene_changing
signal scene_changed

var current_scene: Node = null
var _fade_layer: CanvasLayer = null
var _fade_rect: ColorRect = null
var _fade_duration: float = 0.3

enum TransitionType {
	FADE_BLACK,           # Standard black fade
	FADE_WHITE,           # White flash fade
	FADE_COLOR,           # Custom color fade
	INSTANT               # No transition
}

# ============================================
# MAIN SCENE CHANGE METHODS
# ============================================

func change_scene(scene_path: String) -> void:
	scene_changing.emit()
	# Fade out (use ColorRect + Tween)
	await _fade_out()

	var scene_resource = load(scene_path)
	if scene_resource == null:
		push_error("Scene not found: %s" % scene_path)
		await _fade_in()
		if _fade_rect:
			_fade_rect.color.a = 0.0
		return

	if current_scene:
		current_scene.queue_free()

	var new_scene = scene_resource.instantiate()
	get_tree().root.add_child(new_scene)
	_finalize_scene_change(new_scene)

	await _fade_in()
	if _fade_rect:
		_fade_rect.color.a = 0.0
	scene_changed.emit()

## Change scene with custom transition type
func change_scene_with_transition(scene_path: String, transition: TransitionType = TransitionType.FADE_BLACK, duration: float = 0.5, custom_color: Color = Color.BLACK) -> void:
	scene_changing.emit()

	# Use VisualFeedbackController if available, fallback to internal
	var feedback = get_node_or_null("/root/VisualFeedbackController")

	match transition:
		TransitionType.INSTANT:
			pass  # No fade
		TransitionType.FADE_BLACK:
			if feedback:
				feedback.fade_to_black(duration)
			else:
				await _fade_out_with_color(Color.BLACK, duration)
		TransitionType.FADE_WHITE:
			if feedback:
				feedback.flash_effect(Color.WHITE, duration)
			else:
				await _fade_out_with_color(Color.WHITE, duration)
		TransitionType.FADE_COLOR:
			if feedback:
				feedback.flash_effect(custom_color, duration)
			else:
				await _fade_out_with_color(custom_color, duration)

	# Load new scene
	var scene_resource = load(scene_path)
	if scene_resource == null:
		push_error("Scene not found: %s" % scene_path)
		if feedback and transition != TransitionType.INSTANT:
			feedback.fade_from_black(duration)
		scene_changed.emit()
		return

	if current_scene:
		current_scene.queue_free()

	var new_scene = scene_resource.instantiate()
	get_tree().root.add_child(new_scene)
	_finalize_scene_change(new_scene)

	# Fade in
	match transition:
		TransitionType.INSTANT:
			pass
		TransitionType.FADE_BLACK, TransitionType.FADE_WHITE, TransitionType.FADE_COLOR:
			if feedback:
				feedback.fade_from_black(duration)
			else:
				await _fade_in_with_color(duration)

	scene_changed.emit()

func change_scene_immediate(scene_path: String) -> void:
	scene_changing.emit()
	var scene_resource = load(scene_path)
	if scene_resource == null:
		push_error("Scene not found: %s" % scene_path)
		return

	if current_scene:
		current_scene.queue_free()

	var new_scene = scene_resource.instantiate()
	get_tree().root.add_child(new_scene)
	_finalize_scene_change(new_scene)

	_ensure_fade_layer()
	_fade_rect.color.a = 0.0
	scene_changed.emit()

# ============================================
# FADE METHODS
# ============================================

func _fade_out() -> void:
	if _fade_duration <= 0.0 or DisplayServer.get_name() == "headless":
		_ensure_fade_layer()
		_fade_rect.color.a = 1.0
		return
	_ensure_fade_layer()
	_fade_rect.color.a = 0.0
	var tween = create_tween()
	tween.tween_property(_fade_rect, "color:a", 1.0, _fade_duration)
	await tween.finished

func _fade_in() -> void:
	if _fade_duration <= 0.0 or DisplayServer.get_name() == "headless":
		_ensure_fade_layer()
		_fade_rect.color.a = 0.0
		return
	_ensure_fade_layer()
	var tween = create_tween()
	tween.tween_property(_fade_rect, "color:a", 0.0, _fade_duration)
	await tween.finished

func _fade_out_with_color(color: Color, duration: float) -> void:
	if DisplayServer.get_name() == "headless":
		return
	_ensure_fade_layer()
	_fade_rect.color = Color(color.r, color.g, color.b, 0.0)
	var tween = create_tween()
	tween.tween_property(_fade_rect, "color:a", 1.0, duration)
	await tween.finished

func _fade_in_with_color(duration: float) -> void:
	if DisplayServer.get_name() == "headless":
		return
	_ensure_fade_layer()
	var tween = create_tween()
	tween.tween_property(_fade_rect, "color:a", 0.0, duration)
	await tween.finished

func _ensure_fade_layer() -> void:
	if _fade_layer:
		return

	_fade_layer = CanvasLayer.new()
	_fade_layer.layer = 100
	_fade_rect = ColorRect.new()
	_fade_rect.color = Color(0, 0, 0, 0)
	_fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade_rect.offset_left = 0.0
	_fade_rect.offset_top = 0.0
	_fade_rect.offset_right = 0.0
	_fade_rect.offset_bottom = 0.0
	_fade_layer.add_child(_fade_rect)
	get_tree().root.add_child(_fade_layer)

func _finalize_scene_change(new_scene: Node) -> void:
	if not is_instance_valid(new_scene):
		return
	current_scene = new_scene
	get_tree().current_scene = new_scene

# ============================================
# UTILITY METHODS
# ============================================

## Get current transition duration
func get_fade_duration() -> float:
	return _fade_duration

## Set transition duration for future transitions
func set_fade_duration(duration: float) -> void:
	_fade_duration = max(0.0, duration)
