extends Node
## GameState - Central state management singleton
## See SCHEMA.md for data structure definitions

# Signals
signal inventory_changed(item_id: String, new_quantity: int)
signal gold_changed(new_amount: int)
signal day_advanced(new_day: int)
signal flag_changed(flag: String, value: bool)
signal crop_planted(plot_id: Vector2i, crop_id: String)
signal crop_harvested(plot_id: Vector2i, item_id: String, quantity: int)

# Constants
const TILE_SIZE: int = 32

# State
var current_day: int = 1
var current_season: String = "spring"
var gold: int = 100
var inventory: Dictionary = {} # { "item_id": quantity }
var quest_flags: Dictionary = {} # { "flag_name": bool }
var farm_plots: Dictionary = {} # { Vector2i: PlotData }

# Crop Registry (loaded dynamically)
var _crop_registry: Dictionary = {} # { "crop_id": CropData }
var _item_registry: Dictionary = {} # { "item_id": ItemData }

# ============================================
# INITIALIZATION
# ============================================

func _ready() -> void:
	print("[GameState] Initialized")
	_load_registries()
	
	# Give player starter items for testing
	add_item("wheat_seed", 5)
	print("[GameState] Added starter items")

func _load_registries() -> void:
	# Load crop data
	var wheat_crop = load("res://resources/crops/wheat.tres") as CropData
	if wheat_crop:
		register_crop(wheat_crop)
	
	# Load item data
	var wheat_seed_item = load("res://resources/items/wheat_seed.tres") as ItemData
	if wheat_seed_item:
		register_item(wheat_seed_item)
	
	var wheat_item = load("res://resources/items/wheat.tres") as ItemData
	if wheat_item:
		register_item(wheat_item)
	
	print("[GameState] Registries loaded")

# ============================================
# INVENTORY MANAGEMENT
# ============================================

func add_item(item_id: String, quantity: int = 1) -> void:
	if not inventory.has(item_id):
		inventory[item_id] = 0
	inventory[item_id] += quantity
	inventory_changed.emit(item_id, inventory[item_id])
	print("[GameState] Added %d x %s (total: %d)" % [quantity, item_id, inventory[item_id]])

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

func get_flag(flag: String) -> bool:
	return quest_flags.get(flag, false)

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

func get_item_data(item_id: String) -> ItemData:
	return _item_registry.get(item_id, null)

func register_crop(crop_data: CropData) -> void:
	_crop_registry[crop_data.id] = crop_data
	print("[GameState] Registered crop: %s" % crop_data.id)

func register_item(item_data: ItemData) -> void:
	_item_registry[item_data.id] = item_data
	print("[GameState] Registered item: %s" % item_data.id)
