extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()
	_cleanup_scene_manager()
	SceneManager._fade_duration = 0.01

func after_test() -> void:
	_cleanup_scene_manager()

func _cleanup_scene_manager() -> void:
	if SceneManager.current_scene:
		SceneManager.current_scene.queue_free()
		SceneManager.current_scene = null
	if SceneManager._fade_layer:
		SceneManager._fade_layer.queue_free()
		SceneManager._fade_layer = null
		SceneManager._fade_rect = null

func _wait_frames(count: int) -> void:
	for _i in range(count):
		await get_tree().process_frame

func test_world_inventory_toggle_via_input() -> void:
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var event = InputEventAction.new()
	event.action = "ui_inventory"
	event.pressed = true

	world._unhandled_input(event)
	await get_tree().process_frame
	assert_that(world.inventory_panel.visible).is_true()

	world._unhandled_input(event)
	await get_tree().create_timer(0.2).timeout
	assert_that(world.inventory_panel.visible).is_false()

	world.queue_free()

func test_world_sundial_advances_day() -> void:
	GameState.current_day = 1
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var sundial = world.get_node("Interactables/Sundial")
	sundial.interact()
	assert_that(GameState.current_day).is_equal(2)

	world.queue_free()

func test_world_boat_to_scylla_cove() -> void:
	GameState.quest_flags.clear()
	GameState.set_flag("quest_3_active", true)

	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var boat = world.get_node("Interactables/Boat")
	boat.interact()
	await _wait_frames(5)

	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("ScyllaCove")

func test_world_boat_to_sacred_grove() -> void:
	GameState.quest_flags.clear()
	GameState.set_flag("quest_9_active", true)

	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var boat = world.get_node("Interactables/Boat")
	boat.interact()
	await _wait_frames(5)

	assert_that(SceneManager.current_scene).is_not_null()
	assert_that(SceneManager.current_scene.name).is_equal("SacredGrove")

func test_world_quest_trigger_starts_dialogue() -> void:
	GameState.quest_flags.clear()
	GameState.set_flag("prologue_complete", true)
	GameState.set_flag("quest_1_active", true)

	var dialogue_data = load("res://game/shared/resources/dialogues/act1_herb_identification.tres") as DialogueData
	for flag in dialogue_data.flags_required:
		GameState.set_flag(flag, true)

	var dialogue_box = load("res://game/features/ui/dialogue_box.tscn").instantiate()
	get_tree().root.add_child(dialogue_box)
	await get_tree().process_frame

	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var quest = world.get_node("QuestTriggers/Quest1")
	var player = world.get_node("Player")
	quest._on_body_entered(player)

	assert_that(GameState.get_flag("quest_1_active")).is_true()
	assert_that(dialogue_box.visible).is_true()
	assert_that(dialogue_box.current_dialogue.id).is_equal("act1_herb_identification")

	world.queue_free()
	dialogue_box.queue_free()

func test_world_npc_spawner_hermes() -> void:
	GameState.quest_flags.clear()
	GameState.set_flag("prologue_complete", true)
	GameState.set_flag("quest_3_complete", false)

	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var spawner = world.get_node("NPCs/NPCSpawner")
	spawner._update_npcs()

	assert_that(spawner.spawned_npcs.has("hermes")).is_true()
	world.queue_free()
