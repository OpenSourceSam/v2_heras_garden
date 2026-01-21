extends SceneTree
## Test script to skip to Quest 2 for dialogue choice fix validation
## Run with: Godot*.exe --headless --script tests/skip_to_quest2.gd

var game_state = null

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=".repeat(60))
	print("SKIP TO QUEST 2 FOR DIALOGUE CHOICE FIX TEST")
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

	# Set prerequisite flags for Quest 2
	var flags_to_set = [
		"met_hermes",
		"quest_0_complete",
		"quest_1_complete",
		"quest_1_complete_dialogue_seen"  # Required before quest2_start will show
	]

	for flag in flags_to_set:
		game_state.set_flag(flag, true)
		print("[OK] Set flag: %s = true" % flag)

	# DO NOT set quest_2_active - that's set when player makes a choice in quest2_start
	print("[INFO] quest_2_active NOT set - Hermes will show quest2_start dialogue with choices")

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
			# Set player position near Hermes
			player.position = Vector2(384, 96)
			print("[OK] Player teleported near Hermes (384, 96)")
		else:
			print("[WARN] Player not found in world scene")
	else:
		print("[FAIL] Could not load world scene")
		quit(1)
		return

	print("=".repeat(60))
	print("SETUP COMPLETE - Ready for Quest 2 dialogue choice test")
	print("=".repeat(60))
	print("[INFO] Player near Hermes at (384, 96)")
	print("[INFO] quest_1_complete = true")
	print("[INFO] quest_2_active = false (will be set after making a choice)")
	quit(0)
