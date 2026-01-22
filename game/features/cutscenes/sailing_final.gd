extends CutsceneBase

# Sailing cutscene - final journey to Scylla's Cave (Quest 11)

var _skip_requested: bool = false

func _ready() -> void:
	_play_sequence()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_request_skip()

func _request_skip() -> void:
	if _skip_requested:
		return
	_skip_requested = true
	narration.visible = false
	GameState.set_flag("sailing_to_scylla_final", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")
	queue_free()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.5)
	await get_tree().create_timer(1.0).timeout

	# Opening scene: boat on ocean at night
	await show_text("The boat cuts through dark water.", 3.5)
	await get_tree().create_timer(1.2).timeout

	# Circe internal monologue - reflective
	await show_narrative("Circe: \"The petrification potion is heavy in my hands.\"", 3.5)
	await show_narrative("Circe: \"So much has led to this moment.\"", 3.0)
	await get_tree().create_timer(1.0).timeout

	await show_narrative("Circe: \"The failed attempts. The guilt. The desperate plans.\"", 3.0)
	await get_tree().create_timer(0.8).timeout

	await show_narrative("Circe: \"Scylla begged me to end it.\"", 2.5)
	await show_narrative("Circe: \"And now I finally can.\"", 2.5)
	await get_tree().create_timer(1.0).timeout

	# Atmosphere - night time
	await show_text("[The moon reflects on the black water. No stars tonight.]", 4.0)
	await get_tree().create_timer(2.0).timeout

	# Cliffs approaching
	await show_text("[The cave entrance looms ahead. Dark. Ancient.]", 3.5)
	await get_tree().create_timer(1.0).timeout

	# Resignation and determination
	await show_narrative("Circe: \"This isn't redemption. This is mercy.\"", 3.0)
	await show_narrative("Circe: \"I'm ready, Scylla. I'm sorry... and I love you.\"", 3.5)
	await get_tree().create_timer(1.5).timeout

	# Fade to scene
	fade_out(2.0)
	await get_tree().create_timer(2.0).timeout

	# Complete
	GameState.set_flag("sailing_to_scylla_final", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")

func show_narrative(text: String, duration: float = 3.0) -> void:
	await show_text(text, duration)
