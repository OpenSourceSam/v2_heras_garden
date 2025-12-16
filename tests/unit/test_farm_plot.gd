extends GutTest

var plot_scene = load("res://scenes/entities/farm_plot.tscn")
var plot
var game_state

func before_each():
	game_state = get_node("/root/GameState")
	# Manual reset since reset_state() doesn't exist
	game_state.current_day = 1
	game_state.inventory = {}
	game_state.farm_plots = {}
	game_state.quest_flags = {}
	
	plot = plot_scene.instantiate()
	add_child_autofree(plot)

func test_plant_crop():
	game_state.add_item("wheat_seed", 1)
	plot.interact() # Should till
	
	# Mock seed selection if needed, or rely on auto-plant logic
	# Based on previous code, plant() is called manually or via interaction
	plot.plant("wheat")
	
	assert_eq(plot.crop_id, "wheat")
	assert_eq(plot.current_state, plot.State.PLANTED)

func test_grow_crop():
	plot.plant("wheat")
	assert_eq(plot.current_state, plot.State.PLANTED)
	
	# Advance GameState day
	game_state.advance_day()
	plot.advance_growth() # Plot must update its state
	
	# Check if growth advanced (wheat matures in 3 days)
	# Day 1: Planted (Stage 0)
	# Day 2: Growing
	assert_eq(plot.current_state, plot.State.GROWING)

func test_harvest_crop():
	plot.plant("wheat")
	
	# Fast forward to maturity
	game_state.current_day += 3
	plot.advance_growth()
	
	assert_eq(plot.current_state, plot.State.HARVESTABLE)
	
	plot.harvest()
	assert_eq(game_state.get_item_count("wheat"), 1)
	assert_eq(plot.current_state, plot.State.TILLED) # Wheat doesn't regrow
