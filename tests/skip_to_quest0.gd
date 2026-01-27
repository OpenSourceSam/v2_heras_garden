extends SceneTree
## Test script to skip to Quest 0 for HPV testing
## Run with: Godot*.exe --headless --script tests/skip_to_quest0.gd

var game_state = null

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=".repeat(60))
	print("SKIP TO QUEST 0 FOR HPV TESTING")
	print("=".repeat(60))

	# Get GameState autoload from root
	game_state = root.get_node_or_null("GameState")
	if not game_state:
		print("[FAIL] GameState autoload not found")
		quit(1)
		return

	print("[OK] GameState found")

	# Call new_game to initialize
	game_state.new_game()
	print("[OK] new_game() called")

	print("[INFO] Starting fresh at Quest 0")
	print("[INFO] Player will be at default spawn position")
	print("[INFO] No flags set - ready for natural Quest 0 progression")

	print("=".repeat(60))
	print("SETUP COMPLETE - Ready for Quest 0 HPV")
	print("=".repeat(60))
	quit(0)
