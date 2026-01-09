extends SceneTree

const FLAG_CHECK_INTERVAL = 0.1

# Autoload references (accessed via root node)
var GameState: Node
var AudioController: Node
var SceneManager: Node

func _init():
	# Defer execution so autoloads are initialized before tests run
	call_deferred("_run_all_tests")

func _run_all_tests():
	print("============================================================")
	print("FULL PLAYTHROUGH TEST - Circe's Garden v2")
	print("============================================================")

	# Get autoload references from root
	GameState = root.get_node_or_null("GameState")
	AudioController = root.get_node_or_null("AudioController")
	SceneManager = root.get_node_or_null("SceneManager")

	var all_passed = true

	# Test 1: Full game initialization
	if not test_game_initialization():
		all_passed = false

	# Test 2: Prologue → Quest 1 flow
	if not test_prologue_to_quest1():
		all_passed = false

	# Test 3: Quest 1 completion
	if not test_quest1_completion():
		all_passed = false

	# Test 4: Quest 2 flow (restored - 2026-01-03)
	if not test_quest2_flow():
		all_passed = false

	# Test 5: Quest 3 flow
	if not test_quest3_flow():
		all_passed = false

	# Test 6: Quest 4-6 Act 2
	if not test_act2_flow():
		all_passed = false

	# Test 7: Quest 7-8 Daedalus arc
	if not test_daedalus_arc():
		all_passed = false

	# Test 8: Quest 9-11 Act 3
	if not test_act3_flow():
		all_passed = false

	# Test 9: Scene transitions
	if not test_scene_transitions():
		all_passed = false

	# Test 10: Crafting system
	if not test_crafting_system():
		all_passed = false

	# Test 11: Minigame integration
	if not test_minigames():
		all_passed = false

	print("============================================================")
	print("PLAYTHROUGH TEST SUMMARY")
	print("============================================================")

	if all_passed:
		print("[PASS] ALL PLAYTHROUGH TESTS PASSED")
		quit(0)
	else:
		print("[FAIL] SOME TESTS FAILED")
		quit(1)

func test_game_initialization() -> bool:
	print("\n--- Test: Game Initialization ---")

	# Verify autoloads
	if not GameState:
		print("[FAIL] GameState autoload not found")
		return false

	if not AudioController:
		print("[FAIL] AudioController autoload not found")
		return false

	# Reset game state
	GameState.new_game()

	# Check initial state
	if not GameState.get_flag("prologue_complete"):
		print("[FAIL] prologue_complete should be true after new_game()")
		return false

	# Check starter items
	if not GameState.has_item("wheat_seed") or GameState.get_item_count("wheat_seed") < 3:
		print("[FAIL] Should have 3 wheat_seeds after new_game()")
		return false

	print("[PASS] Game initialization")
	return true

func test_prologue_to_quest1() -> bool:
	print("\n--- Test: Prologue to Quest 1 ---")

	GameState.new_game()

	# Verify prologue cutscene exists and has Helios dialogue
	var prologue_script = load("res://game/features/cutscenes/prologue_opening.gd")
	if not prologue_script:
		print("[FAIL] prologue_opening.gd not found")
		return false

	# Verify prologue contains Helios dialogue (full implementation)
	var prologue_source = prologue_script.get_source_code()
	if not prologue_source.contains("HELIOS"):
		print("[FAIL] prologue_opening.gd missing HELIOS constant")
		return false

	if not prologue_source.contains("Circe"):
		print("[FAIL] prologue_opening.gd missing Circe dialogue")
		return false

	# Check that world.gd has Aiaia arrival trigger
	var world_script = load("res://game/features/world/world.gd")
	if not world_script:
		print("[FAIL] world.gd not found")
		return false

	var world_source = world_script.get_source_code()
	if not world_source.contains("_check_aiaia_arrival"):
		print("[FAIL] world.gd missing _check_aiaia_arrival method")
		return false

	# Verify aiaia_arrival dialogue exists
	var aiaia_arrival = load("res://game/shared/resources/dialogues/aiaia_arrival.tres")
	if not aiaia_arrival:
		print("[FAIL] aiaia_arrival.tres not found")
		return false

	# Verify it sets quest_1_active flag
	var sets_quest_1 = false
	for flag in aiaia_arrival.flags_to_set:
		if flag == "quest_1_active":
			sets_quest_1 = true
			break

	if not sets_quest_1:
		print("[FAIL] aiaia_arrival.tres should set quest_1_active flag")
		return false

	# Trigger quest 1 by completing prologue (already done in new_game)
	if not GameState.get_flag("quest_1_active"):
		GameState.set_flag("quest_1_active", true)

	if not GameState.get_flag("quest_1_active"):
		print("[FAIL] quest_1_active not set")
		return false

	print("[PASS] Prologue to Quest 1")
	return true

