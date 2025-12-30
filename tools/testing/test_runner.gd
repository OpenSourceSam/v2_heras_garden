class_name TestRunner
extends Node

## Base test runner class for headless AI testing
## Combines InputSimulator, StateQuery, and ErrorCatcher

# Components
var input: InputSimulator
var state: StateQuery
var errors: ErrorCatcher

# Test results
var test_results: Array = []
var current_test_name: String = ""
var all_passed: bool = true

# Screenshot helper
var papershot: Papershot

# Timing
var _test_start_time: float = 0.0

func _init():
	input = InputSimulator.new()
	state = StateQuery
	errors = ErrorCatcher.new()

func _ready():
	# Add to tree for input to work
	var tree = get_tree()
	if tree:
		tree.root.add_child(self)

	# Setup papershot for screenshots
	papershot = Papershot.new()
	papershot.folder = "res://.godot/screenshots/"
	papershot.file_format = Papershot.PNG
	add_child(papershot)

## ============================================
## TEST MANAGEMENT
## ============================================

## Start a new test
func test(name: String):
	current_test_name = name
	_test_start_time = Time.get_ticks_msec()
	print("[TEST] " + name)

## End current test and record result
func end_test(passed: bool, details: String = ""):
	var elapsed = Time.get_ticks_msec() - _test_start_time
	var result = {
		"name": current_test_name,
		"passed": passed,
		"details": details,
		"elapsed_ms": elapsed
	}
	test_results.append(result)
	if not passed:
		all_passed = false
	print("  [%s] %s (%.0fms)" % ("PASS" if passed else "FAIL", details, elapsed))

## Assert helper - asserts and ends test
func assert(condition: bool, message: String) -> bool:
	var passed = errors.assert(condition, message)
	end_test(passed, message)
	return passed

## ============================================
## SCREENSHOT
## ============================================

## Take a screenshot with optional name
func screenshot(name: String = "") -> String:
	var error = papershot.take_screenshot()
	if error == OK:
		var path = papershot._get_path()
		print("  [SCREENSHOT] " + path.replace("user://", ""))
		return path
	else:
		print("  [SCREENSHOT] FAILED (error " + str(error) + ")")
		return ""

## ============================================
## SCENE NAVIGATION
## ============================================

## Change to a scene
func change_scene(scene_path: String) -> bool:
	var error = get_tree().change_scene_to_file(scene_path)
	if error == OK:
		await get_tree().process_frame
		await get_tree().process_frame
		return true
	return false

## ============================================
## WAIT UTILITIES
## ============================================

## Wait for seconds
func wait(seconds: float) -> void:
	await input.wait(seconds)

## Wait for frames
func wait_frames(frames: int) -> void:
	for i in range(frames):
		await get_tree().process_frame

## ============================================
## REPORTING
## ============================================

## Print final test report
func print_report():
	print("")
	print("=== Test Report ===")
	var passed = 0
	var failed = 0

	for result in test_results:
		if result.passed:
			passed += 1
		else:
			failed += 1

	print("Total: %d | Passed: %d | Failed: %d" % [test_results.size(), passed, failed])
	print("Status: %s" % ("ALL TESTS PASSED" if all_passed else "SOME TESTS FAILED"))
	print("")

## Get summary
func get_summary() -> Dictionary:
	var passed = 0
	var failed = 0
	for r in test_results:
		if r.passed:
			passed += 1
		else:
			failed += 1
	return {
		"total": test_results.size(),
		"passed": passed,
		"failed": failed,
		"all_passed": all_passed
	}

## ============================================
## STATIC CONVENIENCE METHODS
## ============================================

## Quick assertion that ends test
static func quick_assert(condition: bool, test_name: String, message: String) -> bool:
	if condition:
		print("[PASS] " + message)
		return true
	else:
		print("[FAIL] " + message)
		return false
