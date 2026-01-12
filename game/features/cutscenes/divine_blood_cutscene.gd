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
	GameState.add_item("divine_blood", 1)
	GameState.set_flag("divine_blood_collected", true)
	fade_out(0.8)
	await get_tree().create_timer(0.8).timeout
	cutscene_finished.emit()
