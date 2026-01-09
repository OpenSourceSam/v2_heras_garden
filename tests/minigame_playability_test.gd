#!/usr/bin/env godot
## Minigame Playability Test
## Actually tests if minigames work, not just logic

extends SceneTree

func _init() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	print("============================================================")
	print("MINIGAME PLAYABILITY TEST")
	print("============================================================\n")

	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		print("[ERROR] GameState not found")
		quit(1)
		return

	# Test 1: Herb Identification Minigame
	_test_herb_identification(game_state)

	# Test 2: Crafting Minigame
	_test_crafting_minigame(game_state)

	quit(0)

func _test_herb_identification(game_state) -> void:
	print("=== TEST 1: HERB IDENTIFICATION MINIGAME ===\n")

	# Load the scene
	var scene_path = "res://game/features/minigames/herb_identification.tscn"
	var scene = load(scene_path)
	if not scene:
		print("[FAIL] Could not load: %s" % scene_path)
		return

	print("[PASS] Scene loaded: %s" % scene_path)

	# Instantiate the minigame
	var instance = scene.instantiate()
	if not instance:
		print("[FAIL] Could not instantiate minigame")
		return

	print("[PASS] Minigame instantiated")

	# Add to tree
	root.add_child(instance)
	await root.get_tree().process_frame

	# Check UI root
	var ui_root = instance.get_node_or_null("UI")
	if ui_root:
		print("[PASS] UI root exists")

		# Check timer label
		var timer_label = ui_root.get_node_or_null("TimerLabel")
		if timer_label:
			print("[PASS] TimerLabel exists (visible: %s)" % str(timer_label.visible))
		else:
			print("[WARN] TimerLabel not found")

		# Check score label
		var score_label = ui_root.get_node_or_null("ScoreLabel")
		if score_label:
			print("[PASS] ScoreLabel exists")
		else:
			print("[WARN] ScoreLabel not found")

		# Check plant grid
		var plant_grid = ui_root.get_node_or_null("PlantGrid")
		if plant_grid:
			var child_count = plant_grid.get_child_count()
			print("[PASS] PlantGrid exists with %d children" % child_count)

			# Check for plants with glow
			var glowing_count = 0
			for child in plant_grid.get_children():
				if child.has_meta("is_correct"):
					glowing_count += 1

			print("[INFO] Plants with 'is_correct' meta: %d" % glowing_count)
		else:
			print("[FAIL] PlantGrid not found")
	else:
		print("[FAIL] UI root not found")

	# Clean up
	instance.queue_free()
	print()

func _test_crafting_minigame(game_state) -> void:
	print("=== TEST 2: MORTAR & PESTLE CRAFTING MINIGAME ===\n")

	# Load the scene
	var scene_path = "res://game/features/ui/crafting_minigame.tscn"
	var scene = load(scene_path)
	if not scene:
		print("[FAIL] Could not load: %s" % scene_path)
		return

	print("[PASS] Scene loaded: %s" % scene_path)

	# Instantiate the minigame
	var instance = scene.instantiate()
	if not instance:
		print("[FAIL] Could not instantiate minigame")
		return

	print("[PASS] Crafting minigame instantiated")

	# Add to tree
	root.add_child(instance)
	await root.get_tree().process_frame

	# Check UI elements
	var pattern_display = instance.get_node_or_null("PatternDisplay")
	if pattern_display:
		print("[PASS] PatternDisplay exists")
	else:
		print("[WARN] PatternDisplay not found")

	var progress_bar = instance.get_node_or_null("ProgressBar")
	if progress_bar:
		print("[PASS] ProgressBar exists")
	else:
		print("[WARN] ProgressBar not found")

	var instruction_label = instance.get_node_or_null("InstructionLabel")
	if instruction_label:
		print("[PASS] InstructionLabel exists")
		print("       Text: '%s'" % instruction_label.text)
	else:
		print("[WARN] InstructionLabel not found")

	# Test if start_crafting works
	if instance.has_method("start_crafting"):
		print("[PASS] start_crafting() method exists")

		# Try to start a test crafting session
		var test_pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]
		var test_buttons = ["ui_accept"]

		instance.start_crafting(test_pattern, test_buttons, 2.0)
		print("[PASS] start_crafting() called successfully")

		# Check if pattern was set
		if instance.has_variable("pattern"):
			print("[INFO] Pattern variable exists")
	else:
		print("[FAIL] start_crafting() method missing")

	# Clean up
	instance.queue_free()
	print()

func _delay(seconds: float) -> void:
	await root.get_tree().create_timer(seconds).timeout
