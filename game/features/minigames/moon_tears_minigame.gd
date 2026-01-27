extends Control

signal minigame_complete(success: bool, items: Array)

const TEAR_SCENE = preload("res://game/features/minigames/moon_tear_single.tscn")
const SPAWN_INTERVAL: float = 2.0  # seconds between spawns
const FALL_SPEED: float = 100.0  # pixels per second
const CATCH_WINDOW: float = 140.0  # pixels around marker center
const TEAR_CENTER_OFFSET: Vector2 = Vector2(5, 5)
const TEAR_SIZE: Vector2 = Vector2(10, 10)
const MARKER_SIZE: Vector2 = Vector2(320, 20)

var tears_caught: int = 0
var tears_needed: int = 3
var player_x: float = 0.5
var spawn_timer: float = 0.0
var active_tears: Array[Node2D] = []

@onready var player_marker: ColorRect = $PlayerMarker
@onready var tear_container: Node2D = $TearContainer

func _ready() -> void:
	assert(player_marker != null, "PlayerMarker missing")
	assert(tear_container != null, "TearContainer missing")
	player_marker.size = MARKER_SIZE
	player_marker.custom_minimum_size = MARKER_SIZE
	player_marker.position = Vector2(size.x * player_x, size.y - 50)

	# Play minigame music
	AudioController.play_music("minigame")

	_spawn_tear()

func _process(delta: float) -> void:
	_handle_movement()
	_update_tears(delta)
	_check_catches()

	spawn_timer += delta
	if spawn_timer >= SPAWN_INTERVAL:
		spawn_timer = 0.0
		_spawn_tear()

func _handle_movement() -> void:
	if Input.is_action_pressed("ui_left"):
		player_x = max(0.1, player_x - 0.02)
	if Input.is_action_pressed("ui_right"):
		player_x = min(0.9, player_x + 0.02)

	var target_x = size.x * player_x
	player_marker.position.x = lerp(player_marker.position.x, target_x, 0.2)
	player_marker.position.y = size.y - 50

func _spawn_tear() -> void:
	var tear = TEAR_SCENE.instantiate()
	tear.position.x = randf_range(size.x * 0.1, size.x * 0.9)
	tear.position.y = -20
	tear.modulate.a = 0.0
	tear_container.add_child(tear)
	active_tears.append(tear)

	var tween = create_tween()
	tween.tween_property(tear, "modulate:a", 1.0, 0.3)

func _update_tears(delta: float) -> void:
	for tear in active_tears.duplicate():
		tear.position.y += FALL_SPEED * delta
		if tear.position.y > size.y + 50:
			active_tears.erase(tear)
			tear.queue_free()

func _check_catches() -> void:
	var accept_pressed := Input.is_action_pressed("ui_accept") or Input.is_action_pressed("interact")
	if not accept_pressed:
		return

	for tear in active_tears.duplicate():
		var marker_rect = Rect2(player_marker.global_position, player_marker.size).grow(CATCH_WINDOW)
		var tear_rect = Rect2(tear.global_position, TEAR_SIZE)
		if marker_rect.intersects(tear_rect):
			_catch_tear(tear)
			return

func _catch_tear(tear: Node2D) -> void:
	tears_caught += 1
	active_tears.erase(tear)
	if AudioController.has_sfx("catch_chime"):
		AudioController.play_sfx("catch_chime")
	$TearParticles.global_position = tear.global_position
	$TearParticles.restart()
	tear.queue_free()
	$CaughtCounter.text = "Tears: %d/%d" % [tears_caught, tears_needed]

	if tears_caught >= tears_needed:
		var rewards = ["moon_tear", "moon_tear", "moon_tear"]
		_award_items(rewards)
		minigame_complete.emit(true, rewards)

func _award_items(items: Array) -> void:
	for item_id in items:
		# Add item with visual feedback
		GameState.collect_item_at_position(item_id, 1, player_marker.global_position)

		# Show pickup effect
		if Engine.get_main_loop().root.has_node("VisualFeedbackController"):
			var feedback = Engine.get_main_loop().root.get_node("VisualFeedbackController")
			if feedback.has_method("item_pickup_effect"):
				# Load item icon if available
				var item_path = "res://game/shared/resources/items/%s.tres" % item_id
				var item_data = load(item_path) as ItemData
				var item_texture = item_data.icon if item_data else null
				feedback.item_pickup_effect(player_marker.global_position, item_texture)

# Debug method for headless testing - completes minigame without input
func _debug_complete_minigame() -> void:
	if tears_caught >= tears_needed:
		return
	tears_caught = tears_needed
	var rewards = ["moon_tear", "moon_tear", "moon_tear"]
	_award_items(rewards)
	minigame_complete.emit(true, rewards)
