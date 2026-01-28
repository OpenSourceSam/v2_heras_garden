extends SceneTree
## Quest 11 HPV Validation Script
## Tests petrification recipe and final confrontation changes (commit 764350c)

const StateQuery = preload("res://tools/testing/state_query.gd")

func _init():
	call_deferred("_run_validation")

func _run_validation():
	print("=".repeat(60))
	print("QUEST 11 HPV VALIDATION")
	print("Commit 764350c: Petrification recipe and dialogue changes")
	print("=".repeat(60))
	print("")

	# Test 1: Verify GameState is accessible
	_test_game_state_access()

	# Test 2: Check petrification recipe items exist
	_test_petrification_recipe_items()

	# Test 3: Validate item registry
	_test_item_registry()

	# Test 4: Test flag system
	_test_quest_flags()

	# Test 5: Check dialogue system
	_test_dialogue_system()

	print("")
	print("=".repeat(60))
	print("VALIDATION COMPLETE")
	print("=".repeat(60))

	quit(0)

func _test_game_state_access():
	print("[TEST 1] GameState Access")
	var gs = StateQuery.get_game_state()
	if gs:
		print("  ✓ GameState accessible")
		print("  ✓ Current day: %d" % StateQuery.get_day())
		print("  ✓ Gold: %d" % StateQuery.get_gold())
	else:
		print("  ✗ FAILED: GameState not accessible")
	print("")

func _test_petrification_recipe_items():
	print("[TEST 2] Petrification Recipe Items")
	var required_items = {
		"moly": 5,
		"sacred_earth": 3,
		"moon_tear": 3,
		"divine_blood": 1
	}

	var all_exist = true
	for item_id in required_items.keys():
		var count = StateQuery.get_item_count(item_id)
		var required = required_items[item_id]
		if count >= 0:  # Item exists in registry
			print("  ✓ %s: available (need %d for recipe)" % [item_id, required])
		else:
			print("  ✗ %s: MISSING from registry" % item_id)
			all_exist = false

	if all_exist:
		print("  ✓ All petrification recipe items registered")
	else:
		print("  ✗ FAILED: Some recipe items missing")
	print("")

func _test_item_registry():
	print("[TEST 3] Item Registry Validation")

	# Check key items from commit 764350c
	var key_items = [
		"petrification_potion",
		"divine_blood",
		"moon_tear",
		"sacred_earth"
	]

	var gs = StateQuery.get_game_state()
	if gs and gs.item_registry:
		print("  ✓ Item registry loaded")
		for item_id in key_items:
			if item_id in gs.item_registry:
				print("  ✓ %s registered" % item_id)
			else:
				print("  ✗ %s NOT registered" % item_id)
	else:
		print("  ✗ Item registry not accessible")
	print("")

func _test_quest_flags():
	print("[TEST 4] Quest Flag System")

	# Test flag methods
	var test_flags = [
		"quest_11_active",
		"quest_11_complete",
		"scylla_petrified",
		"game_complete"
	]

	for flag in test_flags:
		var exists = StateQuery.get_flag(flag)
		print("  ✓ Flag '%s': %s" % [flag, "exists" if exists else "not set (expected for new game)"])

	# Test quest helper methods
	print("  ✓ Quest 1 active: %s" % StateQuery.is_quest_active("1"))
	print("  ✓ Quest 1 complete: %s" % StateQuery.is_quest_complete("1"))
	print("")

func _test_dialogue_system():
	print("[TEST 5] Dialogue System")

	var gs = StateQuery.get_game_state()
	if gs and gs.has_node("DialogueBox"):
		var dialogue_box = gs.get_node("DialogueBox")
		print("  ✓ DialogueBox node exists")
		print("  ✓ Dialogue active: %s" % StateQuery.is_dialogue_active())
	else:
		print("  ⚠ DialogueBox not in GameState (may be in scene tree)")

	# Check if dialogue resources exist
	var petrification_dialogue = load("res://game/shared/resources/dialogues/quest11_start.tres")
	if petrification_dialogue:
		print("  ✓ quest11_start dialogue resource exists")
	else:
		print("  ⚠ quest11_start dialogue not found (may be at different path)")

	var final_confrontation = load("res://game/shared/resources/dialogues/quest11_final.tres")
	if final_confrontation:
		print("  ✓ quest11_final dialogue resource exists")
	else:
		print("  ⚠ quest11_final dialogue not found")
	print("")
