# Quest 2 Extension - Quick Reference Card

## The Job (One Page)

**What:** Add 9 Quest 2 step functions to `tests/visual/beta_mechanical_test.gd`
**Why:** Validate visual testing methodology extends beyond Quest 1
**Success:** Exit code 0, all 20 steps pass, 40 files generated

---

## Three Simple Steps

### 1️⃣ Edit the File
Open: `tests/visual/beta_mechanical_test.gd`

Add after line 43 in `_run()`:
```gdscript
# Quest 2 validation
if not _game_state.get_flag("quest_1_complete"):
    quit(1)

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

Add 9 new functions before line 226 (before `_capture()`)
See `QUEST_2_EXTENSION_HANDOFF.md` for complete code

### 2️⃣ Run the Test
```bash
cd c:\Users\Sam\Documents\GitHub\v2_heras_garden
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --script tests/visual/beta_mechanical_test.gd
```

Expected: Exit code 0, [OK] for all 20 steps

### 3️⃣ Document Findings
Create: `.godot/screenshots/full_playthrough/TESTING_METHODOLOGY.md`
Use template in `QUEST_2_EXTENSION_HANDOFF.md`

---

## Key Code Templates

### Pattern Input (Step 16)
```gdscript
var pattern = ["ui_up", "ui_right", "ui_down", "ui_left"]
for _round in range(3):
    for action in pattern:
        _tap_action(action)
        await _delay(0.3)
```

### Inventory Check (Step 17)
```gdscript
var has_sap = _game_state.inventory.get("transformation_sap", 0) >= 1
var pharmaka_count = _game_state.inventory.get("pharmaka_flower", 0)
if not has_sap or pharmaka_count != 0:
    test_passed = false
```

### Dialogue Wait (Standard)
```gdscript
var dialogue_box = await _wait_for_dialogue_box(4.5)
await _delay(0.5)
```

---

## If Something Breaks

**Test won't run:**
- Check syntax errors in VS Code (red underlines)
- Make sure you added all 9 functions
- Verify indentation matches existing code

**Step X fails:**
- Run in debugger: F5 → "Launch Beta Mechanical Test"
- Set breakpoint at failing step
- Inspect `_game_state.inventory` and `_game_state.quest_flags`
- Check console for error message

**Exit code 1:**
- Read console output for `push_error()` messages
- Each step has a specific error message
- e.g., "World scene not available" means world didn't load

---

## Important Values

| Item | Value |
|------|-------|
| Mortar Position | Vector2(0, 0) |
| Dialogue Wait | 4.5s |
| Dialogue Extra Delay | 0.5s |
| Pattern Input Delay | 0.3s |
| Scene Load Timeout | 3-5s |
| Expected Files | 40 (20 PNG + 20 ASCII) |

---

## File Locations

- **Test File:** `tests/visual/beta_mechanical_test.gd`
- **Output:** `.godot/screenshots/full_playthrough/`
- **Reference:** `QUEST_2_EXTENSION_HANDOFF.md`
- **Documentation:** `.godot/screenshots/full_playthrough/TESTING_METHODOLOGY.md`

---

## Success Checklist

- [ ] All 9 functions added
- [ ] Code compiles (no red errors)
- [ ] CLI test runs to completion
- [ ] Exit code 0
- [ ] 40 files generated
- [ ] TESTING_METHODOLOGY.md created
- [ ] Documentation complete

---

**Estimated Time: 2-3 hours**
**Difficulty: Moderate (mostly copy-paste)**
**Need Help: Check QUEST_2_EXTENSION_HANDOFF.md for details**
