extends Node2D

const CONFRONTATION_DIALOGUES := [
	"act1_confront_scylla_gift",
	"act1_confront_scylla_honest",
	"act1_confront_scylla_cryptic"
]
const FINAL_CONFRONTATION_DIALOGUES := [
	"act3_final_confrontation_understand",
	"act3_final_confrontation_mercy",
	"act3_final_confrontation_request"
]

var _cutscene_started := false
@onready var dialogue_box: Node = $UI/DialogueBox

func _ready() -> void:
	if dialogue_box and dialogue_box.has_signal("dialogue_ended"):
		if not dialogue_box.dialogue_ended.is_connected(_on_dialogue_ended):
			dialogue_box.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(dialogue_id: String) -> void:
	if _cutscene_started:
		return
	if GameState.get_flag("quest_3_active") and not GameState.get_flag("quest_3_complete"):
		if CONFRONTATION_DIALOGUES.has(dialogue_id):
			_cutscene_started = true
			CutsceneManager.play_cutscene("res://game/features/cutscenes/scylla_transformation.tscn")
		return
	if GameState.get_flag("quest_5_active") and GameState.has_item("calming_draught") and not GameState.get_flag("calming_draught_failed"):
		_cutscene_started = true
		CutsceneManager.play_cutscene("res://game/features/cutscenes/calming_draught_failed.tscn")
		return
	if GameState.get_flag("quest_6_active") and GameState.has_item("reversal_elixir") and not GameState.get_flag("reversal_elixir_failed"):
		_cutscene_started = true
		CutsceneManager.play_cutscene("res://game/features/cutscenes/reversal_elixir_failed.tscn")
		return
	if GameState.get_flag("quest_8_active") and GameState.has_item("binding_ward") and not GameState.get_flag("binding_ward_failed"):
		_cutscene_started = true
		CutsceneManager.play_cutscene("res://game/features/cutscenes/binding_ward_failed.tscn")
		return
	if GameState.get_flag("quest_11_active") and not GameState.get_flag("quest_11_complete"):
		if FINAL_CONFRONTATION_DIALOGUES.has(dialogue_id):
			_cutscene_started = true
			CutsceneManager.play_cutscene("res://game/features/cutscenes/scylla_petrification.tscn")

# [Codex - 2026-01-16]
