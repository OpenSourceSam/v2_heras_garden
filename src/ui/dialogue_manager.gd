extends Control
## DialogueManager - Handles dialogue display and tree traversal
## See DEVELOPMENT_ROADMAP.md Task 1.5.2

# ============================================
# SIGNALS
# ============================================

signal dialogue_started(dialogue_id: String)
signal dialogue_ended(dialogue_id: String)
signal choice_made(choice_index: int, choice_data: Dictionary)

# ============================================
# NODE REFERENCES
# ============================================

@onready var speaker_label: Label = $Panel/SpeakerName
@onready var text_label: Label = $Panel/Text
@onready var choices_container: VBoxContainer = $Panel/Choices

# ============================================
# STATE
# ============================================

var current_dialogue: DialogueData = null
var current_line_index: int = 0
var is_text_scrolling: bool = false
var text_scroll_speed: float = 30.0 # characters per second
var _scroll_tween: Tween = null


# ============================================
# DIALOGUE FLOW
# ============================================

func _ready() -> void:
	# Debug: if run as standalone scene, start test
	if get_parent() == get_tree().root:
		start_dialogue("test_greeting")

func start_dialogue(dialogue_id: String) -> void:
	var dialogue_data = load("res://resources/dialogues/%s.tres" % dialogue_id) as DialogueData
	if not dialogue_data:
		push_error("[DialogueManager] Dialogue not found: %s" % dialogue_id)
		return
	
	# Check if flags required
	for flag in dialogue_data.flags_required:
		if not GameState.get_flag(flag):
			print("[DialogueManager] Missing required flag: %s" % flag)
			return
	
	current_dialogue = dialogue_data
	current_line_index = 0
	visible = true
	choices_container.visible = false
	dialogue_started.emit(dialogue_id)
	
	_show_next_line()
	print("[DialogueManager] Started dialogue: %s" % dialogue_id)

func _show_next_line() -> void:
	if current_line_index >= current_dialogue.lines.size():
		_end_dialogue()
		return
	
	var line = current_dialogue.lines[current_line_index]
	speaker_label.text = line.get("speaker", "")
	choices_container.visible = false
	
	# Start text scrolling
	is_text_scrolling = true
	_scroll_text(line.get("text", ""))

func _scroll_text(full_text: String) -> void:
	# Cancel existing tween
	if _scroll_tween:
		_scroll_tween.kill()
	
	text_label.text = ""
	text_label.visible_ratio = 0.0
	text_label.text = full_text
	
	var char_count = full_text.length()
	var duration = float(char_count) / text_scroll_speed
	
	_scroll_tween = create_tween()
	_scroll_tween.tween_property(text_label, "visible_ratio", 1.0, duration)
	await _scroll_tween.finished
	
	is_text_scrolling = false
	
	# Check if there are choices
	if current_line_index == current_dialogue.lines.size() - 1 and current_dialogue.choices.size() > 0:
		_show_choices()

func _show_choices() -> void:
	# Clear existing choices
	for child in choices_container.get_children():
		child.queue_free()
	
	# Create choice buttons
	for i in range(current_dialogue.choices.size()):
		var choice = current_dialogue.choices[i]
		
		# Check if choice requires flag
		if choice.has("flag_required") and choice["flag_required"] != "":
			if not GameState.get_flag(choice["flag_required"]):
				continue # Skip this choice
		
		var button = Button.new()
		button.text = choice["text"]
		button.pressed.connect(_on_choice_selected.bind(i, choice))
		choices_container.add_child(button)
	
	choices_container.visible = true

func _on_choice_selected(index: int, choice: Dictionary) -> void:
	print("[DialogueManager] Choice selected: %d" % index)
	choice_made.emit(index, choice)
	choices_container.visible = false
	
	# Set flags if choice specifies
	if choice.has("flag_to_set") and choice["flag_to_set"] != "":
		GameState.set_flag(choice["flag_to_set"], true)
	
	# Jump to next dialogue if specified
	if choice.has("next_id") and choice["next_id"] != "":
		_end_dialogue()
		start_dialogue(choice["next_id"])
	else:
		_end_dialogue()

# ============================================
# INPUT HANDLING
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept"):
		if is_text_scrolling:
			# Skip text scroll - show all text immediately
			if _scroll_tween:
				_scroll_tween.kill()
			text_label.visible_ratio = 1.0
			is_text_scrolling = false
			
			# Check if there are choices
			if current_line_index == current_dialogue.lines.size() - 1 and current_dialogue.choices.size() > 0:
				_show_choices()
		elif choices_container.visible:
			# Choices showing - don't advance
			pass
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
	print("[DialogueManager] Dialogue ended")
