extends Node2D

## Daedalus Workshop Location
## Master craftsman Daedalus's temporary shelter on Aiaia
## Contains the loom for weaving minigame
## Daedalus can be found here during/after Quest 7

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var return_trigger: Area2D = $ReturnTrigger
@onready var loom: StaticBody2D = $Loom
@onready var dialogue_manager = $UI/DialogueBox

var _player_entered := false

func _ready() -> void:
	# Connect return trigger
	if return_trigger and return_trigger.has_signal("body_entered"):
		return_trigger.body_entered.connect(_on_return_trigger_body_entered)

func _on_return_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.change_scene("res://game/features/world/world.tscn")

func interact() -> void:
	# Loom interaction handled by loom.gd
	pass
