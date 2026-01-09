# Quest 2 Extension - Executive Handoff

**Date:** January 1, 2026
**Status:** Infrastructure Validated ✅ Ready for Implementation
**Owner:** Junior Engineer
**Supervisor:** [Senior Engineer]

---

## Quick Start (5 minutes)

### What You're Doing
Extending the Quest 1 visual test to include Quest 2, validating it with the debugger, then documenting what you learned.

### The Three Tasks
1. **Add 9 Quest 2 step functions** to `tests/visual/beta_mechanical_test.gd` (copy-paste code provided)
2. **Run & debug with breakpoints** to verify quest transitions work correctly
3. **Document findings** in `.godot/screenshots/full_playthrough/TESTING_METHODOLOGY.md`

### Success = Passing Exit Code
```bash
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --script tests/visual/beta_mechanical_test.gd
```
Should show: ✅ All 20 steps pass, exit code 0, 40 files generated

**Estimated Time:** 2-3 hours (1h coding + 1h debugging + 30min docs)

---

## Part 1: Code Implementation (1 hour)

### File to Edit
`tests/visual/beta_mechanical_test.gd` (currently at line 43)

### Current Structure (What's Already There)
```gdscript
func _run() -> void:
    # ... Quest 1 setup code ...

    await _step_main_menu_loaded()        // Step 1
    await _step_new_game_prologue_text()  // Step 2
    // ... steps 3-11 ...
    await _step_quest2_activation_marker()  // Step 11

    _print_summary()
    quit(0 if test_passed else 1)
```

### What You Need To Do

**Step 1:** Add directory constants after line 5:
```gdscript
const OUTPUT_DIR_Q2: String = ".godot/screenshots/full_playthrough/quest_02/"
```

**Step 2:** Update `_run()` function before the `quit()` line to verify Quest 1 completion:
```gdscript
    # Verify Quest 1 completed before proceeding to Quest 2
    if not _game_state.get_flag("quest_1_complete"):
        push_error("Quest 1 did not complete - aborting Quest 2")
        test_passed = false
        quit(1)

    # QUEST 2: Extract the Sap (Steps 12-20)
    await _step_quest2_start_dialogue()
    await _step_navigate_to_mortar()
    await _step_interact_mortar()
    await _step_crafting_minigame_entry()
    await _step_complete_crafting_pattern()
    await _step_crafting_success()
    await _step_return_to_world_q2()
    await _step_quest2_complete_dialogue()
    await _step_quest3_activation_marker_q2()
```

**Step 3:** Add the 9 Quest 2 step functions BEFORE the `_capture()` function (before line 226):

### Function 1: Quest 2 Start Dialogue (Step 12)
```gdscript
func _step_quest2_start_dialogue() -> void:
    print("\n[STEP 012] Quest 2 Start Dialogue")

    # Expected state: quest_2_active=true (already set), inventory has pharmaka_flower×3
    var hermes = _find_npc_by_id("hermes")
    if not hermes:
        hermes = _find_npc_by_id("aeetes")  # Fallback to Aeëtes

    if not hermes:
        push_error("No NPC found for Quest 2 start")
        test_passed = false
        return

    _tap_action("interact")
    var dialogue_box = await _wait_for_dialogue_box(4.5)
    await _delay(0.5)

    await _capture("012_quest2_start_dialogue", "Quest 2 start dialogue with NPC")
    await _advance_dialogue(dialogue_box, 20)
```

### Function 2: Navigate to Mortar (Step 13)
```gdscript
func _step_navigate_to_mortar() -> void:
    print("\n[STEP 013] Navigate to Mortar & Pestle")

    var world_scene = root.get_node_or_null("/root/World")
    if not world_scene:
        push_error("World scene not available")
        test_passed = false
        return

    var player = world_scene.get_node_or_null("Player")
    if not player:
        push_error("Player not found")
        test_passed = false
        return

    # Mortar & Pestle is at Vector2(0, 0) in Interactables hierarchy
    # This is the center/house area of the world
    await _move_player_to(world_scene, player, Vector2(0, 0))
    await _delay(0.3)

    await _capture("013_navigate_to_mortar", "Player at mortar & pestle station")
```

