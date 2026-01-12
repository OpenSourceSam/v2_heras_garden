extends CutsceneBase

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.0).timeout
	await show_text("The potion spills into the dark water.", 2.5)
	await show_text("Scylla gasps as stone creeps across her skin.", 2.6)
	await show_text("The sea grows still. The screams fade.", 2.4)
	await show_text("Circe bows her head.", 2.0)
	fade_out(1.0)
	await get_tree().create_timer(1.0).timeout
	GameState.set_flag("scylla_petrified", true)
	GameState.set_flag("quest_11_complete", true)
	GameState.set_flag("game_complete", true)
	cutscene_finished.emit()
	SceneManager.change_scene(Constants.SCENE_WORLD)
