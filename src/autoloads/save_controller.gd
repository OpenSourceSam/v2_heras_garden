extends Node
## SaveController - Save/Load game state to user://
## Uses Constants.SAVE_FILE_PATH and Constants.SAVE_VERSION from src/core/constants.gd

# ============================================
# SAVE GAME
# ============================================

func save_game() -> bool:
	var save_data: Dictionary = {
		"version": Constants.SAVE_VERSION,
		"timestamp": Time.get_datetime_string_from_system(),
		"current_day": GameState.current_day,
		"current_season": GameState.current_season,
		"gold": GameState.gold,
		"inventory": GameState.inventory.duplicate(),
		"quest_flags": GameState.quest_flags.duplicate(),
		"farm_plots": _serialize_farm_plots()
	}

	var json_string = JSON.stringify(save_data, "\t")
	var file := FileAccess.open(Constants.SAVE_FILE_PATH, FileAccess.WRITE)

	if not file:
		push_error("[SaveController] Could not open save file for writing: %s" % Constants.SAVE_FILE_PATH)
		return false

	file.store_string(json_string)
	file.close()

	print("[SaveController] Game saved to %s" % Constants.SAVE_FILE_PATH)
	return true

func _serialize_farm_plots() -> Dictionary:
	var serialized: Dictionary = {}
	for pos in GameState.farm_plots:
		var pos_key = "%d,%d" % [pos.x, pos.y]
		serialized[pos_key] = GameState.farm_plots[pos].duplicate()
	return serialized

# ============================================
# LOAD GAME
# ============================================

func load_game() -> bool:
	if not save_exists():
		print("[SaveController] No save file found at %s" % Constants.SAVE_FILE_PATH)
		return false

	var file := FileAccess.open(Constants.SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		push_error("[SaveController] Could not open save file for reading: %s" % Constants.SAVE_FILE_PATH)
		return false

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result != OK:
		push_error("[SaveController] Failed to parse save file: %s" % json.get_error_message())
		return false

	var save_data = json.data

	if not save_data is Dictionary:
		push_error("[SaveController] Save file is not a dictionary")
		return false

	# Version check
	if save_data.get("version", 0) != Constants.SAVE_VERSION:
		push_warning("[SaveController] Save file version mismatch (expected %d, got %d)" % [Constants.SAVE_VERSION, save_data.get("version", 0)])
		# Could implement migration logic here

	# Restore state
	GameState.current_day = save_data.get("current_day", 1)
	GameState.current_season = save_data.get("current_season", "spring")
	GameState.gold = save_data.get("gold", 100)
	GameState.inventory = save_data.get("inventory", {}).duplicate()
	GameState.quest_flags = save_data.get("quest_flags", {}).duplicate()
	GameState.farm_plots = _deserialize_farm_plots(save_data.get("farm_plots", {}))

	print("[SaveController] Game loaded from %s" % Constants.SAVE_FILE_PATH)
	print("[SaveController] Day: %d, Gold: %d, Inventory items: %d" % [GameState.current_day, GameState.gold, GameState.inventory.size()])

	# Emit signals to update UI
	GameState.gold_changed.emit(GameState.gold)
	GameState.day_advanced.emit(GameState.current_day)

	return true

func _deserialize_farm_plots(serialized: Dictionary) -> Dictionary:
	var farm_plots: Dictionary = {}
	for pos_key in serialized:
		var parts = pos_key.split(",")
		if parts.size() != 2:
			continue
		var pos = Vector2i(int(parts[0]), int(parts[1]))
		farm_plots[pos] = serialized[pos_key].duplicate()
	return farm_plots

# ============================================
# UTILITIES
# ============================================

func save_exists() -> bool:
	return FileAccess.file_exists(Constants.SAVE_FILE_PATH)

func delete_save() -> void:
	if save_exists():
		DirAccess.remove_absolute(Constants.SAVE_FILE_PATH)
		print("[SaveController] Save file deleted")

func get_save_info() -> Dictionary:
	if not save_exists():
		return {}

	var file := FileAccess.open(Constants.SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		return {}

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	if json.parse(json_string) != OK:
		return {}

	var save_data = json.data
	if not save_data is Dictionary:
		return {}

	return {
		"day": save_data.get("current_day", 1),
		"season": save_data.get("current_season", "spring"),
		"timestamp": save_data.get("timestamp", "Unknown")
	}
