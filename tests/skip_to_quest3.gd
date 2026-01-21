extends SceneTree
## Test script to skip to Quest 3 for Scylla Confrontation testing
## Run with: Godot*.exe --headless --script tests/skip_to_quest3.gd

var game_state = null

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=".repeat(60))
	print("SKIP TO QUEST 3 FOR SCYLLA CONFRONTATION TEST")
	print("=".repeat(60))

	# Get GameState autoload from root
	game_state = root.get_node_or_null("GameState")
	if not game_state:
		print("[FAIL] GameState autoload not found")
		quit(1)
		return

	print("[OK] GameState found")

	# Call new_game to initialize
	game_state.new_game()
	print("[OK] new_game() called")

	# Set prerequisite flags for Quest 3
	var flags_to_set = [
		"met_hermes",
		"quest_0_complete",
		"quest_1_complete",
		"quest_1_complete_dialogue_seen",
		"quest_2_complete",
		"quest_2_complete_dialogue_seen"
	]

	for flag in flags_to_set:
		game_state.set_flag(flag, true)
		print("[OK] Set flag: %s = true" % flag)

	# DO NOT set quest_3_active - that's set when player makes a choice in act1_confront_scylla
	print("[INFO] quest_3_active NOT set - Player will trigger boat travel to Scylla's Cove")

	print("[PASS] All prerequisite flags set successfully!")
	print("[INFO] Now loading world scene...")

	# Load and change to world scene
	var world_scene = load("res://game/features/world/world.tscn")
	if world_scene:
		var world_instance = world_scene.instantiate()
		root.add_child(world_instance)
		print("[OK] World scene loaded")

		# Check if player exists
		var player = world_instance.get_node_or_null("Player")
		if player:
			print("[OK] Player found in world")
			# Set player position near boat for Quest 3
			player.position = Vector2(384, 160)
			print("[OK] Player teleported near boat (384, 160)")
		else:
			print("[WARN] Player not found in world scene")
	else:
		print("[FAIL] Could not load world scene")
		quit(1)
		return

	print("=".repeat(60))
	print("SETUP COMPLETE - Ready for Quest 3 Scylla Confrontation test")
	print("=".repeat(60))
	print("[INFO] Player near boat at (384, 160)")
	print("[INFO] quest_2_complete = true")
	print("[INFO] quest_3_active = false (will be set after boat travel)")
	print("[INFO] Next: Interact with boat to travel to Scylla's Cove")
	quit(0)
