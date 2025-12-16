extends GutTest
## Unit tests for NPC base class

const NPCBaseScript = preload("res://src/entities/npc_base.gd")
var npc: CharacterBody2D

func before_each() -> void:
	npc = NPCBaseScript.new()
	npc.npc_id = "test_npc"
	npc.display_name = "Test NPC"
	npc.dialogue_id = "test_dialogue"
	add_child_autofree(npc)

# ============================================
# INITIALIZATION TESTS
# ============================================

func test_npc_exists() -> void:
	assert_not_null(npc)

func test_npc_in_group() -> void:
	# Need to call _ready manually since we created with new()
	npc._ready()
	assert_true(npc.is_in_group("npcs"))

func test_npc_in_interactables_group() -> void:
	npc._ready()
	assert_true(npc.is_in_group("interactables"))

# ============================================
# PROPERTY TESTS
# ============================================

func test_npc_id_set() -> void:
	assert_eq(npc.npc_id, "test_npc")

func test_display_name_set() -> void:
	assert_eq(npc.display_name, "Test NPC")

func test_dialogue_id_set() -> void:
	assert_eq(npc.dialogue_id, "test_dialogue")

# ============================================
# DIALOGUE TESTS
# ============================================

func test_set_dialogue_changes_id() -> void:
	npc.set_dialogue("new_dialogue")
	assert_eq(npc.dialogue_id, "new_dialogue")

# ============================================
# VISIBILITY TESTS
# ============================================

func test_show_npc() -> void:
	npc.hide_npc()
	npc.show_npc()
	assert_true(npc.visible)
	assert_true(npc.is_interactable)

func test_hide_npc() -> void:
	npc.hide_npc()
	assert_false(npc.visible)
	assert_false(npc.is_interactable)

func test_is_interactable_default() -> void:
	assert_true(npc.is_interactable)