### Function 3: Interact with Mortar (Step 14)
```gdscript
func _step_interact_mortar() -> void:
    print("\n[STEP 014] Interact with Mortar & Pestle")

    _tap_action("interact")
    await _delay(0.5)

    await _capture("014_interact_mortar", "Interaction with crafting station")
```

### Function 4: Crafting Minigame Entry (Step 15)
```gdscript
func _step_crafting_minigame_entry() -> void:
    print("\n[STEP 015] Crafting Minigame Entry")

    # Wait for crafting minigame scene to load
    await _wait_for_scene("CraftingMinigame", 3.0)
    await _delay(0.5)

    await _capture("015_crafting_minigame_entry", "Crafting UI with pattern grid")
```

### Function 5: Complete Crafting Pattern (Step 16)
```gdscript
func _step_complete_crafting_pattern() -> void:
    print("\n[STEP 016] Complete Crafting Pattern")

    # Pattern: up, right, down, left (repeat 3 times = 12 total inputs)
    # Timing window: 2.0 seconds between inputs (we use 0.3s = safe margin)
    var pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]

    for _round in range(3):
        for action in pattern:
            _tap_action(action)
            await _delay(0.3)  # Well within 2.0s timing window

    await _delay(0.5)
    await _capture("016_crafting_pattern_complete", "Pattern completion state")
```

### Function 6: Crafting Success (Step 17)
```gdscript
func _step_crafting_success() -> void:
    print("\n[STEP 017] Crafting Success")

    await _delay(0.5)

    # Verify inventory changed: +transformation_sap, -pharmaka_flower×3
    if _game_state:
        var has_sap = _game_state.inventory.get("transformation_sap", 0) >= 1
        var pharmaka_count = _game_state.inventory.get("pharmaka_flower", 0)

        if not has_sap:
            push_error("Crafting failed: transformation_sap not found in inventory")
            test_passed = false

        if pharmaka_count != 0:
            push_error("Crafting failed: pharmaka_flower not consumed (count: %d)" % pharmaka_count)
            test_passed = false

        print("  [VERIFY] Inventory: sap=%d, pharmaka=%d" % [
            _game_state.inventory.get("transformation_sap", 0),
            pharmaka_count
        ])

    await _capture("017_crafting_success", "Crafting success with effects")
```

### Function 7: Return to World (Step 18)
```gdscript
func _step_return_to_world_q2() -> void:
    print("\n[STEP 018] Return to World (Quest 2)")

    await _wait_for_scene("World", 5.0)
    await _delay(0.5)

    await _capture("018_return_to_world", "World scene reloaded after crafting")
```

### Function 8: Quest 2 Complete Dialogue (Step 19)
```gdscript
func _step_quest2_complete_dialogue() -> void:
    print("\n[STEP 019] Quest 2 Complete Dialogue")

    # Set completion flags (like we did in Quest 1 Step 10)
    if _game_state:
        _game_state.set_flag("quest_2_complete", true)
        _game_state.set_flag("quest_2_complete_dialogue_seen", false)

    var world_scene = root.get_node_or_null("/root/World")
    if world_scene:
        var player = world_scene.get_node_or_null("Player")
        if player:
            await _move_player_to(world_scene, player, Vector2(160, -32))

    var npc = _find_npc_by_id("hermes")
    if not npc:
        npc = _find_npc_by_id("aeetes")

    if npc:
        _tap_action("interact")
        await _delay(0.5)
        if npc.has_method("interact"):
            npc.interact()

    var dialogue_box = await _wait_for_dialogue_box(4.5)
    await _delay(0.5)

    await _capture("019_quest2_complete_dialogue", "Quest 2 completion dialogue")
    await _advance_dialogue(dialogue_box, 20)
```

