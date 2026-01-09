extends CharacterBody2D
class_name NPCBase

@export var npc_id: String = ""
@export var dialogue_id: String = ""
@export var portrait: Texture2D = null
@export var wander_enabled: bool = true
@export var wander_radius: float = 32.0
@export var wander_speed: float = 22.0
@export var idle_time_min: float = 0.6
@export var idle_time_max: float = 1.6

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var interaction_zone: Area2D = $InteractionZone
@onready var talk_indicator: Sprite2D = $TalkIndicator

var _home_position: Vector2
var _wander_target: Vector2
var _idle_time_left: float = 0.0
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	assert(sprite != null, "NPC Sprite node missing")
	assert(interaction_zone != null, "NPC InteractionZone missing")
	assert(talk_indicator != null, "NPC TalkIndicator missing")
	talk_indicator.visible = false
	_rng.randomize()
	_home_position = global_position
	_pick_new_wander_target()
	if not interaction_zone.body_entered.is_connected(_on_interaction_zone_body_entered):
		interaction_zone.body_entered.connect(_on_interaction_zone_body_entered)
	if not interaction_zone.body_exited.is_connected(_on_interaction_zone_body_exited):
		interaction_zone.body_exited.connect(_on_interaction_zone_body_exited)
	call_deferred("_refresh_talk_indicator")
	call_deferred("_load_npc_sprite")

func _load_npc_sprite() -> void:
	if npc_id == "":
		return

	var sprite_frames_path := ""
	match npc_id:
		"hermes":
			sprite_frames_path = "res://game/shared/resources/npcs/hermes_frames.tres"
		"aeetes":
			sprite_frames_path = "res://game/shared/resources/npcs/aeetes_frames.tres"
		"daedalus":
			sprite_frames_path = "res://game/shared/resources/npcs/daedalus_frames.tres"
		"scylla":
			sprite_frames_path = "res://game/shared/resources/npcs/scylla_frames.tres"
		"circe":
			sprite_frames_path = "res://game/shared/resources/npcs/circe_frames.tres"
		_:
			return

	var frames = load(sprite_frames_path) as SpriteFrames
	if frames:
		sprite.sprite_frames = frames
		sprite.play("idle")
	# Talk indicator uses a dedicated icon texture set in the scene

func _physics_process(_delta: float) -> void:
	if not wander_enabled:
		velocity = Vector2.ZERO
		return

	if _idle_time_left > 0.0:
		_idle_time_left -= _delta
		velocity = Vector2.ZERO
		return

	var to_target = _wander_target - global_position
	if to_target.length() <= 2.0:
		_idle_time_left = _rng.randf_range(idle_time_min, idle_time_max)
		_pick_new_wander_target()
		velocity = Vector2.ZERO
		return

	velocity = to_target.normalized() * wander_speed
	move_and_slide()
	set_facing(velocity)

func interact() -> void:
	var resolved_dialogue_id = _resolve_dialogue_id()
	if resolved_dialogue_id == "":
		return
	var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_box and dialogue_box.has_method("start_dialogue"):
		dialogue_box.start_dialogue(resolved_dialogue_id)

func set_facing(direction: Vector2) -> void:
	if direction.x != 0:
		sprite.flip_h = direction.x < 0

func _dialogue_exists(dialogue_id: String) -> bool:
	if dialogue_id == "":
		return false
	var dialogue_path := "res://game/shared/resources/dialogues/%s.tres" % dialogue_id
	return ResourceLoader.exists(dialogue_path)

func _pick_new_wander_target() -> void:
	if wander_radius <= 0.0:
		_wander_target = _home_position
		return
	_wander_target = _home_position + Vector2(
		_rng.randf_range(-wander_radius, wander_radius),
		_rng.randf_range(-wander_radius, wander_radius)
	)

func _refresh_talk_indicator() -> void:
	for body in interaction_zone.get_overlapping_bodies():
		if body.is_in_group("player"):
			talk_indicator.visible = true
			return
	talk_indicator.visible = false

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		talk_indicator.visible = true

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		talk_indicator.visible = false

func _resolve_dialogue_id() -> String:
	match npc_id:
		"hermes":
			return _resolve_hermes_dialogue()
		"aeetes":
			return _resolve_aeetes_dialogue()
		"daedalus":
			return _resolve_daedalus_dialogue()
		"scylla":
			return _resolve_scylla_dialogue()
		_:
			return dialogue_id

