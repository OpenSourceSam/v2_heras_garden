extends SceneTree
## Teleport player to AeetesNote for Quest 0 HPV testing
## Run with: Godot*.exe --headless --script tests/teleport_to_note.gd

var game_state = null
var world_instance = null

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=".repeat(60))
	print("TELEPORT TO AEETES NOTE FOR QUEST 0 HPV")
	print("=".repeat(60))

	# Initialize game state
	game_state = root.get_node_or_null("GameState")
	if not game_state:
		print("[FAIL] GameState autoload not found")
		quit(1)
		return

	print("[OK] GameState found")
	game_state.new_game()
	print("[OK] new_game() called - Quest 0 should be active")

	# Load world
	var world_scene = load("res://game/features/world/world.tscn")
	if world_scene:
		world_instance = world_scene.instantiate()
		root.add_child(world_instance)
		print("[OK] World scene loaded")
	else:
		print("[FAIL] Could not load world scene")
		quit(1)
		return

	# Find player and note
	var player = world_instance.get_node_or_null("Player")
	var note = world_instance.get_node_or_null("Interactables/AeetesNote")

	if not player:
		print("[FAIL] Player not found")
		quit(1)
		return

	print("[OK] Player found")

	if note:
		# Position player at the note's location
		var note_pos = note.global_position
		print("[INFO] AeetesNote found at: ", note_pos)
		player.global_position = note_pos + Vector2(0, 50)  # Slightly below the note
		print("[OK] Player teleported to AeetesNote")
		print("[INFO] Player position: ", player.global_position)
		print("[INFO] Player should now be able to interact with the note")
	else:
		print("[WARN] AeetesNote not found, using default position")
		player.global_position = Vector2(384, 200)  # Default position near house

	print("=".repeat(60))
	print("TELEPORT COMPLETE - Ready for Quest 0 interaction")
	print("=".repeat(60))
	print("[INFO] Player is at/near AeetesNote")
	print("[INFO] Press 'interact' to trigger Quest 0 dialogue")
	quit(0)
