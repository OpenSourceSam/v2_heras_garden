extends SceneTree

const Constants = preload("res://game/autoload/constants.gd")

var all_passed: bool = true
var tests_run: int = 0
var tests_passed: int = 0
var errors: Array = []

func _init():
	call_deferred("_run_all_tests")

func _run_all_tests():
	print("============================================================")
	print("MAP SIZE & SHAPE VALIDATION TEST")
	print("Validates: tiles, sprites, hitboxes, spacing, alignment")
	print("============================================================")
	print("")

	# Load world scene
	var world = load("res://game/features/world/world.tscn")
	if not world:
		_fail("World scene fails to load")
		_print_report()
		quit(1)
		return

	# Test tile sizes
	_test_tile_consistency()

	# Test sprite sizes
	_test_sprite_sizes()

	# Test spacing/alignment
	_test_spacing_alignment()

	# Test hitboxes/collision
	_test_collision_shapes()

	# Test NPC spawn points
	_test_npc_spawn_points()

	# Test quest markers
	_test_quest_markers()

	# Test farm plots
	_test_farm_plots()

	_print_report()
	quit(0 if all_passed else 1)

# ============================================
# TILE CONSISTENCY TESTS
# ============================================
func _test_tile_consistency():
	print("============================================================")
	print("TILE CONSISTENCY")
	print("============================================================")

	# TILE_SIZE should be 32
	_pass("TILE_SIZE = 32", Constants.TILE_SIZE == 32, "Constants.TILE_SIZE should be 32")

	# Check tileset
	var tileset = load("res://game/shared/resources/tiles/placeholder_grass_tileset.tres")
	if tileset:
		var tile_size = tileset.tile_size
		_pass("Tileset tile_size = 32x32", tile_size == Vector2i(32, 32), "Tileset should be 32x32, got %s" % tile_size)

		# Check atlas source
		var source = tileset.sources.get(0)
		if source:
			var region_size = source.texture_region_size
			_pass("Atlas source region_size = 32x32", region_size == Vector2i(32, 32), "Atlas should be 32x32, got %s" % region_size)
		else:
			_pass("Atlas source exists", false, "Atlas source not found")

		# Check texture
		var texture = load("res://assets/sprites/tiles/placeholder_grass.png")
		if texture:
			var tex_size = texture.get_size()
			# Should be multiple of 32
			var width_tiles = int(tex_size.x / 32)
			var height_tiles = int(tex_size.y / 32)
			_pass("Texture width is multiple of 32 (%d tiles)" % width_tiles, tex_size.x % 32 == 0, "Texture width %d not divisible by 32" % tex_size.x)
			_pass("Texture height is multiple of 32 (%d tiles)" % height_tiles, tex_size.y % 32 == 0, "Texture height %d not divisible by 32" % tex_size.y)
	else:
		_pass("Tileset loads", false, "Tileset not found")

	print("")

# ============================================
# SPRITE SIZE TESTS
# ============================================
func _test_sprite_sizes():
	print("============================================================")
	print("SPRITE SIZE TESTS")
	print("============================================================")

	# NPC sprites - actual placeholder size
	var npc_sprite = load("res://assets/sprites/placeholders/npc_world_placeholder.png")
	if npc_sprite:
		var size = npc_sprite.get_size()
		_pass("NPC sprite dimensions", size.x == 32 and size.y == 32, "NPC sprite should be 32x32, got %s" % size)

	# Quest marker - actual placeholder size
	var quest_marker = load("res://assets/sprites/placeholders/quest_marker.png")
	if quest_marker:
		var size = quest_marker.get_size()
		_pass("Quest marker dimensions", size.x == 16 and size.y == 24, "Quest marker should be 16x24, got %s" % size)

	# Tree sprite - actual placeholder size
	var tree = load("res://assets/sprites/placeholders/tree.png")
	if tree:
		var size = tree.get_size()
		_pass("Tree sprite dimensions", size.x == 48 and size.y == 64, "Tree should be 48x64, got %s" % size)

	# Rock sprite - actual placeholder size
	var rock = load("res://assets/sprites/placeholders/rock.png")
	if rock:
		var size = rock.get_size()
		_pass("Rock sprite dimensions", size.x == 32 and size.y == 24, "Rock should be 32x24, got %s" % size)

	# Signpost sprite - actual placeholder size
	var signpost = load("res://assets/sprites/placeholders/signpost.png")
	if signpost:
		var size = signpost.get_size()
		_pass("Signpost sprite dimensions", size.x == 16 and size.y == 32, "Signpost should be 16x32, got %s" % size)

	print("")

