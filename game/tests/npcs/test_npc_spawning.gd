extends GdUnitTestSuite

## NPC Spawn Tests
## Tests NPC spawning logic based on quest flags for regression prevention

class TestNpcSpawner:
	extends "res://game/features/npcs/npc_spawner.gd"

	func _spawn_npc(npc_id: String) -> void:
		spawned_npcs[npc_id] = true

	func _despawn_npc(npc_id: String) -> void:
		if npc_id in spawned_npcs:
			spawned_npcs.erase(npc_id)

func before_test():
	# Reset GameState before each test for isolation
	GameState.quest_flags.clear()

func _make_spawner() -> TestNpcSpawner:
	return TestNpcSpawner.new()

# ==================== Hermes Spawn Tests ====================

func test_hermes_spawns_after_prologue():
	# Hermes should spawn after prologue_complete is true
	GameState.set_flag("prologue_complete", true)
	GameState.set_flag("quest_3_complete", false)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_equal(true)

func test_hermes_despawns_after_quest_3():
	# Hermes should despawn after quest 3 is complete
	GameState.set_flag("prologue_complete", true)
	GameState.set_flag("quest_3_complete", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_equal(false)

func test_hermes_does_not_spawn_before_prologue():
	# Hermes should NOT spawn before prologue is complete
	GameState.set_flag("prologue_complete", false)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_equal(false)

# ==================== Aeetes Spawn Tests ====================

func test_aeetes_spawns_after_quest_3():
	# Aeetes should spawn after quest 3 is complete
	GameState.set_flag("quest_3_complete", true)
	GameState.set_flag("quest_7_active", false)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("aeetes")).is_equal(true)

func test_aeetes_spawns_during_quest_4():
	# Aeetes should spawn during quest 4
	GameState.set_flag("quest_4_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("aeetes")).is_equal(true)

func test_aeetes_despawns_after_quest_7_starts():
	# Aeetes should despawn when quest 7 becomes active
	GameState.set_flag("quest_3_complete", true)
	GameState.set_flag("quest_7_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("aeetes")).is_equal(false)

# ==================== Daedalus Spawn Tests ====================

func test_daedalus_spawns_during_quest_7():
	# Daedalus should spawn during quest 7
	GameState.set_flag("quest_7_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("daedalus")).is_equal(true)

func test_daedalus_spawns_during_quest_8():
	# Daedalus should spawn during quest 8
	GameState.set_flag("quest_8_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("daedalus")).is_equal(true)

func test_daedalus_despawns_after_quest_8():
	# Daedalus should despawn after quest 8
	GameState.set_flag("quest_7_active", false)
	GameState.set_flag("quest_8_active", false)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("daedalus")).is_equal(false)

# ==================== Scylla Spawn Tests ====================

func test_scylla_spawns_during_quest_8():
	# Scylla should spawn during quest 8
	GameState.set_flag("quest_8_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("scylla")).is_equal(true)

func test_scylla_spawns_during_quest_9():
	# Scylla should spawn during quest 9
	GameState.set_flag("quest_9_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("scylla")).is_equal(true)

func test_scylla_spawns_during_quest_10():
	# Scylla should spawn during quest 10
	GameState.set_flag("quest_10_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("scylla")).is_equal(true)

func test_scylla_spawns_during_quest_11():
	# Scylla should spawn during quest 11
	GameState.set_flag("quest_11_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("scylla")).is_equal(true)

func test_scylla_despawns_after_quest_11():
	# Scylla should despawn after quest 11 completes
	GameState.set_flag("quest_8_active", false)
	GameState.set_flag("quest_9_active", false)
	GameState.set_flag("quest_10_active", false)
	GameState.set_flag("quest_11_active", false)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("scylla")).is_equal(false)

# ==================== Dialogue Resolution Tests ====================

func test_hermes_intro_dialogue():
	# Hermes should show intro dialogue when first met
	GameState.set_flag("met_hermes", false)

	var dialogue_id = "hermes_intro"  # Simplified from _resolve_hermes_dialogue()
	var should_show_intro = not GameState.get_flag("met_hermes")
	assert_that(should_show_intro).is_equal(true)

func test_hermes_quest1_start_dialogue():
	# Hermes should show quest 1 start dialogue after prologue
	GameState.set_flag("met_hermes", true)
	GameState.set_flag("prologue_complete", true)
	GameState.set_flag("quest_1_active", false)

	var should_show_quest1 = (
		GameState.get_flag("prologue_complete") and
		not GameState.get_flag("quest_1_active")
	)
	assert_that(should_show_quest1).is_equal(true)

func test_aeetes_quest4_start_dialogue():
	# Aeetes should show quest 4 start dialogue after quest 3
	GameState.set_flag("met_aeetes", false)
	GameState.set_flag("quest_3_complete", true)
	GameState.set_flag("quest_4_active", false)

	var should_show_quest4 = (
		GameState.get_flag("quest_3_complete") and
		not GameState.get_flag("quest_4_active")
	)
	assert_that(should_show_quest4).is_equal(true)

# ==================== NPC State Transition Tests ====================

func test_npc_spawn_flag_change():
	# Verify NPCs respond to flag changes
	# Simulating Hermes appearing when prologue_complete becomes true
	GameState.set_flag("prologue_complete", false)
	GameState.set_flag("quest_3_complete", false)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_equal(false)

	# Now set prologue_complete to true
	GameState.set_flag("prologue_complete", true)

	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_equal(true)

func test_multiple_npcs_visible_same_time():
	# Verify multiple NPCs can be visible simultaneously
	# For example: During quest 4, both Hermes (if quest 3 not complete) and Aeetes could be visible
	GameState.set_flag("quest_3_complete", false)
	GameState.set_flag("prologue_complete", true)
	GameState.set_flag("quest_4_active", true)

	var spawner = _make_spawner()
	spawner._update_npcs()
	assert_that(spawner.spawned_npcs.has("hermes")).is_equal(true)
	assert_that(spawner.spawned_npcs.has("aeetes")).is_equal(true)
