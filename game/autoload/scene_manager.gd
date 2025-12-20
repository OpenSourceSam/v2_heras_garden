extends Node

signal scene_changing
signal scene_changed

var current_scene: Node = null

func change_scene(scene_path: String) -> void:
	scene_changing.emit()
	# Fade out (use ColorRect + Tween)
	await _fade_out()

	if current_scene:
		current_scene.queue_free()

	var new_scene = load(scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene

	await _fade_in()
	scene_changed.emit()

func _fade_out() -> void:
	# TODO: Implement fade animation
	await get_tree().create_timer(0.3).timeout

func _fade_in() -> void:
	# TODO: Implement fade animation
	await get_tree().create_timer(0.3).timeout
