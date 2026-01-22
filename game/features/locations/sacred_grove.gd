extends Node2D
## Sacred Grove flow controller for Sacred Earth and Moon Tears minigames.
## Enhanced with nighttime atmosphere for Quest 9 (Moon Tears)

@onready var ui_layer: CanvasLayer = $UI
@onready var sky: ColorRect = $Sky
@onready var moon: ColorRect = $Moon
@onready var stars: Node2D = $Stars

var _active_minigame: Control = null

func _ready() -> void:
	assert(ui_layer != null, "UI layer missing")
	_apply_time_of_day_atmosphere()
	_start_active_minigame()

func _apply_time_of_day_atmosphere() -> void:
	# Check if we're in Quest 9 (Moon Tears) - this is a night scene
	if GameState.get_flag("quest_9_active") and not GameState.get_flag("quest_9_complete"):
		# Nighttime atmosphere for Moon Tears collection
		if sky:
			sky.color = Color(0.05, 0.05, 0.15, 1)  # Deep night blue
		if moon:
			moon.visible = true
		if stars:
			stars.visible = true
	else:
		# Daytime atmosphere for Sacred Earth (Quest 8)
		if sky:
			sky.color = Color(0.5, 0.7, 0.9, 1)  # Day sky blue
		if moon:
			moon.visible = false
		if stars:
			stars.visible = false

func _start_active_minigame() -> void:
	if GameState.get_flag("quest_8_active") and not GameState.get_flag("quest_8_complete"):
		_launch_minigame("res://game/features/minigames/sacred_earth.tscn", _on_sacred_earth_complete)
		return
	if GameState.get_flag("quest_9_active") and not GameState.get_flag("quest_9_complete"):
		_launch_minigame("res://game/features/minigames/moon_tears_minigame.tscn", _on_moon_tears_complete)
		return

func _launch_minigame(scene_path: String, callback: Callable) -> void:
	if _active_minigame:
		return
	var minigame_scene = load(scene_path)
	if not minigame_scene:
		push_error("Failed to load minigame: %s" % scene_path)
		return
	var minigame = minigame_scene.instantiate()
	ui_layer.add_child(minigame)
	_active_minigame = minigame
	if minigame.has_signal("minigame_complete"):
		minigame.minigame_complete.connect(callback)

func _on_sacred_earth_complete(success: bool, _items: Array) -> void:
	if success:
		pass
	_finish_minigame()

func _on_moon_tears_complete(success: bool, _items: Array) -> void:
	if success:
		GameState.set_flag("quest_9_complete", true)
		GameState.set_flag("moon_tears_collected", true)
	_finish_minigame()

func _finish_minigame() -> void:
	if _active_minigame:
		_active_minigame.queue_free()
		_active_minigame = null
	SceneManager.change_scene(Constants.SCENE_WORLD)
