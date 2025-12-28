extends Node

signal scene_changing
signal scene_changed

var current_scene: Node = null
var _fade_layer: CanvasLayer = null
var _fade_rect: ColorRect = null
var _fade_duration: float = 0.3

func change_scene(scene_path: String) -> void:
	scene_changing.emit()
	# Fade out (use ColorRect + Tween)
	await _fade_out()

	var scene_resource = load(scene_path)
	if scene_resource == null:
		push_error("Scene not found: %s" % scene_path)
		await _fade_in()
		return

	if current_scene:
		current_scene.queue_free()

	var new_scene = scene_resource.instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene

	await _fade_in()
	scene_changed.emit()

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
