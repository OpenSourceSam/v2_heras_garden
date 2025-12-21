extends Control

signal minigame_complete(success: bool, items: Array)

var progress: float = 0.0
var time_remaining: float = 10.0
const PROGRESS_PER_PRESS: float = 0.05
const DECAY_RATE: float = 0.15
const SHAKE_AMOUNT: float = 3.0

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var timer_label: Label = $TimerLabel
@onready var dirt_particles: GPUParticles2D = $DirtParticles
@onready var digging_area: Sprite2D = $DiggingArea

var original_position: Vector2
var urgency_playing: bool = false

func _ready() -> void:
	original_position = position

func _process(delta: float) -> void:
	time_remaining -= delta
	progress = max(0, progress - DECAY_RATE * delta)

	_update_ui()
	_check_urgency()
	position = position.lerp(original_position, 0.2)

	if progress >= 1.0:
		_win()
	elif time_remaining <= 0:
		_lose()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_dig()

func _dig() -> void:
	progress = min(1.0, progress + PROGRESS_PER_PRESS)
	AudioController.play_sfx("dig_thud")
	_shake()
	dirt_particles.restart()
	digging_area.frame = int(progress * 4)

func _shake() -> void:
	position = original_position + Vector2(
		randf_range(-SHAKE_AMOUNT, SHAKE_AMOUNT),
		randf_range(-SHAKE_AMOUNT, SHAKE_AMOUNT)
	)

func _update_ui() -> void:
	progress_bar.value = progress * 100
	timer_label.text = "%.1f" % time_remaining
	$ProgressBar/ProgressGlow.visible = progress > 0.8
	timer_label.modulate = Color.RED if time_remaining < 3.0 else Color.WHITE

func _check_urgency() -> void:
	if time_remaining < 3.0 and not urgency_playing:
		urgency_playing = true
		AudioController.play_sfx("urgency_tick")

func _win() -> void:
	AudioController.play_sfx("success_fanfare")
	var rewards = ["sacred_earth", "sacred_earth", "sacred_earth"]
	_award_items(rewards)
	minigame_complete.emit(true, rewards)

func _lose() -> void:
	AudioController.play_sfx("failure_sad")
	minigame_complete.emit(false, [])

func _award_items(items: Array) -> void:
	for item_id in items:
		GameState.add_item(item_id, 1)
