extends CharacterBody2D
class_name NPCBase
## Base class for all NPCs
## See Storyline.md for NPC specifications

# ============================================
# EXPORTS
# ============================================

@export var npc_id: String = ""
@export var display_name: String = ""
@export var dialogue_id: String = ""

# ============================================
# NODE REFERENCES
# ============================================

@onready var sprite: Sprite2D = $Sprite
@onready var collision: CollisionShape2D = $Collision

# ============================================
# STATE
# ============================================

var is_interactable: bool = true

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	add_to_group("npcs")
	add_to_group("interactables")
	print("[NPC:%s] Ready" % npc_id)

# ============================================
# INTERACTION
# ============================================

func interact() -> void:
	if not is_interactable:
		print("[NPC:%s] Not interactable" % npc_id)
		return
	
	print("[NPC:%s] Interacted - Starting dialogue: %s" % [npc_id, dialogue_id])
	
	# Get dialogue UI from scene tree
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue(dialogue_id)
	else:
		# Try finding via world's CanvasLayer
		var world = get_tree().current_scene
		if world and world.has_node("CanvasLayer/DialogueBox"):
			var dlg = world.get_node("CanvasLayer/DialogueBox")
			if dlg.has_method("start_dialogue"):
				dlg.start_dialogue(dialogue_id)
		else:
			push_warning("[NPC:%s] Could not find DialogueBox" % npc_id)

func set_dialogue(new_dialogue_id: String) -> void:
	"""Change the NPC's current dialogue."""
	dialogue_id = new_dialogue_id
	print("[NPC:%s] Dialogue changed to: %s" % [npc_id, new_dialogue_id])

func show_npc() -> void:
	visible = true
	is_interactable = true

func hide_npc() -> void:
	visible = false
	is_interactable = false

# ============================================
# ANIMATION (Override in subclasses)
# ============================================

func play_idle() -> void:
	pass

func play_talk() -> void:
	pass

func play_appear() -> void:
	"""Override for dramatic entrance animations."""
	visible = true
