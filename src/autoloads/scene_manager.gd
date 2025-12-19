extends Node
## Scene Manager - Handles scene transitions with fade effects
## See docs/execution/ROADMAP.md Task 1.2.2 for implementation details

# ============================================
# SIGNALS
# ============================================
signal scene_changing
signal scene_changed(new_scene_path: String)

# ============================================
# STATE
# ============================================
var current_scene: Node = null
var is_transitioning: bool = false

# ============================================
# NODE REFERENCES
# ============================================
# TODO (Task 1.2.2): Add fade overlay
# var fade_overlay: ColorRect = null

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO (Task 1.2.2): Create fade overlay
	# - Create ColorRect covering full screen
	# - Set color to black with alpha 0
	# - Add to scene tree
	# - Set as top-level (z-index high)

	# Get current scene (main_menu at startup)
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print("[SceneManager] Initialized with scene: %s" % current_scene.name)

# ============================================
# SCENE TRANSITIONS
# ============================================

func change_scene(scene_path: String) -> void:
	# TODO (Task 1.2.2): Implement scene transition
	# - Check if already transitioning (return if so)
	# - Set is_transitioning = true
	# - Emit scene_changing signal
	# - Call _fade_out() and await
	# - Unload current_scene
	# - Load new scene
	# - Add new scene to tree
	# - Call _fade_in() and await
	# - Set is_transitioning = false
	# - Emit scene_changed signal

	# Temporary stub: just load scene directly
	call_deferred("_change_scene_immediate", scene_path)

func _change_scene_immediate(scene_path: String) -> void:
	# Temporary implementation without fade
	if current_scene:
		current_scene.queue_free()

	var new_scene_resource = load(scene_path)
	if new_scene_resource:
		current_scene = new_scene_resource.instantiate()
		get_tree().root.add_child(current_scene)
		get_tree().current_scene = current_scene
		scene_changed.emit(scene_path)
		print("[SceneManager] Changed to scene: %s" % scene_path)
	else:
		push_error("[SceneManager] Failed to load scene: %s" % scene_path)

# ============================================
# FADE EFFECTS
# ============================================

func _fade_out() -> void:
	# TODO (Task 1.2.2): Fade to black
	# - Tween fade_overlay alpha from 0 to 1
	# - Duration: 0.3 seconds
	# - await tween.finished
	await get_tree().create_timer(0.3).timeout  # Temporary

func _fade_in() -> void:
	# TODO (Task 1.2.2): Fade from black
	# - Tween fade_overlay alpha from 1 to 0
	# - Duration: 0.3 seconds
	# - await tween.finished
	await get_tree().create_timer(0.3).timeout  # Temporary

# ============================================
# UTILITY
# ============================================

func get_current_scene_path() -> String:
	if current_scene and current_scene.scene_file_path:
		return current_scene.scene_file_path
	return ""

func reload_current_scene() -> void:
	# TODO: Reload current scene (useful for testing)
	var current_path = get_current_scene_path()
	if current_path:
		change_scene(current_path)
