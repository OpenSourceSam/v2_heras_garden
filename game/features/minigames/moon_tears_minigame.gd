extends Control

signal minigame_complete(success: bool, items: Array)

const TEAR_SCENE = preload("res://game/features/minigames/moon_tear_single.tscn")
const SPAWN_INTERVAL: float = 2.0
const FALL_SPEED: float = 100.0
const CATCH_WINDOW: float = 40.0

var tears_caught: int = 0
var tears_needed: int = 3
var player_x: float = 0.5
var spawn_timer: float = 0.0
var active_tears: Array[Node2D] = []

@onready var player_marker: ColorRect = $PlayerMarker
@onready var tear_container: Node2D = $TearContainer

func _ready() -> void:
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
	if not Input.is_action_just_pressed("ui_accept"):
		return

	for tear in active_tears.duplicate():
		var dist_x = abs(tear.position.x - player_marker.position.x)
		var dist_y = abs(tear.position.y - player_marker.position.y)
		if dist_x < CATCH_WINDOW and dist_y < CATCH_WINDOW:
			_catch_tear(tear)
			return

func _catch_tear(tear: Node2D) -> void:
	tears_caught += 1
	active_tears.erase(tear)
	AudioController.play_sfx("catch_chime")
	$TearParticles.global_position = tear.global_position
	$TearParticles.restart()
	tear.queue_free()
	$CaughtCounter.text = "Tears: %d/%d" % [tears_caught, tears_needed]

	if tears_caught >= tears_needed:
		minigame_complete.emit(true, ["moon_tear", "moon_tear", "moon_tear"])
