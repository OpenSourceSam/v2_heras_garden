# Tier 1 AI Testing Framework (HLC + HPV)

Enable AI agents (Codex, MiniMax) to run Headless Logic Checks (HLC) and support Headed Playability Validation (HPV) using the same test utilities.

## Overview

The Tier 1 testing framework provides HLC-focused tooling for game logic verification, and it can also support HPV (headed) playability checks. It allows AI agents to:
- Simulate game input (D-pad, confirm, cancel)
- Query game state (gold, inventory, quests, flags)
- Assert conditions and capture errors
- Run automated test scripts

**Scripted Playthrough Testing (SPT):** SPT is automation, not a playtest. Use it when Sam explicitly asks; otherwise avoid it.

## Components

### Input Simulation (`tools/testing/input_simulator.gd`)

Simulates keyboard and gamepad input for menu navigation and gameplay.

**Key Methods:**
```gdscript
# Press and release an action immediately
input.press_action("ui_accept")

# Hold an action for duration
input.hold_action("ui_right", 0.5)

# Move in a direction (-1 to 1 for each axis)
input.move_direction(1, 0)  # Move right

# Navigate D-pad
input.nav_up()
input.nav_down()
input.nav_left()
input.nav_right()

# Confirm/Select
input.confirm()

# Cancel/Back
input.cancel()

# Wait for duration
await input.wait(0.5)
```

### State Query (`tools/testing/state_query.gd`)

Query game state for assertions without modifying anything.

**Key Methods:**
```gdscript
# Get gold amount
var gold = StateQuery.get_gold()

# Get current day
var day = StateQuery.get_day()

# Get inventory dictionary
var inventory = StateQuery.get_inventory()

# Check if player has item
var has_seeds = StateQuery.has_item("wheat_seed", 3)

# Check quest flags
var flags = StateQuery.get_quest_flags()
var quest_active = StateQuery.is_quest_active("quest_1")
var quest_complete = StateQuery.is_quest_complete("prologue")

# Get player position
var pos = StateQuery.get_player_position()

# Check if in world
var in_world = StateQuery.is_in_world()

# Get farm plots
var plots = StateQuery.get_farm_plots()
```

### Error Catcher (`tools/testing/error_catcher.gd`)

Safe function calling with error capture and assertion helpers.

**Key Methods:**
```gdscript
# Assert a condition
var passed = error_catcher.assert(condition, "Gold should be 100")

# Assert equality
var passed = error_catcher.assert_eq(actual, expected, "Gold mismatch")

# Get error count
var errors = error_catcher.get_error_count()

# Reset counters
error_catcher.reset()
```

### Test Runner Base (`tools/testing/test_runner.gd`)

Base class combining all utilities for test scripts.

**Key Methods:**
```gdscript
# Start a new test
runner.test("Main Menu Flow")

# End test and record result
runner.end_test(passed, "Details about the test")

# Take screenshot
runner.screenshot("main_menu")

# Change scene
runner.change_scene("res://game/features/world/world.tscn")

# Wait utilities
await runner.wait(0.5)
await runner.wait_frames(2)

# Print final report
runner.print_report()
```

## File Structure

```
tools/testing/
├── input_simulator.gd      # Input simulation
├── state_query.gd          # Game state queries
├── error_catcher.gd        # Error handling
└── test_runner.gd          # Base test runner class

tests/ai/
├── test_basic.gd               # Basic smoke test
├── test_map_size_shape.gd
```

## Usage

### HLC (Headless Logic Check)

Use HLC for fast, repeatable logic tests:

```bash
# Run core HLC suite
godot --headless --script tests/run_tests.gd

# Run AI smoke tests
godot --headless --script tests/ai/test_basic.gd
godot --headless --script tests/ai/test_map_size_shape.gd
```

**What works in HLC:**
- State queries (gold, inventory, quests)
- Save/load functionality
- Scene loading
- Autoload access
- Assertions and error catching

**What doesn't work in HLC:**
- Player node lookup (returns null)
- Viewport textures (screenshots are empty)
- Visual rendering verification

### HPV (Headed Playability Validation)

Use HPV when you need to verify visuals and playability:

```bash
# Launch headed playthrough (manual/MCP validation)
godot --path .
```

Use MCP runtime inspection while playing to validate UI and quest flow.

**What works in HPV:**
- All HLC capabilities
- Screenshots with actual visuals
- Player node verification
- Visual rendering checks

## What AI Agents Can Verify

### Verified Capabilities

- Gold amount is correct
- Inventory has expected items
- Quest flags are set properly
- Game saves/loads successfully
- Scenes load without errors
- Farm data structure exists
- Dialogue triggers set correct flags

