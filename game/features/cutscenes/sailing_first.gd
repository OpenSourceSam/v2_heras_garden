extends CutsceneBase

# Sailing cutscene - first journey to Scylla's Cove (Quest 3)

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
	GameState.set_flag("sailing_to_scylla_first", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")
	queue_free()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.0).timeout

	# Opening scene: boat on ocean
	await show_text("The boat glides across the water.", 3.0)
	await get_tree().create_timer(1.0).timeout

	# Circe internal monologue
	await show_narrative("Circe: \"The Transformation Sap is ready.\"", 3.0)
	await show_narrative("Circe: \"I can feel it pulsing in my pocket.\"", 2.5)
	await get_tree().create_timer(0.8).timeout

	await show_narrative("Circe: \"She needs to drink this.\"", 2.5)
	await show_narrative("Circe: \"It will change her back. Make her human again.\"", 3.0)
	await get_tree().create_timer(1.0).timeout

	# Atmosphere
	await show_text("[Ocean waves lap against the boat. Gulls cry overhead.]", 3.0)
	await get_tree().create_timer(1.5).timeout

	# Cliffs approaching
	await show_text("[Cliffs rise in the distance. A sea cave entrance visible.]", 3.0)
	await get_tree().create_timer(1.0).timeout

	# Determination
	await show_narrative("Circe: \"I'm coming, Scylla.\"", 2.5)
	await show_narrative("Circe: \"I'm going to fix this.\"", 2.5)

	# Fade to scene
	fade_out(1.5)
	await get_tree().create_timer(1.5).timeout

	# Complete
	GameState.set_flag("sailing_to_scylla_first", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")

func show_narrative(text: String, duration: float = 3.0) -> void:
	await show_text(text, duration)
