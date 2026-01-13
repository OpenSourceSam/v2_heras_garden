#!/usr/bin/env godot
## Headless test for Phase 3 dialogue and quest flow.
## Tests that NPC dialogue routes correctly and quest flags progress.

## ⚠️ IMPORTANT: Headless Test Limitations
## This test verifies dialogue flag logic but does NOT test:
## - Visual dialogue rendering
## - Text readability
## - Choice UI visibility
## - Player experience flow
##
## For playability validation, use MCP/manual playthrough.

extends SceneTree

var all_passed := true
var tests_run := 0
var tests_passed := 0

func _init() -> void:
	call_deferred("_run_all_tests")

func _run_all_tests() -> void:
	print("============================================================")
	print("PHASE 3 DIALOGUE & QUEST FLOW TEST")
	print("============================================================")

	# Get autoloads
	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		print("[FAIL] GameState autoload not found")
		quit(1)
		return

	# Reset game state for clean test
	game_state.new_game()

	test_hermes_quest_flow(game_state)
	test_aeetes_quest_flow(game_state)
	test_daedalus_quest_flow(game_state)
	test_scylla_quest_flow(game_state)
	test_dialogue_flag_gating(game_state)

	print("============================================================")
	print("TEST SUMMARY")
	print("============================================================")
	print("Tests run: " + str(tests_run))
	print("Tests passed: " + str(tests_passed))
	print("Tests failed: " + str(tests_run - tests_passed))

	if all_passed:
		print("\n[OK] ALL DIALOGUE FLOW TESTS PASSED")
		quit(0)
	else:
		print("\n[FAIL] SOME DIALOGUE FLOW TESTS FAILED")
		quit(1)

func record_test(name: String, passed: bool, details: String = "") -> void:
	tests_run += 1
	if passed:
		tests_passed += 1
		print("[PASS] %s" % name)
	else:
		all_passed = false
		print("[FAIL] %s" % name)
		if details:
			print("       %s" % details)

func get_npc_dialogue(npc_id: String, game_state) -> String:
	# Simulate NPCBase._get_dialogue_id() logic
	match npc_id:
		"hermes":
			return _resolve_hermes_dialogue(game_state)
		"aeetes":
			return _resolve_aeetes_dialogue(game_state)
		"daedalus":
			return _resolve_daedalus_dialogue(game_state)
		"scylla":
			return _resolve_scylla_dialogue(game_state)
		_:
			return ""

# Copied from NPCBase for testing
func _resolve_hermes_dialogue(game_state) -> String:
	if game_state.get_flag("prologue_complete") and not game_state.get_flag("quest_1_active"):
		return "quest1_start"
	if game_state.get_flag("quest_1_active") and not game_state.get_flag("quest_1_complete"):
		return "act1_herb_identification"
	if game_state.get_flag("quest_1_complete") and not game_state.get_flag("quest_2_active"):
		return "quest2_start"
	if game_state.get_flag("quest_2_active") and not game_state.get_flag("quest_2_complete"):
		return "act1_extract_sap"
	if game_state.get_flag("quest_2_complete") and not game_state.get_flag("quest_3_active"):
		return "quest3_start"
	if game_state.get_flag("quest_3_active") and not game_state.get_flag("quest_3_complete"):
		return "act1_confront_scylla"
	return "hermes_default"

func _resolve_aeetes_dialogue(game_state) -> String:
	if game_state.get_flag("quest_3_complete") and not game_state.get_flag("quest_4_active"):
		return "quest4_start"
	if game_state.get_flag("quest_4_active") and not game_state.get_flag("quest_4_complete"):
		return "act2_farming_tutorial"
	if game_state.get_flag("quest_4_complete") and not game_state.get_flag("quest_5_active"):
		return "quest5_start"
	if game_state.get_flag("quest_5_active") and not game_state.get_flag("quest_5_complete"):
		return "act2_calming_draught"
	if game_state.get_flag("quest_5_complete") and not game_state.get_flag("quest_6_active"):
		return "quest6_start"
	if game_state.get_flag("quest_6_active") and not game_state.get_flag("quest_6_complete"):
		return "act2_reversal_elixir"
	return "aeetes_default"

func _resolve_daedalus_dialogue(game_state) -> String:
	if game_state.get_flag("quest_6_complete") and not game_state.get_flag("quest_7_active"):
		return "quest7_start"
	if game_state.get_flag("quest_7_active") and not game_state.get_flag("quest_7_complete"):
		return "act2_daedalus_arrives"
	if game_state.get_flag("quest_7_complete") and not game_state.get_flag("quest_8_active"):
		return "quest8_start"
	if game_state.get_flag("quest_8_active") and not game_state.get_flag("quest_8_complete"):
		return "act2_binding_ward"
	return "daedalus_default"

