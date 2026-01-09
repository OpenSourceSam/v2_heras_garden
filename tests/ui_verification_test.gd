#!/usr/bin/env godot
## UI Verification Test - Checks cutscene UI properties programmatically

extends SceneTree

var all_passed := true
var tests_run := 0
var tests_passed := 0

func _init() -> void:
	call_deferred("_run_test")

func _run_test() -> void:
	print("============================================================")
	print("UI VERIFICATION TEST")
	print("============================================================")
	print("")

	# Load cutscene directly (not via CutsceneManager which needs headless-compatible path change)
	var prologue_path := "res://game/features/cutscenes/prologue_opening.tscn"
	var prologue_scene = load(prologue_path)
	if prologue_scene == null:
		record_test("Load prologue_opening.tscn", false, "Failed to load scene resource")
		quit_with_result()
		return

	var prologue = prologue_scene.instantiate()
	root.add_child(prologue)

	# Wait for _ready() - use root's tree reference
	await root.get_tree().process_frame

	print("")
	print("--- Checking CutsceneBase Structure ---")

	# Test 1: NarrationLabel exists
	var narration = prologue.get_node_or_null("NarrationLabel")
	record_test("NarrationLabel exists", narration != null)

	if narration:
		# Test 2: Has custom_minimum_size with height > 0
		var min_size = narration.custom_minimum_size
		record_test("NarrationLabel has minimum height", min_size.y >= 100,
			"min_size.y = %d" % min_size.y)

		# Test 3: Anchors are correct (anchor_top = 0.7 means 70% down screen)
		var anchor_top = narration.anchor_top
		var anchor_bottom = narration.anchor_bottom
		record_test("NarrationLabel anchor_top = 0.7", is_equal_approx(anchor_top, 0.7),
			"anchor_top = %s" % anchor_top)
		record_test("NarrationLabel anchor_bottom = 0.9", is_equal_approx(anchor_bottom, 0.9),
			"anchor_bottom = %s" % anchor_bottom)

		# Test 4: Position calculation - with 600px screen, y should be 420-540
		# anchor_top=0.7 * 600 = 420, anchor_bottom=0.9 * 600 = 540
		var screen_height: float = 600.0
		var expected_top: float = screen_height * anchor_top
		var expected_bottom: float = screen_height * anchor_bottom
		var label_height: float = expected_bottom - expected_top

		print("")
		print("--- Position Calculation (screen_height=600) ---")
		print("  Expected y range: %.0f to %.0f" % [expected_top, expected_bottom])
		print("  Label height: %.0f" % label_height)
		print("  Custom minimum height: %d" % min_size.y)

		# Test 5: RichTextLabel properties
		record_test("NarrationLabel is RichTextLabel", narration is RichTextLabel)

		# Test 6: bbcode_enabled is true (needed for color tags)
		record_test("NarrationLabel bbcode_enabled", narration.bbcode_enabled,
			"bbcode_enabled = %s" % narration.bbcode_enabled)

		# Test 7: visible starts as false (shown by show_text())
		record_test("NarrationLabel visible starts false", narration.visible == false,
			"visible = %s" % narration.visible)

		# Test 8: Check parent scene type
		record_test("PrologueOpening has script", prologue.has_method("_ready"))

	# Test 9: AnimationPlayer exists
	var anim_player = prologue.get_node_or_null("AnimationPlayer")
	record_test("AnimationPlayer exists", anim_player != null)

	# Test 10: Overlay exists (black overlay for fade effect)
	var overlay = prologue.get_node_or_null("Overlay")
	record_test("Overlay exists", overlay != null)

	# Cleanup
	prologue.queue_free()

	# Summary
	print("")
	print("------------------------------------------------------------")
	print("SUMMARY")
	print("------------------------------------------------------------")
	print("Tests run: %d" % tests_run)
	print("Tests passed: %d" % tests_passed)
	print("")

	quit_with_result()

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

func quit_with_result() -> void:
	if all_passed:
		print("[OK] ALL TESTS PASSED")
		quit(0)
	else:
		print("[FAIL] SOME TESTS FAILED")
		quit(1)
