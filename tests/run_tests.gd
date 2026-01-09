extends SceneTree
## Automated test runner for Circe's Garden v2
## Run with: godot --headless --script tests/run_tests.gd

## ⚠️ IMPORTANT: Testing Limitations
## This file contains HEADLESS tests only.
## Headless tests verify logic and mechanics but CANNOT validate:
## - UI visibility and rendering
## - Human playability
## - Visual feedback and polish
## - Game feel and pacing
##
## For playability validation, you MUST run HEADED tests:
## godot --path . --script tests/visual_walkthrough_test.gd
## godot --path . --script tests/autonomous_playthrough_quest3.gd

var passed: int = 0
var failed: int = 0

func _init() -> void:
	# Defer execution so autoloads are initialized before tests run.
	call_deferred("_run_all_tests")

func _run_all_tests() -> void:
	print("=".repeat(60))
	print("CIRCE'S GARDEN V2 - TEST SUITE")
	print("=".repeat(60))
	print("")

	_run_test("Test 1: Autoloads Registered", _test_autoloads)
	_run_test("Test 2: Resource Classes Compile", _test_resource_classes)
	_run_test("Test 3: TILE_SIZE Constant Defined", _test_tile_size)
	_run_test("Test 4: GameState Initialization", _test_game_state_init)
	_run_test("Test 5: Scene Wiring", _test_scene_wiring)

	print("")
	print("=".repeat(60))
	print("TEST SUMMARY")
	print("=".repeat(60))
	print("Passed: %d" % passed)
	print("Failed: %d" % failed)
	print("Total:  %d" % (passed + failed))
	print("")

	if failed == 0:
		print("[OK] ALL TESTS PASSED")
		quit(0)
	else:
		print("[FAIL] SOME TESTS FAILED")
		quit(1)

func _run_test(test_name: String, test_callable: Callable) -> void:
	print("[RUNNING] %s" % test_name)
	var result = test_callable.call()
	if result:
		passed += 1
		print("[PASS] %s" % test_name)
	else:
		failed += 1
		print("[FAIL] %s" % test_name)
	print("")

# ============================================
# TEST: Autoloads Registered
# ============================================

func _test_autoloads() -> bool:
	var required_autoloads = ["GameState", "AudioController", "SaveController"]
	var all_exist = true

	for autoload_name in required_autoloads:
		if root.has_node(autoload_name):
			print("  [OK] %s found" % autoload_name)
		else:
			print("  [FAIL] %s NOT FOUND" % autoload_name)
			all_exist = false

	return all_exist

# ============================================
# TEST: Resource Classes Compile
# ============================================

func _test_resource_classes() -> bool:
	var resource_scripts = {
		"CropData": "res://src/resources/crop_data.gd",
		"ItemData": "res://src/resources/item_data.gd",
		"DialogueData": "res://src/resources/dialogue_data.gd",
		"NPCData": "res://src/resources/npc_data.gd",
	}
	var all_exist = true

	for cls_name in resource_scripts.keys():
		var script_path = resource_scripts[cls_name]
		var script = load(script_path)
		if script:
			print("  [OK] %s script loads" % cls_name)
		else:
			print("  [FAIL] %s script failed to load (%s)" % [cls_name, script_path])
			all_exist = false

	return all_exist

# ============================================
# TEST: TILE_SIZE Constant
# ============================================

func _test_tile_size() -> bool:
	var constants = root.get_node_or_null("Constants")
	if not constants:
		print("  [FAIL] Constants autoload not found")
		return false

	if constants.TILE_SIZE == 32:
		print("  [OK] TILE_SIZE = %d (correct)" % constants.TILE_SIZE)
		return true

	print("  [FAIL] TILE_SIZE = %d (expected 32)" % constants.TILE_SIZE)
	return false

# ============================================
# TEST: GameState Initialization
# ============================================

func _test_game_state_init() -> bool:
	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		print("  [FAIL] GameState not found")
		return false

	var checks_passed = true

	if game_state.current_day == 1:
		print("  [OK] current_day initialized to 1")
	else:
		print("  [FAIL] current_day = %d (expected 1)" % game_state.current_day)
		checks_passed = false

	if game_state.gold == 100:
		print("  [OK] gold initialized to 100")
	else:
		print("  [FAIL] gold = %d (expected 100)" % game_state.gold)
		checks_passed = false

	if game_state.inventory is Dictionary:
		print("  [OK] inventory is Dictionary")
	else:
		print("  [FAIL] inventory is not Dictionary")
		checks_passed = false

	if game_state.quest_flags is Dictionary:
		print("  [OK] quest_flags is Dictionary")
	else:
		print("  [FAIL] quest_flags is not Dictionary")
		checks_passed = false

	game_state.add_item("test_item", 5)
	if game_state.get_item_count("test_item") == 5:
		print("  [OK] add_item() works")
	else:
		print("  [FAIL] add_item() failed")
		checks_passed = false

	if game_state.has_item("test_item", 3):
		print("  [OK] has_item() works")
	else:
		print("  [FAIL] has_item() failed")
		checks_passed = false

	if game_state.remove_item("test_item", 2):
		print("  [OK] remove_item() works")
	else:
		print("  [FAIL] remove_item() failed")
		checks_passed = false

	if game_state.get_item_count("test_item") == 3:
		print("  [OK] item count correct after removal")
	else:
		print("  [FAIL] item count incorrect (got %d, expected 3)" % game_state.get_item_count("test_item"))
		checks_passed = false

	return checks_passed

# ============================================
# TEST: Scene Wiring
# ============================================

func _test_scene_wiring() -> bool:
	var scene_paths = [
		"res://game/features/player/player.tscn",
		"res://game/features/farm_plot/farm_plot.tscn",
		"res://game/features/ui/main_menu.tscn",
		"res://game/features/ui/dialogue_box.tscn",
		"res://game/features/ui/debug_hud.tscn",
	]

	var all_ok = true

	for path in scene_paths:
		var packed_scene = load(path)
		if not packed_scene:
			print("  [FAIL] Could not load scene: %s" % path)
			all_ok = false
			continue

		var instance = packed_scene.instantiate()
		var script = instance.get_script()
		if script == null:
			print("  [FAIL] No script attached to root: %s" % path)
			all_ok = false
		else:
			print("  [OK] Script attached: %s" % path)

		instance.queue_free()

	return all_ok