### Function 9: Quest 3 Activation (Step 20)
```gdscript
func _step_quest3_activation_marker_q2() -> void:
    print("\n[STEP 020] Quest 3 Activation Marker")

    if _game_state:
        _game_state.set_flag("quest_3_active", true)

    await _wait_frames(2)
    await _capture("020_quest3_activation", "Quest 3 ready to start")
```

---

## Part 2: Test & Debug (1 hour)

### Run 1: CLI Test (Autonomous)
```bash
cd c:\Users\Sam\Documents\GitHub\v2_heras_garden
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --script tests/visual/beta_mechanical_test.gd
```

**Expected Output:**
```
=== Beta Mechanical Test: Quest 1 ===
[STEP 001] Main Menu Loaded
... steps 1-11 ...
[STEP 011] Quest 2 Activation Marker
[STEP 012] Quest 2 Start Dialogue
... steps 12-20 ...
=== Beta Mechanical Test Complete ===
[OK] 020_quest3_activation
```

**Expected Exit:** Code 0 (success), all 20 steps show [OK]

### If CLI Test Fails:
Use the debugger to investigate:

**Debugger Launch (VS Code):**
1. Press `F5` → Select "Launch Beta Mechanical Test (Script)"
2. Godot will launch in debug mode

**Set Breakpoints:**
- Click on line number in [tests/visual/beta_mechanical_test.gd](tests/visual/beta_mechanical_test.gd) to set breakpoint
- Recommended: Set breakpoint at line in `_step_quest2_start_dialogue()` before `_capture()` call

**When Paused:**
- **Variables pane** (left sidebar): Shows `_game_state.inventory`, `_game_state.quest_flags`
- **Debug Console**: Type `print(_game_state.inventory)` to inspect state
- **Call Stack**: Shows function hierarchy (which step is running)

**Useful Watch Expressions:**
- `_game_state.inventory` - Shows current items (should have pharmaka_flower×3 at step 12)
- `_game_state.get_flag("quest_1_complete")` - Should be true before Quest 2
- `_game_state.get_flag("quest_2_active")` - Should be true starting at step 12

**Continue Execution:** Press F5 (or click "Continue" button) to resume

---

## Part 3: Document Findings (30 minutes)

### Create File:
Create new file: `.godot/screenshots/full_playthrough/TESTING_METHODOLOGY.md`

### Use This Template:

```markdown
# Visual Testing Methodology - Quest 1 + Quest 2 Sequential Testing

**Date:** [Today's date]
**Tester:** [Your name]
**Status:** [PASSED / NEEDS FIXES]

## Executive Summary

Document what you found:
- Did all 20 steps pass with exit code 0?
- How many files generated? (Should be 40 = 20 PNG + 20 ASCII)
- Any timing issues encountered?
- Any unexpected game behavior?

## Quest 1 Results (Steps 1-11)

- ✅ or ❌ All steps passed from previous run
- File count: 22 files

## Quest 2 Results (Steps 12-20)

Document for each step:
- Step 12 (Quest 2 Start): [✅ passed / ❌ failed with notes]
- Step 13 (Navigate to Mortar): [Any issues finding mortar?]
- Step 14 (Interact): [Worked?]
- Step 15 (Minigame Entry): [Scene loaded?]
- Step 16 (Pattern Input): [Pattern executed?]
- Step 17 (Success): [Inventory changed correctly?]
- Step 18 (Return World): [Scene transitions?]
- Step 19 (Completion): [Dialogue appeared?]
- Step 20 (Quest 3): [Flag set correctly?]

## Timing Observations

Document if you needed to adjust timing anywhere:
- Dialogue waits: 4.5s + 0.5s delay (from Quest 1) - did this work?
- Crafting pattern: 0.3s between inputs - any issues?
- Scene transitions: Any unexpected delays?

## Debugger Insights

Document what you found using debugger:
- Which breakpoints were most useful?
- What variables were important to watch?
- Any surprising state values?

## Issues Found (if any)

For each issue:
1. **What:** Describe the problem
2. **Where:** Which step?
3. **Evidence:** What did the test/screenshot show?
4. **Fix Applied:** What did you change?

## Lessons Learned

- What worked well from Quest 1's approach?
- What needs adjustment for future quests?
- Tips for the next engineer extending to Quest 3-11?

## Ready for Quest 3-11 Expansion?

- ✅ YES - [Justification]
- ❌ NO - [What needs to be fixed]

## File Count Verification

```
Expected: 40 files (20 PNG + 20 ASCII)
Generated: [Your count]
Location: .godot/screenshots/full_playthrough/
```
```

