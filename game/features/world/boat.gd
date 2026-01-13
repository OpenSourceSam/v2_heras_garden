extends StaticBody2D

## Boat Travel System
## Determines destination based on quest state and handles return trips
## Usage: Place in world.tscn (for outgoing) or location scenes (for return)

@export var is_return_boat: bool = false
@export var return_to_scene: String = "res://game/features/world/world.tscn"

func interact() -> void:
	if is_return_boat:
		# Return boat - go back to world
		SceneManager.change_scene(return_to_scene)
	else:
		# Departure boat - determine destination based on quest state
		var destination: String = ""

		# Scylla Cove destinations
		if GameState.get_flag("quest_3_active") and not GameState.get_flag("quest_3_complete"):
			destination = "scylla_cove"  # Confront Scylla
		elif GameState.get_flag("quest_5_active") or GameState.get_flag("quest_6_active"):
			destination = "scylla_cove"  # Failed attempt / Reversal
		elif GameState.get_flag("quest_11_active"):
			destination = "scylla_cove"  # Final confrontation

		# Sacred Grove destinations
		elif GameState.get_flag("quest_8_active") or GameState.get_flag("quest_9_active"):
			destination = "sacred_grove"  # Sacred Earth / Moon Tears

		# Return to world (after quest_3_complete, before quest_8)
		elif GameState.get_flag("quest_3_complete") and not GameState.get_flag("quest_8_active"):
			return_to_world()

		if destination != "":
			var scene_path = "res://game/features/locations/" + destination + ".tscn"
			SceneManager.change_scene(scene_path)
		else:
			# Show "nowhere to go" message
			print("No destination available - check quest flags")

func return_to_world() -> void:
	SceneManager.change_scene("res://game/features/world/world.tscn")
