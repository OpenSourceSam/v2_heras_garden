class_name StateQuery
extends Node

## Utility for querying game state in headless AI tests
## Accesses GameState, Constants, and other autoloads

## Get reference to GameState autoload
static func get_game_state() -> Node:
	var tree = Engine.get_main_loop() as SceneTree
	if tree and tree.root.has_node("GameState"):
		return tree.root.get_node("GameState")
	return null

## Get reference to Constants autoload
static func get_constants() -> Node:
	var tree = Engine.get_main_loop() as SceneTree
	if tree and tree.root.has_node("Constants"):
		return tree.root.get_node("Constants")
	return null

## ============================================
## GAME STATE QUERIES
## ============================================

## Get current day
static func get_day() -> int:
	var gs = get_game_state()
	return gs.current_day if gs else -1

## Get current season
static func get_season() -> String:
	var gs = get_game_state()
	return gs.current_season if gs else ""

## Get current gold amount
static func get_gold() -> int:
	var gs = get_game_state()
	return gs.gold if gs else -1

## Get full inventory as Dictionary
static func get_inventory() -> Dictionary:
	var gs = get_game_state()
	return gs.inventory.duplicate() if gs else {}

## Get quantity of a specific item
static func get_item_count(item_id: String) -> int:
	var gs = get_game_state()
	if gs and gs.inventory.has(item_id):
		return gs.inventory[item_id]
	return 0

## Check if player has at least count of item
static func has_item(item_id: String, count: int = 1) -> bool:
	return get_item_count(item_id) >= count

## Get all quest flags
static func get_quest_flags() -> Dictionary:
	var gs = get_game_state()
	return gs.quest_flags.duplicate() if gs else {}

## Check if a specific flag is set
static func get_flag(flag: String) -> bool:
	var gs = get_game_state()
	return gs.get_flag(flag) if gs and gs.has_method("get_flag") else false

## Check if a quest is active (flag starts with quest name)
static func is_quest_active(quest_name: String) -> bool:
	var flags = get_quest_flags()
	# Quest active flags typically start with "quest_"
	return flags.has("quest_" + quest_name + "_active")

## Check if a quest is complete
static func is_quest_complete(quest_name: String) -> bool:
	var flags = get_quest_flags()
	return flags.has("quest_" + quest_name + "_complete")

## Check if prologue is complete
static func is_prologue_complete() -> bool:
	return get_flag("prologue_complete")

## ============================================
## FARM STATE QUERIES
## ============================================

## Get all farm plots
static func get_farm_plots() -> Dictionary:
	var gs = get_game_state()
	return gs.farm_plots.duplicate() if gs else {}

## Count crops at a specific growth stage
## growth_stage: 0=planted, 1=sprouted, 2=grown, 3=harvestable
static func count_crops_at_stage(growth_stage: int) -> int:
	var plots = get_farm_plots()
	var count = 0
	for plot_id in plots:
		var plot = plots[plot_id]
		if plot.has("growth_stage") and plot.growth_stage == growth_stage:
			count += 1
	return count

## Check if a specific plot has a crop
static func plot_has_crop(plot_id: Vector2i) -> bool:
	var plots = get_farm_plots()
	return plots.has(plot_id) and plots[plot_id].has("crop_id")

## ============================================
## CONSTANTS QUERIES
## ============================================

## Get TILE_SIZE constant
static func get_tile_size() -> int:
	var consts = get_constants()
	if consts and consts.has_method("get_tile_size"):
		return consts.get_tile_size()
	return 32  # Default

## ============================================
## SCENE/UI STATE QUERIES
## ============================================

## Get current scene path
static func get_current_scene_path() -> String:
	var tree = Engine.get_main_loop() as SceneTree
	if tree and tree.current_scene:
		return tree.current_scene.scene_file_path
	return ""

## Check if we're in the main world
static func is_in_world() -> bool:
	var path = get_current_scene_path()
	return "world" in path.to_lower()

## Check if we're in main menu
static func is_in_main_menu() -> bool:
	var path = get_current_scene_path()
	return "main_menu" in path.to_lower()

## Check if dialogue is active (dialogue_box node exists)
static func is_dialogue_active() -> bool:
	var tree = Engine.get_main_loop() as SceneTree
	if tree and tree.root.has_node("DialogueBox"):
		return true
	# Also check if current scene is dialogue
	var path = get_current_scene_path()
	return "dialogue" in path.to_lower()

## ============================================
## PLAYER STATE QUERIES (if player exists)
## ============================================

## Get player node if it exists in scene
static func get_player() -> Node:
	var tree = Engine.get_main_loop() as SceneTree
	if tree and tree.current_scene:
		# Try direct child first
		if tree.current_scene.has_node("Player"):
			return tree.current_scene.get_node("Player")
		# Try find_child for nested nodes
		var player = tree.current_scene.find_child("Player", true, false)
		if player:
			return player
	return null

## Get player global position
static func get_player_position() -> Vector2:
	var player = get_player()
	return player.global_position if player else Vector2.ZERO

## ============================================
## SUMMARY
## ============================================

## Get a summary of current state for debugging
static func get_summary() -> Dictionary:
	return {
		"day": get_day(),
		"season": get_season(),
		"gold": get_gold(),
		"inventory_size": get_inventory().size(),
		"quest_flags_size": get_quest_flags().size(),
		"farm_plots": get_farm_plots().size(),
		"in_world": is_in_world(),
		"in_menu": is_in_main_menu(),
		"dialogue_active": is_dialogue_active()
	}

## Print state summary to console
static func print_summary() -> void:
	var summary = get_summary()
	print("=== Game State Summary ===")
	print("Day: %d, Season: %s" % [summary.day, summary.season])
	print("Gold: %d" % summary.gold)
	print("Inventory items: %d" % summary.inventory_size)
	print("Quest flags: %d" % summary.quest_flags_size)
	print("Farm plots: %d" % summary.farm_plots)
	print("In world: %s, In menu: %s, Dialogue: %s" % [
		"yes" if summary.in_world else "no",
		"yes" if summary.in_menu else "no",
		"yes" if summary.dialogue_active else "no"
	])
