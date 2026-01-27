extends Node
## GameState - Central state management singleton
## See docs/design/SCHEMA.md for data structure definitions

# Signals
signal inventory_changed(item_id: String, new_quantity: int)
signal gold_changed(new_amount: int)
signal day_advanced(new_day: int)
signal flag_changed(flag: String, value: bool)
signal crop_planted(plot_id: Vector2i, crop_id: String)
signal crop_harvested(plot_id: Vector2i, item_id: String, quantity: int)
signal item_collected(item_id: String, quantity: int, position: Vector2)

# Note: For TILE_SIZE and other constants, use Constants.TILE_SIZE (see game/autoload/constants.gd)

# State
var current_day: int = 1
var current_season: String = "spring"
var gold: int = 100
var inventory: Dictionary = {}  # { "item_id": quantity }
var quest_flags: Dictionary = {}  # { "flag_name": bool }
var farm_plots: Dictionary = {}  # { Vector2i: PlotData }

# Crop Registry (loaded dynamically)
var _crop_registry: Dictionary = {}  # { "crop_id": CropData }
var _item_registry: Dictionary = {}  # { "item_id": ItemData }

# ============================================
# INITIALIZATION
# ============================================

func _ready() -> void:
	print("[GameState] Initialized")
	_load_registries()

func new_game() -> void:
	if _crop_registry.is_empty() or _item_registry.is_empty():
		_load_registries()
	current_day = 1
	current_season = "spring"
	gold = 100
	inventory.clear()
	quest_flags.clear()
	farm_plots.clear()
	add_item("wheat_seed", 3)
	set_flag("quest_0_active", true)
	set_flag("prologue_complete", true)

func _load_registries() -> void:
	# Load all CropData resources
	var crop_paths = [
		"res://game/shared/resources/crops/wheat.tres",
		"res://game/shared/resources/crops/nightshade.tres",
		"res://game/shared/resources/crops/moly.tres",
		"res://game/shared/resources/crops/golden_glow.tres"
	]

	for path in crop_paths:
		var crop = load(path) as CropData
		if crop:
			register_crop(crop)
		else:
			push_error("Failed to load crop: %s" % path)

	# Load all ItemData resources
	var item_paths = [
		"res://game/shared/resources/items/wheat.tres",
		"res://game/shared/resources/items/wheat_seed.tres",
		"res://game/shared/resources/items/nightshade.tres",
		"res://game/shared/resources/items/nightshade_seed.tres",
		"res://game/shared/resources/items/moly.tres",
		"res://game/shared/resources/items/moly_seed.tres",
		"res://game/shared/resources/items/calming_draught_potion.tres",
		"res://game/shared/resources/items/binding_ward_potion.tres",
		"res://game/shared/resources/items/reversal_elixir_potion.tres",
		"res://game/shared/resources/items/petrification_potion.tres",
		"res://game/shared/resources/items/moon_tear.tres",
		"res://game/shared/resources/items/sacred_earth.tres",
		"res://game/shared/resources/items/divine_blood.tres",
		"res://game/shared/resources/items/woven_cloth.tres",
		"res://game/shared/resources/items/pharmaka_flower.tres",
			"res://game/shared/resources/items/golden_glow.tres",  # lotus
		"res://game/shared/resources/items/golden_glow_seed.tres",  # lotus_seed
		"res://game/shared/resources/items/transformation_sap.tres"
	]

	for path in item_paths:
		var item = load(path) as ItemData
		if item:
			register_item(item)
		else:
			push_error("Failed to load item: %s" % path)

	print("[GameState] Registries loaded: %d crops, %d items" % [_crop_registry.size(), _item_registry.size()])

# ============================================
# INVENTORY MANAGEMENT
# ============================================

func add_item(item_id: String, quantity: int = 1) -> void:
	if not inventory.has(item_id):
		inventory[item_id] = 0
	inventory[item_id] += quantity
	inventory_changed.emit(item_id, inventory[item_id])
	print("[GameState] Added %d x %s (total: %d)" % [quantity, item_id, inventory[item_id]])
	_check_quest4_completion()

## Collect item at a specific world position (triggers visual feedback)
func collect_item_at_position(item_id: String, quantity: int, position: Vector2) -> void:
	add_item(item_id, quantity)
	item_collected.emit(item_id, quantity, position)

func remove_item(item_id: String, quantity: int = 1) -> bool:
	if not has_item(item_id, quantity):
		return false
	inventory[item_id] -= quantity
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	inventory_changed.emit(item_id, inventory.get(item_id, 0))
	print("[GameState] Removed %d x %s" % [quantity, item_id])
	return true

func has_item(item_id: String, quantity: int = 1) -> bool:
	return inventory.get(item_id, 0) >= quantity

func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)

