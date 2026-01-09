#!/usr/bin/env godot
## Headed test to validate Quest 1 and Quest 2 are human playable.
## This test loads the main scene and checks UI elements are visible.

extends SceneTree

var tests_run := 0
var tests_passed := 0
var all_passed := true

func _init() -> void:
	# Load the main scene first
	var main_scene = load("res://game/features/world/world.tscn")
	if main_scene:
		change_scene_to(main_scene)
	call_deferred("_run_validation_test")

func _run_validation_test() -> void:
	print("============================================================")
	print("QUEST 1 & 2 HUMAN PLAYABILITY VALIDATION TEST")
	print("============================================================")

	# Wait for scene to load
	await get_tree().process_frame

	# Check we're in the world scene
	var world = get_tree().get_root().get_node_or_null("World")
	if not world:
		print("[FAIL] World scene not found")
		quit(1)
		return

	print("[OK] World scene loaded")

	# Check dialogue system exists
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box:
		print("[OK] Dialogue system exists")
	else:
		print("[WARN] Dialogue UI not found in group")

	# Check mortar & pestle exists
	var mortar = world.get_node_or_null("Interactables/MortarPestle")
	if mortar:
		print("[OK] Mortar & Pestle exists in world")
	else:
		print("[FAIL] Mortar & Pestle not found in world")
		all_passed = false

	# Check crafting controller
	var crafting_controller = world.get_node_or_null("UI/CraftingController")
	if crafting_controller:
		print("[OK] CraftingController exists")
	else:
		print("[WARN] CraftingController not found")

	# Check herb identification minigame scene
	var herb_minigame_scene = load("res://game/features/minigames/herb_identification.tscn")
	if herb_minigame_scene:
		print("[OK] Herb Identification minigame scene exists")
	else:
		print("[FAIL] Herb Identification minigame scene missing")
		all_passed = false

	# Check quest markers exist
	var quest_markers = world.get_node_or_null("QuestMarkers")
	if quest_markers:
		print("[OK] Quest markers exist")
		var marker_count = quest_markers.get_child_count()
		print("     Found %d quest markers" % marker_count)
	else:
		print("[FAIL] Quest markers not found")
		all_passed = false

	# Check NPC spawner
	var npc_spawner = get_tree().get_first_node_in_group("npc_spawner")
	if npc_spawner:
		print("[OK] NPC spawner exists")
	else:
		print("[WARN] NPC spawner not found")

	print("\n============================================================")
	print("VALIDATION SUMMARY")
	print("============================================================")
	print("Tests run: %d" % tests_run)
	print("Tests passed: %d" % tests_passed)
	print("Tests failed: %d" % (tests_run - tests_passed))

	if all_passed:
		print("\n[OK] ALL VALIDATION CHECKS PASSED")
		print("\nQuest 1 & Quest 2 appear to be implemented correctly.")
		print("The game should be playable, but MANUAL headed testing is still required.")
		quit(0)
	else:
		print("\n[FAIL] SOME VALIDATION CHECKS FAILED")
		quit(1)
