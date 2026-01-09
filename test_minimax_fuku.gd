extends SceneTree

func _init():
	call_deferred("_test_minimax_backend")

func _test_minimax_backend():
	print("=== Testing MiniMax Backend for Fuku ===")
	print("")
	
	var all_passed = true
	
	# Test 1: Check if backend file exists
	var backend_path = "res://addons/fuku/backends/minimax_backend.gd"
	print("Test 1: Backend file exists")
	var exists = FileAccess.file_exists(backend_path)
	print("  Status: " + ("✓ EXISTS" if exists else "✗ MISSING"))
	if not exists:
		all_passed = false
	print("")
	
	# Test 2: Load the backend class
	print("Test 2: Load backend class")
	var backend_script = load(backend_path)
	if backend_script:
		print("  Status: ✓ Script loaded")
		var backend = backend_script.new()
		if backend:
			print("  Status: ✓ Backend instantiated")
			print("  Provider: " + backend.get_provider_name())
			print("  Chat endpoint: " + backend.get_chat_endpoint())
			print("  Models endpoint: " + backend.get_models_endpoint())
			var models = backend.get_default_models()
			print("  Default models: " + str(models.size()) + " models")
		else:
			print("  Status: ✗ Failed to instantiate")
			all_passed = false
	else:
		print("  Status: ✗ Failed to load script")
		all_passed = false
	print("")
	
	# Test 3: Check ConfigManager
	print("Test 3: Check ConfigManager")
	var config_path = "res://addons/fuku/core/config_manager.gd"
	var config_script = load(config_path)
	if config_script:
		print("  Status: ✓ ConfigManager loaded")
		var config = config_script.new()
		if config:
			print("  Status: ✓ ConfigManager instantiated")
			var key_name = config._get_env_key_name("minimax")
			if key_name == "MINIMAX_API_KEY":
				print("  ✓ MINIMAX_API_KEY mapping: CORRECT")
			else:
				print("  ✗ MINIMAX_API_KEY mapping: " + key_name)
				all_passed = false
		else:
			print("  Status: ✗ Failed to instantiate")
			all_passed = false
	else:
		print("  Status: ✗ Failed to load")
		all_passed = false
	print("")
	
	# Summary
	print("=== Summary ===")
	if all_passed:
		print("✅ ALL TESTS PASSED!")
		print("")
		print("MiniMax backend is properly integrated into Fuku.")
		print("")
		print("Next steps:")
		print("1. Open Godot Editor")
		print("2. Go to Project → Project Settings → Plugins")
		print("3. Enable 'Fuku' plugin (Status: Enabled)")
		print("4. Fuku panel will appear in the editor")
		print("5. Select 'MiniMax' from Provider dropdown")
		print("6. Enter API key: sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c")
		print("7. Click 'Connect' to fetch models")
		print("8. Start chatting with MiniMax! 🚀")
	else:
		print("❌ SOME TESTS FAILED")
		print("Please check the errors above.")
	
	print("")
	print("=== End Test ===")
	quit(0)
