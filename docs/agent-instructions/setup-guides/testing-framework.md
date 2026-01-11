# Testing Framework Guide

**Comprehensive testing procedures for Godot projects**

This guide documents the testing framework and best practices for validating game functionality, UX, and human playability.

---

## 🎯 Testing Philosophy

**Two-Layer Testing Strategy:**

1. **Headless Logic Check (HLC)**: Verify mechanics work (quest flags, inventory, save/load, crafting logic, day advancement)
2. **Headed Playability Validation (HPV)**: Ensure humans can see, understand, and interact with game UI

**Critical Context:** HLC can pass (118/118) but humans may not be able to play due to UX issues. We use both layers to ensure complete validation.

---

## 🧪 Testing Approaches

### Approach 1: Headless Logic Check (HLC) ✅

**Purpose:** Fast regression testing, CI/CD validation

**Command:**
```bash
Godot*.exe --headless --script tests/*.gd
```

**Best for:**
- Verifying mechanics work
- Quest flags progression
- Inventory operations
- Save/load functionality
- Crafting logic
- Day advancement
- Fast regression testing

**Structure:**
```gdscript
extends SceneTree

func _init():
    call_deferred("_run_all_tests")

func _run_all_tests():
    # Test logic here
    quit(0)  # Pass
    # quit(1)  # Fail
```

### Approach 2: Headed Playability Validation (HPV) ✅ **PREFERRED**

**Purpose:** Validate human playability and UX

**Command (typical):**
- Run the project in headed mode (editor run or MCP `run_project`).
- Use MCP/manual input to follow the quest flow.

**Best for:**
- UI visibility validation
- UX flow verification
- Visual state inspection
- Human interaction testing
- Capture visual state
- Programmatic debugging

**Why HPV:**
- **HLC log parsing** can tell you IF something broke, but not WHY the human experience is broken
- **HPV (headed) testing** lets agents see what renders and inspect game state at any moment
- Agents can autonomously inspect game state, verify UI visibility, capture visual state

---

## 🛠️ Programmatic Debugging

### Setup
- Launch the game in headed mode (editor or MCP).
- Use MCP runtime inspection for scene tree and UI state when helpful.
- Before HPV begins, confirm Godot editor and the debugger are running; if not, ask Sam to start them.
- If MCP will not connect while Godot is already running, close all Godot editor instances and relaunch a single editor for this project.
- HPV scope excludes minigames; if a minigame appears, skip it and mark completion via approved shortcuts, then log the skip.
- If MCP timeouts occur during quest flag restoration, use smaller batches or single-flag writes and verify after each batch.
- If quest flow is blocked by a spawn gate, log the gating issue and use the approved shortcut to keep HPV moving.

### Enhanced Test Scripts Can:
- Check UI visibility flags: `dialogue_box.visible`
- Verify nodes exist: `minigame_node != null`
- Capture and analyze screenshots
- Print game variables, node properties, state flags
- All without human interaction

### Key Insight
The limitation is NOT that agents need humans to click F5. The limitation is that HLC does not capture visual state. Use HPV programmatically.

---

## 📋 Godot Testing Best Practices

### 1. Use `extends SceneTree` for HLC Scripts

```gdscript
extends SceneTree

func _init():
    call_deferred("_run_all_tests")

func _run_all_tests():
    # Access autoloads via root.get_node_or_null("AutoloadName")
    var game_state = get_root().get_node_or_null("GameState")

    # Exit with quit(0) for pass, quit(1) for fail
    quit(0)
```

### 2. Test Game State Transitions Properly

```gdscript
# Reset state between tests
GameState.new_game()

# Progress flags sequentially
# Complete quest 4 before testing quest 5
assert(GameState.quest_4_complete == true)
GameState.complete_quest_5()

# Don't create inconsistent states
# e.g., quest_6_complete without quest_4_complete
```

### 3. Understand Default Game State

```gdscript
# new_game() sets prologue_complete=true by default
assert(GameState.prologue_complete == true)

# new_game() adds starter items
assert(GameState.inventory.has("wheat_seeds"))
assert(GameState.inventory["wheat_seeds"] >= 3)

# Account for these in test expectations
```

### 4. Test Structure

```gdscript
# Group related tests in functions
func test_hermes_quest_flow():
    # Test complete quest flow

func test_inventory_management():
    # Test inventory operations

# Use descriptive test names
func test_quest_4_to_5_transition_requires_completion():
    # Verify quest progression

# Provide failure details
func record_test(test_name: String, condition: bool, message: String):
    if not condition:
        print("FAILED: " + test_name)
        print("  " + message)
```

---

## 🎮 Test Categories

### Logic Tests (HLC)

