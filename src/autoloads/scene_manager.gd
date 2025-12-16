extends Node
## SceneManager - Handles scene transitions with fade effects
## See DEVELOPMENT_ROADMAP.md Task 1.2.2

# ============================================
# SIGNALS
# ============================================

signal scene_changing
signal scene_changed

# ============================================
# STATE
# ============================================

var current_scene: Node = null
var _fade_overlay: ColorRect = null
var _is_transitioning: bool = false

# ============================================
# INITIALIZATION
# ============================================

func _ready() -> void:
	print("[SceneManager] Initialized")
	_setup_fade_overlay()
	
	# Track the initial scene
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func _setup_fade_overlay() -> void:
	_fade_overlay = ColorRect.new()
	_fade_overlay.color = Color.BLACK
	_fade_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_overlay.modulate.a = 0.0 # Start transparent
	_fade_overlay.z_index = 100 # Above everything
	get_tree().root.add_child.call_deferred(_fade_overlay)

# ============================================
# SCENE MANAGEMENT
# ============================================

func change_scene(scene_path: String) -> void:
	if _is_transitioning:
		push_warning("[SceneManager] Already transitioning, ignoring")
		return
	
	_is_transitioning = true
	scene_changing.emit()
	print("[SceneManager] Changing scene to: %s" % scene_path)
	
	# Fade out
	await _fade_out()
	
	# Remove current scene
	if current_scene:
		current_scene.queue_free()
	
	# Load and add new scene
	var new_scene_resource = load(scene_path)
	if not new_scene_resource:
		push_error("[SceneManager] Failed to load scene: %s" % scene_path)
		_is_transitioning = false
		await _fade_in()
		return
	
	var new_scene = new_scene_resource.instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
	get_tree().current_scene = new_scene
	
	# Fade in
	await _fade_in()
	
	_is_transitioning = false
	scene_changed.emit()
	print("[SceneManager] Scene changed successfully")

func reload_current_scene() -> void:
	if current_scene and current_scene.scene_file_path:
		await change_scene(current_scene.scene_file_path)

# ============================================
# FADE EFFECTS
# ============================================

func _fade_out() -> void:
	if not _fade_overlay:
		await get_tree().create_timer(0.3).timeout
		return
	
	var tween = create_tween()
	tween.tween_property(_fade_overlay, "modulate:a", 1.0, 0.3)
	await tween.finished

func _fade_in() -> void:
	if not _fade_overlay:
		await get_tree().create_timer(0.3).timeout
		return
	
	var tween = create_tween()
	tween.tween_property(_fade_overlay, "modulate:a", 0.0, 0.3)
	await tween.finished

# ============================================
# UTILITY
# ============================================

func get_current_scene_path() -> String:
	if current_scene and current_scene.scene_file_path:
		return current_scene.scene_file_path
	return ""

func is_transitioning() -> bool:
	return _is_transitioning
