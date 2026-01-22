extends Node2D
## Shore location where Circe appears during Quest 3.

@onready var ui_layer: CanvasLayer = $UI
@onready var dialogue_box = $UI/DialogueBox
@onready var circe_spawn_point: Marker2D = $CirceSpawnPoint

func _ready() -> void:
	assert(ui_layer != null, "UI layer missing")
	assert(dialogue_box != null, "DialogueBox missing")
	assert(circe_spawn_point != null, "CirceSpawnPoint missing")

	# Check if Circe should appear
	if GameState.get_flag("quest_3_active") and not GameState.get_flag("quest_3_complete"):
		_spawn_circe_and_start_dialogue()

func _spawn_circe_and_start_dialogue() -> void:
	# Check if Circe NPC already exists (from NPCSpawner)
	var circe = get_node_or_null("NPCSpawner/Circe")
	if not circe:
		# If Circe isn't spawned yet, we'll let NPCSpawner handle it
		# The dialogue will be triggered when player interacts with Circe
		return

	# Position Circe at the spawn point
	circe.global_position = circe_spawn_point.global_position

	# Start the confrontation dialogue after a brief delay
	await get_tree().create_timer(1.0).timeout
	var dialogue_manager = get_tree().get_first_node_in_group("dialogue_manager")
	if dialogue_manager and dialogue_manager.has_method("start_dialogue"):
		dialogue_manager.start_dialogue("quest3_confrontation")
