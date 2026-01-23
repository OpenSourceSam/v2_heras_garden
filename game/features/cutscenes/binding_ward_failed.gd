extends CutsceneBase

## Binding Ward Failure Cutscene (Quest 8)
## Circe attempts to contain Scylla's power with a Binding Ward
## The chains shatter - Scylla asks for death as her only mercy

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.0).timeout
	await show_text("Scylla's Cave. Circe enters with sacred earth in her pockets.", 3.5)
	await show_text("The Binding Ward will contain Scylla's power.", 3.0)
	await show_text("It won't heal her. But it will protect everyone else.", 3.0)
	await show_text("Circe: \"Scylla. I have to do this.\"", 2.5)
	await show_text("The six heads watch. Too tired to fight anymore.", 3.0)
	await show_text("Scylla: \"Do what you must. I don't care anymore.\"", 3.5)
	await show_text("Circe spreads the sacred earth in a circle around Scylla.", 3.5)
	await show_text("Chants words of binding. Ancient words. Heavy words.", 3.0)
	await show_text("The earth glows. Ethereal chains rise from the circle.", 3.5)
	await show_text("They wrap around Scylla's body. Around each head.", 3.0)
	await show_text("For a moment, it seems to work. The chains hold.", 3.5)
	await show_text("Then - a crack. Like lightning in the circle.", 2.5)
	await show_text("Another. The chains strain. Scylla's power fights back.", 3.5)
	await show_text("Scylla: \"Circe... stop... please...\"", 2.5)
	await show_text("The chains shatter. Sacred earth scatters like dust.", 3.0)
	await show_text("The Binding Ward has failed.", 2.5)
	await show_text("Scylla looks up. Six heads. Twelve eyes. Full of pain.", 3.5)
	await show_text("Scylla: \"JUST LET ME DIE, CIRCE!\"", 3.0)
	await show_text("Circe: \"Because... because I have to try to help...\"", 3.5)
	await show_text("Scylla: \"IF YOU EVER CARED AT ALL... JUST... LET... ME... DIE!\"", 3.0)
	await show_text("Silence hangs heavy in the cave.", 2.5)
	await show_text("Circe: \"Let you die...\" (whisper)", 3.0)
	await show_text("The only mercy left is the hardest choice of all.", 3.5)
	fade_out(1.0)
	await get_tree().create_timer(1.0).timeout
	GameState.set_flag("binding_ward_failed", true)
	GameState.set_flag("quest_8_complete", true)
	GameState.set_flag("quest_9_active", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/locations/aiaia_shore.tscn")
