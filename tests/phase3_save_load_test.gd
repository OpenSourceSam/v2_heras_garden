#!/usr/bin/env godot
## Headless test for Phase 3 save/load edge cases.

extends SceneTree

var all_passed := true
var tests_run := 0
var tests_passed := 0

func _init() -> void:
	call_deferred("_run_all_tests")

func _run_all_tests() -> void:
	print("============================================================")
	print("PHASE 3 SAVE/LOAD EDGE CASE TEST")
	print("============================================================")

	# Get autoloads
	var save_controller = root.get_node_or_null("SaveController")
	var game_state = root.get_node_or_null("GameState")
	var constants = root.get_node_or_null("Constants")

	if not save_controller:
		print("[FAIL] SaveController autoload not found")
		quit(1)
		return

	if not game_state:
		print("[FAIL] GameState autoload not found")
		quit(1)
		return

	if not constants:
		print("[FAIL] Constants autoload not found")
		quit(1)
		return

	# Clean up any existing save
	save_controller.delete_save()

	test_save_load_basic(game_state, save_controller)
	test_save_load_inventory(game_state, save_controller)
	test_save_load_quest_flags(game_state, save_controller)
	test_save_load_farm_plots(game_state, save_controller)
	test_save_exists_behavior(save_controller)
	test_corrupt_save_handling(save_controller, constants)

	# Clean up
	save_controller.delete_save()

	print("============================================================")
	print("TEST SUMMARY")
	print("============================================================")
	print("Tests run: " + str(tests_run))
	print("Tests passed: " + str(tests_passed))
	print("Tests failed: " + str(tests_run - tests_passed))

	if all_passed:
		print("\n[OK] ALL SAVE/LOAD EDGE CASE TESTS PASSED")
		quit(0)
	else:
		print("\n[FAIL] SOME SAVE/LOAD EDGE CASE TESTS FAILED")
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

# ============================================
# BASIC SAVE/LOAD
# ============================================

func test_save_load_basic(game_state, save_controller) -> void:
	print("\n--- Testing Basic Save/Load ---")

	# Initial state
	record_test("Fresh game has day=1", game_state.current_day == 1)
	record_test("Fresh game has gold=100", game_state.gold == 100)

	# Advance day
	game_state.current_day = 5
	record_test("Can advance day to 5", game_state.current_day == 5)

	# Save
	var save_result = save_controller.save_game()
	record_test("Save returns true", save_result == true)

	# Verify save exists
	record_test("Save file exists after save", save_controller.save_exists() == true)

	# Load
	game_state.current_day = 1  # Reset to verify load works
	var load_result = save_controller.load_game()
	record_test("Load returns true", load_result == true)

	# Verify restored
	record_test("Day restored to 5 after load", game_state.current_day == 5)

	# Modify after load
	game_state.gold = 999
	game_state.current_day = 10

	# Load again (should overwrite)
	load_result = save_controller.load_game()
	record_test("Second load returns true", load_result == true)
	record_test("Day is still 5 (first save)", game_state.current_day == 5)
	record_test("Gold still 100 (first save)", game_state.gold == 100)

# ============================================
# INVENTORY SAVE/LOAD
# ============================================

func test_save_load_inventory(game_state, save_controller) -> void:
	print("\n--- Testing Inventory Save/Load ---")

	game_state.new_game()

	# Add items (new_game adds 3 wheat_seed, account for that)
	var initial_wheat = game_state.get_item_count("wheat_seed")
	game_state.add_item("moly", 3)
	game_state.add_item("wheat_seed", 5)
	record_test("Added moly (3)", game_state.get_item_count("moly") == 3)
	record_test("Added wheat_seed (5)", game_state.get_item_count("wheat_seed") == initial_wheat + 5)

	# Save and load
	save_controller.save_game()
	game_state.new_game()  # Reset inventory (has starter items)
	var wheat_after_new = game_state.get_item_count("wheat_seed")
	record_test("New game has starter wheat_seed", wheat_after_new > 0)

	var load_result = save_controller.load_game()
	record_test("Load inventory succeeds", load_result == true)
	record_test("Moly restored (3)", game_state.get_item_count("moly") == 3)
	record_test("Wheat seed restored (+5 added)", game_state.get_item_count("wheat_seed") >= wheat_after_new + 5)

	# Test removal then load
	var moly_before = game_state.get_item_count("moly")
	game_state.remove_item("moly", 2)
	record_test("Removed 2 moly", game_state.get_item_count("moly") == moly_before - 2)

	# Load original save
	load_result = save_controller.load_game()
	record_test("Load restores full moly", game_state.get_item_count("moly") == 3)