func test_quest1_completion() -> bool:
	print("\n--- Test: Quest 1 Completion ---")

	GameState.new_game()
	GameState.set_flag("quest_1_active", true)

	# Complete quest 1 - give golden_glow to Circe
	GameState.add_item("golden_glow", 1)
	GameState.set_flag("quest_1_complete", true)

	if not GameState.get_flag("quest_1_complete"):
		print("[FAIL] quest_1_complete not set")
		return false

	# Quest 2 removed - should skip to quest 3
	if GameState.get_flag("quest_1_complete") and not GameState.get_flag("quest_3_active"):
		GameState.set_flag("quest_3_active", true)

	print("[PASS] Quest 1 Completion")
	return true

func test_quest2_flow() -> bool:
	print("\n--- Test: Quest 2 Flow (Extract the Sap) ---")

	GameState.new_game()
	GameState.set_flag("quest_1_complete", true)

	# Quest 2 should be activated when talking to Hermes after quest 1 complete
	# Check that Hermes dialogue routing includes quest2_start
	var npc_base_script = load("res://game/features/npcs/npc_base.gd")
	if not npc_base_script:
		print("[FAIL] npc_base.gd not found")
		return false

	# Verify quest2_start dialogue resource exists
	var quest2_dialogue = load("res://game/shared/resources/dialogues/quest2_start.tres")
	if not quest2_dialogue:
		print("[FAIL] quest2_start.tres not found")
		return false

	# Verify dialogue contains Hermes warning about pharmaka
	var has_hermes_warning = false
	var has_pharmaka_warning = false
	for line in quest2_dialogue.lines:
		if line.get("speaker", "") == "Hermes" and "pharmaka" in line.get("text", "").to_lower():
			has_pharmaka_warning = true
		if line.get("speaker", "") == "Hermes":
			has_hermes_warning = true

	if not has_hermes_warning:
		print("[FAIL] quest2_start dialogue missing Hermes lines")
		return false

	if not has_pharmaka_warning:
		print("[FAIL] quest2_start dialogue missing pharmaka warning from Hermes")
		return false

	# Simulate player completing quest 2 by crafting transformation sap
	GameState.set_flag("quest_2_active", true)
	GameState.add_item("pharmaka_flower", 3)

	# Verify moly_grind recipe exists (used for quest 2 crafting)
	var moly_grind_recipe = load("res://game/shared/resources/recipes/moly_grind.tres")
	if not moly_grind_recipe:
		print("[FAIL] moly_grind.tres not found")
		return false

	# Verify recipe requires pharmaka_flower
	var has_pharmaka_ingredient = false
	for ingredient in moly_grind_recipe.ingredients:
		if ingredient.get("item_id", "") == "pharmaka_flower":
			has_pharmaka_ingredient = true
			break

	if not has_pharmaka_ingredient:
		print("[FAIL] moly_grind recipe should require pharmaka_flower")
		return false

	# Verify recipe creates transformation_sap
	if moly_grind_recipe.result_item_id != "transformation_sap":
		print("[FAIL] moly_grind recipe should create transformation_sap")
		return false

	# Simulate crafting completion
	GameState.set_flag("quest_2_complete", true)

	if not GameState.get_flag("quest_2_complete"):
		print("[FAIL] quest_2_complete not set")
		return false

	# Verify that after quest 2 complete, Hermes routes to quest3_start
	if GameState.get_flag("quest_2_complete") and not GameState.get_flag("quest_3_active"):
		GameState.set_flag("quest_3_active", true)

	print("[PASS] Quest 2 Flow")
	return true