func _resolve_hermes_dialogue() -> String:
	if not GameState.get_flag("met_hermes"):
		return "hermes_intro"
	if GameState.get_flag("prologue_complete") and not GameState.get_flag("quest_1_active"):
		return "quest1_start"
	if GameState.get_flag("quest_1_active") and not GameState.get_flag("quest_1_complete"):
		return "quest1_inprogress"
	if GameState.get_flag("quest_1_complete") and not GameState.get_flag("quest_1_complete_dialogue_seen"):
		return "quest1_complete"
	# Quest 2: Extract the Sap - Hermes warning, then player returns to house
	if GameState.get_flag("quest_1_complete") and not GameState.get_flag("quest_2_active"):
		return "quest2_start"
	if GameState.get_flag("quest_2_active") and not GameState.get_flag("quest_2_complete"):
		return "act1_extract_sap"
	if GameState.get_flag("quest_2_complete") and not GameState.get_flag("quest_3_active"):
		return "quest3_start"
	return "hermes_idle"

func _resolve_aeetes_dialogue() -> String:
	if _dialogue_exists("aeetes_intro") and not GameState.get_flag("met_aeetes"):
		return "aeetes_intro"
	if GameState.get_flag("quest_3_complete") and not GameState.get_flag("quest_4_active"):
		return "quest4_start"
	if GameState.get_flag("quest_4_active") and not GameState.get_flag("quest_4_complete"):
		if _dialogue_exists("quest4_inprogress"):
			return "quest4_inprogress"
		return "act2_farming_tutorial"
	if GameState.get_flag("quest_4_complete") and not GameState.get_flag("quest_5_active"):
		if _dialogue_exists("quest4_complete") and not GameState.get_flag("quest_4_complete_dialogue_seen"):
			return "quest4_complete"
		return "quest5_start"
	if GameState.get_flag("quest_5_active") and not GameState.get_flag("quest_5_complete"):
		if _dialogue_exists("quest5_inprogress"):
			return "quest5_inprogress"
		return "act2_calming_draught"
	if GameState.get_flag("quest_5_complete") and not GameState.get_flag("quest_6_active"):
		if _dialogue_exists("quest5_complete") and not GameState.get_flag("quest_5_complete_dialogue_seen"):
			return "quest5_complete"
		return "quest6_start"
	if GameState.get_flag("quest_6_active") and not GameState.get_flag("quest_6_complete"):
		if _dialogue_exists("quest6_inprogress"):
			return "quest6_inprogress"
		return "act2_reversal_elixir"
	if _dialogue_exists("aeetes_idle"):
		return "aeetes_idle"
	return dialogue_id

func _resolve_daedalus_dialogue() -> String:
	if _dialogue_exists("daedalus_intro") and not GameState.get_flag("met_daedalus"):
		return "daedalus_intro"
	if GameState.get_flag("quest_6_complete") and not GameState.get_flag("quest_7_active"):
		return "quest7_start"
	if GameState.get_flag("quest_7_active") and not GameState.get_flag("quest_7_complete"):
		if _dialogue_exists("quest7_inprogress"):
			return "quest7_inprogress"
		return "act2_daedalus_arrives"
	if GameState.get_flag("quest_7_complete") and not GameState.get_flag("quest_8_active"):
		if _dialogue_exists("quest7_complete") and not GameState.get_flag("quest_7_complete_dialogue_seen"):
			return "quest7_complete"
		return "quest8_start"
	if GameState.get_flag("quest_8_active") and not GameState.get_flag("quest_8_complete"):
		if _dialogue_exists("quest8_inprogress"):
			return "quest8_inprogress"
		return "act2_binding_ward"
	if _dialogue_exists("daedalus_idle"):
		return "daedalus_idle"
	return dialogue_id

func _resolve_scylla_dialogue() -> String:
	if _dialogue_exists("scylla_intro") and not GameState.get_flag("met_scylla"):
		return "scylla_intro"
	if GameState.get_flag("quest_8_complete") and not GameState.get_flag("quest_9_active"):
		return "quest9_start"
	if GameState.get_flag("quest_9_active") and not GameState.get_flag("quest_9_complete"):
		if _dialogue_exists("quest9_inprogress"):
			return "quest9_inprogress"
		return "act3_sacred_earth"
	if GameState.get_flag("quest_9_complete") and not GameState.get_flag("quest_10_active"):
		if _dialogue_exists("quest9_complete") and not GameState.get_flag("quest_9_complete_dialogue_seen"):
			return "quest9_complete"
		return "quest10_start"
	if GameState.get_flag("quest_10_active") and not GameState.get_flag("quest_10_complete"):
		if _dialogue_exists("quest10_inprogress"):
			return "quest10_inprogress"
		return "act3_moon_tears"
	if GameState.get_flag("quest_10_complete") and not GameState.get_flag("quest_11_active"):
		if _dialogue_exists("quest10_complete") and not GameState.get_flag("quest_10_complete_dialogue_seen"):
			return "quest10_complete"
		return "quest11_start"
	if GameState.get_flag("quest_11_active") and not GameState.get_flag("quest_11_complete"):
		if _dialogue_exists("quest11_inprogress"):
			return "quest11_inprogress"
		return "act3_final_confrontation"
	if _dialogue_exists("scylla_idle"):
		return "scylla_idle"
	return dialogue_id
