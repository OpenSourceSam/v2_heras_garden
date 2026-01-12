extends Node2D

const CONFRONTATION_DIALOGUES := [
	"act1_confront_scylla_gift",
	"act1_confront_scylla_honest",
	"act1_confront_scylla_cryptic"
]

var _cutscene_started := false

func _ready() -> void:
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_signal("dialogue_ended"):
		if not dialogue_box.dialogue_ended.is_connected(_on_dialogue_ended):
			dialogue_box.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(dialogue_id: String) -> void:
	if _cutscene_started:
		return
	if not GameState.get_flag("quest_3_active") or GameState.get_flag("quest_3_complete"):
		return
	if not CONFRONTATION_DIALOGUES.has(dialogue_id):
		return
	_cutscene_started = true
	CutsceneManager.play_cutscene("res://game/features/cutscenes/scylla_transformation.tscn")
