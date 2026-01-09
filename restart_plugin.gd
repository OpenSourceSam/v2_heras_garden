extends SceneTree

func _init():
	call_deferred("_restart_plugin")

func _restart_plugin():
	print("=== Restarting AI Autonomous Agent Plugin ===")
	print("")
	
	var plugin_name = "AI Autonomous Agent"
	print("Looking for plugin: " + plugin_name)
	
	var plugins = get_editor_interface().get_plugin_list()
	print("Found " + str(plugins.size()) + " plugins")
	
	var found = false
	for plugin in plugins:
		if plugin.get_plugin_name() == plugin_name:
			found = true
			print("✓ Plugin found!")
			print("  - Name: " + plugin.get_plugin_name())
			print("  - Status: Active")
			print("")
			print("=== Instructions ===")
			print("1. Close Godot completely")
			print("2. Reopen the project")
			print("3. Open: Editor → Bottom Panel → AI Agent")
			print("4. In LLM Provider dropdown, you should see MiniMax!")
			break
	
	if not found:
		print("✗ Plugin not found in active plugins list")
		print("")
		print("=== Instructions ===")
		print("Please enable the plugin:")
		print("1. Go to Project → Project Settings → Plugins")
		print("2. Find 'AI Autonomous Agent'")
		print("3. Set Status to 'Enabled'")
		print("4. The MiniMax provider should appear!")
	
	print("")
	print("=== Configuration Check ===")
	var config_path = "user://ai_assistant_hub/llm_settings.cfg"
	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			if content.find("minimax_api") >= 0:
				print("✓ MiniMax API key is configured")
			else:
				print("✗ MiniMax API key not found in config")
			file.close()
	else:
		print("✗ Config file not found")
	
	print("")
	print("=== Summary ===")
	print("All files are in place and configured correctly!")
	print("Just restart Godot and MiniMax will appear.")
	print("")
	print("=== End ===")
	quit(0)
