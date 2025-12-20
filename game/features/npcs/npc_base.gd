extends CharacterBody2D
class_name NPCBase

@export var npc_id: String = ""
@export var dialogue_id: String = ""
@export var portrait: Texture2D = null

@onready var sprite: Sprite2D = $Sprite

func interact() -> void:
	var dialogue_path = "res://game/shared/resources/dialogues/%s.tres" % dialogue_id
	var dialogue = load(dialogue_path)
	if dialogue:
		var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
		if dialogue_box and dialogue_box.has_method("start_dialogue"):
			dialogue_box.start_dialogue(dialogue)

func set_facing(direction: Vector2) -> void:
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
