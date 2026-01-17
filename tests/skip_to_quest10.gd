extends SceneTree
## Test script to skip to Quest 10 for HPV validation
## Run with: Godot*.exe --headless --script tests/skip_to_quest10.gd

var game_state = null

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("[TEST] Skipping to Quest 10 for HPV validation...")
	
	# Get GameState autoload from root
	game_state = root.get_node_or_null("GameState")
	if not game_state:
		print("[FAIL] GameState autoload not found")
		quit(1)
		return
	
	print("[OK] GameState found")
	
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
	
	# Verify flags were set
	var all_set = true
	for flag in flags_to_set:
		if not game_state.get_flag(flag):
			print("[FAIL] Flag not set: %s" % flag)
			all_set = false
	
	if not game_state.get_flag("quest_10_active"):
		print("[FAIL] quest_10_active not set")
		all_set = false
	
	if all_set:
		print("[PASS] All prerequisite flags set successfully!")
		print("[INFO] Player should now find Quest 10 (Moon Tears) at position (384, 64)")
		print("[INFO] Navigate east from spawn to trigger the Moon Tears minigame")
	else:
		print("[FAIL] Some flags failed to set")
		quit(1)
		return
	
	print("[TEST] Skip to Quest 10 complete - ready for HPV validation")
	quit(0)
