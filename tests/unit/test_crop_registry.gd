extends GutTest
## Unit tests for Crop Registry
## Tests that all crops (wheat, nightshade, moly) are properly registered

# ============================================
# CROP REGISTRY TESTS
# ============================================

func test_wheat_crop_registered() -> void:
	var wheat = GameState.get_crop_data("wheat")
	assert_not_null(wheat, "Wheat crop should be registered")
	assert_eq(wheat.id, "wheat", "Wheat should have correct ID")
	assert_eq(wheat.days_to_mature, 3, "Wheat should mature in 3 days")
	assert_eq(wheat.harvest_item_id, "wheat", "Wheat should harvest to wheat item")
	assert_eq(wheat.seed_item_id, "wheat_seed", "Wheat should use wheat_seed")

func test_nightshade_crop_registered() -> void:
	var nightshade = GameState.get_crop_data("nightshade")
	assert_not_null(nightshade, "Nightshade crop should be registered")
	assert_eq(nightshade.id, "nightshade", "Nightshade should have correct ID")
	assert_eq(nightshade.days_to_mature, 5, "Nightshade should mature in 5 days")
	assert_eq(nightshade.harvest_item_id, "nightshade", "Nightshade should harvest to nightshade item")
	assert_eq(nightshade.seed_item_id, "nightshade_seed", "Nightshade should use nightshade_seed")

func test_moly_crop_registered() -> void:
	var moly = GameState.get_crop_data("moly")
	assert_not_null(moly, "Moly crop should be registered")
	assert_eq(moly.id, "moly", "Moly should have correct ID")
	assert_eq(moly.days_to_mature, 7, "Moly should mature in 7 days")
	assert_eq(moly.harvest_item_id, "moly", "Moly should harvest to moly item")
	assert_eq(moly.seed_item_id, "moly_seed", "Moly should use moly_seed")

# ============================================
# ITEM REGISTRY TESTS
# ============================================

func test_wheat_items_registered() -> void:
	var wheat = GameState.get_item_data("wheat")
	var wheat_seed = GameState.get_item_data("wheat_seed")
	assert_not_null(wheat, "Wheat item should be registered")
	assert_not_null(wheat_seed, "Wheat seed should be registered")
	assert_eq(wheat.category, "crop", "Wheat should be crop category")
	assert_eq(wheat_seed.category, "seed", "Wheat seed should be seed category")

func test_nightshade_items_registered() -> void:
	var nightshade = GameState.get_item_data("nightshade")
	var nightshade_seed = GameState.get_item_data("nightshade_seed")
	assert_not_null(nightshade, "Nightshade item should be registered")
	assert_not_null(nightshade_seed, "Nightshade seed should be registered")
	assert_eq(nightshade.category, "crop", "Nightshade should be crop category")
	assert_eq(nightshade_seed.category, "seed", "Nightshade seed should be seed category")

func test_moly_items_registered() -> void:
	var moly = GameState.get_item_data("moly")
	var moly_seed = GameState.get_item_data("moly_seed")
	assert_not_null(moly, "Moly item should be registered")
	assert_not_null(moly_seed, "Moly seed should be registered")
	assert_eq(moly.category, "crop", "Moly should be crop category")
	assert_eq(moly_seed.category, "seed", "Moly seed should be seed category")

# ============================================
# CROP LIFECYCLE TESTS
# ============================================

func test_wheat_growth_cycle() -> void:
	# Reset GameState
	GameState.current_day = 1
	GameState.farm_plots.clear()
	
	# Plant wheat
	GameState.plant_crop(Vector2i(0, 0), "wheat")
	
	# Verify planted
	assert_true(GameState.farm_plots.has(Vector2i(0, 0)), "Plot should exist")
	var plot = GameState.farm_plots[Vector2i(0, 0)]
	assert_eq(plot["crop_id"], "wheat", "Should be wheat")
	assert_eq(plot["planted_day"], 1, "Should be planted on day 1")
	assert_false(plot["ready_to_harvest"], "Should not be harvestable yet")
	
	# Advance 3 days
	for i in range(3):
		GameState.advance_day()
	
	# Check harvestable
	plot = GameState.farm_plots[Vector2i(0, 0)]
	assert_true(plot["ready_to_harvest"], "Should be ready to harvest after 3 days")

func test_nightshade_growth_cycle() -> void:
	GameState.current_day = 1
	GameState.farm_plots.clear()
	GameState.plant_crop(Vector2i(1, 0), "nightshade")
	
	# Advance 4 days - should NOT be ready
	for i in range(4):
		GameState.advance_day()
	var plot = GameState.farm_plots[Vector2i(1, 0)]
	assert_false(plot["ready_to_harvest"], "Should not be ready after 4 days")
	
	# Advance 1 more day (total 5)
	GameState.advance_day()
	plot = GameState.farm_plots[Vector2i(1, 0)]
	assert_true(plot["ready_to_harvest"], "Should be ready after 5 days")

func test_moly_growth_cycle() -> void:
	GameState.current_day = 1
	GameState.farm_plots.clear()
	GameState.plant_crop(Vector2i(2, 0), "moly")
	
	# Advance 6 days - should NOT be ready
	for i in range(6):
		GameState.advance_day()
	var plot = GameState.farm_plots[Vector2i(2, 0)]
	assert_false(plot["ready_to_harvest"], "Should not be ready after 6 days")
	
	# Advance 1 more day (total 7)
	GameState.advance_day()
	plot = GameState.farm_plots[Vector2i(2, 0)]
	assert_true(plot["ready_to_harvest"], "Should be ready after 7 days")

# ============================================
# STARTER ITEMS TEST
# ============================================

func test_starter_seeds_provided() -> void:
	# Note: GameState._ready() automatically adds starter items
	# This test verifies they were added
	assert_true(GameState.has_item("wheat_seed", 1), "Should have wheat seeds")
	assert_true(GameState.has_item("nightshade_seed", 1), "Should have nightshade seeds")
	assert_true(GameState.has_item("moly_seed", 1), "Should have moly seeds")