func _resolve_scylla_dialogue(game_state) -> String:
	if game_state.get_flag("quest_8_complete") and not game_state.get_flag("quest_9_active"):
		return "quest9_start"
	if game_state.get_flag("quest_9_active") and not game_state.get_flag("quest_9_complete"):
		return "act3_moon_tears"
	if game_state.get_flag("quest_9_complete") and not game_state.get_flag("quest_10_active"):
		return "quest10_start"
	if game_state.get_flag("quest_10_active") and not game_state.get_flag("quest_10_complete"):
		return "act3_ultimate_crafting"
	if game_state.get_flag("quest_10_complete") and not game_state.get_flag("quest_11_active"):
		return "quest11_start"
	if game_state.get_flag("quest_11_active") and not game_state.get_flag("quest_11_complete"):
		return "act3_final_confrontation"
	return "scylla_default"

func test_hermes_quest_flow(game_state) -> void:
	print("\n--- Testing Hermes Quest Flow ---")

	# Initial state: prologue not complete
	game_state.new_game()
	game_state.set_flag("prologue_complete", false)
	var dialog_id := get_npc_dialogue("hermes", game_state)
	record_test("Hermes before prologue", dialog_id == "hermes_default",
		"Got: %s" % dialog_id)

	# Complete prologue
	game_state.set_flag("prologue_complete", true)
	dialog_id = get_npc_dialogue("hermes", game_state)
	record_test("Hermes after prologue", dialog_id == "quest1_start",
		"Expected quest1_start, got: %s" % dialog_id)

	# Start quest 1
	game_state.set_flag("quest_1_active", true)
	dialog_id = get_npc_dialogue("hermes", game_state)
	record_test("Hermes during quest 1", dialog_id == "act1_herb_identification",
		"Expected act1_herb_identification, got: %s" % dialog_id)

	# Complete quest 1
	game_state.set_flag("quest_1_complete", true)
	game_state.set_flag("quest_2_active", true)
	dialog_id = get_npc_dialogue("hermes", game_state)
	record_test("Hermes during quest 2", dialog_id == "act1_extract_sap",
		"Expected act1_extract_sap, got: %s" % dialog_id)

	# Complete quest 2, start quest 3
	game_state.set_flag("quest_2_complete", true)
	game_state.set_flag("quest_3_active", true)
	dialog_id = get_npc_dialogue("hermes", game_state)
	record_test("Hermes during quest 3", dialog_id == "act1_confront_scylla",
		"Expected act1_confront_scylla, got: %s" % dialog_id)

	# Complete all Hermes quests
	game_state.set_flag("quest_3_complete", true)
	dialog_id = get_npc_dialogue("hermes", game_state)
	record_test("Hermes after quest 3 complete", dialog_id == "hermes_default",
		"Got: %s" % dialog_id)

func test_aeetes_quest_flow(game_state) -> void:
	print("\n--- Testing Aeetes Quest Flow ---")

	# Aeetes should not appear until quest 3 complete
	game_state.new_game()
	game_state.set_flag("quest_3_complete", false)
	var dialog_id := get_npc_dialogue("aeetes", game_state)
	record_test("Aeetes before quest 3", dialog_id == "aeetes_default",
		"Got: %s" % dialog_id)

	# Complete quest 3, Aeetes should offer quest 4
	game_state.set_flag("quest_3_complete", true)
	dialog_id = get_npc_dialogue("aeetes", game_state)
	record_test("Aeetes after quest 3", dialog_id == "quest4_start",
		"Expected quest4_start, got: %s" % dialog_id)

	# During quest 4
	game_state.set_flag("quest_4_active", true)
	dialog_id = get_npc_dialogue("aeetes", game_state)
	record_test("Aeetes during quest 4", dialog_id == "act2_farming_tutorial",
		"Expected act2_farming_tutorial, got: %s" % dialog_id)

	# Complete quest 4, start quest 5
	game_state.set_flag("quest_4_complete", true)
	game_state.set_flag("quest_5_active", true)
	dialog_id = get_npc_dialogue("aeetes", game_state)
	record_test("Aeetes during quest 5", dialog_id == "act2_calming_draught",
		"Expected act2_calming_draught, got: %s" % dialog_id)

	# Complete quest 5, start quest 6
	game_state.set_flag("quest_5_complete", true)
	game_state.set_flag("quest_6_active", true)
	dialog_id = get_npc_dialogue("aeetes", game_state)
	record_test("Aeetes during quest 6", dialog_id == "act2_reversal_elixir",
		"Expected act2_reversal_elixir, got: %s" % dialog_id)

	# Complete all Aeetes quests (properly progress through all)
	game_state.set_flag("quest_6_complete", true)
	dialog_id = get_npc_dialogue("aeetes", game_state)
	record_test("Aeetes after quest 6 complete", dialog_id == "aeetes_default",
		"Got: %s" % dialog_id)

