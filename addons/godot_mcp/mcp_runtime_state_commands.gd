@tool
class_name MCPRuntimeStateCommands
extends MCPBaseCommandProcessor

## HPV Testing Commands - Provides high-level runtime state inspection and modification
## for playability validation (HPV) workflows

func process_command(client_id: int, command_type: String, params: Dictionary, command_id: String) -> bool:
	match command_type:
		"get_global_variables":
			_handle_get_global_variables(client_id, params, command_id)
			return true
		"get_runtime_properties":
			_handle_get_runtime_properties(client_id, params, command_id)
			return true
		"set_flag":
			_handle_set_flag(client_id, params, command_id)
			return true
		"get_flag":
			_handle_get_flag(client_id, params, command_id)
			return true
		"teleport_player":
			_handle_teleport_player(client_id, params, command_id)
			return true
		"get_inventory":
			_handle_get_inventory(client_id, params, command_id)
			return true
		"add_item":
			_handle_add_item(client_id, params, command_id)
			return true
		"skip_to_quest":
			_handle_skip_to_quest(client_id, params, command_id)
			return true
	return false

func _get_runtime_bridge() -> MCPRuntimeDebuggerBridge:
	if Engine.has_meta("MCPRuntimeDebuggerBridge"):
		return Engine.get_meta("MCPRuntimeDebuggerBridge") as MCPRuntimeDebuggerBridge
	return null

func _evaluate_expression(expression: String, timeout_ms: int = 2000) -> Dictionary:
	var runtime_bridge := _get_runtime_bridge()
	if runtime_bridge == null:
		return { "error": "Runtime debugger bridge not available. Ensure the project is running." }
	
	var request_info := runtime_bridge.evaluate_runtime_expression(expression, {})
	if request_info.has("error"):
		return request_info
	
	var session_id: int = request_info.get("session_id", -1)
	var request_id: int = request_info.get("request_id", -1)
	if session_id < 0 or request_id < 0:
		return { "error": "Failed to enqueue runtime evaluation request." }
	
	var scene_tree := get_tree()
	if scene_tree == null:
		return { "error": "Scene tree unavailable while waiting for runtime evaluation." }
	
	var deadline: int = Time.get_ticks_msec() + timeout_ms
	var response: Dictionary = {}
	
	while Time.get_ticks_msec() <= deadline:
		if runtime_bridge.has_eval_result(session_id, request_id):
			response = runtime_bridge.take_eval_result(session_id, request_id)
			break
		await scene_tree.process_frame
	
	if response.is_empty():
		return { "error": "Timed out waiting for runtime evaluation result." }
	
	return response

# ---- get_global_variables ----

func _handle_get_global_variables(client_id: int, params: Dictionary, command_id: String) -> void:
	var include_private := params.get("include_private", false)
	var prefix := params.get("prefix", "")
	
	# Query GameState flags
	var result := {}
	
	# Get all GameState properties
	var gs_result = await _evaluate_expression("get_tree().get_first_node_in_group('autoload').get_meta('flag_state', {})")
	if gs_result.has("result") and gs_result["result"] is Dictionary:
		var flags: Dictionary = gs_result["result"]
		for key in flags:
			if key.begins_with("_") and not include_private:
				continue
			if not prefix.is_empty() and not key.begins_with(prefix):
				continue
			result[key] = flags[key]
	
	# Also get key quest flags individually for convenience
	var quest_flags := [
		"quest_0_active", "quest_0_complete",
		"quest_1_active", "quest_1_complete",
		"quest_2_active", "quest_2_complete",
		"quest_3_active", "quest_3_complete",
		"quest_4_active", "quest_4_complete",
		"quest_5_active", "quest_5_complete",
		"quest_6_active", "quest_6_complete",
		"quest_7_active", "quest_7_complete",
		"quest_8_active", "quest_8_complete",
		"quest_9_active", "quest_9_complete",
		"quest_10_active", "quest_10_complete",
		"quest_11_active", "quest_11_complete",
		"prologue_complete", "game_complete", "free_play_unlocked",
		"met_circe", "met_hermes", "met_aeetes", "met_daedalus", "met_scylla",
		"transformed_scylla", "scylla_petrified"
	]
	
	for flag in quest_flags:
		var flag_result = await _evaluate_expression("get_tree().get_first_node_in_group('autoload').get_flag('" + flag + "')")
		if flag_result.has("result"):
			result[flag] = flag_result["result"]
	
	_send_success(client_id, {
		"global_variables": result,
		"count": result.size()
	}, command_id)

# ---- get_runtime_properties ----

func _handle_get_runtime_properties(client_id: int, params: Dictionary, command_id: String) -> void:
	var node_path: String = params.get("node_path", "")
	var include_hidden := params.get("include_hidden", false)
	
	if node_path.is_empty():
		_send_error(client_id, "node_path parameter is required", command_id)
		return
	
	var expression := "var _node = get_node(\"" + node_path + "\"); var _props = {}; for prop in _node.get_property_list(): if prop.usage & PROPERTY_USAGE_EDITOR: _props[prop.name] = _node.get(prop.name); _props"
	var result = await _evaluate_expression(expression)
	
	_send_success(client_id, result, command_id)

