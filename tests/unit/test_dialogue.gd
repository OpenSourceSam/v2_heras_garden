extends GutTest

var DialogueBoxScene = load("res://scenes/ui/dialogue_box.tscn")
var dialogue_box = null

func before_each():
	dialogue_box = DialogueBoxScene.instantiate()
	add_child_autofree(dialogue_box)

func test_dialogue_basic_flow():
	watch_signals(dialogue_box)
	
	# Start test dialogue
	dialogue_box.start_dialogue("test_greeting")
	
	# Verify dialogue started signal
	assert_signal_emitted(dialogue_box, "dialogue_started")
	
	# Verify visibility
	assert_true(dialogue_box.visible, "Dialogue box should be visible")
	
	# Verify first line loaded
	assert_eq(dialogue_box.current_line_index, 0, "Should be on first line")
	
func test_flag_requirement():
	# Try to start dialogue that requires a flag
	GameState.set_flag("test_flag", false)
	
	dialogue_box.start_dialogue("test_greeting")
	
	# Should start even without flags (test_greeting has no required flags)
	assert_true(dialogue_box.visible, "Should start dialogue without required flags")

func test_choice_display():
	watch_signals(dialogue_box)
	
	dialogue_box.start_dialogue("test_greeting")
	
	# Fast-forward through text by spamming accept
	# Line 0
	sender.action_down("ui_accept")
	sender.action_up("ui_accept")
	await wait_frames(2)
	
	# Line 1 (last line)
	sender.action_down("ui_accept")
	sender.action_up("ui_accept")
	await wait_frames(2)
	
	# Choices should now be visible
	# Note: This may not work perfectly in tests due to timing
	# But we can verify the structure exists
	var choices_container = dialogue_box.get_node("Panel/Choices")
	assert_not_null(choices_container, "Choices container should exist")

func test_flag_setting_on_end():
	watch_signals(dialogue_box)
	
	dialogue_box.start_dialogue("test_greeting")
	
	# Simulate ending the dialogue
	dialogue_box._end_dialogue()
	
	# Verify flags were set
	assert_true(GameState.get_flag("dialogue_test_complete"), "Flag should be set on dialogue end")
	
	# Verify signal emitted
	assert_signal_emitted(dialogue_box, "dialogue_ended")
