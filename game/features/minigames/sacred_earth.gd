extends Control

signal minigame_complete(success: bool, items: Array)

var progress: float = 0.0
var time_remaining: float = 10.0  # seconds
const PROGRESS_PER_PRESS: float = 0.05  # progress per button press
const DECAY_RATE: float = 0.15  # progress decay per second
const SHAKE_AMOUNT: float = 3.0  # pixels of shake offset

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var timer_label: Label = $TimerLabel
@onready var dirt_particles: GPUParticles2D = $DirtParticles
@onready var digging_area: Sprite2D = $DiggingArea

var original_position: Vector2
var urgency_playing: bool = false
var is_complete: bool = false

func _ready() -> void:
	assert(progress_bar != null, "ProgressBar missing")
	assert(timer_label != null, "TimerLabel missing")
	assert(dirt_particles != null, "DirtParticles missing")
	assert(digging_area != null, "DiggingArea missing")
	original_position = position

	# Play minigame music
	AudioController.play_music("minigame")

func _process(delta: float) -> void:
	if is_complete:
		return
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
	if AudioController.has_sfx("dig_thud"):
		AudioController.play_sfx("dig_thud")
	_shake()
	dirt_particles.restart()
	var max_frame = max(0, digging_area.hframes * digging_area.vframes - 1)
	digging_area.frame = clampi(int(progress * 4), 0, max_frame)

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
		if AudioController.has_sfx("urgency_tick"):
			AudioController.play_sfx("urgency_tick")

func _win() -> void:
	if is_complete:
		return
	is_complete = true
	if AudioController.has_sfx("success_fanfare"):
		AudioController.play_sfx("success_fanfare")
	var rewards = ["sacred_earth", "sacred_earth", "sacred_earth"]
	_award_items(rewards)
	minigame_complete.emit(true, rewards)

func _lose() -> void:
	if is_complete:
		return
	is_complete = true
	if AudioController.has_sfx("failure_sad"):
		AudioController.play_sfx("failure_sad")
	minigame_complete.emit(false, [])

func _award_items(items: Array) -> void:
	for item_id in items:
		GameState.add_item(item_id, 1)

# Debug method for headless testing - completes minigame without input
func _debug_complete_minigame() -> void:
	if is_complete:
		return
	progress = 1.0
	_win()