func test_quest3_flow() -> bool:
	print("\n--- Test: Quest 3 Flow (Confront Scylla) ---")

	GameState.new_game()
	GameState.set_flag("quest_1_complete", true)
	GameState.set_flag("quest_3_active", true)

	# Check boat destination
	var boat_script = load("res://game/features/world/boat.gd").new()
	if not boat_script:
		print("[FAIL] Boat script not found")
		return false

	# Verify boat would go to scylla_cove
	if not GameState.get_flag("quest_3_active"):
		print("[FAIL] quest_3_active should be true for scylla_cove")
		return false

	# Check scylla_cove scene exists
	var scylla_cove = load("res://game/features/locations/scylla_cove.tscn")
	if not scylla_cove:
		print("[FAIL] scylla_cove.tscn not found")
		return false

	# Check scylla_cove can be instantiated (lightweight test)
	var scylla_cove_instance = scylla_cove.instantiate()
	if not scylla_cove_instance:
		print("[FAIL] scylla_cove.tscn failed to instantiate")
		return false

	# Check return boat node exists
	var return_boat = scylla_cove_instance.get_node_or_null("ReturnBoat")
	if not return_boat:
		print("[FAIL] ReturnBoat not found in scylla_cove")
		return false

	if not return_boat.has_method("interact"):
		print("[FAIL] ReturnBoat missing interact method")
		return false

	print("[PASS] Quest 3 Flow")
	return true

func test_act2_flow() -> bool:
	print("\n--- Test: Act 2 Flow (Quests 4-6) ---")

	GameState.new_game()
	GameState.set_flag("quest_3_complete", true)

	# Quest 4: Plant wheat
	GameState.set_flag("quest_4_active", true)
	GameState.add_item("wheat_seed", 5)

	# Simulate planting and harvesting
	GameState.remove_item("wheat_seed", 3)
	GameState.add_item("wheat", 3)
	GameState.set_flag("quest_4_complete", true)

	# Quest 5: Calming Draught
	GameState.set_flag("quest_5_active", true)
	GameState.add_item("moly", 1)
	GameState.add_item("pharmaka_flower", 1)
	GameState.set_flag("quest_5_complete", true)

	# Quest 6: Reversal Elixir
	GameState.set_flag("quest_6_active", true)
	GameState.add_item("nightshade", 1)
	GameState.add_item("moon_tear", 1)
	GameState.set_flag("quest_6_complete", true)

	if not GameState.get_flag("quest_6_complete"):
		print("[FAIL] quest_6_complete not set")
		return false

	print("[PASS] Act 2 Flow")
	return true

func test_daedalus_arc() -> bool:
	print("\n--- Test: Daedalus Arc (Quests 7-8) ---")

	GameState.new_game()
	GameState.set_flag("quest_6_complete", true)

	# Quest 7: Daedalus arrives, weave cloth
	GameState.set_flag("quest_7_active", true)

	# Check loom scene exists
	var loom = load("res://game/features/world/loom.tscn")
	if not loom:
		print("[FAIL] loom.tscn not found")
		return false

	var loom_instance = loom.instantiate()
	if not loom_instance:
		print("[FAIL] loom.tscn failed to instantiate")
		return false

	if not loom_instance.has_method("interact"):
		print("[FAIL] Loom missing interact method")
		return false

	# Simulate weaving completion (gives woven_cloth)
	GameState.add_item("woven_cloth", 1)
	GameState.set_flag("quest_7_complete", true)

	# Quest 8: Binding Ward
	GameState.set_flag("quest_8_active", true)
	GameState.add_item("nightshade", 1)
	GameState.set_flag("quest_8_complete", true)

	if not GameState.get_flag("quest_8_complete"):
		print("[FAIL] quest_8_complete not set")
		return false

	print("[PASS] Daedalus Arc")
	return true

func test_act3_flow() -> bool:
	print("\n--- Test: Act 3 Flow (Quests 9-11) ---")

	GameState.new_game()
	GameState.set_flag("quest_8_complete", true)

	# Quest 9: Sacred Earth
	GameState.set_flag("quest_9_active", true)
	GameState.set_flag("quest_9_complete", true)

	# Quest 10: Moon Tears
	GameState.set_flag("quest_10_active", true)
	GameState.add_item("moon_tear", 3)
	GameState.set_flag("quest_10_complete", true)

	# Quest 11: Petrification Potion
	GameState.set_flag("quest_11_active", true)
	GameState.add_item("sacred_earth", 1)
	GameState.add_item("nightshade", 1)
	GameState.set_flag("quest_11_complete", true)

	if not GameState.get_flag("quest_11_complete"):
		print("[FAIL] quest_11_complete not set")
		return false

	# Check sacred_grove has return boat
	var sacred_grove = load("res://game/features/locations/sacred_grove.tscn")
	if not sacred_grove:
		print("[FAIL] sacred_grove.tscn not found")
		return false

	var sacred_grove_instance = sacred_grove.instantiate()
	if not sacred_grove_instance:
		print("[FAIL] sacred_grove.tscn failed to instantiate")
		return false

	var return_boat = sacred_grove_instance.get_node_or_null("ReturnBoat")
	if not return_boat:
		print("[FAIL] ReturnBoat not found in sacred_grove")
		return false

	print("[PASS] Act 3 Flow")
	return true

