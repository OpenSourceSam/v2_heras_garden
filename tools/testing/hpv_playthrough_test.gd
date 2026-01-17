extends SceneTree
## HPV Playthrough verification script
## Run with: Godot*.exe --script tests/run_hpv_playthrough.gd --remote-debug tcp://127.0.0.1:6007

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("[HPV] Starting playthrough verification...")
	
	# Verify MCP handlers are available
	var has_input_handler = ClassDB.class_exists("MCPInputHandler")
	var has_eval_handler = ClassDB.class_exists("MCEvalHandler")
	
	if not has_input_handler:
		print("[FAIL] MCP Input Handler not available")
		quit(1)
		return
	
	if not has_eval_handler:
		print("[FAIL] MCP Eval Handler not available")
		quit(1)
		return
	
	print("[PASS] MCP handlers available")
	await _test_aiaia_arrival()
	await _test_house_interior()
	await _test_quest_0_note()
	await _test_quest_1_herb_id()
	await _test_quest_2_crafting()
	await _test_quest_3_scylla()
	
	print("")
	print("=".repeat(60))
	print("PLAYTHROUGH TEST COMPLETE")
	print("=".repeat(60))
	
	quit(0)

## Test 1: Verify Title Screen
func _test_title_screen() -> void:
	print("[TEST] Title Screen")
	var summary = state_q.get_summary()
	print("  In menu: %s" % ("yes" if summary.in_menu else "no"))
	print("  Dialogue active: %s" % ("yes" if summary.dialogue_active else "no"))
	
	# Verify we're in main menu
	if not summary.in_menu:
		print("  [WARN] Not in main menu, checking current scene...")
		var path = state_q.get_current_scene_path()
		print("  Scene path: %s" % path)

## Test 2: Select New Game
func _test_new_game() -> void:
	print("[TEST] New Game Selection")
	
	# Press A to select NEW GAME (should be pre-focused)
	input_sim.confirm()
	await input_sim.wait(1.0)
	
	var summary = state_q.get_summary()
	print("  After A press - In menu: %s" % ("yes" if summary.in_menu else "no"))
	print("  Dialogue active: %s" % ("yes" if summary.dialogue_active else "no"))

## Test 3: Prologue Cutscene
func _test_prologue() -> void:
	print("[TEST] Prologue Cutscene")
	
	# Wait for prologue dialogue to complete
	var wait_count = 0
	while state_q.is_dialogue_active() and wait_count < 30:
		await input_sim.wait(0.5)
		wait_count += 1
	
	if state_q.is_dialogue_active():
		print("  [WARN] Dialogue still active after 15 seconds")
	else:
		print("  Prologue dialogue completed")
	
	# Check prologue_complete flag
	if state_q.is_prologue_complete():
		print("  [OK] prologue_complete flag is set")
	else:
		print("  [WARN] prologue_complete flag NOT set")

## Test 4: Aiaia Arrival
func _test_aiaia_arrival() -> void:
	print("[TEST] Aiaia Island Arrival")
	
	# Verify we're in the world
	var summary = state_q.get_summary()
	if summary.in_world:
		print("  [OK] In world scene")
	else:
		print("  [WARN] Not in world scene")
		var path = state_q.get_current_scene_path()
		print("  Scene path: %s" % path)
	
	# Check player position
	var pos = state_q.get_player_position()
	print("  Player position: %s" % pos)

## Test 5: House Interior
func _test_house_interior() -> void:
	print("[TEST] House Interior")
	
	# Move toward house (assume house is north of spawn)
	input_sim.move_direction(0, -1, 2.0) # Move north for 2 seconds
	await input_sim.wait(0.5)
	
	# Try to interact with house door
	input_sim.confirm()
	await input_sim.wait(1.0)
	
	# Check if we're in house interior
	var path = state_q.get_current_scene_path()
	if "house" in path.to_lower():
		print("  [OK] Entered house interior")
	else:
		print("  [WARN] May not have entered house")
		print("  Scene path: %s" % path)

## Test 6: Quest 0 - Aeëtes Note
func _test_quest_0_note() -> void:
	print("[TEST] Aeëtes Note (Quest 0)")
	
	# Move to table and interact
	input_sim.move_direction(1, 0, 1.0) # Move right
	input_sim.move_direction(0, -1, 1.0) # Move up
	input_sim.confirm()
	await input_sim.wait(1.0)
	
	# Check quest_0_complete flag
	if state_q.get_flag("quest_0_complete"):
		print("  [OK] quest_0_complete flag is set")
	else:
		print("  [WARN] quest_0_complete flag NOT set")
	
	# Check quest_1_active flag (should be set after Hermes spawns)
	if state_q.get_flag("quest_1_active"):
		print("  [OK] quest_1_active flag is set")
	else:
		print("  [INFO] quest_1_active flag NOT set (Hermes may not have spawned yet)")

## Test 7: Quest 1 - Herb Identification
func _test_quest_1_herb_id() -> void:
	print("[TEST] Quest 1 - Herb Identification")
	
	# Check if quest is active
	if not state_q.is_quest_active("1"):
		print("  [INFO] Quest 1 not active yet")
		return
	
	print("  Quest 1 is active")
	
	# Check inventory
	var inventory = state_q.get_inventory()
	if inventory.has("pharmaka_flower"):
		print("  Pharmaka flowers in inventory: %d" % inventory["pharmaka_flower"])
	else:
		print("  No pharmaka flowers yet")

## Test 8: Quest 2 - Crafting
func _test_quest_2_crafting() -> void:
	print("[TEST] Quest 2 - Transformation Sap")
	
	if not state_q.is_quest_active("2"):
		print("  [INFO] Quest 2 not active yet")
		return
	
	print("  Quest 2 is active")
	
	# Check if transformation_sap is in inventory
	if state_q.has_item("transformation_sap"):
		print("  [OK] Transformation sap crafted")
	else:
		print("  Transformation sap not yet crafted")

## Test 9: Quest 3 - Scylla Confrontation
func _test_quest_3_scylla() -> void:
	print("[TEST] Quest 3 - Scylla Confrontation")
	
	if not state_q.is_quest_active("3"):
		print("  [INFO] Quest 3 not active yet")
		return
	
	print("  Quest 3 is active")
	
	# Check if boat is available
	if state_q.get_flag("quest_3_complete"):
		print("  [OK] Quest 3 completed!")
	else:
		print("  Quest 3 not yet complete")
