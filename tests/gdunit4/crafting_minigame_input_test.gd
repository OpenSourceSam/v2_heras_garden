extends GdUnitTestSuite

func test_crafting_minigame_advances_on_input_event() -> void:
	var packed := load("res://game/features/ui/crafting_minigame.tscn")
	assert_that(packed).is_not_null()
	var minigame: Control = auto_free(packed.instantiate())
	get_tree().root.add_child(minigame)
	await get_tree().process_frame

	var pattern: Array[String] = ["ui_up"]
	var buttons: Array[String] = []
	minigame.start_crafting(pattern, buttons, 2.0)
	await get_tree().process_frame
	assert_that(minigame.current_pattern_index).is_equal(0)

	var event := InputEventAction.new()
	event.action = "ui_up"
	event.pressed = true
	minigame._input(event)
	await get_tree().process_frame

	assert_that(minigame.current_pattern_index).is_equal(1)

	minigame.queue_free()
	await get_tree().process_frame
