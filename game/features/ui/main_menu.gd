extends Control
## Main Menu UI Controller
## Handles button presses and scene transitions
## See docs/execution/ROADMAP.md for Phase 1 implementation

const UIHelpers = preload("res://game/features/ui/ui_helpers.gd")

# ============================================
# NODE REFERENCES
# ============================================
# TODO: Add @onready references after verifying button names in scene
@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var weaving_button: Button = $VBoxContainer/WeavingButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var settings_menu: Control = $SettingsMenu

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO: Connect button signals
	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	weaving_button.pressed.connect(_on_weaving_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	for button in [
		new_game_button,
		continue_button,
		settings_button,
		weaving_button,
		quit_button
	]:
		UIHelpers.setup_button_focus(button)
	new_game_button.grab_focus()

	# TODO: Check if save file exists, disable continue button if not
	pass

# ============================================
# BUTTON HANDLERS
# ============================================

func _on_new_game_pressed() -> void:
	# TODO: Start new game
	# - Reset GameState
	# - Load world scene via SceneManager (Task 1.2.2)
	# SceneManager.change_scene("res://game/features/world/world.tscn")
	SceneManager.change_scene("res://game/features/world/world.tscn")

func _on_continue_pressed() -> void:
	# TODO: Load saved game
	# - Call SaveController.load_game()
	# - Load world scene
	SceneManager.change_scene("res://game/features/world/world.tscn")

func _on_settings_pressed() -> void:
	settings_menu.open()

func _on_weaving_pressed() -> void:
	SceneManager.change_scene("res://game/features/minigames/weaving_minigame.tscn")

func _on_quit_pressed() -> void:
	# TODO: Quit game
	# get_tree().quit()
	get_tree().quit()
