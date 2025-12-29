extends SceneTree
## Phase 3 helper: load key scenes headless and ensure they initialize without missing nodes.
## Run with: godot --headless --path . --script tests/phase3_scene_load_runner.gd

var failed: int = 0

func _init() -> void:
	call_deferred("_run")

func _fail(message: String) -> void:
	failed += 1
	push_error("[Phase3SceneLoad] " + message)

func _require_node(root: Node, path: NodePath, label: String) -> void:
	if root.get_node_or_null(path) == null:
		_fail("%s missing required node: %s" % [label, String(path)])

func _load_and_check(scene_path: String, required_nodes: Array[NodePath]) -> void:
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_fail("Failed to load scene: %s" % scene_path)
		return

	var instance := packed.instantiate()
	if instance == null:
		_fail("Failed to instantiate scene: %s" % scene_path)
		return

	root.add_child(instance)
	for i in 2:
		await process_frame

	for node_path in required_nodes:
		_require_node(instance, node_path, scene_path)

	instance.queue_free()
	await process_frame

func _load_only(scene_path: String) -> void:
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_fail("Failed to load scene: %s" % scene_path)
		return
	var instance := packed.instantiate()
	if instance == null:
		_fail("Failed to instantiate scene: %s" % scene_path)
		return
	instance.free()

func _run() -> void:
	print("=".repeat(60))
	print("PHASE 3 - SCENE LOAD SMOKE")
	print("=".repeat(60))

	await _load_and_check("res://game/features/ui/main_menu.tscn", [
		^"VBoxContainer/NewGameButton",
		^"VBoxContainer/SettingsButton",
		^"SettingsMenu",
	])

	await _load_and_check("res://game/features/world/world.tscn", [
		^"Ground",
		^"Player",
		^"UI/InventoryPanel",
		^"UI/SeedSelector",
	])

	await _load_and_check("res://game/features/ui/crafting_controller.tscn", [])
	await _load_and_check("res://game/features/ui/crafting_minigame.tscn", [
		^"MortarSprite",
		^"PatternDisplay",
		^"ProgressBar",
	])

	await _load_and_check("res://game/features/minigames/herb_identification.tscn", [])
	await _load_and_check("res://game/features/minigames/moon_tears.tscn", [
		^"PlayerMarker",
		^"CaughtCounter",
	])
	await _load_and_check("res://game/features/minigames/sacred_earth.tscn", [
		^"DiggingArea",
		^"ProgressBar",
	])
	await _load_and_check("res://game/features/minigames/weaving_minigame.tscn", [])

	# Cutscenes schedule SceneTreeTimers; load-only avoids false-positive leak warnings in headless runs.
	_load_only("res://game/features/cutscenes/prologue_opening.tscn")
	_load_only("res://game/features/cutscenes/scylla_transformation.tscn")

	await _load_and_check("res://game/features/locations/scylla_cove.tscn", [])
	await _load_and_check("res://game/features/locations/sacred_grove.tscn", [])

	await _load_and_check("res://game/features/npcs/aeetes.tscn", [])
	await _load_and_check("res://game/features/npcs/daedalus.tscn", [])
	await _load_and_check("res://game/features/npcs/hermes.tscn", [])
	await _load_and_check("res://game/features/npcs/scylla.tscn", [])

	print("")
	print("Failures: %d" % failed)
	if failed == 0:
		print("[Phase3SceneLoad] OK")
		quit(0)
	else:
		print("[Phase3SceneLoad] FAIL")
		quit(1)
