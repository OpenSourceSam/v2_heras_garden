extends Control
## Main Menu UI Controller
## Handles button presses and scene transitions
## See docs/execution/ROADMAP.md for Phase 1 implementation

# ============================================
# NODE REFERENCES
# ============================================
@onready var new_game_button: Button = $NewGameButton
@onready var continue_button: Button = $ContinueButton
@onready var settings_button: Button = $SettingsButton
@onready var weaving_button: Button = $WeavingButton
@onready var quit_button: Button = $QuitButton
@onready var settings_menu: Control = $SettingsMenu
var _starting_new_game: bool = false

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	SceneManager.current_scene = self
	assert(new_game_button != null, "NewGameButton missing")
	assert(continue_button != null, "ContinueButton missing")
	assert(settings_button != null, "SettingsButton missing")
	assert(weaving_button != null, "WeavingButton missing")
	assert(quit_button != null, "QuitButton missing")
	assert(settings_menu != null, "SettingsMenu missing")

	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	weaving_button.pressed.connect(_on_weaving_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	var focus_buttons: Array[Button] = [
		new_game_button,
		continue_button,
		settings_button,
		quit_button
	]
	if weaving_button.visible:
		focus_buttons.append(weaving_button)
	for button in focus_buttons:
		UIHelpers.setup_button_focus(button)
	new_game_button.grab_focus()

	continue_button.disabled = not SaveController.save_exists()

# ============================================
# BUTTON HANDLERS
# ============================================

func _on_new_game_pressed() -> void:
	if _starting_new_game:
		return
	_starting_new_game = true
	_set_menu_interactive(false)
	visible = false
	# Initialize game state, then play prologue cutscene
	GameState.new_game()
	await CutsceneManager.play_cutscene("res://game/features/cutscenes/prologue_opening.tscn")

func _on_continue_pressed() -> void:
	if SaveController.load_game():
		SceneManager.change_scene("res://game/features/world/world.tscn")

func _on_settings_pressed() -> void:
	settings_menu.open()

func _on_weaving_pressed() -> void:
	SceneManager.change_scene("res://game/features/minigames/weaving_minigame.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _set_menu_interactive(enabled: bool) -> void:
	new_game_button.disabled = not enabled
	continue_button.disabled = not enabled
	settings_button.disabled = not enabled
	weaving_button.disabled = not enabled
	quit_button.disabled = not enabled

# [Codex - 2026-01-08]
