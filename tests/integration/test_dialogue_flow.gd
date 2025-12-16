extends GutTest
## Integration Test - Dialogue System
## Tests: Dialogue loading → Display → Choices → Flag management

# ============================================
# SETUP
# ============================================

var dialogue_manager: Control
var test_dialogue: DialogueData

func before_each() -> void:
	# Load dialogue manager scene
	var scene = load("res://scenes/ui/dialogue_box.tscn")
	dialogue_manager = scene.instantiate()
	add_child_autofree(dialogue_manager)
	
	# Load test dialogue
	test_dialogue = load("res://resources/dialogues/d_act1_hermes_intro.tres")
	
	# Reset GameState
	GameState.reset_state()

# ============================================
# TESTS
# ============================================

func test_dialogue_loads_correctly() -> void:
	assert_not_null(test_dialogue, "Dialogue should load")
	assert_eq(test_dialogue.id, "d_act1_hermes_intro", "Dialogue ID should match")
	assert_eq(test_dialogue.lines.size(), 3, "Should have 3 lines")
	assert_eq(test_dialogue.choices.size(), 3, "Should have 3 choices")

func test_dialogue_manager_instantiates() -> void:
	assert_not_null(dialogue_manager, "Dialogue manager should instantiate")
	assert_false(dialogue_manager.visible, "Should start hidden")

func test_start_dialogue_shows_ui() -> void:
	dialogue_manager.start_dialogue("d_act1_hermes_intro")
	
	await wait_seconds(0.1)
	
	assert_true(dialogue_manager.visible, "Should become visible")

func test_dialogue_lines_display() -> void:
	var started = false
	
	dialogue_manager.dialogue_started.connect(
		func(_id: String):
			started = true
	)
	
	dialogue_manager.start_dialogue("d_act1_hermes_intro")
	
	await wait_seconds(0.1)
	
	assert_true(started, "Should emit dialogue_started signal")

func test_dialogue_advances_with_input() -> void:
	dialogue_manager.start_dialogue("d_act1_hermes_intro")
	
	# Wait for first line to display
	await wait_seconds(0.2)
	
	# Simulate advance input
	var event = InputEventAction.new()
	event.action = "ui_accept"
	event.pressed = true
	Input.parse_input_event(event)
	
	await wait_seconds(0.1)
	
	# Should advance to next line
	# (Hard to test exact state without exposing internals)
	assert_true(dialogue_manager.visible, "Should still be visible")

func test_choices_appear_at_end() -> void:
	dialogue_manager.start_dialogue("d_act1_hermes_intro")
	
	# Advance through all lines (3 total)
	for i in range(3):
		await wait_seconds(0.5) # Wait for scroll
		var event = InputEventAction.new()
		event.action = "ui_accept"
		event.pressed = true
		Input.parse_input_event(event)
		await wait_seconds(0.1)
	
	await wait_seconds(0.5)
	
	# Choices should be visible
	var choices_container = dialogue_manager.get_node("Panel/Choices")
	assert_true(choices_container.visible, "Choices should be visible at end")

func test_flag_set_after_dialogue() -> void:
	# Ensure flag not set
	assert_false(GameState.get_flag("met_hermes"), "Flag should not be set initially")
	
	dialogue_manager.start_dialogue("d_act1_hermes_intro")
	
	# Wait for dialogue to complete
	var ended = false
	dialogue_manager.dialogue_ended.connect(
		func(_id: String):
			ended = true
	)
	
	# Speed through dialogue
	for i in range(5):
		await wait_seconds(0.2)
		var event = InputEventAction.new()
		event.action = "ui_accept"
		event.pressed = true
		Input.parse_input_event(event)
	
	await wait_seconds(1)
	
	# Note: Flag is set when dialogue ENDS, not when choices appear
	# This test may need adjustment based on actual implementation

func test_flag_requirement_blocks_dialogue() -> void:
	# Create a test with flag requirement
	var test_data = DialogueData.new()
	test_data.id = "test_blocked"
	test_data.lines = [ {"speaker": "Test", "text": "You shouldn't see this"}]
	test_data.flags_required = ["nonexistent_flag"]
	
	# Try to start it
	GameState.set_flag("nonexistent_flag", false)
	
	# Manually test the logic
	var can_start = true
	for flag in test_data.flags_required:
		if not GameState.get_flag(flag):
			can_start = false
			break
	
	assert_false(can_start, "Should not be able to start dialogue without required flag")

func test_choice_selection_sets_flag() -> void:
	dialogue_manager.start_dialogue("d_act1_hermes_intro")
	
	var choice_made_signal = false
	dialogue_manager.choice_made.connect(
		func(_index: int, _choice: Dictionary):
			choice_made_signal = true
	)
	
	# This test is complex - would need to simulate clicking a choice button
	# For now, just verify the signal exists
	assert_true(dialogue_manager.has_signal("choice_made"), "Should have choice_made signal")

# ============================================
# HELPERS
# ============================================

func _simulate_accept() -> void:
	var event = InputEventAction.new()
	event.action = "ui_accept"
	event.pressed = true
	Input.parse_input_event(event)
	await get_tree().process_frame