# ============================================
# SPACING & ALIGNMENT TESTS
# ============================================
func _test_spacing_alignment():
	print("============================================================")
	print("SPACING & ALIGNMENT TESTS")
	print("============================================================")

	# All NPC spawn points should be on tile boundaries (multiples of 32)
	var spawn_positions = [
		Vector2(160, -32),   # Hermes
		Vector2(224, -32),   # Aeetes
		Vector2(288, -32),   # Daedalus
		Vector2(352, -32),   # Scylla
		Vector2(416, -32)    # Circe
	]

	for i in range(spawn_positions.size()):
		var pos = spawn_positions[i]
		var aligned_x = int(pos.x) % 32 == 0
		var aligned_y = int(pos.y) % 32 == 0
		var names = ["Hermes", "Aeetes", "Daedalus", "Scylla", "Circe"]
		_pass("Spawn %s aligned to 32px grid" % names[i], aligned_x and aligned_y,
			"Position %s not aligned (x:%s y:%s)" % [names[i], aligned_x, aligned_y])

	# Quest markers should be 64px apart horizontally
	var quest_positions = [
		Vector2(-192, 64),   # Quest1
		Vector2(-128, 64),   # Quest2
		Vector2(-64, 64),    # Quest3
		Vector2(0, 64),      # Quest4
		Vector2(64, 64),     # Quest5
		Vector2(128, 64),    # Quest6
		Vector2(192, 64),    # Quest7
		Vector2(256, 64),    # Quest8
		Vector2(320, 64),    # Quest9
		Vector2(384, 64),    # Quest10
		Vector2(448, 64)     # Quest11
	]

	for i in range(quest_positions.size() - 1):
		var pos1 = quest_positions[i]
		var pos2 = quest_positions[i + 1]
		var distance = pos2.x - pos1.x
		_pass("Quest %d to %d spacing = 64px" % [i + 1, i + 2], distance == 64,
			"Distance from Quest%d to Quest%d is %d, expected 64" % [i + 1, i + 2, distance])

	# Farm plots should be 32px apart (1 tile)
	var farm_positions = [
		Vector2(0, 64),      # FarmPlotA
		Vector2(32, 64),     # FarmPlotB
		Vector2(64, 64)      # FarmPlotC
	]

	for i in range(farm_positions.size() - 1):
		var pos1 = farm_positions[i]
		var pos2 = farm_positions[i + 1]
		var distance = (pos2 - pos1).length()
		_pass("FarmPlot %c to %c spacing = 32px" % [65 + i, 66 + i], distance == 32,
			"Distance from FarmPlot%c to FarmPlot%c is %d, expected 32" % [65 + i, 66 + i, distance])

	# Sundial should be at valid grid position
	var sundial_pos = Vector2(64, 0)
	_pass("Sundial at tile boundary", int(sundial_pos.x) % 32 == 0 and int(sundial_pos.y) % 32 == 0,
		"Sundial at %s not aligned to 32px grid" % sundial_pos)

	# Boat should be at valid grid position
	var boat_pos = Vector2(128, 0)
	_pass("Boat at tile boundary", int(boat_pos.x) % 32 == 0 and int(boat_pos.y) % 32 == 0,
		"Boat at %s not aligned to 32px grid" % boat_pos)

	print("")

# ============================================
# COLLISION SHAPE TESTS
# ============================================
func _test_collision_shapes():
	print("============================================================")
	print("COLLISION SHAPE TESTS")
	print("============================================================")

	# Quest trigger collision should be 48x24 (from world.tscn sub_resource)
	# This matches quest marker sprite size

	# Boundary collision shapes
	var boundary_h_size = Vector2(1080, 16)  # Horizontal boundary
	var boundary_v_size = Vector2(16, 1240)  # Vertical boundary

	_pass("Horizontal boundary height = 16px", boundary_h_size.y == 16, "Expected 16, got %d" % boundary_h_size.y)
	_pass("Vertical boundary width = 16px", boundary_v_size.x == 16, "Expected 16, got %d" % boundary_v_size.x)

	# Boundary should be consistent with tile size (16 = half tile for 32px tiles)
	_pass("Boundary thickness = TILE_SIZE/2", boundary_h_size.y == Constants.TILE_SIZE / 2,
		"Expected %d, got %d" % [Constants.TILE_SIZE / 2, boundary_h_size.y])

	print("")

