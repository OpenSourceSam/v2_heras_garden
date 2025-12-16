extends NPCBase
## Hermes - Messenger god, delivers news and quest updates
## See Storyline.md for dialogue

func _ready() -> void:
	npc_id = "hermes"
	display_name = "Hermes"
	dialogue_id = "act1_hermes_warning"
	super._ready()

func play_appear() -> void:
	"""Hermes appears in a flash of golden light."""
	visible = true
	# TODO: Add particle effect or flash animation
	print("[Hermes] Appeared in flash of light")

func on_dialogue_complete() -> void:
	"""Called when Hermes finishes talking - he disappears."""
	print("[Hermes] Dialogue complete, vanishing...")
	# TODO: Add vanish animation
	hide_npc()
