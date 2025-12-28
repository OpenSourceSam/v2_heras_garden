extends GdUnitTestSuite

func test_quest_trigger_emits_on_body_entered_signal() -> void:
	GameState.quest_flags.clear()
	GameState.set_flag("req_flag", true)

	var trigger: QuestTrigger = auto_free(QuestTrigger.new())
	trigger.required_flag = "req_flag"
	trigger.set_flag_on_enter = "set_flag"
	get_tree().root.add_child(trigger)
	await get_tree().process_frame

	var body: Node2D = auto_free(Node2D.new())
	body.add_to_group("player")
	get_tree().root.add_child(body)
	trigger.emit_signal("body_entered", body)
	await get_tree().process_frame

	assert_that(GameState.get_flag("set_flag")).is_true()
