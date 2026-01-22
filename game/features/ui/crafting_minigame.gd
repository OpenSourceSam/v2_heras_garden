extends Control

signal crafting_complete(success: bool)

enum Difficulty { TUTORIAL, ADVANCED, ADVANCED_PLUS, EXPERT, EXPERT_PLUS }

const DIFFICULTY_SETTINGS = {
	Difficulty.TUTORIAL: {"inputs": 4, "display_time": 5.0, "buttons": 0, "retry": false},
	Difficulty.ADVANCED: {"inputs": 8, "display_time": 4.0, "buttons": 0, "retry": false},
	Difficulty.ADVANCED_PLUS: {"inputs": 12, "display_time": 3.0, "buttons": 0, "retry": false},
	Difficulty.EXPERT: {"inputs": 16, "display_time": 2.0, "buttons": 0, "retry": false},
	Difficulty.EXPERT_PLUS: {"inputs": 20, "display_time": 1.5, "buttons": 0, "retry": true}
}

enum Phase { DISPLAY, INPUT, COMPLETE }

var pattern: Array[String] = []  # ["ui_up", "ui_right", "ui_down", "ui_left"]
var current_input_index: int = 0
var display_time_remaining: float = 0.0
var current_phase: Phase = Phase.DISPLAY
var allow_retry: bool = false
var total_inputs_required: int = 4

signal display_phase_complete()

func start_crafting(difficulty_or_index: Variant, custom_pattern: Array[String] = []) -> void:
	# Convert to Difficulty enum if integer is passed
	var diff: Difficulty
	if difficulty_or_index is int:
		diff = difficulty_or_index as Difficulty
	else:
		diff = difficulty_or_index

	var settings = DIFFICULTY_SETTINGS[diff]
	allow_retry = settings.retry
	total_inputs_required = settings.inputs

	if custom_pattern.size() > 0:
		pattern = custom_pattern
	else:
		_generate_pattern(settings.inputs)

	current_input_index = 0
	current_phase = Phase.DISPLAY
	display_time_remaining = settings.display_time

	# Start display phase timer
	_update_display()

	# Create timer for display phase
	var timer = get_tree().create_timer(settings.display_time)
	timer.timeout.connect(_on_display_phase_complete)
	timer.autostart = true

	# Show display countdown
	_create_display_timer(settings.display_time)

func _on_display_phase_complete() -> void:
	if current_phase == Phase.DISPLAY:
		current_phase = Phase.INPUT
		display_phase_complete.emit()
		_update_display()

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if current_phase != Phase.INPUT:
		return

	_handle_input(event)

func _handle_input(event: InputEvent) -> void:
	if current_input_index >= pattern.size():
		return

	var expected = pattern[current_input_index]

	if event.is_action_pressed(expected):
		# Correct input
		current_input_index += 1
		_play_feedback(true)
		_update_display()

		if current_input_index >= pattern.size():
			# All inputs correct - success!
			_complete_crafting(true)
	else:
		# Check for any wrong directional input
		for action in ["ui_up", "ui_right", "ui_down", "ui_left"]:
			if event.is_action_pressed(action):
				# Wrong input - fail immediately
				_play_feedback(false)
				_fail_crafting()
				return

func _complete_crafting(success: bool) -> void:
	crafting_complete.emit(success)
	current_phase = Phase.COMPLETE
	_update_display()

func _fail_crafting() -> void:
	if allow_retry:
		_reset_for_retry()
	else:
		_complete_crafting(false)

func _reset_for_retry() -> void:
	# Brief pause before retry
	await get_tree().create_timer(1.0).timeout
	_reset_minigame()

func _reset_minigame() -> void:
	current_input_index = 0
	current_phase = Phase.DISPLAY
	# Use current difficulty's display time (stored in total_inputs_required for retry)
	var settings = DIFFICULTY_SETTINGS.values()
	for s in settings:
		if s.inputs == total_inputs_required:
			display_time_remaining = s.display_time
			break

	# Restart display phase
	_update_display()

	var timer = get_tree().create_timer(display_time_remaining)
	timer.timeout.connect(_on_display_phase_complete)
	timer.autostart = true

	_create_display_timer(display_time_remaining)

