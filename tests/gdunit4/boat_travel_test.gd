extends GdUnitTestSuite

func test_boat_interact_changes_scene_when_quest_active() -> void:
	GameState.quest_flags.clear()
	GameState.set_flag("quest_3_active", true)

	var dummy_scene: Node2D = auto_free(Node2D.new())
	get_tree().root.add_child(dummy_scene)
	SceneManager.current_scene = dummy_scene

	var packed := load("res://game/features/world/boat.tscn")
	assert_that(packed).is_not_null()
	var boat: StaticBody2D = auto_free(packed.instantiate())
	get_tree().root.add_child(boat)

	boat.interact()
	await get_tree().process_frame
	await get_tree().process_frame

	assert_that(SceneManager.current_scene).is_not_null()
	if SceneManager.current_scene != null:
		assert_that(SceneManager.current_scene.scene_file_path.strip_edges()).is_equal(
			"res://game/features/locations/scylla_cove.tscn"
		)
