extends Control

signal crafting_complete(success: bool)

enum Difficulty { TUTORIAL, EASY, MEDIUM, HARD, EXPERT }

const DIFFICULTY_SETTINGS = {
	Difficulty.TUTORIAL: {"inputs": 12, "buttons": 0, "timing": 2.0, "retry": false},
	Difficulty.EASY: {"inputs": 12, "buttons": 0, "timing": 2.0, "retry": false},
	Difficulty.MEDIUM: {"inputs": 16, "buttons": 4, "timing": 1.5, "retry": false},
	Difficulty.HARD: {"inputs": 16, "buttons": 6, "timing": 1.0, "retry": false},
	Difficulty.EXPERT: {"inputs": 36, "buttons": 10, "timing": 0.6, "retry": true}
}

var pattern: Array[String] = []  # ["ui_up", "ui_right", "ui_down", "ui_left"]
var button_sequence: Array[String] = []  # ["ui_accept", "ui_accept", "ui_cancel"]
var current_pattern_index: int = 0
var current_button_index: int = 0
var timing_window: float = 1.5  # seconds
var last_input_time: float = 0.0
var is_grinding_phase: bool = true
var allow_retry: bool = false

func start_crafting(grinding_pattern: Array[String], buttons: Array[String], timing: float = 1.5) -> void:
	pattern = grinding_pattern
	button_sequence = buttons
	timing_window = timing
	current_pattern_index = 0
	current_button_index = 0
	is_grinding_phase = true
	last_input_time = Time.get_ticks_msec() / 1000.0

	_update_display()

func start_with_difficulty(diff: Difficulty, _recipe: RecipeData) -> void:
	var settings = DIFFICULTY_SETTINGS[diff]
	allow_retry = settings.retry
	timing_window = settings.timing
	_generate_pattern(settings.inputs)
	_generate_buttons(settings.buttons)
	start_crafting(pattern, button_sequence, timing_window)

func _input(event: InputEvent) -> void:
	if not visible:
		return

	var current_time = Time.get_ticks_msec() / 1000.0

	# Check timing window
	if current_time - last_input_time > timing_window:
		_fail_crafting()
		return

	if is_grinding_phase:
		_handle_grinding_input(event)
	else:
		_handle_button_input(event)

func _handle_grinding_input(event: InputEvent) -> void:
	var expected = pattern[current_pattern_index]

	if event.is_action_pressed(expected):
		# Correct input
		current_pattern_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)

		if current_pattern_index >= pattern.size():
			# Grinding complete, move to button sequence
			is_grinding_phase = false
			current_button_index = 0
			last_input_time = Time.get_ticks_msec() / 1000.0
			_update_display()

	# Check for wrong input
	for action in ["ui_up", "ui_right", "ui_down", "ui_left"]:
		if action != expected and event.is_action_pressed(action):
			_play_feedback(false)
			# Don't fail immediately, just give negative feedback

func _handle_button_input(event: InputEvent) -> void:
	var expected = button_sequence[current_button_index]

	if event.is_action_pressed(expected):
		# Correct input
		current_button_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)

		if current_button_index >= button_sequence.size():
			# All inputs correct - success!
			_complete_crafting(true)

	# Check for wrong input
	for action in ["ui_accept", "ui_cancel", "ui_select"]:
		if action != expected and event.is_action_pressed(action):
			_fail_crafting()

func _complete_crafting(success: bool) -> void:
	crafting_complete.emit(success)
	visible = false

func _fail_crafting() -> void:
	_on_crafting_failed()

func _on_crafting_failed() -> void:
	if allow_retry:
		_reset_minigame()
	else:
		_complete_crafting(false)

func _update_display() -> void:
	# Update UI to show current progress
	# Show next expected input
	pass

func _play_feedback(_correct: bool) -> void:
	# Play sound, show visual effect
	pass

func _generate_pattern(count: int) -> void:
	pattern.clear()
	var actions = ["ui_up", "ui_right", "ui_down", "ui_left"]
	for _i in range(count):
		pattern.append(actions[randi() % actions.size()])

func _generate_buttons(count: int) -> void:
	button_sequence.clear()
	var actions = ["ui_accept", "ui_cancel", "ui_select"]
	for _i in range(count):
		button_sequence.append(actions[randi() % actions.size()])

func _reset_minigame() -> void:
	current_pattern_index = 0
	current_button_index = 0
	is_grinding_phase = true
	last_input_time = Time.get_ticks_msec() / 1000.0
	_update_display()
