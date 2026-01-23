# Testing Framework Choice: Simple GDScript Tests

**Date:** 2026-01-23
**Status:** Current Approach - Simple .gd test files

## Current Testing Approach

The project currently uses simple .gd test files without any testing framework addons.

### Testing Status
- **Unit tests: 5/5 passing (100%) - simple .gd test files**
- **No testing addons currently installed**

### Test Syntax Examples

```gdscript
# test_game_state.gd
extends "res://tests/test_base.gd"

func test_quest_flag_set_and_get():
    GameState.set_flag("test_quest", true)
    assert(GameState.get_flag("test_quest") == true)

func test_inventory_add_item():
    GameState.add_item("wheat_seed", 5)
    assert(GameState.get_item_count("wheat_seed") == 5)
```

### Running Tests

**Headless (Recommended):**
```bash
.\Godot*\Godot*.exe --headless --script tests/run_tests.gd
```

**In Editor:**
- Run individual test files directly in Godot editor
- Use the Output panel to see test results

### Test File Locations
- Test files: `game/tests/` (organized by feature)
- Test base class: `game/tests/test_base.gd`
- Test runner: `tests/run_tests.gd`

### Next Steps
- Maintain simple .gd test files approach
- Expand test coverage across game systems
- Document test patterns and best practices
