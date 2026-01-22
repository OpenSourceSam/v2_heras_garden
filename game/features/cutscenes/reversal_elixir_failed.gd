extends CutsceneBase

## Reversal Elixir Failure Cutscene (Quest 6)
## Circe attempts to reverse Scylla's transformation
## The elixir fails - transformation cannot be undone, only managed

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.0).timeout
	await show_text("Scylla's Cave. Circe returns, the Reversal Elixir clutched tight.", 3.5)
	await show_text("This time will be different. This time, she can fix it.", 3.0)
	await show_text("Circe: \"Scylla. I'm back.\"", 2.5)
	await show_text("The six heads rise. Recognition - and fear.", 3.0)
	await show_text("Scylla: \"Circe... don't. Nothing can undo what you've done.\"", 4.0)
	await show_text("Circe: \"No. This is different. Aeetes helped me make it.\"", 3.5)
	await show_text("Circe: \"It's a Reversal Elixir. It will turn you back.\"", 3.0)
	await show_text("Circe uncorks the vial. The liquid glimmers with hope.", 3.0)
	await show_text("Scylla: \"Please... Circe... don't give me hope...\"", 3.5)
	await show_text("Circe approaches slowly, carefully. \"Please, Scylla. Trust me.\"", 3.5)
	await show_text("One head drinks. Then another. Then all six.", 3.5)
	await show_text("For a moment, silence. Hope hangs in the air.", 3.0)
	await show_text("Then - a scream. All six heads screaming at once.", 3.5)
	await show_text("Scylla thrashes. Body contorts. But no change comes.", 3.5)
	await show_text("The transformation holds. Too deep. Too complete.", 3.0)
	await show_text("Scylla collapses, exhausted. \"Why... Circe? Why?\"", 3.0)
	await show_text("Circe falls to her knees. \"I don't know. I don't know...\"", 3.5)
	await show_text("The Reversal Elixir failed.", 2.5)
	await show_text("Transformation cannot be undone. Only contained... or ended.", 3.5)
	fade_out(1.0)
	await get_tree().create_timer(1.0).timeout
	GameState.set_flag("reversal_elixir_failed", true)
	GameState.set_flag("quest_6_complete", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/aiaia_shore.tscn")
