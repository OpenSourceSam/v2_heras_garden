extends SceneTree
## Test script to skip to Quest 10 and load world scene for HPV validation
## Run with: Godot*.exe --headless --script tests/skip_to_quest10_and_load_world.gd

var game_state = null

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=".repeat(60))
	print("SKIP TO QUEST 10 + LOAD WORLD")
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
	
	# Set all prerequisite quest flags to complete
	var flags_to_set = [
		"quest_0_complete",
		"quest_1_complete",
		"quest_2_complete",
		"quest_3_complete",
		"quest_4_complete",
		"quest_5_complete",
		"quest_6_complete",
		"quest_7_complete",
		"quest_8_complete",
		"quest_9_complete"
	]
	
	for flag in flags_to_set:
		game_state.set_flag(flag, true)
		print("[OK] Set flag: %s = true" % flag)
	
	# Set quest_10_active to trigger the Moon Tears quest
	game_state.set_flag("quest_10_active", true)
	print("[OK] Set flag: quest_10_active = true")
	
	# Add some items for Quest 11 (Petrification Potion ingredients)
	game_state.add_item("moon_tear", 3)
	game_state.add_item("sacred_earth", 1)
	game_state.add_item("divine_blood", 1)
	print("[OK] Added Quest 11 ingredients")
	
	# Verify flags were set
	var all_set = true
	for flag in flags_to_set:
		if not game_state.get_flag(flag):
			print("[FAIL] Flag not set: %s" % flag)
			all_set = false
	
	if not game_state.get_flag("quest_10_active"):
		print("[FAIL] quest_10_active not set")
		all_set = false
	
	if not all_set:
		print("[FAIL] Some flags failed to set")
		quit(1)
		return
	
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
			# Set player position to Quest 10 trigger
			player.position = Vector2(384, 64)
			print("[OK] Player teleported to Quest 10 trigger (384, 64)")
		else:
			print("[WARN] Player not found in world scene")
	else:
		print("[FAIL] Could not load world scene")
		quit(1)
		return
	
	print("=".repeat(60))
	print("SETUP COMPLETE - Ready for HPV validation")
	print("=".repeat(60))
	print("[INFO] Player at Quest 10 trigger (384, 64)")
	print("[INFO] quest_10_active = true")
	print("[INFO] Quest 11 ingredients in inventory")
	quit(0)
