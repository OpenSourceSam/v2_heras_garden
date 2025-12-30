extends Node

@export var npc_scenes: Dictionary = {
	"hermes": preload("res://game/features/npcs/hermes.tscn"),
	"aeetes": preload("res://game/features/npcs/aeetes.tscn"),
	"daedalus": preload("res://game/features/npcs/daedalus.tscn")
}

var spawned_npcs: Dictionary = {}

func _ready() -> void:
	GameState.flag_changed.connect(_on_flag_changed)
	_update_npcs()

func _on_flag_changed(_flag: String, _value: bool) -> void:
	_update_npcs()

func _update_npcs() -> void:
	# Hermes: appears after prologue, before quest 3 complete
	_set_npc_visible("hermes",
		GameState.get_flag("prologue_complete") and
		not GameState.get_flag("quest_3_complete"))

	# Aeetes: appears during quest 6
	_set_npc_visible("aeetes",
		GameState.get_flag("quest_4_active") or
		GameState.get_flag("quest_5_active") or
		GameState.get_flag("quest_6_active"))

	# Daedalus: appears during quest 7
	_set_npc_visible("daedalus",
		GameState.get_flag("quest_7_active") or
		GameState.get_flag("quest_8_active"))

func _set_npc_visible(npc_id: String, visible: bool) -> void:
	if visible and npc_id not in spawned_npcs:
		_spawn_npc(npc_id)
	elif not visible and npc_id in spawned_npcs:
		_despawn_npc(npc_id)

func _spawn_npc(npc_id: String) -> void:
	var spawn_point = get_node_or_null("SpawnPoints/" + npc_id.capitalize())
	if spawn_point and npc_id in npc_scenes:
		var npc = npc_scenes[npc_id].instantiate()
		npc.global_position = spawn_point.global_position
		add_child(npc)
		spawned_npcs[npc_id] = npc

func _despawn_npc(npc_id: String) -> void:
	if npc_id in spawned_npcs:
		spawned_npcs[npc_id].queue_free()
		spawned_npcs.erase(npc_id)
