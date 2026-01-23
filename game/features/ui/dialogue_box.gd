extends Control

signal dialogue_started(dialogue_id: String)
signal dialogue_ended(dialogue_id: String)
signal choice_made(choice_index: int, choice_data: Dictionary)

@onready var speaker_label: Label = $Panel/SpeakerName
@onready var text_label: Label = $Panel/Text
@onready var choices_container: VBoxContainer = $Panel/Choices
@onready var continue_prompt: Label = $Panel/ContinuePrompt

var current_dialogue: DialogueData = null
var current_line_index: int = 0
var is_text_scrolling: bool = false
var text_scroll_speed: float = 30.0 # characters per second
var _scroll_version: int = 0
var _current_full_text: String = ""

func _ready() -> void:
	assert(speaker_label != null, "Dialogue speaker label missing")
	assert(text_label != null, "Dialogue text label missing")
	assert(choices_container != null, "Dialogue choices container missing")
	assert(continue_prompt != null, "Dialogue continue prompt missing")

func start_dialogue(dialogue_id: String) -> void:
	var dialogue_path = "res://game/shared/resources/dialogues/%s.tres" % dialogue_id
	var dialogue_data = load(dialogue_path) as DialogueData
	if not dialogue_data:
		push_error("Dialogue not found: %s" % dialogue_id)
		return
	_show_dialogue_data(dialogue_data)

func show_dialogue(dialogue_data: DialogueData) -> void:
	_show_dialogue_data(dialogue_data)

func _show_dialogue_data(dialogue_data: DialogueData) -> void:
	if not dialogue_data:
		push_error("Dialogue data is null")
		return

	# Check if flags required
	for flag in dialogue_data.flags_required:
		if not GameState.get_flag(flag):
			print("Missing required flag: %s" % flag)
			return

	current_dialogue = dialogue_data
	current_line_index = 0
	visible = true
	choices_container.visible = false
	continue_prompt.visible = true
	dialogue_started.emit(dialogue_data.id)

	_show_next_line()

func _show_next_line() -> void:
	if current_line_index >= current_dialogue.lines.size():
		_end_dialogue()
		return

	var line = current_dialogue.lines[current_line_index]
	speaker_label.text = line.get("speaker", "")

	# Start text scrolling
	is_text_scrolling = true
	_scroll_text(line.get("text", ""))

func _scroll_text(full_text: String) -> void:
	text_label.text = ""
	var chars_shown = 0
	_scroll_version += 1
	_current_full_text = full_text
	var scroll_id = _scroll_version

	while chars_shown < full_text.length():
		if scroll_id != _scroll_version:
			return
		text_label.text = full_text.substr(0, chars_shown + 1)
		chars_shown += 1
		await get_tree().create_timer(1.0 / text_scroll_speed).timeout

	is_text_scrolling = false

	# Check if there are choices
	if current_line_index == current_dialogue.lines.size() - 1 and current_dialogue.choices.size() > 0:
		_show_choices()

func _show_choices() -> void:
	# Clear existing choices
	for child in choices_container.get_children():
		child.queue_free()

	var first_button: Button = null

	# Create choice buttons
	for i in range(current_dialogue.choices.size()):
		var choice = current_dialogue.choices[i]

		# Check if choice requires flag
		if choice.has("flag_required") and choice["flag_required"] != "":
			if not GameState.get_flag(choice["flag_required"]):
				continue # Skip this choice

		var button = Button.new()
		button.focus_mode = Control.FOCUS_ALL
		button.text = choice["text"]
		button.pressed.connect(_on_choice_selected.bind(i, choice))
		choices_container.add_child(button)
		UIHelpers.setup_button_focus(button)

		if first_button == null:
			first_button = button

	choices_container.visible = choices_container.get_child_count() > 0
	continue_prompt.visible = false
	if first_button:
		first_button.grab_focus()
		# Vital debug: Log focus state for troubleshooting
		print("[DEBUG] DialogueBox: First choice button '%s' grabbed focus" % first_button.text)

func _activate_choice_from_input() -> bool:
	if not choices_container.visible:
		return false
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner is Button and focus_owner.get_parent() == choices_container:
		# Vital debug: Log which button is being activated
		print("[DEBUG] DialogueBox: Activating focused choice '%s'" % focus_owner.text)
		# Emit the pressed signal to trigger the button's action
		focus_owner.emit_signal("pressed")
		return true
	if choices_container.get_child_count() > 0:
		var first_button = choices_container.get_child(0)
		if first_button is Button:
			# Vital debug: Log fallback to first button
			print("[DEBUG] DialogueBox: No focused button, activating first choice '%s'" % first_button.text)
			# Emit the pressed signal to trigger the button's action
			first_button.emit_signal("pressed")
			return true
	print("[DEBUG] DialogueBox: Failed to activate choice - no buttons found")
	return false

func _on_choice_selected(index: int, choice: Dictionary) -> void:
	choice_made.emit(index, choice)
	choices_container.visible = false

	# Jump to next dialogue if specified
	if choice.has("next_id") and choice["next_id"] != "":
		_end_dialogue()
		start_dialogue(choice["next_id"])
	else:
		_end_dialogue()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		if choices_container.visible:
			if _activate_choice_from_input():
				get_viewport().set_input_as_handled()
			return
		if is_text_scrolling:
			_scroll_version += 1
			text_label.text = _current_full_text
			is_text_scrolling = false
			if current_line_index == current_dialogue.lines.size() - 1 and current_dialogue.choices.size() > 0:
				_show_choices()
		else:
			# Next line
			current_line_index += 1
			_show_next_line()

func _end_dialogue() -> void:
	# Set flags if specified
	for flag in current_dialogue.flags_to_set:
		GameState.set_flag(flag, true)

	# Auto-track quest completion dialogues (questX_complete pattern)
	if current_dialogue.id.begins_with("quest") and current_dialogue.id.ends_with("_complete"):
		# Extract quest number from dialogue ID (e.g., "quest1_complete" -> "1")
		var quest_id = current_dialogue.id.trim_prefix("quest").trim_suffix("_complete")
		if quest_id.is_valid_int():
			GameState.mark_dialogue_completed(quest_id)

	dialogue_ended.emit(current_dialogue.id)
	visible = false
	current_dialogue = null

# [Codex - 2026-01-16]