func _update_display() -> void:
	var pattern_display = get_node_or_null("PatternDisplay")
	if pattern_display:
		var display_text = ""

		match current_phase:
			Phase.DISPLAY:
				display_text = "MEMORIZE THIS PATTERN:\n\n"
				for i in range(pattern.size()):
					display_text += "[%s] " % _action_to_symbol(pattern[i])
					if (i + 1) % 4 == 0:
						display_text += "\n"
				display_text += "\nTime: %.1f" % display_time_remaining

			Phase.INPUT:
				display_text = "INPUT THE PATTERN:\n\n"
				for i in range(pattern.size()):
					if i < current_input_index:
						display_text += "[✓] "
					elif i == current_input_index:
						display_text += "[?] "
					else:
						display_text += "[ ] "
					if (i + 1) % 4 == 0:
						display_text += "\n"
				display_text += "\nProgress: %d/%d" % [current_input_index, pattern.size()]

			Phase.COMPLETE:
				display_text = "COMPLETE!"

		if pattern_display.has_method("set_text"):
			pattern_display.set_text(display_text)

	# Update progress bar
	var progress_bar = get_node_or_null("ProgressBar")
	if progress_bar:
		var progress = (float(current_input_index) / float(max(pattern.size(), 1))) * 100.0
		progress_bar.value = progress

func _create_display_timer(duration: float) -> void:
	# Create a timer that updates the display countdown each 0.1s
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.autostart = true
	timer.timeout.connect(_update_display_timer.bind(timer))
	add_child(timer)

func _update_display_timer(timer: Timer) -> void:
	if current_phase == Phase.DISPLAY:
		display_time_remaining -= 0.1
		if display_time_remaining <= 0:
			display_time_remaining = 0
			timer.queue_free()
		_update_display()

func _action_to_symbol(action: String) -> String:
	var symbols = {
		"ui_up": "↑",
		"ui_down": "↓",
		"ui_left": "←",
		"ui_right": "→",
		"ui_accept": "A",
		"ui_cancel": "B",
		"ui_select": "X"
	}
	return symbols.get(action, "?")

func _play_feedback(correct: bool) -> void:
	# Play sound, show visual effect
	var audio = get_node_or_null("/root/AudioController")
	if audio and audio.has_method("play_sfx"):
		if correct:
			audio.play_sfx("correct_ding")
		else:
			audio.play_sfx("wrong_buzz")

	# Visual feedback
	var tween = get_tree().create_tween()
	if correct:
		tween.tween_property(self, "modulate", Color(0.8, 1.0, 0.8), 0.1)
		tween.tween_property(self, "modulate", Color(1, 1, 1), 0.2)
	else:
		var original_pos = position
		tween.tween_property(self, "position:x", original_pos.x + 10, 0.05)
		tween.tween_property(self, "position:x", original_pos.x - 10, 0.05)
		tween.tween_property(self, "position:x", original_pos.x, 0.05)
		tween.tween_property(self, "modulate", Color(1.0, 0.8, 0.8), 0.1)
		tween.tween_property(self, "modulate", Color(1, 1, 1), 0.2)

func _generate_pattern(count: int) -> void:
	pattern.clear()
	var actions = ["ui_up", "ui_right", "ui_down", "ui_left"]
	for _i in range(count):
		pattern.append(actions[randi() % actions.size()])

# Legacy compatibility - old method signatures
func start_crafting_legacy(grinding_pattern: Array[String], buttons: Array[String], timing: float = 1.5) -> void:
	# Convert old difficulty to new one
	var diff: Difficulty
	if grinding_pattern.size() <= 4:
		diff = Difficulty.TUTORIAL
	elif grinding_pattern.size() <= 8:
		diff = Difficulty.ADVANCED
	elif grinding_pattern.size() <= 12:
		diff = Difficulty.ADVANCED_PLUS
	elif grinding_pattern.size() <= 16:
		diff = Difficulty.EXPERT
	else:
		diff = Difficulty.EXPERT_PLUS

	pattern = grinding_pattern
	start_crafting(diff, pattern)

func start_with_difficulty(difficulty_or_index: Variant, _recipe: RecipeData = null) -> void:
	start_crafting(difficulty_or_index)