# ============================================
# QUEST FLAGS SAVE/LOAD
# ============================================

func test_save_load_quest_flags(game_state, save_controller) -> void:
	print("\n--- Testing Quest Flags Save/Load ---")

	game_state.new_game()

	# Count initial flags (new_game sets some)
	var initial_flags = game_state.quest_flags.size()

	# Set quest flags
	game_state.set_flag("quest_1_active", true)
	game_state.set_flag("quest_1_complete", true)
	game_state.set_flag("quest_2_active", true)
	record_test("Set 3 additional quest flags", game_state.quest_flags.size() >= initial_flags + 3)

	# Save and load
	save_controller.save_game()
	game_state.new_game()  # Reset (new_game sets prologue_complete)
	# Note: new_game() doesn't fully clear flags, it resets to initial state
	# What matters is that load() restores our saved state
	record_test("New game resets to initial", game_state.get_flag("prologue_complete") == true)

	var load_result = save_controller.load_game()
	record_test("Load quest flags succeeds", load_result == true)
	record_test("All flags restored", game_state.quest_flags.size() == 4)
	record_test("prologue_complete is true", game_state.get_flag("prologue_complete") == true)
	record_test("quest_1_active is true", game_state.get_flag("quest_1_active") == true)
	record_test("quest_1_complete is true", game_state.get_flag("quest_1_complete") == true)
	record_test("quest_2_active is true", game_state.get_flag("quest_2_active") == true)

# ============================================
# FARM PLOTS SAVE/LOAD
# ============================================

func test_save_load_farm_plots(game_state, save_controller) -> void:
	print("\n--- Testing Farm Plots Save/Load ---")

	game_state.new_game()

	# Add a farm plot
	var plot_pos = Vector2i(0, 0)
	game_state.farm_plots[plot_pos] = {
		"tilled": true,
		"planted": true,
		"crop_id": "moly",
		"growth_stage": 2,
		"days_planted": 2
	}
	record_test("Added farm plot", game_state.farm_plots.has(plot_pos))

	# Save and load
	save_controller.save_game()
	game_state.farm_plots.clear()  # Clear plots
	record_test("Cleared farm plots", game_state.farm_plots.is_empty())

	var load_result = save_controller.load_game()
	record_test("Load farm plots succeeds", load_result == true)
	record_test("Farm plot restored", game_state.farm_plots.has(plot_pos))
	var restored_plot = game_state.farm_plots[plot_pos]
	record_test("Plot tilled state preserved", restored_plot.get("tilled") == true)
	record_test("Plot planted state preserved", restored_plot.get("planted") == true)
	record_test("Plot crop_id preserved", restored_plot.get("crop_id") == "moly")
	record_test("Plot growth_stage preserved", restored_plot.get("growth_stage") == 2)

# ============================================
# SAVE EXISTS BEHAVIOR
# ============================================

func test_save_exists_behavior(save_controller) -> void:
	print("\n--- Testing Save Exists Behavior ---")

	# Clean state
	save_controller.delete_save()
	record_test("No save file initially", save_controller.save_exists() == false)

	var info = save_controller.get_save_info()
	record_test("get_save_info returns empty when no save", info.is_empty())

	# Create save
	var game_state = root.get_node_or_null("GameState")
	game_state.current_day = 10
	save_controller.save_game()
	record_test("Save file exists after save", save_controller.save_exists() == true)

	info = save_controller.get_save_info()
	record_test("get_save_info returns data", info.has("day"))
	record_test("get_save_info day=10", info.get("day") == 10)

	# Delete save
	save_controller.delete_save()
	record_test("Save file deleted", save_controller.save_exists() == false)

# ============================================
# CORRUPT SAVE HANDLING
# ============================================

func test_corrupt_save_handling(save_controller, constants) -> void:
	print("\n--- Testing Corrupt Save Handling ---")

	# Clean first
	save_controller.delete_save()

	# Create corrupt save file
	var corrupt_data = "{ this is not valid json }"
	var file := FileAccess.open(constants.SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_string(corrupt_data)
	file.close()

	record_test("Corrupt file exists", save_controller.save_exists())

	# Try to load corrupt file
	var load_result = save_controller.load_game()
	record_test("Load corrupt file returns false", load_result == false)

	# Clean up
	save_controller.delete_save()

	# Test empty object
	file = FileAccess.open(constants.SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_string("{}")
	file.close()

	load_result = save_controller.load_game()
	record_test("Load empty dict returns true", load_result == true)

	# Clean up
	save_controller.delete_save()
