extends Control
## Main Menu UI Controller
## Handles button presses and scene transitions
## See DEVELOPMENT_ROADMAP.md for Phase 1 implementation

# ============================================
# NODE REFERENCES
# ============================================
# TODO: Add @onready references after verifying button names in scene
# @onready var new_game_button: Button = $VBoxContainer/NewGameButton
# @onready var continue_button: Button = $VBoxContainer/ContinueButton
# @onready var settings_button: Button = $VBoxContainer/SettingsButton
# @onready var quit_button: Button = $VBoxContainer/QuitButton

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO: Connect button signals
	# new_game_button.pressed.connect(_on_new_game_pressed)
	# continue_button.pressed.connect(_on_continue_pressed)
	# settings_button.pressed.connect(_on_settings_pressed)
	# quit_button.pressed.connect(_on_quit_pressed)

	# TODO: Check if save file exists, disable continue button if not
	pass

# ============================================
# BUTTON HANDLERS
# ============================================

func _on_new_game_pressed() -> void:
	# TODO: Start new game
	# - Reset GameState
	# - Load world scene via SceneManager (Task 1.2.2)
	# SceneManager.change_scene("res://scenes/world.tscn")
	pass

func _on_continue_pressed() -> void:
	# TODO: Load saved game
	# - Call SaveController.load_game()
	# - Load world scene
	pass

func _on_settings_pressed() -> void:
	# TODO (Phase 3): Open settings menu
	# - Show settings overlay or change to settings scene
	pass

func _on_quit_pressed() -> void:
	# TODO: Quit game
	# get_tree().quit()
	pass