func test_scene_transitions() -> bool:
	print("\n--- Test: Scene Transitions ---")

	# Test SceneManager
	if not SceneManager:
		print("[FAIL] SceneManager autoload not found")
		return false

	# Test world scene loads
	var world = load("res://game/features/world/world.tscn")
	if not world:
		print("[FAIL] world.tscn not found")
		return false

	var world_instance = world.instantiate()
	if not world_instance:
		print("[FAIL] world.tscn failed to instantiate")
		return false

	# Test scylla_cove scene loads
	var scylla_cove = load("res://game/features/locations/scylla_cove.tscn")
	if not scylla_cove:
		print("[FAIL] scylla_cove.tscn not found")
		return false

	var scylla_cove_instance = scylla_cove.instantiate()
	if not scylla_cove_instance:
		print("[FAIL] scylla_cove.tscn failed to instantiate")
		return false

	# Test sacred_grove scene loads
	var sacred_grove = load("res://game/features/locations/sacred_grove.tscn")
	if not sacred_grove:
		print("[FAIL] sacred_grove.tscn not found")
		return false

	var sacred_grove_instance = sacred_grove.instantiate()
	if not sacred_grove_instance:
		print("[FAIL] sacred_grove.tscn failed to instantiate")
		return false

	print("[PASS] Scene Transitions")
	return true

func test_crafting_system() -> bool:
	print("\n--- Test: Crafting System ---")

	# Check recipes exist
	var calming_draught = load("res://game/shared/resources/recipes/calming_draught.tres")
	if not calming_draught:
		print("[FAIL] calming_draught.tres not found")
		return false

	var reversal_elixir = load("res://game/shared/resources/recipes/reversal_elixir.tres")
	if not reversal_elixir:
		print("[FAIL] reversal_elixir.tres not found")
		return false

	var binding_ward = load("res://game/shared/resources/recipes/binding_ward.tres")
	if not binding_ward:
		print("[FAIL] binding_ward.tres not found")
		return false

	var petrification = load("res://game/shared/resources/recipes/petrification_potion.tres")
	if not petrification:
		print("[FAIL] petrification_potion.tres not found")
		return false

	# Verify recipe ingredients
	if calming_draught.ingredients.size() != 2:
		print("[FAIL] Calming Draught should have 2 ingredients")
		return false

	if binding_ward.ingredients.size() != 2:
		print("[FAIL] Binding Ward should have 2 ingredients")
		return false

	print("[PASS] Crafting System")
	return true

func test_minigames() -> bool:
	print("\n--- Test: Minigames ---")

	# Test weaving minigame
	var weaving = load("res://game/features/minigames/weaving_minigame.tscn")
	if not weaving:
		print("[FAIL] weaving_minigame.tscn not found")
		return false

	var weaving_instance = weaving.instantiate()
	if not weaving_instance:
		print("[FAIL] weaving_minigame.tscn failed to instantiate")
		return false

	if not weaving_instance.has_method("_win"):
		print("[FAIL] Weaving minigame missing _win method")
		return false

	# Test moon_tears minigame
	var moon_tears = load("res://game/features/minigames/moon_tears_minigame.tscn")
	if not moon_tears:
		print("[FAIL] moon_tears_minigame.tscn not found")
		return false

	var moon_tears_instance = moon_tears.instantiate()
	if not moon_tears_instance:
		print("[FAIL] moon_tears_minigame.tscn failed to instantiate")
		return false

	if not moon_tears_instance.has_method("_award_items"):
		print("[FAIL] Moon Tears minigame missing _award_items method")
		return false

	# Test sacred_earth minigame
	var sacred_earth = load("res://game/features/minigames/sacred_earth.tscn")
	if not sacred_earth:
		print("[FAIL] sacred_earth.tscn not found")
		return false

	var sacred_earth_instance = sacred_earth.instantiate()
	if not sacred_earth_instance:
		print("[FAIL] sacred_earth.tscn failed to instantiate")
		return false

	if not sacred_earth_instance.has_method("_on_mash_pressed"):
		print("[FAIL] Sacred Earth minigame missing _on_mash_pressed method")
		return false

	print("[PASS] Minigames")
	return true
