extends Node2D
## Sacred Grove flow controller for Sacred Earth and Moon Tears minigames.

@onready var ui_layer: CanvasLayer = $UI

var _active_minigame: Control = null

func _ready() -> void:
	assert(ui_layer != null, "UI layer missing")
	_start_active_minigame()

func _start_active_minigame() -> void:
	if GameState.get_flag("quest_9_active") and not GameState.get_flag("quest_9_complete"):
		_launch_minigame("res://game/features/minigames/sacred_earth.tscn", _on_sacred_earth_complete)
		return
	if GameState.get_flag("quest_10_active") and not GameState.get_flag("quest_10_complete"):
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
		GameState.set_flag("quest_9_complete", true)
	_finish_minigame()

func _on_moon_tears_complete(success: bool, _items: Array) -> void:
	if success:
		GameState.set_flag("moon_tears_collected", true)
	_finish_minigame()

func _finish_minigame() -> void:
	if _active_minigame:
		_active_minigame.queue_free()
		_active_minigame = null
	SceneManager.change_scene(Constants.SCENE_WORLD)