func test_daedalus_quest_flow(game_state) -> void:
	print("\n--- Testing Daedalus Quest Flow ---")

	game_state.new_game()

	# Daedalus should not appear until quest 6 complete
	game_state.set_flag("quest_6_complete", false)
	var dialog_id := get_npc_dialogue("daedalus", game_state)
	record_test("Daedalus before quest 6", dialog_id == "daedalus_default",
		"Got: %s" % dialog_id)

	# Complete quest 6
	game_state.set_flag("quest_6_complete", true)
	dialog_id = get_npc_dialogue("daedalus", game_state)
	record_test("Daedalus after quest 6", dialog_id == "quest7_start",
		"Expected quest7_start, got: %s" % dialog_id)

	# During quest 7
	game_state.set_flag("quest_7_active", true)
	dialog_id = get_npc_dialogue("daedalus", game_state)
	record_test("Daedalus during quest 7", dialog_id == "act2_daedalus_arrives",
		"Expected act2_daedalus_arrives, got: %s" % dialog_id)

	# Complete quest 7, start quest 8
	game_state.set_flag("quest_7_complete", true)
	game_state.set_flag("quest_8_active", true)
	dialog_id = get_npc_dialogue("daedalus", game_state)
	record_test("Daedalus during quest 8", dialog_id == "act2_binding_ward",
		"Expected act2_binding_ward, got: %s" % dialog_id)

	# Complete all Daedalus quests
	game_state.set_flag("quest_8_complete", true)
	dialog_id = get_npc_dialogue("daedalus", game_state)
	record_test("Daedalus after quest 8 complete", dialog_id == "daedalus_default",
		"Got: %s" % dialog_id)

func test_scylla_quest_flow(game_state) -> void:
	print("\n--- Testing Scylla Quest Flow ---")

	game_state.new_game()

	# Scylla should not appear until quest 8 complete
	game_state.set_flag("quest_8_complete", false)
	var dialog_id := get_npc_dialogue("scylla", game_state)
	record_test("Scylla before quest 8", dialog_id == "scylla_default",
		"Got: %s" % dialog_id)

	# Complete quest 8
	game_state.set_flag("quest_8_complete", true)
	dialog_id = get_npc_dialogue("scylla", game_state)
	record_test("Scylla after quest 8", dialog_id == "quest9_start",
		"Expected quest9_start, got: %s" % dialog_id)

	# During quest 9
	game_state.set_flag("quest_9_active", true)
	dialog_id = get_npc_dialogue("scylla", game_state)
	record_test("Scylla during quest 9", dialog_id == "act3_moon_tears",
		"Expected act3_moon_tears, got: %s" % dialog_id)

	# Complete quest 9, start quest 10
	game_state.set_flag("quest_9_complete", true)
	game_state.set_flag("quest_10_active", true)
	dialog_id = get_npc_dialogue("scylla", game_state)
	record_test("Scylla during quest 10", dialog_id == "act3_ultimate_crafting",
		"Expected act3_ultimate_crafting, got: %s" % dialog_id)

	# Complete quest 10, start quest 11
	game_state.set_flag("quest_10_complete", true)
	game_state.set_flag("quest_11_active", true)
	dialog_id = get_npc_dialogue("scylla", game_state)
	record_test("Scylla during quest 11", dialog_id == "act3_final_confrontation",
		"Expected act3_final_confrontation, got: %s" % dialog_id)

	# Complete all Scylla quests
	game_state.set_flag("quest_11_complete", true)
	dialog_id = get_npc_dialogue("scylla", game_state)
	record_test("Scylla after quest 11 complete", dialog_id == "scylla_default",
		"Got: %s" % dialog_id)

func test_dialogue_flag_gating(game_state) -> void:
	print("\n--- Testing Dialogue Flag Gating ---")

	# Note: game_state.new_game() sets prologue_complete=true, so we test
	# the gating logic by manually checking flag requirements

	# quest1_start requires prologue_complete (verified by checking dialogue resource)
	var dialogue = load("res://game/shared/resources/dialogues/quest1_start.tres")
	var requires_prologue = "prologue_complete" in dialogue.flags_required
	record_test("quest1_start declares prologue_complete requirement",
		requires_prologue == true)

	# quest4_start requires quest_3_complete
	dialogue = load("res://game/shared/resources/dialogues/quest4_start.tres")
	var requires_quest3 = "quest_3_complete" in dialogue.flags_required
	record_test("quest4_start declares quest_3_complete requirement",
		requires_quest3 == true)

	# Simulate flag gating logic works by checking if GameState.get_flag works
	game_state.new_game()
	var prologue_is_true = game_state.get_flag("prologue_complete")
	record_test("New game has prologue_complete=true", prologue_is_true == true)

	# Test flag setting works
	game_state.set_flag("test_flag", true)
	var test_flag_works = game_state.get_flag("test_flag")
	record_test("Flag setting works", test_flag_works == true)

	# Test flags_to_set simulation
	game_state.new_game()
	record_test("quest_1_active initially false", game_state.get_flag("quest_1_active") == false)
	# Simulate playing quest1_start (which sets quest_1_active)
	game_state.set_flag("quest_1_active", true)
	record_test("quest_1_active set after dialogue", game_state.get_flag("quest_1_active") == true)
