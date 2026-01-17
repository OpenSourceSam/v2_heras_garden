extends CutsceneBase

# Constants for character names
const CIRCE: String = "Circe"
const HELIOS: String = "Helios"

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
	GameState.set_flag("prologue_complete", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/world/world.tscn")
	queue_free()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.0)
	await get_tree().create_timer(1.2).timeout

	# Opening narration
	await show_text("Love can make monsters of us all.", 2.5)
	await show_text("But witchcraft... witchcraft makes them real.", 2.5)
	await get_tree().create_timer(1.0).timeout

	# Fade in: Helios's palace garden, golden hour
	await show_text("[Fade in: Helios's palace garden, golden hour]", 2.0)
	await get_tree().create_timer(0.5).timeout

	# Circe internal monologue
	await show_narrative("Circe: \"There he is. The god I made. The man I loved.\"", 3.0)
	await show_narrative("Circe: \"And there she is. Scylla. Beautiful, vain, cruel Scylla.\"", 3.0)
	await show_narrative("Circe: \"He chose her.\"", 2.5)

	# Scene action
	await show_narrative("[Glaucos kisses Scylla. Circe's hands clench into fists.]", 2.5)

	# More internal monologue
	await show_narrative("Circe: \"I gave him immortality. I made him divine.\"", 3.0)
	await show_narrative("Circe: \"And this is my reward? To watch him love someone else?\"", 3.5)

	# Helios appears
	await show_narrative("[Helios appears behind Circe, glowing golden.]", 2.0)

	# Dialogue: Helios
	await show_dialogue(HELIOS, "Circe. You're brooding again.", 2.5)

	# Dialogue: Circe
	await show_dialogue(CIRCE, "Father. I didn't hear you approach.", 2.0)

	# Dialogue: Helios
	await show_dialogue(HELIOS, "You've been standing here for an hour. Watching. Seething.", 3.5)
	await show_dialogue(HELIOS, "It's unbecoming of a goddess.", 2.5)

	# Dialogue: Circe
	await show_dialogue(CIRCE, "I'm not a goddess. You've made that clear.", 2.5)

	# Dialogue: Helios
	await show_dialogue(HELIOS, "Don't start. What do you want?", 2.0)

	# Dialogue: Circe
	await show_dialogue(CIRCE, "Permission to visit Aiaia. The island you mentioned. I need... solitude.", 4.0)

	# Dialogue: Helios
	await show_dialogue(HELIOS, "Aiaia? Why there?", 2.0)

	# Dialogue: Circe
	await show_dialogue(CIRCE, "To think. To be alone. Away from... this.", 3.0)

	# Dialogue: Helios
	await show_dialogue(HELIOS, "Very well. But don't cause trouble, Circe.", 3.0)
	await show_dialogue(HELIOS, "You're already an embarrassment to this family.", 3.5)

	# Helios vanishes
	await show_narrative("[Helios vanishes in golden light]", 2.0)

	# Final internal monologue
	await show_narrative("Circe: \"Trouble? No, Father.\"", 2.5)
	await show_narrative("Circe: \"I'm going to fix things.\"", 2.5)

	# Fade to Aiaia
	fade_out(1.5)
	await get_tree().create_timer(1.5).timeout
	await show_narrative("[Scene Transition: Aiaia Island - Daytime]", 2.0)

	# Complete prologue
	GameState.set_flag("prologue_complete", true)
	cutscene_finished.emit()
	SceneManager.change_scene("res://game/features/world/world.tscn")

# Helper function to show character dialogue with speaker name
func show_dialogue(speaker: String, text: String, duration: float = 3.0) -> void:
	var formatted_text = "[b]%s:[/b] %s" % [speaker, text]
	await show_text(formatted_text, duration)

# Helper function to show narration/description
func show_narrative(text: String, duration: float = 3.0) -> void:
	await show_text(text, duration)
