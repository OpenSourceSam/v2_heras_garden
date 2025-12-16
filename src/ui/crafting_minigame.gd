extends Control

signal crafting_complete(success: bool)

var pattern: Array[String] = []
var button_sequence: Array[String] = []
var current_pattern_index: int = 0
var current_button_index: int = 0
var timing_window: float = 1.5
var last_input_time: float = 0.0
var is_grinding_phase: bool = true

func _ready() -> void:
	# Debug: if run as standalone scene, start test
	if get_parent() == get_tree().root:
		start_crafting(
			["ui_up", "ui_down", "ui_left", "ui_right"],
			["ui_accept", "ui_accept"],
			2.0
		)

func start_crafting(grinding_pattern: Array[String], buttons: Array[String], timing: float = 1.5) -> void:
	pattern = grinding_pattern
	button_sequence = buttons
	timing_window = timing
	current_pattern_index = 0
	current_button_index = 0
	is_grinding_phase = true
	last_input_time = Time.get_ticks_msec() / 1000.0
	
	visible = true
	set_process_unhandled_input(true)
	_update_display()
	print("Crafting started: Pattern=%s, Buttons=%s" % [pattern, button_sequence])

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	# Only check for key presses
	if not event is InputEventKey and not event is InputEventJoypadButton:
		return
	if not event.pressed:
		return

	var current_time = Time.get_ticks_msec() / 1000.0

	# Check timing window
	if current_time - last_input_time > timing_window:
		print("Time expired! %f vs %f" % [current_time - last_input_time, timing_window])
		_fail_crafting()
		return

	if is_grinding_phase:
		_handle_grinding_input(event)
	else:
		_handle_button_input(event)

func _handle_grinding_input(event: InputEvent) -> void:
	if current_pattern_index >= pattern.size():
		return # Should have transitioned already

	var expected = pattern[current_pattern_index]
	
	if event.is_action_pressed(expected):
		# Correct input
		current_pattern_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)
		print("Pattern match: %s" % expected)

		if current_pattern_index >= pattern.size():
			# Grinding complete, move to button sequence
			print("Grinding phase complete!")
			is_grinding_phase = false
			current_button_index = 0
			last_input_time = Time.get_ticks_msec() / 1000.0
			_update_display()
			
			# If no buttons, auto-complete
			if button_sequence.size() == 0:
				_complete_crafting(true)

	else:
		# Check for wrong input (only directional checks to avoid punishing non-related keys)
		for action in ["ui_up", "ui_right", "ui_down", "ui_left"]:
			if action != expected and event.is_action_pressed(action):
				print("Wrong pattern input: %s (expected %s)" % [action, expected])
				_play_feedback(false)
				# Optional: Fail on wrong input or just penalize
				# For now, let's valid failure on wrong directional input
				# _fail_crafting() 

func _handle_button_input(event: InputEvent) -> void:
	if current_button_index >= button_sequence.size():
		return

	var expected = button_sequence[current_button_index]

	if event.is_action_pressed(expected):
		# Correct input
		current_button_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)
		print("Button match: %s" % expected)

		if current_button_index >= button_sequence.size():
			# All inputs correct - success!
			_complete_crafting(true)

	else:
		# Check for wrong input
		for action in ["ui_accept", "ui_cancel", "ui_select", "ui_focus_next"]:
			if action != expected and event.is_action_pressed(action):
				print("Wrong button input: %s (expected %s)" % [action, expected])
				_fail_crafting()

func _complete_crafting(success: bool) -> void:
	print("Crafting complete: Success=%s" % success)
	crafting_complete.emit(success)
	set_process_unhandled_input(false)
	# visible = false # Let caller handle visibility or wait for animation

func _fail_crafting() -> void:
	_complete_crafting(false)

func _update_display() -> void:
	# Placeholder for UI updates
	pass

func _play_feedback(correct: bool) -> void:
	# Placeholder for audio/visual feedback
	pass
