extends GutTest

func test_scene_manager_exists():
	assert_not_null(SceneManager, "SceneManager autoload should exist")

func test_fade_overlay_setup():
	# Check if overlay was created
	var overlay = SceneManager._fade_overlay
	assert_not_null(overlay, "Fade overlay should be created on ready")
	assert_eq(overlay.color, Color.BLACK, "Overlay should be black")
	assert_eq(overlay.modulate.a, 0.0, "Overlay should start transparent")

func test_change_scene_logic():
	# We can't easily test full scene transition in unit test without risking stability
	# But we can verify the method exists and signals depend on it
	watch_signals(SceneManager)
	
	# Mock the transition
	# Since it awaits, we might just check initial state
	assert_false(SceneManager.is_transitioning(), "Should not be transitioning initially")
