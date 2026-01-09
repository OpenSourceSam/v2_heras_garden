#!/usr/bin/env godot
## Debug test - Check cutscene tree structure

extends SceneTree

func _init() -> void:
	call_deferred("_run_debug")

func _run_debug() -> void:
	print("=== CUTSCENE TREE DEBUG ===")

	# Load main menu
	var error = change_scene_to_file("res://game/features/ui/main_menu.tscn")

	var game_state = root.get_node_or_null("GameState")
	if game_state:
		game_state.new_game()

	# Load and add cutscene
	var prologue_path := "res://game/features/cutscenes/prologue_opening.tscn"
	var prologue_scene = load(prologue_path)
	var prologue = prologue_scene.instantiate()
	root.add_child(prologue)

	# Check tree structure
	print("")
	print("--- Tree Structure ---")
	print("Root children: %d" % root.get_child_count())
	for i in range(root.get_child_count()):
		var child = root.get_child(i)
		var size = Vector2.ZERO
		if child is Control:
			size = child.size
		print("  [%d] %s (type=%s, size=%s)" % [i, child.name, child.get_class(), size])

	# Check MainMenu relationship
	var main_menu = root.get_node_or_null("MainMenu")
	if main_menu:
		var is_child = false
		for child in main_menu.get_children():
			if child.name.begins_with("Prologue"):
				is_child = true
				break
		if is_child:
			print("!!! PROBLEM: Cutscene is CHILD of MainMenu !!!")
		else:
			print("Cutscene is NOT child of MainMenu (correct)")

	# Check cutscene size/position
	var base = prologue as Control
	if base:
		print("")
		print("--- CutsceneBase ---")
		print("  position: %s" % base.position)
		print("  size: %s" % base.size)
		print("  anchor_right: %s" % base.anchor_right)
		print("  anchor_bottom: %s" % base.anchor_bottom)
		print("  layout_mode: %s" % base.layout_mode)
		print("  anchors_preset: %s" % base.anchors_preset)

		var narration = base.get_node_or_null("NarrationLabel")
		if narration:
			print("")
			print("--- NarrationLabel ---")
			print("  position: %s" % narration.position)
			print("  size: %s" % narration.size)
			print("  anchor_top: %s" % narration.anchor_top)
			print("  anchor_bottom: %s" % narration.anchor_bottom)
			print("  custom_minimum_size: %s" % narration.custom_minimum_size)

			# Calculate where it should appear
			var screen_height = 600  # Assume default
			if base.size.y > 0:
				screen_height = base.size.y
			var expected_top = narration.anchor_top * screen_height
			var expected_bottom = narration.anchor_bottom * screen_height
			print("  Expected position: y=%.0f to y=%.0f (screen_height=%.0f)" % [expected_top, expected_bottom, screen_height])

	prologue.queue_free()
	print("")
	print("=== DONE ===")
	quit(0)
