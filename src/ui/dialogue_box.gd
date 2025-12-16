extends CanvasLayer
## Dialogue Box UI Controller
## Displays dialogue text, handles text scrolling, and shows choices
## See DEVELOPMENT_ROADMAP.md Task 1.5.1 for implementation details

# ============================================
# CONSTANTS
# ============================================
const TEXT_SPEED: float = 0.03  # Seconds per character
const CHOICE_BUTTON_SCENE = preload("res://scenes/ui/choice_button.tscn")  # TODO: Create this

# ============================================
# NODE REFERENCES
# ============================================
# TODO (Task 1.5.1): Add @onready references
# @onready var speaker_name: Label = $Panel/MarginContainer/VBoxContainer/SpeakerName
# @onready var dialogue_text: RichTextLabel = $Panel/MarginContainer/VBoxContainer/DialogueText
# @onready var choices_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ChoicesContainer
# @onready var continue_prompt: Label = $Panel/MarginContainer/VBoxContainer/ContinuePrompt

# ============================================
# STATE
# ============================================
var current_dialogue: DialogueData = null
var current_line_index: int = 0
var is_scrolling: bool = false
var full_text: String = ""
var visible_characters: int = 0

# ============================================
# SIGNALS
# ============================================
signal dialogue_finished
signal choice_selected(choice_index: int)

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO (Task 1.5.1): Initialize
	# - Hide dialogue box initially
	# - Set up text scrolling
	hide()

# ============================================
# DIALOGUE DISPLAY
# ============================================

func show_dialogue(dialogue: DialogueData) -> void:
	# TODO (Task 1.5.1): Display dialogue
	# - Store dialogue reference
	# - Reset current_line_index
	# - Show first line
	# - Make visible
	pass

func _show_line(line_dict: Dictionary) -> void:
	# TODO (Task 1.5.1): Show single line
	# - Set speaker_name.text from line_dict["speaker"]
	# - Get full text from line_dict["text"]
	# - Start text scrolling animation
	# - Hide continue_prompt until scrolling done
	pass

func _advance_line() -> void:
	# TODO (Task 1.5.1): Move to next line
	# - Increment current_line_index
	# - Check if more lines exist
	# - If yes: show next line
	# - If no: check for choices or finish
	pass

# ============================================
# TEXT SCROLLING
# ============================================

func _process(delta: float) -> void:
	# TODO (Task 1.5.1): Handle text scrolling
	# - If is_scrolling:
	#   - Increment visible_characters over time
	#   - Update dialogue_text.visible_characters
	#   - When done, set is_scrolling = false, show continue_prompt
	pass

func _skip_text_scroll() -> void:
	# TODO (Task 1.5.1): Instant text reveal
	# - Set visible_characters to full_text.length()
	# - Stop scrolling
	# - Show continue_prompt
	pass

# ============================================
# INPUT HANDLING
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	# TODO (Task 1.5.1): Handle input
	# - If "interact" pressed:
	#   - If scrolling: skip to end
	#   - Else: advance to next line
	pass

# ============================================
# CHOICES
# ============================================

func _show_choices(choices: Array[Dictionary]) -> void:
	# TODO (Task 1.5.2): Display choice buttons
	# - Clear existing buttons from choices_container
	# - For each choice in choices:
	#   - Create choice button
	#   - Set button text
	#   - Connect pressed signal
	#   - Check flag_required, disable if not met
	# - Hide continue_prompt
	pass

func _on_choice_pressed(choice_index: int) -> void:
	# TODO (Task 1.5.2): Handle choice selection
	# - Emit choice_selected signal
	# - Get next_dialogue_id from choice
	# - Load and show next dialogue
	pass
