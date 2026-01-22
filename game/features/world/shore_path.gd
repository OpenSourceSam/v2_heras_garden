extends StaticBody2D
## Shore path trigger - allows access to shore scene after Quest 2 complete.

func _on_interact() -> void:
	if GameState.get_flag("quest_2_complete") and not GameState.get_flag("quest_3_complete"):
		SceneManager.change_scene("res://game/features/locations/aiaia_shore.tscn")
