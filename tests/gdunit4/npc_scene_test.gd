extends GdUnitTestSuite

func test_npc_scenes_instantiate() -> void:
	var npc_scenes = [
		"res://game/features/npcs/hermes.tscn",
		"res://game/features/npcs/aeetes.tscn",
		"res://game/features/npcs/daedalus.tscn"
	]

	for scene_path in npc_scenes:
		var packed = load(scene_path)
		assert_that(packed).is_not_null()
		var instance = packed.instantiate()
		assert_that(instance).is_not_null()
		assert_that(instance is Node2D).is_true()
		if instance != null:
			instance.queue_free()
