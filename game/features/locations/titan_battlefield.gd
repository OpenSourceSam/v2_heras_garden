extends Node2D

## Titan Battlefield Location
## Ancient battlefield where Titans once fought
## Sacred ground with divine energy - Circe comes here to collect divine blood

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var return_trigger: Area2D = $ReturnTrigger
@onready var divine_blood_trigger: Area2D = $DivineBloodTrigger
@onready var dialogue_manager = $UI/DialogueBox

var _player_entered := false

func _ready() -> void:
	# Connect return trigger
	if return_trigger and return_trigger.has_signal("body_entered"):
		return_trigger.body_entered.connect(_on_return_trigger_body_entered)

	# Connect divine blood trigger
	if divine_blood_trigger and divine_blood_trigger.has_signal("body_entered"):
		divine_blood_trigger.body_entered.connect(_on_divine_blood_trigger_body_entered)

func _on_return_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.change_scene("res://game/features/world/world.tscn")

func _on_divine_blood_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not _player_entered:
		_player_entered = true
		_trigger_divine_blood_cutscene()

func _trigger_divine_blood_cutscene() -> void:
	if GameState.get_flag("quest_10_active") and not GameState.get_flag("divine_blood_collected"):
		CutsceneManager.play_cutscene("res://game/features/cutscenes/divine_blood_cutscene.tscn")