# ---- set_flag ----

func _handle_set_flag(client_id: int, params: Dictionary, command_id: String) -> void:
	var flag_name: String = params.get("flag_name", "")
	var value: Variant = params.get("value", true)
	
	if flag_name.is_empty():
		_send_error(client_id, "flag_name parameter is required", command_id)
		return
	
	var bool_value := bool(value) if typeof(value) == TYPE_BOOL else true
	var expression := "get_tree().get_first_node_in_group('autoload').set_flag('" + flag_name + "', " + str(bool_value) + ")"
	var result = await _evaluate_expression(expression)
	
	_send_success(client_id, {
		"flag_name": flag_name,
		"value": bool_value,
		"result": result
	}, command_id)

# ---- get_flag ----

func _handle_get_flag(client_id: int, params: Dictionary, command_id: String) -> void:
	var flag_name: String = params.get("flag_name", "")
	
	if flag_name.is_empty():
		_send_error(client_id, "flag_name parameter is required", command_id)
		return
	
	var expression := "get_tree().get_first_node_in_group('autoload').get_flag('" + flag_name + "')"
	var result = await _evaluate_expression(expression)
	
	_send_success(client_id, {
		"flag_name": flag_name,
		"value": result.get("result", false)
	}, command_id)

# ---- teleport_player ----

func _handle_teleport_player(client_id: int, params: Dictionary, command_id: String) -> void:
	var x: float = params.get("x", 0.0)
	var y: float = params.get("y", 0.0)
	var location: String = params.get("location", "")
	
	var target_pos := Vector2(x, y)
	
	# Handle location-based teleportation
	if not location.is_empty():
		var loc_result = await _evaluate_expression("_get_location_position('" + location + "')")
		if loc_result.has("result") and loc_result["result"] is Vector2:
			target_pos = loc_result["result"]
	
	var expression := "var _player = get_node_or_null('/root/World/Player'); if _player: _player.global_position = Vector2(" + str(target_pos.x) + ", " + str(target_pos.y) + "); 'teleported'"
	var result = await _evaluate_expression(expression)
	
	_send_success(client_id, {
		"position": { "x": target_pos.x, "y": target_pos.y },
		"result": result
	}, command_id)

# ---- get_inventory ----

func _handle_get_inventory(client_id: int, params: Dictionary, command_id: String) -> void:
	var result = await _evaluate_expression("get_tree().get_first_node_in_group('autoload').inventory")
	
	var inventory: Dictionary = {}
	if result.has("result") and result["result"] is Dictionary:
		inventory = result["result"]
	
	_send_success(client_id, {
		"inventory": inventory,
		"item_count": inventory.size()
	}, command_id)

# ---- add_item ----

func _handle_add_item(client_id: int, params: Dictionary, command_id: String) -> void:
	var item_id: String = params.get("item_id", "")
	var quantity: int = int(params.get("quantity", 1))
	
	if item_id.is_empty():
		_send_error(client_id, "item_id parameter is required", command_id)
		return
	
	var expression := "get_tree().get_first_node_in_group('autoload').add_item('" + item_id + "', " + str(quantity) + ")"
	var result = await _evaluate_expression(expression)
	
	_send_success(client_id, {
		"item_id": item_id,
		"quantity": quantity,
		"result": result
	}, command_id)

# ---- skip_to_quest ----

func _handle_skip_to_quest(client_id: int, params: Dictionary, command_id: String) -> void:
	var quest_number: int = int(params.get("quest_number", 10))
	var skip_rewards := params.get("skip_rewards", true)
	
	if quest_number < 0 or quest_number > 11:
		_send_error(client_id, "quest_number must be between 0 and 11", command_id)
		return
	
	var result := {}
	
	# Set all prerequisite quest flags to complete
	for i in range(quest_number):
		var flag := "quest_" + str(i) + "_complete"
		var set_result = await _evaluate_expression("get_tree().get_first_node_in_group('autoload').set_flag('" + flag + "', true)")
		result[flag] = set_result.get("result", false)
	
	# Set the target quest as active
	var active_flag := "quest_" + str(quest_number) + "_active"
	var active_result = await _evaluate_expression("get_tree().get_first_node_in_group('autoload').set_flag('" + active_flag + "', true)")
	result[active_flag] = active_result.get("result", false)
	
	# Add quest rewards if requested
	if skip_rewards:
		var rewards_result = await _evaluate_expression("_add_quest_rewards(" + str(quest_number) + ")")
		result["rewards"] = rewards_result
	
	_send_success(client_id, {
		"quest_number": quest_number,
		"flags_set": result,
		"message": "Skipped to Quest " + str(quest_number)
	}, command_id)