---

## Checklist

Use this to track your progress:

### Before You Start
- [ ] Read this entire document
- [ ] Open `tests/visual/beta_mechanical_test.gd` in VS Code
- [ ] Understand existing Quest 1 functions (review steps 1-11)

### Implementation
- [ ] Add OUTPUT_DIR_Q2 constant
- [ ] Update _run() function with Quest 2 calls
- [ ] Add Function 1 (Quest 2 Start Dialogue)
- [ ] Add Function 2 (Navigate to Mortar)
- [ ] Add Function 3 (Interact with Mortar)
- [ ] Add Function 4 (Minigame Entry)
- [ ] Add Function 5 (Pattern Input)
- [ ] Add Function 6 (Success)
- [ ] Add Function 7 (Return World)
- [ ] Add Function 8 (Completion Dialogue)
- [ ] Add Function 9 (Quest 3 Activation)
- [ ] Code compiles (check VS Code errors)

### Testing
- [ ] Run CLI test (step Part 2, Run 1)
- [ ] All 20 steps show [OK]
- [ ] Exit code is 0
- [ ] Verify 40 files generated
- [ ] If failed: Use debugger (Part 2) to investigate

### Documentation
- [ ] Create TESTING_METHODOLOGY.md
- [ ] Fill in all template sections
- [ ] Document any issues found
- [ ] Mark ready/not-ready for Quest 3-11

### Final Verification
- [ ] Run test one more time
- [ ] Confirm exit code 0
- [ ] Confirm 40 files
- [ ] Documentation complete
- [ ] Ready to hand off

---

## Important Notes

### Mortar & Pestle Location
The crafting station is located at **Vector2(0, 0)** in the Interactables node hierarchy. This should move the player to the center/house area of the world. If this doesn't work visually, you may need to adjust coordinates.

**How to debug position:**
1. In debugger, set breakpoint in `_step_navigate_to_mortar()`
2. Inspect `player.global_position` in Variables pane
3. If player doesn't move, check if position is wrong
4. Adjust Vector2 coordinates based on what you see

### Quest 2 NPC
The quest start might be with Hermes or Aeëtes. Code checks for both with fallback:
```gdscript
var npc = _find_npc_by_id("hermes")
if not npc:
    npc = _find_npc_by_id("aeetes")
```

If dialogue doesn't appear, this might be the issue. Check NPC ID in world scene.

### Inventory Verification
The test verifies inventory changes automatically:
```gdscript
var has_sap = _game_state.inventory.get("transformation_sap", 0) >= 1
var pharmaka_count = _game_state.inventory.get("pharmaka_flower", 0)
```

If this fails, check:
1. Does crafting minigame complete successfully?
2. Are items named correctly? (transformation_sap, not transformation_sap_potion, etc.)
3. Does minigame trigger item addition?

### Exit Code Meaning
- **Exit code 0** = All tests passed ✅
- **Exit code 1** = One or more tests failed ❌

Check console output for specific failure messages.

---

## Questions?

Look here first:
1. **Where is X in the code?** - Use Ctrl+F to search file
2. **What does this function do?** - Check inline comments in beta_mechanical_test.gd
3. **Why didn't step Y work?** - Check console error message + use debugger to inspect state
4. **Should I change X?** - No, only add the 9 Quest 2 functions, don't modify existing Quest 1 code

---

**Good luck! You've got this. 🚀**
