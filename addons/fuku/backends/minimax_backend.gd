extends BaseBackend
class_name MinimaxBackend

func _init() -> void:
	base_url = "https://api.minimax.io"

func get_chat_endpoint() -> String:
	return "/v1/text/chatcompletion_pro"

func get_models_endpoint() -> String:
	return "/v1/models"

func setup_headers() -> void:
	headers = ["Content-Type: application/json"]
	
	# #region agent log
	var project_root = ProjectSettings.globalize_path("res://")
	var log_path = project_root + "/.cursor/debug.log"
	var log_data = {
		"sessionId": "debug-session",
		"runId": "run1",
		"hypothesisId": "C",
		"location": "minimax_backend.gd:13",
		"message": "Setting up headers",
		"data": {
			"api_key_empty": api_key.is_empty(),
			"api_key_length": api_key.length(),
			"headers_count_before": headers.size()
		},
		"timestamp": Time.get_ticks_msec()
	}
	var log_file = FileAccess.open(log_path, FileAccess.READ_WRITE)
	if log_file:
		log_file.seek_end()
		log_file.store_string(JSON.stringify(log_data) + "\n")
		log_file.close()
	# #endregion
	
	if not api_key.is_empty():
		headers.append("Authorization: Bearer " + api_key)
		headers.append("MM-API-Source: godot-fuku-plugin")
		
		# #region agent log
		var project_root2 = ProjectSettings.globalize_path("res://")
		var log_path2 = project_root2 + "/.cursor/debug.log"
		var log_data2 = {
			"sessionId": "debug-session",
			"runId": "run1",
			"hypothesisId": "C",
			"location": "minimax_backend.gd:17",
			"message": "API key added to headers",
			"data": {
				"headers_count_after": headers.size(),
				"has_auth_header": headers.has("Authorization: Bearer " + api_key)
			},
			"timestamp": Time.get_ticks_msec()
		}
		var log_file2 = FileAccess.open(log_path2, FileAccess.READ_WRITE)
		if log_file2:
			log_file2.seek_end()
			log_file2.store_string(JSON.stringify(log_data2) + "\n")
			log_file2.close()
		# #endregion

func build_request_body(messages: Array, model: String, system_content: String = "") -> Dictionary:
	var formatted_messages: Array = []

	if not system_content.is_empty():
		formatted_messages.append({"role": "system", "content": system_content})

	for msg in messages:
		formatted_messages.append(msg)

	return {
		"model": model,
		"messages": formatted_messages,
		"use_standard_sse": false
	}

func extract_message_from_response(response: Dictionary) -> String:
	# Try MiniMax specific format first
	if response.has("reply") and not response.reply.is_empty():
		return response.reply

	# Try OpenAI-compatible format
	if response.has("choices") and response.choices.size() > 0:
		var choice = response.choices[0]
		if choice.has("message") and choice.message.has("content"):
			return choice.message.content

	return ""

func parse_models_response(response: Dictionary) -> Array:
	if not response.has("data"):
		return get_default_models()

	var models: Array = []
	for model_data in response.data:
		if model_data.has("model"):
			var model_id = model_data.model
			if not model_id.is_empty():
				models.append(model_id)

	return models if not models.is_empty() else get_default_models()

func get_default_models() -> Array:
	return ["abab6.5s-chat", "abab6.5g-chat", "abab6.5m-chat"]

func get_provider_name() -> String:
	return "MiniMax"
