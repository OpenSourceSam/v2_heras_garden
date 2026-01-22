extends StaticBody2D

## Workshop Path - Access to Daedalus Workshop
## Only accessible during/after Quest 7 when Daedalus is on the island

func _on_interact() -> void:
	if GameState.get_flag("quest_7_active") or GameState.get_flag("quest_7_complete"):
		SceneManager.change_scene("res://game/features/locations/daedalus_workshop.tscn")
	else:
		print("[WorkshopPath] Workshop not available - Quest 7 not started")

func interact() -> void:
	_on_interact()
