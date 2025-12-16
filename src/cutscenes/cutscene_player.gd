extends Control
## Cutscene Player
## Handles character positioning, dialogue, transitions
## See DEVELOPMENT_ROADMAP.md Phase 2 Task 2.4

# ============================================
# SIGNALS
# ============================================
signal cutscene_finished

# ============================================
# NODE REFERENCES
# ============================================
# TODO (Phase 2): Add @onready references
# @onready var background: Sprite2D = $Background
# @onready var character_left: Sprite2D = $CharacterLeft
# @onready var character_right: Sprite2D = $CharacterRight
# @onready var dialogue_box: Control = $DialogueBox

# ============================================
# STATE
# ============================================
var cutscene_data: Dictionary = {}
var current_step: int = 0

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO (Phase 2): Initialize cutscene player
	# - Connect dialogue_box.dialogue_finished signal
	# - Hide initially
	pass

# ============================================
# PLAYBACK
# ============================================

func play_cutscene(cutscene_id: String) -> void:
	# TODO (Phase 2): Load and play cutscene
	# - Load cutscene definition from resources/cutscenes/
	# - Parse steps (dialogue, character_enter, character_exit, background_change)
	# - Start playback
	# - Show control
	pass

func _advance_step() -> void:
	# TODO (Phase 2): Advance to next cutscene step
	# - Execute step command (show_dialogue, move_character, etc.)
	# - If last step: emit cutscene_finished, hide control
	pass

# ============================================
# COMMANDS
# ============================================

func _show_dialogue(character_id: String, dialogue_id: String) -> void:
	# TODO (Phase 2): Display dialogue
	# - Load DialogueData
	# - Show via dialogue_box
	pass

func _character_enter(character_id: String, position: String) -> void:
	# TODO (Phase 2): Animate character entering
	# - position: "left" or "right"
	# - Tween from off-screen
	pass

func _character_exit(character_id: String) -> void:
	# TODO (Phase 2): Animate character exiting
	# - Tween to off-screen
	pass

func _change_background(background_id: String) -> void:
	# TODO (Phase 2): Change background sprite
	# - Load new background texture
	# - Fade transition
	pass
