extends Control

signal minigame_complete(success: bool, items: Array)

const MAX_MISTAKES: int = 3
const INPUT_ACTIONS: Dictionary = {
	"ui_left": "Left",
	"ui_right": "Right",
	"ui_up": "Up",
	"ui_down": "Down"
}

var PATTERNS = [
	PackedStringArray(["ui_left", "ui_right", "ui_up", "ui_down"]),
	PackedStringArray(["ui_up", "ui_up", "ui_right", "ui_down"]),
	PackedStringArray(["ui_left", "ui_left", "ui_down", "ui_right"])
]

@onready var pattern_label: Label = $PatternLabel
@onready var status_label: Label = $StatusLabel
@onready var mistakes_label: Label = $MistakesLabel
@onready var hint_label: Label = $HintLabel

var current_pattern: PackedStringArray = PackedStringArray()
var progress_index: int = 0
var mistakes: int = 0

func _ready() -> void:
	assert(pattern_label != null, "PatternLabel missing")
	assert(status_label != null, "StatusLabel missing")
	assert(mistakes_label != null, "MistakesLabel missing")
	assert(hint_label != null, "HintLabel missing")
	_select_pattern()
	_update_ui()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	for action in INPUT_ACTIONS.keys():
		if event.is_action_pressed(action):
			_handle_input(action)
			return

func _select_pattern() -> void:
	current_pattern = PATTERNS.pick_random()
	progress_index = 0
	mistakes = 0

func _handle_input(action: String) -> void:
	if progress_index >= current_pattern.size():
		return

	if action == current_pattern[progress_index]:
		progress_index += 1
		if AudioController.has_sfx("ui_confirm"):
			AudioController.play_sfx("ui_confirm")
		if progress_index >= current_pattern.size():
			_win()
			return
	else:
		mistakes += 1
		if AudioController.has_sfx("wrong_buzz"):
			AudioController.play_sfx("wrong_buzz")
		if mistakes >= MAX_MISTAKES:
			_fail()
			return

	_update_ui()

func _pattern_text() -> String:
	var labels: Array[String] = []
	for action in current_pattern:
		labels.append(INPUT_ACTIONS.get(action, action))
	return "Pattern: %s" % " ".join(labels)

func _update_ui() -> void:
	pattern_label.text = _pattern_text()
	status_label.text = "Progress: %d/%d" % [progress_index, current_pattern.size()]
	mistakes_label.text = "Mistakes: %d/%d" % [mistakes, MAX_MISTAKES]
	hint_label.text = "Match the pattern with the D-pad"

func _win() -> void:
	if AudioController.has_sfx("success_fanfare"):
		AudioController.play_sfx("success_fanfare")
	var rewards = ["woven_cloth"]
	_award_items(rewards)
	GameState.set_flag("quest_7_complete", true)
	minigame_complete.emit(true, rewards)
	await get_tree().create_timer(1.0).timeout
	SceneManager.change_scene(Constants.SCENE_WORLD)

func _fail() -> void:
	if AudioController.has_sfx("failure_sad"):
		AudioController.play_sfx("failure_sad")
	minigame_complete.emit(false, [])
	await get_tree().create_timer(1.0).timeout
	SceneManager.change_scene(Constants.SCENE_WORLD)

func _award_items(items: Array) -> void:
	for item_id in items:
		GameState.add_item(item_id, 1)
