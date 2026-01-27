extends CutsceneBase

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(0.8)
	await get_tree().create_timer(0.8).timeout
	await show_text("Circe draws the blade across her palm.", 2.5)
	await show_text("Blood beads like dark rubies.", 2.2)
	await show_text("She steadies her breath and seals the vial.", 2.2)

	# Collect divine blood with visual feedback
	var viewport_center = get_viewport().get_visible_rect().size / 2
	var global_pos = get_viewport().canvas_transform.affine_inverse() * viewport_center
	GameState.collect_item_at_position("divine_blood", 1, global_pos)

	# Also show pickup effect using UIHelpers
	if get_node_or_null("/root/VisualFeedbackController"):
		var item_data = load("res://game/shared/resources/items/divine_blood.tres") as ItemData
		var item_texture = item_data.icon if item_data else null
		UIHelpers.show_item_pickup(global_pos, item_texture)

	GameState.set_flag("divine_blood_collected", true)
	fade_out(0.8)
	await get_tree().create_timer(0.8).timeout
	cutscene_finished.emit()
