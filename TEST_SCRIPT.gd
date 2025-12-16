extends SceneTree
## Quick validation script for Phase 0
## Run with: godot --headless --script TEST_SCRIPT.gd

func _init() -> void:
	print("=" * 60)
	print("CIRCE'S GARDEN - PHASE 0 VALIDATION")
	print("=" * 60)
	print("")

	var all_passed = true

	# Test 1: Autoloads exist
	print("[TEST 1] Checking autoloads...")
	var autoloads = ["GameState", "AudioController", "SaveController"]
	for autoload in autoloads:
		if has_node("/root/" + autoload):
			print("  ✅ %s found" % autoload)
		else:
			print("  ❌ %s NOT FOUND" % autoload)
			all_passed = false

	print("")

	# Test 2: Resource classes
	print("[TEST 2] Checking resource classes...")
	var classes = ["CropData", "ItemData", "DialogueData", "NPCData"]
	for class_name in classes:
		if ClassDB.class_exists(class_name):
			print("  ✅ %s exists" % class_name)
		else:
			print("  ❌ %s NOT FOUND" % class_name)
			all_passed = false

	print("")

	# Test 3: Constants
	print("[TEST 3] Checking constants...")
	var game_state = get_node_or_null("/root/GameState")
	if game_state and game_state.TILE_SIZE == 32:
		print("  ✅ TILE_SIZE = 32")
	else:
		print("  ❌ TILE_SIZE incorrect or missing")
		all_passed = false

	print("")

	# Test 4: Scene files exist
	print("[TEST 4] Checking scene files...")
	var scenes = [
		"res://scenes/ui/main_menu.tscn",
		"res://scenes/entities/player.tscn",
		"res://scenes/entities/farm_plot.tscn",
		"res://scenes/world.tscn"
	]
	for scene_path in scenes:
		if FileAccess.file_exists(scene_path):
			print("  ✅ %s exists" % scene_path)
		else:
			print("  ❌ %s NOT FOUND" % scene_path)
			all_passed = false

	print("")

	# Test 5: Documentation exists
	print("[TEST 5] Checking documentation...")
	var docs = [
		"res://CONSTITUTION.md",
		"res://SCHEMA.md",
		"res://DEVELOPMENT_ROADMAP.md",
		"res://PROJECT_SUMMARY.md",
		"res://Storyline.md"
	]
	for doc_path in docs:
		if FileAccess.file_exists(doc_path):
			print("  ✅ %s exists" % doc_path)
		else:
			print("  ❌ %s NOT FOUND" % doc_path)
			all_passed = false

	print("")
	print("=" * 60)

	if all_passed:
		print("✅ PHASE 0 VALIDATION PASSED")
		print("Ready to begin Phase 1 implementation")
		quit(0)
	else:
		print("❌ PHASE 0 VALIDATION FAILED")
		print("Fix errors before proceeding")
		quit(1)