**File Pattern:** `tests/phase*.gd`, `tests/*_test.gd`

**Examples:**
- `tests/phase3_dialogue_flow_test.gd` - Test dialogue system
- `tests/phase3_minigame_mechanics_test.gd` - Test minigame logic
- `tests/phase3_softlock_test.gd` - Test for game-breaking scenarios
- `tests/phase4_balance_test.gd` - Test game balance

**Command:**
```bash
Godot*.exe --headless --script tests/phase3_dialogue_flow_test.gd
```

### Visual Tests (HPV)

Use MCP/manual playthrough with notes or screenshots. Scripted Playthrough Testing (SPT) is automation and is avoided unless Sam explicitly asks.

---

## 🔍 Testing Workflows

### Standard Test Workflow

1. **Run HPV for playability validation**
   - Use MCP/manual playthrough in headed mode.

2. **Run HLC for fast logic checks when useful**
   ```bash
   Godot*.exe --headless --script tests/run_tests.gd
   ```

3. **Inspect Results**
   - HLC: Check console output for pass/fail
   - HPV: Check playthrough notes or screenshots

### Autonomous Testing Workflow

Use MCP to inspect runtime state while doing a headed playthrough. This keeps validation tied to real player inputs.

---

## 📊 Test Execution

### Run All Tests
```bash
# HLC
Godot*.exe --headless --script tests/run_tests.gd

# Expected output: "All tests passed!" or failure details
```

### Run Specific Test Category
```bash
# Dialogue flow
Godot*.exe --headless --script tests/phase3_dialogue_flow_test.gd

# Minigame mechanics
Godot*.exe --headless --script tests/phase3_minigame_mechanics_test.gd

# Soft-lock scenarios
Godot*.exe --headless --script tests/phase3_softlock_test.gd

# Balance testing
Godot*.exe --headless --script tests/phase4_balance_test.gd
```

### Run Visual Tests
Use MCP/manual playthrough in headed mode for visual validation.
Godot*.exe --path . --script tests/visual/beta_mechanical_test.gd

# With remote debug
Godot*.exe --path . --remote-debug tcp://127.0.0.1:6007 --script tests/visual/beta_mechanical_test.gd
```

---

## 📝 Test Result Interpretation

### HLC Output

**Pass:**
```
=== Test Suite: Phase 3 Dialogue Flow ===
✅ test_prologue_dialogue: PASSED
✅ test_quest_3_start: PASSED
✅ test_hermes_interaction: PASSED
All tests passed!
```

**Fail:**
```
=== Test Suite: Phase 3 Dialogue Flow ===
❌ test_quest_3_start: FAILED
  Expected quest_3_started=true, got false
  Quest flags: {prologue_complete: true, quest_2_complete: true}
Some tests failed!
```

### Visual Test Output

**Pass:**
```
=== Visual State Inspection ===
✅ Dialogue box visible: true
✅ Minigame node exists: true
✅ UI elements rendered correctly
Visual validation passed!
```

**Issues Found:**
```
=== Visual State Inspection ===
❌ Dialogue box visible: false
⚠️ Minigame node missing from scene tree
❌ Quest UI not rendering
Issues found - human may not be able to proceed
```

---

## 🛡️ Quality Assurance

### Before Claiming Tests Pass

1. **Run verification-before-completion skill**
   ```gdscript
   Skill(skill: "verification-before-completion")
   ```

2. **Check Both Layers**
   - HLC passes ✅
   - HPV confirms human playability ✅

3. **Document Results**
   - Test execution output
   - Any issues found
   - Verification steps taken

### Common Pitfalls to Avoid

❌ **Don't:** Run HLC → parse logs → guess at UI issues
✅ **Do:** Run HPV with programmatic debugging → inspect visual state → document findings

❌ **Don't:** Assume passing logic tests means human playability
✅ **Do:** Verify both logic and visual layers

❌ **Don't:** Skip visual testing for "speed"
✅ **Do:** Include visual validation in all test runs

---

## 🔗 Related Resources

**Comprehensive Guidance:**
- **Human playability testing:** `tests/visual/playthrough_guide.md` - Playthrough reference
- **Godot Tools reference:** `docs/testing/GODOT_TOOLS_GUIDE.md` - HPV guidance section

**Project Rules:**
- **Core rules:** [`../core-directives/project-rules.md`](../core-directives/project-rules.md#testing-methodology-requirements)
- **Skills for testing:** [`../core-directives/skill-inventory.md`](../core-directives/skill-inventory.md)

---

**Last Updated:** 2026-01-09
**Purpose:** Testing framework and best practices for Godot projects

[Codex - 2026-01-09]
[Codex - 2026-01-11]
