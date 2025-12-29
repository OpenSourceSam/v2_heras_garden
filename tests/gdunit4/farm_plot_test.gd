extends GdUnitTestSuite

func before_test() -> void:
	GameState.new_game()

func test_farm_plot_till_plant_harvest() -> void:
	var plot = load("res://game/features/farm_plot/farm_plot.tscn").instantiate()
	get_tree().root.add_child(plot)
	await get_tree().process_frame

	plot.grid_position = Vector2i(0, 0)
	plot.till()
	assert_that(plot.current_state).is_equal(plot.State.TILLED)

	plot.plant("wheat_seed")
	assert_that(GameState.farm_plots.has(plot.grid_position)).is_true()

	GameState.farm_plots[plot.grid_position]["ready_to_harvest"] = true
	plot.sync_from_game_state()
	plot.harvest()

	assert_that(GameState.get_item_count("wheat")).is_greater(0)
	plot.queue_free()

func test_world_seed_selector_plants_crop() -> void:
	var world = load("res://game/features/world/world.tscn").instantiate()
	get_tree().root.add_child(world)
	await get_tree().process_frame

	var plot = world.get_node("FarmPlots/FarmPlotA")
	plot.till()
	plot.interact()
	await get_tree().process_frame

	var selector = world.get_node("UI/SeedSelector")
	assert_that(selector.visible).is_true()

	selector.seed_selected.emit("wheat_seed")
	await get_tree().process_frame

	assert_that(GameState.farm_plots.has(plot.grid_position)).is_true()
	world.queue_free()
