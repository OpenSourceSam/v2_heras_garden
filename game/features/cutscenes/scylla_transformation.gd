extends CutsceneBase

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.0).timeout
	await show_text("The sap touches the water.", 2.0)
	await show_text("Scylla screams. Her body twists.", 2.5)
	await show_text("Six heads rise from the pool.", 2.5)
	await show_text("Circe staggers back, horrified.", 2.0)
	await show_text("Thunder splits the sky.", 2.0)
	await show_text("Zeus: You used pharmaka, Circe.", 2.5)
	await show_text("Helios: You made a monster of a nymph.", 2.5)
	await show_text("Circe: I did not mean this. I can fix it.", 2.5)
	await show_text("Zeus: Intent is nothing. The damage is done.", 2.5)
	await show_text("Zeus: For this, you are exiled to Aiaia.", 2.5)
	fade_out(1.0)
	await get_tree().create_timer(1.0).timeout
	GameState.set_flag("transformed_scylla", true)
	GameState.set_flag("quest_3_complete", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")