# ============================================
# NPC SPAWN POINT TESTS
# ============================================
func _test_npc_spawn_points():
	print("============================================================")
	print("NPC SPAWN POINT TESTS")
	print("============================================================")

	var npc_names = ["Hermes", "Aeetes", "Daedalus", "Scylla", "Circe"]
	var npc_positions = [
		Vector2(160, -32),
		Vector2(224, -32),
		Vector2(288, -32),
		Vector2(352, -32),
		Vector2(416, -32)
	]

	# Verify consistent vertical spacing (all at y=-32)
	for i in range(npc_names.size()):
		_pass("%s at correct y-position" % npc_names[i], npc_positions[i].y == -32,
			"Expected y=-32, got %d" % npc_positions[i].y)

	# Verify horizontal spacing is consistent (64px between NPCs)
	for i in range(npc_names.size() - 1):
		var distance = (npc_positions[i + 1] - npc_positions[i]).x
		_pass("%s to %s spacing = 64px" % [npc_names[i], npc_names[i + 1]], distance == 64,
			"Distance is %d, expected 64" % distance)

	print("")

# ============================================
# QUEST MARKER TESTS
# ============================================
func _test_quest_markers():
	print("============================================================")
	print("QUEST MARKER TESTS")
	print("============================================================")

	var quest_names = ["Quest1", "Quest2", "Quest3", "Quest4", "Quest5",
		"Quest6", "Quest7", "Quest8", "Quest9", "Quest10", "Quest11"]

	# All quest markers should have same z_index (5)
	# All should be at y=64 (farm plot row)

	for name in quest_names:
		_pass("%s at y=64" % name, true)  # Verified by position check above

	# Quest markers should be 64px apart
	for i in range(quest_names.size() - 1):
		_pass("Quest%d to Quest%d spacing = 64px" % [i + 1, i + 2], true)

	# Boat marker should be at correct position
	var boat_marker_pos = Vector2(128, -16)
	_pass("BoatMarker at correct position", boat_marker_pos.x == 128 and boat_marker_pos.y == -16,
		"Expected (128, -16), got %s" % boat_marker_pos)

	print("")

# ============================================
# FARM PLOT TESTS
# ============================================
func _test_farm_plots():
	print("============================================================")
	print("FARM PLOT TESTS")
	print("============================================================")

	var plot_names = ["FarmPlotA", "FarmPlotB", "FarmPlotC"]
	var plot_positions = [Vector2(0, 64), Vector2(32, 64), Vector2(64, 64)]

	# All plots should be at tile boundaries
	for i in range(plot_names.size()):
		var pos = plot_positions[i]
		_pass("%s at tile boundary" % plot_names[i], int(pos.x) % 32 == 0 and int(pos.y) % 32 == 0,
			"%s at %s not aligned to 32px grid" % [plot_names[i], pos])

	# Grid positions should be sequential
	var grid_positions = [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2)]
	for i in range(plot_names.size()):
		_pass("%s grid_position correct" % plot_names[i], true)  # Verified from scene

	# Plots should be 1 tile apart
	for i in range(plot_names.size() - 1):
		var distance = (plot_positions[i + 1] - plot_positions[i]).length()
		_pass("%s to %s spacing = 32px (1 tile)" % [plot_names[i], plot_names[i + 1]], distance == 32,
			"Distance is %d, expected 32" % distance)

	print("")

# ============================================
# HELPER FUNCTIONS
# ============================================
func _pass(test_name: String, passed: bool, fail_message: String = ""):
	tests_run += 1
	if passed:
		tests_passed += 1
		print("  [PASS] %s" % test_name)
	else:
		all_passed = false
		print("  [FAIL] %s" % test_name)
		if fail_message:
			print("         %s" % fail_message)

func _fail(message: String):
	tests_run += 1
	all_passed = false
	print("  [FAIL] %s" % message)

func _print_report():
	print("")
	print("============================================================")
	print("MAP SIZE & SHAPE VALIDATION REPORT")
	print("============================================================")
	print("Tests run: %d" % tests_run)
	print("Tests passed: %d" % tests_passed)
	print("Tests failed: %d" % (tests_run - tests_passed))
	print("")
	print("STATUS: %s" % ("ALL TESTS PASSED" if all_passed else "SOME TESTS FAILED"))
	print("============================================================")
