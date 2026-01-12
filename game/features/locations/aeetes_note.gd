extends StaticBody2D

@export var dialogue_id: String = "aeetes_note"

func interact() -> void:
	var dialogue_manager = get_tree().get_first_node_in_group("dialogue_manager")
	if dialogue_manager and dialogue_manager.has_method("start_dialogue"):
		dialogue_manager.start_dialogue(dialogue_id)
		return

	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("show_dialogue"):
		var dialogue_res = load("res://game/shared/resources/dialogues/%s.tres" % dialogue_id)
		if dialogue_res:
			dialogue_box.show_dialogue(dialogue_res)
