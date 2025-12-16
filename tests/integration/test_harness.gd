extends Node
## Integration Test Harness
## Runs automated gameplay sequences and captures results
##
## Usage: Run this scene to execute bot-driven tests
## Results saved to user://test_results/

const TEST_RESULTS_DIR = "user://test_results/"
const SCREENSHOTS_DIR = "user://test_screenshots/"

var test_results: Dictionary = {
	"timestamp": "",
	"tests": [],
	"passed": 0,
	"failed": 0,
}

var current_test: String = ""
var player: CharacterBody2D

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	_ensure_directories()
	test_results["timestamp"] = Time.get_datetime_string_from_system()
	print("[TestHarness] Starting integration tests...")
	
	# Wait for scene to be ready
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Find player
	player = _find_player()
	if not player:
		_log_test("find_player", false, "Player not found in scene")
		_finish_tests()
		return
	
	_log_test("find_player", true, "Player found at %s" % player.global_position)
	
	# Run test sequence
	await _run_movement_tests()
	await _run_gamestate_tests()
	
	_finish_tests()

func _ensure_directories() -> void:
	DirAccess.make_dir_recursive_absolute(TEST_RESULTS_DIR.replace("user://", OS.get_user_data_dir() + "/"))
	DirAccess.make_dir_recursive_absolute(SCREENSHOTS_DIR.replace("user://", OS.get_user_data_dir() + "/"))

# ============================================
# TEST SEQUENCES
# ============================================

func _run_movement_tests() -> void:
	current_test = "movement"
	print("[TestHarness] Running movement tests...")
	
	var start_pos = player.global_position
	_take_screenshot("01_start_position")
	
	# Test move right
	_simulate_input("ui_right", 0.5)
	await get_tree().create_timer(0.6).timeout
	var moved_right = player.global_position.x > start_pos.x
	_log_test("move_right", moved_right, "Moved from %.0f to %.0f" % [start_pos.x, player.global_position.x])
	_take_screenshot("02_after_move_right")
	
	# Test move up
	start_pos = player.global_position
	_simulate_input("ui_up", 0.5)
	await get_tree().create_timer(0.6).timeout
	var moved_up = player.global_position.y < start_pos.y
	_log_test("move_up", moved_up, "Moved from %.0f to %.0f" % [start_pos.y, player.global_position.y])
	_take_screenshot("03_after_move_up")
	
	# Test sprite flip
	_simulate_input("ui_left", 0.3)
	await get_tree().create_timer(0.4).timeout
	var sprite = player.get_node_or_null("Sprite") as Sprite2D
	var flipped = sprite and sprite.flip_h
	_log_test("sprite_flip_left", flipped, "Sprite flip_h = %s" % (sprite.flip_h if sprite else "N/A"))
	_take_screenshot("04_sprite_flipped_left")

func _run_gamestate_tests() -> void:
	current_test = "gamestate"
	print("[TestHarness] Running GameState tests...")
	
	# Test inventory
	var initial_count = GameState.get_item_count("test_item")
	GameState.add_item("test_item", 5)
	var after_add = GameState.get_item_count("test_item")
	_log_test("add_item", after_add == initial_count + 5, "Count: %d -> %d" % [initial_count, after_add])
	
	# Test gold
	var initial_gold = GameState.gold
	GameState.add_gold(100)
	_log_test("add_gold", GameState.gold == initial_gold + 100, "Gold: %d -> %d" % [initial_gold, GameState.gold])
	
	# Test flags
	GameState.set_flag("test_harness_flag", true)
	_log_test("set_flag", GameState.get_flag("test_harness_flag"), "Flag set correctly")
	
	# Test day advance
	var initial_day = GameState.current_day
	GameState.advance_day()
	_log_test("advance_day", GameState.current_day == initial_day + 1, "Day: %d -> %d" % [initial_day, GameState.current_day])

# ============================================
# HELPERS
# ============================================

func _find_player() -> CharacterBody2D:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0] as CharacterBody2D
	return null

func _simulate_input(action: String, duration: float) -> void:
	Input.action_press(action)
	await get_tree().create_timer(duration).timeout
	Input.action_release(action)

func _take_screenshot(screenshot_name: String) -> void:
	await RenderingServer.frame_post_draw
	var image = get_viewport().get_texture().get_image()
	var path = SCREENSHOTS_DIR + screenshot_name + ".png"
	var error = image.save_png(path)
	if error == OK:
		print("[TestHarness] Screenshot saved: %s" % path)
	else:
		print("[TestHarness] Failed to save screenshot: %s" % path)

func _log_test(test_name: String, passed: bool, message: String) -> void:
	var result = {
		"name": current_test + "/" + test_name,
		"passed": passed,
		"message": message,
	}
	test_results["tests"].append(result)
	if passed:
		test_results["passed"] += 1
		print("[PASS] %s: %s" % [result["name"], message])
	else:
		test_results["failed"] += 1
		print("[FAIL] %s: %s" % [result["name"], message])

func _finish_tests() -> void:
	print("\n" + "=".repeat(50))
	print("[TestHarness] Tests Complete!")
	print("Passed: %d / Failed: %d" % [test_results["passed"], test_results["failed"]])
	print("=".repeat(50) + "\n")
	
	# Save results to JSON
	var json_str = JSON.stringify(test_results, "\t")
	var file = FileAccess.open(TEST_RESULTS_DIR + "results.json", FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()
		print("[TestHarness] Results saved to %s" % (TEST_RESULTS_DIR + "results.json"))
	
	# Quit if running in headless mode
	if OS.has_feature("headless"):
		get_tree().quit(test_results["failed"])
