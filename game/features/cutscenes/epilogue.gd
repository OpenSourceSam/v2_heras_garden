extends CutsceneBase

## Epilogue Cutscene
## One week after Scylla's petrification
## Hermes visits with news about exile status
## Leads into final ending choice

func _ready() -> void:
	_play_sequence()

func _play_sequence() -> void:
	await get_tree().process_frame
	fade_in(1.5)
	await get_tree().create_timer(1.0).timeout
	await show_text("One week has passed.", 2.5)
	await show_text("The garden is peaceful. Pharmaka grow in neat rows.", 3.0)
	await show_text("Circe sits on the shore, watching the waves.", 3.0)
	await show_text("Hermes appears beside her.", 2.0)
	await show_text("Hermes: \"I have news from Olympus.\"", 2.5)
	await show_text("Circe looks up. \"Good news, I hope.\"", 2.5)
	await show_text("Hermes: \"Your exile... has been partially lifted.\"", 3.0)
	await show_text("Hermes: \"You are free to choose your path now.\"", 3.0)
	await show_text("Circe: \"I can leave Aiaia?\"", 2.5)
	await show_text("Hermes: \"Yes. Or stay. The choice is yours.\"", 3.0)
	await show_text("Hermes: \"You have paid for your mistakes, Circe.\"", 3.0)
	await show_text("Hermes: \"What you do now... that is up to you.\"", 3.0)
	await show_text("Hermes fades away. Circe is alone with her thoughts.", 3.5)
	await show_text("She could stay. Continue her work with pharmaka.", 3.5)
	await show_text("Help those who come seeking healing or wisdom.", 3.0)
	await show_text("Or she could leave. See what the world has become.", 3.5)
	await show_text("Aiaia has been her prison. Now it could be her home... or her past.", 4.0)
	fade_out(1.0)
	await get_tree().create_timer(1.0).timeout
	GameState.set_flag("epilogue_cutscene_seen", true)
	cutscene_finished.emit()

	# Trigger the ending choice dialogue
	var dialogue_manager = get_tree().get_first_node_in_group("dialogue_manager")
	if dialogue_manager and dialogue_manager.has_method("start_dialogue"):
		dialogue_manager.start_dialogue("epilogue_ending_choice")
