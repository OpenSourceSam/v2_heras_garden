#!/usr/bin/env godot
## Manual Playthrough Test - ACTUAL Game Flow
## Tests the real quest progression by actually playing through

extends SceneTree

var _game_state = null
var _scene_manager = null

func _init() -> void:
	call_deferred("_run_playthrough")

func _run_playthrough() -> void:
	print("============================================================")
	print("MANUAL PLAYTHROUGH TEST - ACTUAL GAME FLOW")
	print("============================================================\n")

	# Get autoloads
	_game_state = root.get_node_or_null("GameState")
	_scene_manager = root.get_node_or_null("SceneManager")

	if not _game_state:
		print("[ERROR] GameState not found")
		quit(1)
		return

	# START: New Game
	print("=== STEP 1: NEW GAME ===")
	_game_state.new_game()
	await _delay(1.0)
	_print_game_state()

	# PROLOGUE
	print("\n=== STEP 2: PROLOGUE COMPLETE ===")
	await _delay(2.0)
	_print_game_state()

	# WORLD
	print("\n=== STEP 3: WORLD SCENE LOAD ===")
	var error = change_scene_to_file("res://game/features/world/world.tscn")
	if error != OK:
		print("[ERROR] Failed to load world: %d" % error)
		quit(1)
		return
	await _delay(1.0)
	_print_game_state()

	# QUEST 1
	print("\n=== STEP 4: QUEST 1 - HERMES INTERACTION ===")
	# Simulate talking to Hermes
	_game_state.set_flag("quest_1_active", true)
	await _delay(0.5)
	_print_game_state()

	print("\n=== STEP 5: COMPLETE QUEST 1 (Herb Identification) ===")
	# Simulate completing herb identification minigame
	_game_state.add_item("pharmaka_flower", 3)
	_game_state.set_flag("quest_1_complete", true)
	_game_state.set_flag("quest_1_complete_dialogue_seen", true)
	await _delay(0.5)
	_print_game_state()

	# NOW THE CRITICAL TEST: What does Hermes offer next?
	print("\n=== STEP 6: TALK TO HERMES AFTER QUEST 1 ===")
	var hermes_dialogue = _get_hermes_dialogue()
	print("[HERMES DIALOGUE] %s" % hermes_dialogue)
	_print_game_state()

	# Is Quest 2 available?
	var quest_2_exists = _game_state.get_flag("quest_2_active") or _game_state.get_flag("quest_2_complete")
	print("\n[CHECK] Quest 2 exists: %s" % quest_2_exists)

	# Is Quest 3 available?
	var quest_3_exists = _game_state.get_flag("quest_3_active") or _game_state.get_flag("quest_3_complete")
	print("[CHECK] Quest 3 exists: %s" % quest_3_exists)

	# What does Hermes offer?
	if quest_2_exists:
		print("\n[RESULT] After Quest 1, Hermes offers Quest 2")
	elif quest_3_exists:
		print("\n[RESULT] After Quest 1, Hermes offers Quest 3 (skipping Quest 2)")
	else:
		print("\n[RESULT] After Quest 1, no quest available - TESTING Quest 3 activation")
		# Try to activate Quest 3 like the autonomous test does
		_game_state.set_flag("quest_3_active", true)
		await _delay(0.5)
		var hermes_dialogue_after_q3 = _get_hermes_dialogue()
		print("[HERMES AFTER Q3] %s" % hermes_dialogue_after_q3)

	_print_game_state()

	print("\n============================================================")
	print("PLAYTHROUGH COMPLETE")
	print("============================================================")
	quit(0)

func _get_hermes_dialogue() -> String:
	# Check what dialogue Hermes would offer based on flags
	var hermes_dialogue_id = "No dialogue"

	# Based on quest_system.gd logic
	if not _game_state.get_flag("prologue_complete"):
		hermes_dialogue_id = "prologue"
	elif not _game_state.get_flag("quest_1_complete"):
		hermes_dialogue_id = "quest1_start"
	elif _game_state.get_flag("quest_1_complete") and not _game_state.get_flag("quest_1_complete_dialogue_seen"):
		hermes_dialogue_id = "quest1_complete"
	elif _game_state.get_flag("quest_1_complete") and not _game_state.get_flag("quest_3_complete"):
		# This is the key check - does Hermes offer Quest 2 or Quest 3?
		if _game_state.get_flag("quest_2_active") or _game_state.get_flag("quest_2_complete"):
			hermes_dialogue_id = "quest2_start"
		else:
			hermes_dialogue_id = "quest3_start"  # Quest 2 is skipped!
	elif _game_state.get_flag("quest_3_complete") and not _game_state.get_flag("quest_4_complete"):
		hermes_dialogue_id = "quest4_start"
	elif _game_state.get_flag("quest_4_complete"):
		hermes_dialogue_id = "quest5_start"

	return hermes_dialogue_id

func _print_game_state() -> void:
	print("  [STATE]")
	print("    Prologue complete: %s" % _game_state.get_flag("prologue_complete"))
	print("    Quest 1 active: %s, complete: %s, dialogue_seen: %s" % [
		_game_state.get_flag("quest_1_active"),
		_game_state.get_flag("quest_1_complete"),
		_game_state.get_flag("quest_1_complete_dialogue_seen")
	])
	print("    Quest 2 active: %s, complete: %s" % [
		_game_state.get_flag("quest_2_active"),
		_game_state.get_flag("quest_2_complete")
	])
	print("    Quest 3 active: %s, complete: %s" % [
		_game_state.get_flag("quest_3_active"),
		_game_state.get_flag("quest_3_complete")
	])
	print("    Inventory: pharmaka_flower=%d, golden_glow=%d" % [
		_game_state.get_item_count("pharmaka_flower"),
		_game_state.get_item_count("golden_glow")
	])

func _delay(seconds: float) -> void:
	await create_timer(seconds).timeout