func _check_quest4_completion() -> void:
	if not get_flag("quest_4_active") or get_flag("quest_4_complete"):
		return
	if get_item_count("moly") >= 3 and get_item_count("nightshade") >= 3 and get_item_count("lotus") >= 3:
		set_flag("quest_4_complete", true)
		set_flag("garden_built", true)

# ============================================
# GOLD MANAGEMENT
# ============================================

func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)
	print("[GameState] Added %d gold (total: %d)" % [amount, gold])

func remove_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	gold_changed.emit(gold)
	print("[GameState] Removed %d gold (total: %d)" % [amount, gold])
	return true

# ============================================
# QUEST FLAGS
# ============================================

func set_flag(flag: String, value: bool = true) -> void:
	quest_flags[flag] = value
	flag_changed.emit(flag, value)
	print("[GameState] Flag set: %s = %s" % [flag, value])
	if flag == "quest_4_active" and value:
		_check_quest4_completion()

func get_flag(flag: String) -> bool:
	return quest_flags.get(flag, false)

## Mark a quest completion dialogue as seen
## Automatically sets the appropriate quest_X_complete_dialogue_seen flag
## Returns true if the flag was newly set (first time seeing this dialogue)
func mark_dialogue_completed(quest_id: String) -> bool:
	var flag_name = "quest_%s_complete_dialogue_seen" % quest_id
	var was_already_seen = get_flag(flag_name)
	set_flag(flag_name, true)
	return not was_already_seen

# ============================================
# DAY/SEASON MANAGEMENT
# ============================================

func advance_day() -> void:
	current_day += 1
	day_advanced.emit(current_day)
	print("[GameState] Day advanced to %d" % current_day)

	# Update season every 28 days
	var season_day = (current_day - 1) % 112
	if season_day < 28:
		current_season = "spring"
	elif season_day < 56:
		current_season = "summer"
	elif season_day < 84:
		current_season = "fall"
	else:
		current_season = "winter"

	_update_all_crops()
	get_tree().call_group("farm_plots", "sync_from_game_state")

# ============================================
# FARM PLOT MANAGEMENT
# ============================================

func plant_crop(position: Vector2i, crop_id: String) -> void:
	farm_plots[position] = {
		"crop_id": crop_id,
		"planted_day": current_day,
		"current_stage": 0,
		"watered_today": false,
		"ready_to_harvest": false
	}
	crop_planted.emit(position, crop_id)
	print("[GameState] Planted %s at %s" % [crop_id, position])

func harvest_crop(position: Vector2i) -> void:
	if not farm_plots.has(position):
		return

	var plot_data = farm_plots[position]
	if not plot_data["ready_to_harvest"]:
		print("[GameState] Crop at %s not ready to harvest" % position)
		return

	var crop_data = get_crop_data(plot_data["crop_id"])
	if not crop_data:
		return

	# Add harvest item to inventory
	add_item(crop_data.harvest_item_id, 1)

	# Remove plot if crop doesn't regrow
	if not crop_data.regrows:
		farm_plots.erase(position)
	else:
		# Reset to growing stage
		plot_data["current_stage"] = 0
		plot_data["planted_day"] = current_day
		plot_data["ready_to_harvest"] = false

	crop_harvested.emit(position, crop_data.harvest_item_id, 1)
	print("[GameState] Harvested %s at %s" % [crop_data.harvest_item_id, position])

func _update_all_crops() -> void:
	for pos in farm_plots:
		var plot_data = farm_plots[pos]
		if plot_data.get("crop_id", "") == "":
			continue
		var crop_data = get_crop_data(plot_data["crop_id"])
		if not crop_data:
			continue

		var days_elapsed = current_day - plot_data["planted_day"]

		# Update growth stage
		if days_elapsed >= crop_data.days_to_mature:
			plot_data["ready_to_harvest"] = true
			plot_data["current_stage"] = crop_data.growth_stages.size() - 1
		else:
			# Calculate current stage based on days elapsed
			var stage_count = crop_data.growth_stages.size()
			var stage = int(float(days_elapsed) / float(crop_data.days_to_mature) * float(stage_count))
			plot_data["current_stage"] = min(stage, stage_count - 1)

		# Reset watered status
		plot_data["watered_today"] = false

# ============================================
# REGISTRY ACCESS
# ============================================

func get_crop_data(crop_id: String) -> CropData:
	return _crop_registry.get(crop_id, null)

func get_crop_id_from_seed(seed_item_id: String) -> String:
	for crop_id in _crop_registry.keys():
		var crop_data = _crop_registry[crop_id]
		if crop_data.seed_item_id == seed_item_id:
			return crop_id
	return ""

func get_item_data(item_id: String) -> ItemData:
	return _item_registry.get(item_id, null)

func register_crop(crop_data: CropData) -> void:
	_crop_registry[crop_data.id] = crop_data
	print("[GameState] Registered crop: %s" % crop_data.id)

func register_item(item_data: ItemData) -> void:
	_item_registry[item_data.id] = item_data
	print("[GameState] Registered item: %s" % item_data.id)
