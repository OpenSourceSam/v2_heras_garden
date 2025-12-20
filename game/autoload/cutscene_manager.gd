extends Node

var current_cutscene: Node = null

func play_cutscene(scene_path: String) -> void:
	var scene = load(scene_path).instantiate()
	get_tree().root.add_child(scene)
	current_cutscene = scene
	await scene.cutscene_finished
	scene.queue_free()
	current_cutscene = null

func is_playing() -> bool:
	return current_cutscene != null
