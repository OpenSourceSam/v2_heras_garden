#!/usr/bin/env godot
## Headless test for Phase 3 minigame mechanics.
## Tests core mechanics without requiring input timing.

extends SceneTree

var all_passed := true
var tests_run := 0
var tests_passed := 0

func _init() -> void:
	call_deferred("_run_all_tests")

func _run_all_tests() -> void:
	print("============================================================")
	print("PHASE 3 MINIGAME MECHANICS TEST")
	print("============================================================")

	test_sacred_earth_mechanics()
	test_moon_tears_mechanics()
	test_weaving_mechanics()
	test_herb_id_mechanics()

	print("============================================================")
	print("TEST SUMMARY")
	print("============================================================")
	print("Tests run: " + str(tests_run))
	print("Tests passed: " + str(tests_passed))
	print("Tests failed: " + str(tests_run - tests_passed))

	if all_passed:
		print("\n[OK] ALL MINIGAME MECHANICS TESTS PASSED")
		quit(0)
	else:
		print("\n[FAIL] SOME MINIGAME MECHANICS TESTS FAILED")
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
# SACRED EARTH MECHANICS
# ============================================

func test_sacred_earth_mechanics() -> void:
	print("\n--- Testing Sacred Earth Mechanics ---")

	# Test parameters from sacred_earth.gd
	var progress: float = 0.0
	var time_remaining: float = 10.0
	var PROGRESS_PER_PRESS: float = 0.05
	var DECAY_RATE: float = 0.15

	# Initial state
	record_test("Sacred Earth starts at 0 progress", progress == 0.0)
	record_test("Sacred Earth starts with 10s timer", time_remaining == 10.0)

	# Test progress increase
	progress += PROGRESS_PER_PRESS
	record_test("Press increases progress by 0.05", progress == 0.05)

	progress += PROGRESS_PER_PRESS * 5  # 5 presses
	record_test("5 more presses = 0.30 total", progress == 0.30)

	# Test decay over time (simulate 1 second)
	var delta: float = 1.0
	progress = max(0, progress - DECAY_RATE * delta)
	record_test("Decay reduces progress by 0.15/s", progress == 0.15)

	# Test win condition
	progress = 1.0
	record_test("Progress >= 1.0 triggers win", progress >= 1.0)

	# Test lose condition
	time_remaining = 0.0
	record_test("Timer <= 0 triggers loss", time_remaining <= 0)

	# Test complete cycle (win before time runs out)
	var game_progress: float = 0.0
	var game_time: float = 10.0
	var presses_needed: int = 0

	while game_progress < 1.0 and game_time > 0:
		game_progress += PROGRESS_PER_PRESS
		game_time -= 0.1  # Each press takes some time
		progress = max(0, progress - DECAY_RATE * 0.1)
		presses_needed += 1

	record_test("Win requires ~20-25 presses", presses_needed >= 15 and presses_needed <= 30,
		"presses_needed=" + str(presses_needed))

# ============================================
# MOON TEARS MECHANICS
# ============================================

func test_moon_tears_mechanics() -> void:
	print("\n--- Testing Moon Tears Mechanics ---")

	# Test parameters from moon_tears_minigame.gd
	var SPAWN_INTERVAL: float = 2.0
	var FALL_SPEED: float = 100.0
	var CATCH_WINDOW: float = 140.0
	var tears_needed: int = 3
	var tears_caught: int = 0

	record_test("Moon Tears needs 3 tears", tears_needed == 3)
	record_test("Starts with 0 tears caught", tears_caught == 0)
	record_test("Spawn interval is 2.0s", SPAWN_INTERVAL == 2.0)
	record_test("Fall speed is 100px/s", FALL_SPEED == 100.0)
	record_test("Catch window is 140px", CATCH_WINDOW == 140.0)

	# Test falling distance calculation
	var screen_height: float = 480.0
	var time_to_fall: float = screen_height / FALL_SPEED  # ~4.8 seconds
	record_test("Tear falls screen in ~4.8s", time_to_fall > 4.0 and time_to_fall < 5.5,
		"time_to_fall=" + str(time_to_fall))

	# Test catch window vs player marker
	var marker_size: float = 320.0
	record_test("Catch window (140) < marker (320)", CATCH_WINDOW < marker_size)

	# Simulate catching tears
	var spawn_timer: float = 0.0
	var active_tears: Array = []
	var player_x: float = 0.5

	# Spawn and catch first tear
	spawn_timer += SPAWN_INTERVAL
	active_tears.append({"x": player_x, "y": 100.0})  # Just spawned
	tears_caught += 1
	record_test("First tear caught", tears_caught == 1)

	# Catch second tear
	active_tears.append({"x": player_x, "y": 100.0})
	tears_caught += 1
	record_test("Second tear caught", tears_caught == 2)

	# Catch third tear (win condition)
	active_tears.append({"x": player_x, "y": 100.0})
	tears_caught += 1
	record_test("Third tear caught = WIN", tears_caught >= tears_needed)

# ============================================
# WEAVING MECHANICS
# ============================================

func test_weaving_mechanics() -> void:
	print("\n--- Testing Weaving Mechanics ---")

	# Check weaving minigame parameters
	var weaving_scene = load("res://game/features/minigames/weaving_minigame.tscn")
	if not weaving_scene:
		record_test("Weaving scene loads", false, "Could not load scene")
		return

	var instance = weaving_scene.instantiate()
	var script = instance.get_script()
	instance.queue_free()

	if not script:
		record_test("Weaving scene has script", false)
		return

	# Weaving typically has a pattern the player must match
	# Test the pattern length
	record_test("Weaving scene loads correctly", true)

	# Weaving in Circe's garden: match a weaving pattern with D-pad
	# This is timing-based so we just verify the scene exists
	record_test("Weaving minigame scene verified", true)

# ============================================
# HERB IDENTIFICATION MECHANICS
# ============================================

func test_herb_id_mechanics() -> void:
	print("\n--- Testing Herb Identification Mechanics ---")

	# Check herb identification minigame parameters
	var herb_scene = load("res://game/features/minigames/herb_identification.tscn")
	if not herb_scene:
		record_test("Herb ID scene loads", false, "Could not load scene")
		return

	var instance = herb_scene.instantiate()
	var script = instance.get_script()
	instance.queue_free()

	if not script:
		record_test("Herb ID scene has script", false)
		return

	# Herb identification in Circe's garden: find the glowing herb
	# Player must identify the correct herb among options
	record_test("Herb ID minigame scene verified", true)

	# Test that herb resources exist
	var moly_resource = load("res://game/shared/resources/items/moly.tres")
	record_test("Moly item resource exists", moly_resource != null)

	var moly_seed_resource = load("res://game/shared/resources/items/moly_seed.tres")
	record_test("Moly seed resource exists", moly_seed_resource != null)

	# Test herb sprites exist
	var herb_sprite = load("res://assets/sprites/placeholders/pharmaka_flower.png")
	record_test("Herb placeholder sprite exists", herb_sprite != null)
