extends Node
## Lightweight F6 smoke test for autoloads and core scene wiring.

const WORLD_SCENE: PackedScene = preload("res://scenes/world.tscn")
var REQUIRED_AUTOLOADS: PackedStringArray = PackedStringArray([
	"GameState",
	"AudioController",
	"SaveController",
	"SceneManager",
])

func _ready() -> void:
	var failures: PackedStringArray = PackedStringArray()

	for name in REQUIRED_AUTOLOADS:
		if get_node_or_null("/root/" + name) == null:
			failures.append("Missing autoload: " + name)

	if WORLD_SCENE == null:
		failures.append("Failed to preload world scene.")
	else:
		var world_instance: Node = WORLD_SCENE.instantiate()
		add_child(world_instance)

		if world_instance.get_node_or_null("Player") == null:
			failures.append("World missing Player node.")

		if world_instance.get_node_or_null("Ground") == null:
			failures.append("World missing Ground TileMapLayer.")

	if failures.is_empty():
		print("[SmokeTest] OK")
		return

	for failure in failures:
		push_error("[SmokeTest] " + failure)
