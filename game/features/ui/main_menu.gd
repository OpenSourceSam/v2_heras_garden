extends Control
## Main Menu UI Controller
## Handles button presses and scene transitions
## See docs/execution/ROADMAP.md for Phase 1 implementation

# ============================================
# NODE REFERENCES
# ============================================
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

	for button in [
		new_game_button,
		continue_button,
		settings_button,
		weaving_button,
		quit_button
	]:
		UIHelpers.setup_button_focus(button)
	new_game_button.grab_focus()

	continue_button.disabled = not SaveController.save_exists()

# ============================================
# BUTTON HANDLERS
# ============================================

func _on_new_game_pressed() -> void:
	GameState.new_game()
	SceneManager.change_scene("res://game/features/world/world.tscn")

func _on_continue_pressed() -> void:
	if SaveController.load_game():
		SceneManager.change_scene("res://game/features/world/world.tscn")

func _on_settings_pressed() -> void:
	settings_menu.open()

func _on_weaving_pressed() -> void:
	SceneManager.change_scene("res://game/features/minigames/weaving_minigame.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
