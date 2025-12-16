extends Node2D
## Pharmaka Field - Location for Act 1 Quest 1
## Player finds Hermes here and plays herb identification minigame

# ============================================
# NODE REFERENCES
# ============================================

@onready var hermes: NPCBase = $Entities/Hermes
@onready var pharmaka_trigger: Area2D = $Entities/PharmakaTrigger
@onready var herb_minigame: Control = $CanvasLayer/HerbMinigame
@onready var dialogue_box: Control = $CanvasLayer/DialogueBox
@onready var player: CharacterBody2D = $Entities/Player

# ============================================
# STATE
# ============================================

var hermes_introduced: bool = false
var minigame_started: bool = false

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	print("[PharmakaField] Scene loaded")
	
	# Connect signals
	if pharmaka_trigger:
		pharmaka_trigger.body_entered.connect(_on_trigger_entered)
		# Add collision shape
		var shape = CircleShape2D.new()
		shape.radius = 48
		var collision = pharmaka_trigger.get_node("CollisionShape2D")
		if collision:
			collision.shape = shape
	
	if herb_minigame:
		herb_minigame.minigame_complete.connect(_on_minigame_complete)
	
	if dialogue_box:
		dialogue_box.dialogue_ended.connect(_on_dialogue_ended)
	
	# Check if player has already met Hermes
	if GameState.get_flag("met_hermes"):
		hermes_introduced = true
		hermes.dialogue_id = "act1_hermes_warning"

func _on_trigger_entered(body: Node2D) -> void:
	if body == player and not minigame_started:
		print("[PharmakaField] Player entered pharmaka trigger")
		
		# If haven't met Hermes yet, introduce him first
		if not hermes_introduced:
			_introduce_hermes()
		else:
			_start_herb_minigame()

func _introduce_hermes() -> void:
	print("[PharmakaField] Introducing Hermes")
	hermes_introduced = true
	
	# Hermes appears dramatically
	hermes.play_appear()
	
	# Brief pause then show dialogue
	await get_tree().create_timer(0.5).timeout
	hermes.interact()

func _on_dialogue_ended(dialogue_id: String) -> void:
	print("[PharmakaField] Dialogue ended: %s" % dialogue_id)
	
	# If this was Hermes intro, start minigame after
	if dialogue_id == "d_act1_hermes_intro" or dialogue_id.begins_with("d_act1_hermes_intro_"):
		await get_tree().create_timer(1.0).timeout
		_start_herb_minigame()

func _start_herb_minigame() -> void:
	if minigame_started:
		return
	
	print("[PharmakaField] Starting herb identification minigame")
	minigame_started = true
	
	# Disable player movement during minigame
	if player:
		player.set_physics_process(false)
	
	herb_minigame.start_minigame()

func _on_minigame_complete(success: bool, pharmaka_collected: int) -> void:
	print("[PharmakaField] Minigame complete: success=%s, collected=%d" % [success, pharmaka_collected])
	
	# Re-enable player movement
	if player:
		player.set_physics_process(true)
	
	if success:
		# Mark quest as complete
		GameState.set_flag("quest_pharmaka_complete", true)
		
		# Hermes comments on success
		await get_tree().create_timer(1.0).timeout
		dialogue_box.start_dialogue("act1_hermes_warning")
	else:
		# Allow retry
		minigame_started = false
