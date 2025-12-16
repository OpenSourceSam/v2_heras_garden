extends GutTest
## Unit tests for Player movement and interaction
## Uses GutInputSender to simulate player input

var player: CharacterBody2D
var player_scene = preload("res://scenes/entities/player.tscn")
var _sender: GutInputSender

# ============================================
# SETUP / TEARDOWN
# ============================================

func before_each() -> void:
	player = player_scene.instantiate()
	add_child_autofree(player)
	player.global_position = Vector2(100, 100)
	_sender = GutInputSender.new(Input)
	add_child_autofree(_sender)

func after_each() -> void:
	_sender.release_all()
	_sender.clear()

# ============================================
# MOVEMENT TESTS
# ============================================

func test_player_exists() -> void:
	assert_not_null(player, "Player should exist")

func test_player_has_sprite() -> void:
	var sprite = player.get_node_or_null("Sprite")
	assert_not_null(sprite, "Player should have Sprite node")

func test_player_has_collision() -> void:
	var collision = player.get_node_or_null("Collision")
	assert_not_null(collision, "Player should have Collision node")

func test_player_has_camera() -> void:
	var camera = player.get_node_or_null("Camera")
	assert_not_null(camera, "Player should have Camera node")

func test_player_has_interaction_zone() -> void:
	var zone = player.get_node_or_null("InteractionZone")
	assert_not_null(zone, "Player should have InteractionZone")

func test_player_initial_velocity_zero() -> void:
	assert_eq(player.velocity, Vector2.ZERO, "Initial velocity should be zero")

func test_player_move_right() -> void:
	var start_pos = player.global_position
	_sender.action_down("ui_right")
	await _wait_for_frames(10)
	_sender.action_up("ui_right")
	assert_gt(player.global_position.x, start_pos.x, "Player should move right")

func test_player_move_left() -> void:
	var start_pos = player.global_position
	_sender.action_down("ui_left")
	await _wait_for_frames(10)
	_sender.action_up("ui_left")
	assert_lt(player.global_position.x, start_pos.x, "Player should move left")

func test_player_move_up() -> void:
	var start_pos = player.global_position
	_sender.action_down("ui_up")
	await _wait_for_frames(10)
	_sender.action_up("ui_up")
	assert_lt(player.global_position.y, start_pos.y, "Player should move up")

func test_player_move_down() -> void:
	var start_pos = player.global_position
	_sender.action_down("ui_down")
	await _wait_for_frames(10)
	_sender.action_up("ui_down")
	assert_gt(player.global_position.y, start_pos.y, "Player should move down")

# ============================================
# SPRITE FLIP TESTS
# ============================================

func test_sprite_flips_left() -> void:
	_sender.action_down("ui_left")
	await _wait_for_frames(5)
	_sender.action_up("ui_left")
	var sprite = player.get_node("Sprite") as Sprite2D
	assert_true(sprite.flip_h, "Sprite should flip when moving left")

func test_sprite_not_flipped_right() -> void:
	_sender.action_down("ui_right")
	await _wait_for_frames(5)
	_sender.action_up("ui_right")
	var sprite = player.get_node("Sprite") as Sprite2D
	assert_false(sprite.flip_h, "Sprite should not flip when moving right")

# ============================================
# INTERACTION TESTS
# ============================================

func test_interaction_signal_exists() -> void:
	assert_has_signal(player, "interacted_with")

func test_get_grid_position() -> void:
	player.global_position = Vector2(64, 96)
	var grid_pos = player.get_grid_position()
	assert_eq(grid_pos, Vector2i(2, 3), "Grid position should be (2, 3)")

func test_get_facing_tile() -> void:
	player.global_position = Vector2(64, 64)
	player.facing_direction = Vector2.RIGHT
	var facing = player.get_facing_tile()
	# Should be one tile to the right
	assert_eq(facing.x, 3, "Facing tile X should be 3")

# ============================================
# HELPER FUNCTIONS
# ============================================

func _wait_for_frames(count: int) -> void:
	for i in range(count):
		await get_tree().process_frame
