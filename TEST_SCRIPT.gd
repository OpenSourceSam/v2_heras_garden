extends SceneTree
## Quick validation script for Phase 0
## Run with: godot --headless --script TEST_SCRIPT.gd

func _init() -> void:
	print("=".repeat(60))
	print("CIRCE'S GARDEN - PHASE 0 VALIDATION")
	print("=".repeat(60))
	print("")

	var all_passed = true

	# Test 1: Autoloads exist
	print("[TEST 1] Checking autoloads...")
	var autoloads = ["GameState", "AudioController", "SaveController"]
	for autoload_name in autoloads:
		if root.has_node(autoload_name):
			print("  âœ… %s found" % autoload_name)
		else:
			print("  âŒ %s NOT FOUND" % autoload_name)
			all_passed = false

	print("")

	# Test 2: Resource classes
	print("[TEST 2] Checking resource classes...")
	var classes = ["CropData", "ItemData", "DialogueData", "NPCData"]
	for cls_name in classes:
		if ClassDB.class_exists(cls_name):
			print("  âœ… %s exists" % cls_name)
		else:
			print("  âŒ %s NOT FOUND" % cls_name)
			all_passed = false

	print("")

	# Test 3: Constants
	print("[TEST 3] Checking constants...")
	var game_state = root.get_node_or_null("GameState")
	if game_state and game_state.TILE_SIZE == 32:
		print("  âœ… TILE_SIZE = 32")
	else:
		print("  âŒ TILE_SIZE incorrect or missing")
		all_passed = false

	print("")

	# Test 4: Scene files exist
	print("[TEST 4] Checking scene files...")
	var scenes = [
		"res://game/features/ui/main_menu.tscn",
		"res://game/features/player/player.tscn",
		"res://game/features/farm_plot/farm_plot.tscn",
		"res://game/features/world/world.tscn"
	]
	for scene_path in scenes:
		if FileAccess.file_exists(scene_path):
			print("  âœ… %s exists" % scene_path)
		else:
			print("  âŒ %s NOT FOUND" % scene_path)
			all_passed = false

	print("")

	# Test 5: Documentation exists
	print("[TEST 5] Checking documentation...")
	var docs = [
		"res://CONTEXT.md",
		"res://docs/design/SCHEMA.md",
		"res://docs/execution/ROADMAP.md",
		"res://docs/design/Storyline.md"
	]
	for doc_path in docs:
		if FileAccess.file_exists(doc_path):
			print("  âœ… %s exists" % doc_path)
		else:
			print("  âŒ %s NOT FOUND" % doc_path)
			all_passed = false

	print("")
	print("=".repeat(60))

	if all_passed:
		print("âœ… PHASE 0 VALIDATION PASSED")
		print("Ready to begin Phase 1 implementation")
		quit(0)
	else:
		print("âŒ PHASE 0 VALIDATION FAILED")
		print("Fix errors before proceeding")
		quit(1)
