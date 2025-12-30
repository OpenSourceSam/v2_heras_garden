extends Control

signal dialogue_started(dialogue_id: String)
signal dialogue_ended(dialogue_id: String)
signal choice_made(choice_index: int, choice_data: Dictionary)

@onready var speaker_label: Label = $Panel/SpeakerName
@onready var text_label: Label = $Panel/Text
@onready var choices_container: VBoxContainer = $Panel/Choices

var current_dialogue: DialogueData = null
var current_line_index: int = 0
var is_text_scrolling: bool = false
var text_scroll_speed: float = 30.0  # characters per second
var _scroll_version: int = 0
var _current_full_text: String = ""

func _ready() -> void:
	assert(speaker_label != null, "Dialogue speaker label missing")
	assert(text_label != null, "Dialogue text label missing")
	assert(choices_container != null, "Dialogue choices container missing")

func start_dialogue(dialogue_id: String) -> void:
	var dialogue_path = "res://game/shared/resources/dialogues/%s.tres" % dialogue_id
	var dialogue_data = load(dialogue_path) as DialogueData
	if not dialogue_data:
		push_error("Dialogue not found: %s" % dialogue_id)
		return

	# Check if flags required
	for flag in dialogue_data.flags_required:
		if not GameState.get_flag(flag):
			print("Missing required flag: %s" % flag)
			return

	current_dialogue = dialogue_data
	current_line_index = 0
	visible = true
	dialogue_started.emit(dialogue_id)

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
				continue  # Skip this choice

		var button = Button.new()
		button.focus_mode = Control.FOCUS_ALL
		button.text = choice["text"]
		button.pressed.connect(_on_choice_selected.bind(i, choice))
		choices_container.add_child(button)
		UIHelpers.setup_button_focus(button)

		if first_button == null:
			first_button = button

	choices_container.visible = choices_container.get_child_count() > 0
	if first_button:
		first_button.grab_focus()

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

	dialogue_ended.emit(current_dialogue.id)
	visible = false
	current_dialogue = null
