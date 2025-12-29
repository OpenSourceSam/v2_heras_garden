extends GdUnitTestSuite

func before_test() -> void:
	GameState.quest_flags.clear()

func test_hermes_starts_quest_1() -> void:
	GameState.set_flag("prologue_complete", true)

	var npc = _instantiate_npc("res://game/features/npcs/hermes.tscn")
	assert_that(npc._resolve_dialogue_id()).is_equal("quest1_start")
	npc.queue_free()

func test_hermes_in_progress_quest_1() -> void:
	GameState.set_flag("quest_1_active", true)

	var npc = _instantiate_npc("res://game/features/npcs/hermes.tscn")
	assert_that(npc._resolve_dialogue_id()).is_equal("act1_herb_identification")
	npc.queue_free()

func test_aeetes_starts_quest_4() -> void:
	GameState.set_flag("quest_3_complete", true)

	var npc = _instantiate_npc("res://game/features/npcs/aeetes.tscn")
	assert_that(npc._resolve_dialogue_id()).is_equal("quest4_start")
	npc.queue_free()

func test_daedalus_starts_quest_7() -> void:
	GameState.set_flag("quest_6_complete", true)

	var npc = _instantiate_npc("res://game/features/npcs/daedalus.tscn")
	assert_that(npc._resolve_dialogue_id()).is_equal("quest7_start")
	npc.queue_free()

func test_scylla_starts_quest_9() -> void:
	GameState.set_flag("quest_8_complete", true)

	var npc = _instantiate_npc("res://game/features/npcs/scylla.tscn")
	assert_that(npc._resolve_dialogue_id()).is_equal("quest9_start")
	npc.queue_free()

func _instantiate_npc(scene_path: String) -> NPCBase:
	var packed = load(scene_path)
	assert_that(packed).is_not_null()
	var instance = packed.instantiate() as NPCBase
	assert_that(instance).is_not_null()
	get_tree().root.add_child(instance)
	return instance
