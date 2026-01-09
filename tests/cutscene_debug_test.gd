#!/usr/bin/env godot
## Debug test - Check where cutscene is added in tree

extends SceneTree

func _init() -> void:
	call_deferred("_run_debug")

func _run_debug() -> void:
	print("=== CUTSCENE TREE DEBUG ===")
	print("")

	# Load main menu
	var error = change_scene_to_file("res://game/features/ui/main_menu.tscn")
	print("Main menu load error: %d" % error)

	await get_tree().process_frame

	# Check tree structure
	print("")
	print("--- Tree structure ---")
	print("Root children count: %d" % get_tree().root.get_child_count())

	for i in range(get_tree().root.get_child_count()):
		var child = get_tree().root.get_child(i)
		print("  [%d] %s (type: %s)" % [i, child.name, child.get_class()])

	# Now simulate what happens when New Game is pressed
	print("")
	print("--- Simulating New Game ---")

	var game_state = get_tree().root.get_node_or_null("GameState")
	if game_state:
		game_state.new_game()
		print("GameState.new_game() called")

	# Load and add cutscene
	var prologue_path := "res://game/features/cutscenes/prologue_opening.tscn"
	var prologue_scene = load(prologue_path)
	if prologue_scene:
		var prologue = prologue_scene.instantiate()
		get_tree().root.add_child(prologue)
		print("Cutscene added to root")

		await get_tree().process_frame

		print("")
		print("--- After adding cutscene ---")
		print("Root children count: %d" % get_tree().root.get_child_count())

		for i in range(get_tree().root.get_child_count()):
			var child = get_tree().root.get_child(i)
			print("  [%d] %s (type: %s)" % [i, child.name, child.get_class()])

		# Check cutscene position/size
		var base = prologue as Control
		if base:
			print("")
			print("--- CutsceneBase properties ---")
			print("  name: %s" % base.name)
			print("  position: %s" % base.position)
			print("  size: %s" % base.size)
			print("  anchors_preset: %s" % base.anchors_preset)
			print("  anchor_right: %s" % base.anchor_right)
			print("  anchor_bottom: %s" % base.anchor_bottom)

			var narration = base.get_node_or_null("NarrationLabel")
			if narration:
				print("")
				print("--- NarrationLabel properties ---")
				print("  position: %s" % narration.position)
				print("  size: %s" % narration.size)
				print("  anchors_preset: %s" % narration.anchors_preset)
				print("  offset_left: %s" % narration.offset_left)
				print("  offset_top: %s" % narration.offset_top)
				print("  offset_right: %s" % narration.offset_right)
				print("  offset_bottom: %s" % narration.offset_bottom)
				print("  custom_minimum_size: %s" % narration.custom_minimum_size)

		# Check if cutscene is child of MainMenu
		var main_menu = get_tree().root.get_node_or_null("MainMenu")
		if main_menu:
			var cutscene_as_child = main_menu.get_node_or_null("PrologueOpening")
			if cutscene_as_child:
				print("")
				print("!!! CUTSCENE IS CHILD OF MAINMENU !!!")
			else:
				print("")
				print("Cutscene is NOT a child of MainMenu (good)")

		prologue.queue_free()

	print("")
	print("=== DEBUG COMPLETE ===")
	quit(0)
