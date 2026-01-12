extends StaticBody2D

@export var destination_scene: String = "res://game/features/locations/aiaia_house.tscn"

func interact() -> void:
	if destination_scene == "":
		return
	SceneManager.change_scene(destination_scene)
