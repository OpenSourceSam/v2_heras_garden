extends SceneTree

## Visual screenshot test runner using Papershot
## Run: godot --headless --script tests/visual_screenshot_test.gd

# Use global Papershot class - don't shadow it with a constant
var papershot_node: Papershot
var test_results: Array = []

func _init() -> void:
    call_deferred("_run_visual_tests")

func _run_visual_tests() -> void:
    print("=== Visual Screenshot Test Suite ===")
    print("")

    # Create Papershot instance and add to root (which has autoloads)
    papershot_node = Papershot.new()
    papershot_node.folder = "res://.godot/screenshots/"
    papershot_node.file_format = Papershot.PNG
    root.add_child(papershot_node)

    # Define visual tests
    var tests = [
        {"name": "Main Menu", "scene": "res://game/features/ui/main_menu.tscn"},
        {"name": "World View", "scene": "res://game/features/world/world.tscn"},
    ]

    # Run each test
    for test in tests:
        await _run_single_test(test.name, test.scene)

    # Print results
    _print_results()
    quit(0 if test_results.size() > 0 and test_results.all(func(r): return r.passed) else 1)

func _run_single_test(test_name: String, scene_path: String) -> void:
    print("Testing: %s" % test_name)

    # Change scene - SceneTree has change_scene_to_file() method directly
    var error = change_scene_to_file(scene_path)
    if error != OK:
        test_results.append({"name": test_name, "passed": false, "error": "Failed to load scene"})
        return

    # Wait for scene to settle
    await process_frame
    await process_frame

    # Take screenshot
    error = papershot_node.take_screenshot()
    if error == OK:
        var screenshot_path = papershot_node._get_path()
        print("  Screenshot saved: %s" % screenshot_path.replace("user://", ""))
        test_results.append({"name": test_name, "passed": true, "path": screenshot_path})
    else:
        test_results.append({"name": test_name, "passed": false, "error": "Screenshot failed"})

    print("")

func _print_results() -> void:
    print("=== Test Results ===")
    var passed = 0
    var failed = 0

    for result in test_results:
        var status = "PASS" if result.passed else "FAIL"
        if result.passed:
            passed += 1
            print("[%s] %s" % [status, result.name])
            print("       %s" % result.path.replace("user://", ""))
        else:
            failed += 1
            print("[%s] %s" % [status, result.name])
            if result.has("error"):
                print("       Error: %s" % result.error)

    print("")
    print("Total: %d passed, %d failed" % [passed, failed])
