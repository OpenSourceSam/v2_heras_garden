## Runtime Limits
- Run only one Godot instance at a time when possible to avoid slowing the host machine.

## Tier 1 AI Testing Framework

**Reference:** [docs/testing/TIER1_TESTING.md](docs/testing/TIER1_TESTING.md)

The Tier 1 framework enables AI agents to perform 95% human-equivalent testing via headless GDScript scripts.

### Framework Components

| Component | Purpose | Key Capabilities |
|-----------|---------|------------------|
| InputSimulator | Simulate input | press_action, move_direction, confirm, wait |
| StateQuery | Query game state | get_gold(), has_item(), is_quest_complete() |
| ErrorCatcher | Assertions | assert(), assert_eq(), error counting |
| TestRunner | Base test class | test(), end_test(), screenshot() |

### Headless vs Headed Mode

**Headless Mode** (recommended for logic tests):
```bash
godot --headless --script tests/ai/test_full_playthrough.gd
```
- Fast, repeatable
- Verifies: gold, inventory, quests, save/load, scene loading
- Limitations: null player node, empty screenshots

**Headed Mode** (for visual verification):
```bash
godot --path . --script tests/ai/test_full_playthrough.gd --quit-after 15
```
- Opens window, captures actual visuals
- Verifies: NPC sprites, UI layout, tile rendering
- Use when headless tests pass but visuals need checking

### What AI Agents Can Verify

**Verified in headless:**
- Gold/inventory state
- Quest flags
- Save/load integrity
- Scene loading
- Farm data structure

**Requires headed mode:**
- Visual rendering
- Player node
- Screenshots
- NPC sprite verification

## Testing Workflow

These patterns tend to reduce iteration time during verification.

### Headless Checks (Fast)

Running these before and after changes can catch regressions early:

```powershell
# Unit tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# Smoke scene wiring
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30

# Scene load validation
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd

# AI Framework Test
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/ai/test_full_playthrough.gd
```

### Runtime Verification

When headless checks pass but you need to verify gameplay:
- `get_runtime_scene_structure` helps locate nodes after scene transitions
- `evaluate_runtime_expression` can assert state or call gameplay hooks directly
- Consider using node groups (e.g., `get_tree().get_nodes_in_group("player")`) when available - this can reduce path hunting

### Timing-Sensitive Tests

For minigames or features with timing windows:
- Input simulation can be flaky even when the sequence is correct
- Consider calling completion handlers directly via `evaluate_runtime_expression` to validate reward/consumption logic
- This doesn't replace real input testing but can reduce automation churn
