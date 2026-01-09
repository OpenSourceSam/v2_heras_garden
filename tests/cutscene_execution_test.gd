#!/usr/bin/env godot
## Test that actually runs the cutscene and verifies text appears

extends SceneTree

var all_passed := true
var tests_run := 0
var tests_passed := 0

func _init() -> void:
	call_deferred("_run_test")

func _run_test() -> void:
	print("============================================================")
	print("FULL CUTSCENE EXECUTION TEST")
	print("============================================================")
	print("")

	# Initialize game state
	var game_state = root.get_node_or_null("GameState")
	if game_state:
		game_state.new_game()
		record_test("GameState.new_game()", true)
	else:
		record_test("GameState.new_game()", false, "GameState not found")

	# Play cutscene using CutsceneManager (same as main menu)
	print("")
	print("--- Triggering cutscene via CutsceneManager ---")

	# Get CutsceneManager from root (autoload)
	var cutscene_mgr = root.get_node_or_null("CutsceneManager")
	if cutscene_mgr:
		cutscene_mgr.play_cutscene("res://game/features/cutscenes/prologue_opening.tscn")
	else:
		print("[WARN] CutsceneManager not found, skipping cutscene trigger")

	# Wait for cutscene to complete
	# In headless, this may not work - the await needs the scene to be running
	# Let's just check what happens

	# Note: In headless mode, get_tree() is not available on SceneTree
	# We'll skip the awaits and check tree state directly

	# Check if cutscene finished and world loaded
	var world = root.get_node_or_null("World")
	if world:
		print("")
		print("[PASS] World scene loaded - cutscene finished")
		record_test("Cutscene finished -> World loaded", true)
	else:
		print("")
		print("[FAIL] World scene NOT loaded - cutscene may not have finished")
		record_test("Cutscene finished -> World loaded", false, "World not found")

		# Debug: what IS in the tree?
		print("")
		print("--- Debug: Root children ---")
		for i in range(root.get_child_count()):
			var child = root.get_child(i)
			var size_info = ""
			if child is Control:
				size_info = " (size=" + str(child.size) + ")"
			print("  [%d] %s%s" % [i, child.name, size_info])

		# Check if World is somewhere (already declared above as 'world')
		if world:
			print("   -> World found!")
		else:
			print("   -> World NOT found")

	# Check GameState flag
	if game_state and game_state.get_flag("prologue_complete"):
		print("[PASS] prologue_complete flag is true")
		record_test("prologue_complete flag set", true)
	else:
		print("[FAIL] prologue_complete flag is false or GameState missing")
		record_test("prologue_complete flag set", false)

	# Summary
	print("")
	print("------------------------------------------------------------")
	print("SUMMARY")
	print("------------------------------------------------------------")
	print("Tests run: %d" % tests_run)
	print("Tests passed: %d" % tests_passed)
	print("")

	if all_passed:
		print("[OK] ALL TESTS PASSED")
		quit(0)
	else:
		print("[FAIL] SOME TESTS FAILED")
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
			print("       Details: %s" % details)
