extends SceneTree

func _init():
	call_deferred("_debug_plugin")

func _debug_plugin():
	print("=== AI Autonomous Agent Plugin Debug ===")
	print("")

	# Check if plugin files exist
	var provider_path = "res://addons/ai_autonomous_agent/llm_providers/minimax.tres"
	var api_path = "res://addons/ai_autonomous_agent/llm_apis/minimax_api.gd"

	print("Checking plugin files:")
	var provider_exists = FileAccess.file_exists(provider_path)
	var api_exists = FileAccess.file_exists(api_path)
	print("  Provider (.tres): " + ("✓ EXISTS" if provider_exists else "✗ MISSING"))
	print("  API (.gd): " + ("✓ EXISTS" if api_exists else "✗ MISSING"))
	print("")

	# Try to load the provider
	if provider_exists:
		print("Loading provider resource...")
		var provider = load(provider_path)
		if provider:
			print("  ✓ Provider loaded successfully")
			print("  Name: " + provider.name)
			print("  API ID: " + provider.api_id)
			print("  Description: " + provider.description)
		else:
			print("  ✗ Failed to load provider")
	print("")

	# Check config directory
	var config_dir = "user://ai_assistant_hub/"
	print("Config directory: " + config_dir)
	var config_exists = DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(config_dir))
	print("  Exists: " + ("✓ YES" if config_exists else "✗ NO"))
	print("")

	# List all providers
	print("Available LLM providers:")
	var providers_dir = "res://addons/ai_autonomous_agent/llm_providers/"
	if DirAccess.dir_exists_absolute(providers_dir):
		var dir = DirAccess.open(providers_dir)
		dir.list_dir_begin()
		var file = dir.get_next()
		while not file.is_empty():
			if file.ends_with(".tres"):
				print("  - " + file)
			file = dir.get_next()
	print("")

	print("=== End Debug ===")
	quit(0)
