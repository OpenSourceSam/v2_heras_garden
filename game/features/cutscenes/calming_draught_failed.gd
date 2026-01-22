extends CutsceneBase

## Calming Draught Failure Cutscene (Quest 5)
## Circe attempts to heal Scylla with the calming potion
## Scylla's transformation is too advanced - the potion fails

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.0).timeout
	await show_text("Scylla's Cave. The air is thick with the scent of sea and decay.", 3.0)
	await show_text("Circe approaches slowly, the vial of Calming Draught in hand.", 3.0)
	await show_text("Circe: \"Scylla... I've brought something. To help you.\"", 3.5)
	await show_text("The six heads stir. One focuses on her, eyes wild.", 3.0)
	await show_text("Scylla: \"Circe? Is that... you?\"", 2.5)
	await show_text("Circe: \"Yes. Please. Drink this. It will calm the... the pain.\"", 3.5)
	await show_text("Circe holds out the vial. Her hands tremble.", 3.0)
	await show_text("Scylla's head lunges forward - then recoils with a snarl.", 3.0)
	await show_text("Scylla: \"NO! You... YOU did this!\"", 2.5)
	await show_text("The vial shatters against the cave wall. Potion splashes, wasted.", 3.5)
	await show_text("Circe: \"Scylla, please... I'm trying to help...\"", 3.0)
	await show_text("Scylla: \"HELP? You turned me into THIS!\"", 2.5)
	await show_text("Scylla: \"Leave! Before I... before I hurt you too.\"", 3.0)
	await show_text("Circe backs away, tears in her eyes.", 2.5)
	await show_text("The Calming Draught was not enough.", 2.5)
	await show_text("Transformation has progressed too far.", 2.5)
	fade_out(1.0)
	await get_tree().create_timer(1.0).timeout
	GameState.set_flag("calming_draught_failed", true)
	GameState.set_flag("quest_5_complete", true)
	GameState.set_flag("quest_6_active", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/aiaia_shore.tscn")