### Limitations

- Typically does not verify visual rendering in HLC
- Player node lookup fails in HLC (use scene file check instead)
- Screenshots require HPV (headed) for actual visuals
- NPC sprite verification requires manual visual check

## HLC Limitations and Workarounds

### Player Node Null

**Problem:** `StateQuery.get_player()` returns null in HLC.

**Workaround:** Verify scene file loads correctly instead:
```gdscript
var scene = StateQuery.get_current_scene()
var passed = scene != null  # Scene loads, even if player is null
```

### Screenshots Empty

**Problem:** `papershot.take_screenshot()` creates files but viewport texture is null in HLC.

**Workaround:**
```gdscript
# Accept null texture in HLC
if texture == null:
    print("Screenshot skipped - HLC")
else:
    # Process screenshot
```

### NPC Verification

**Problem:** Typically does not visually verify NPC sprites in HLC.

**Workaround:** Run HPV via a headed playthrough:
```bash
godot --path .
```

## Example Test Script

```gdscript
extends SceneTree

const InputSimulator = preload("res://tools/testing/input_simulator.gd")
const StateQuery = preload("res://tools/testing/state_query.gd")
const Papershot = preload("res://addons/papershot/papershot.gd")

var input: InputSimulator
var papershot: Papershot
var test_results: Array = []
var all_passed: bool = true

func _init():
    call_deferred("_run_full_test")

func _run_full_test():
    print("================================")
    print("AI FULL TEST")
    print("================================")

    input = InputSimulator.new()
    papershot = Papershot.new()
    papershot.folder = "user://screenshots/"
    papershot.file_format = Papershot.PNG
    root.add_child(papershot)

    _initialize_game()
    _load_world()
    _test_inventory()
    _test_farm()
    _test_save_load()

    _print_report()
    quit(0 if all_passed else 1)

func _initialize_game():
    print("[INIT] Setting up new game")
    var game_state = root.get_node_or_null("GameState")
    if game_state:
        game_state.new_game()
        await process_frame
        await process_frame

func _load_world():
    print("[LOAD] Loading world scene")
    var err = change_scene_to_file("res://game/features/world/world.tscn")
    if err == OK:
        await process_frame
        await process_frame

func _test_inventory():
    print("[TEST] Inventory")
    var has_seeds = StateQuery.has_item("wheat_seed")
    var passed = StateQuery.get_inventory().size() > 0 and has_seeds
    end_test("Inventory", passed)
    print("  Has wheat seeds: " + str(has_seeds))

func _test_farm():
    print("[TEST] Farm")
    var plots = StateQuery.get_farm_plots()
    var passed = plots != null
    end_test("Farm", passed)
    print("  Farm accessible: " + str(passed))

func _test_save_load():
    print("[TEST] Save/Load")
    var save_ctrl = root.get_node_or_null("SaveController")
    if save_ctrl:
        var save_ok = save_ctrl.save_game()
        var save_exists = save_ctrl.save_exists()
        var passed = save_ok and save_exists
        end_test("Save/Load", passed)
    else:
        end_test("Save/Load", false)

func end_test(name: String, passed: bool):
    test_results.append({"name": name, "passed": passed})
    if not passed:
        all_passed = false
    print("  [" + ("PASS" if passed else "FAIL") + "] " + name)

func _print_report():
    print("")
    print("=== Test Report ===")
    var passed = 0
    var failed = 0
    for r in test_results:
        if r.passed:
            passed += 1
        else:
            failed += 1
    print("Total: " + str(test_results.size()) + " | Passed: " + str(passed) + " | Failed: " + str(failed))
    print("Status: " + ("ALL PASSED" if all_passed else "SOME FAILED"))
```

## Recommendations for AI Agents

1. **Run HPV via MCP/manual playthrough** - Preferred for playtesting
2. **Use HLC for fast logic checks** - Helpful for quick regression signals
3. **Chain tests together** - Run multiple test scripts sequentially
4. **Check test output carefully** - Some failures are expected in HLC

### Suggested Test Sequence

```bash
# 1. HPV (playability validation)
godot --path .

# 2. HLC (fast logic check)
godot --headless --script tests/run_tests.gd

# 3. HLC (AI smoke tests)
godot --headless --script tests/ai/test_basic.gd
godot --headless --script tests/ai/test_map_size_shape.gd
```

## See Also

- [ROADMAP.md](../execution/ROADMAP.md) - Development roadmap with testing phases
- [AGENT.md](../AGENT.md) - Agent guidance and testing patterns
- [tests/ai/](tests/ai/) - Example test scripts

[Codex - 2026-01-09]
