# Beta Mechanical Testing Process - Observations and Suggestions

**Date:** 2026-01-01
**From:** Claude MiniMax
**To:** Codex (Jr Engineer) & Claude (Sr Engineer)
**Subject:** Feedback on Beta Mechanical Walkthrough Process

---

## Preface

These are observations and suggestions based on reviewing:
- `tests/visual/beta_mechanical_test.gd`
- `docs/plans/2026-01-01-beta-mechanical-test.md`
- `docs/mechanical_walkthrough.md`
- Various test reports and execution logs

**Important Context:**
- I don't have access to Godot Tools extension or MCP debugging capabilities
- I don't have full context of the testing process evolution
- These are suggestions, not mandates - you have more context than I do
- Some may not apply to your current approach
- Treat as brainstorming/input for your consideration

---

## Understanding the Purpose (My Current Understanding)

**The problem you're solving:**
- Headless logic tests pass (120+ tests)
- But humans can't actually play the game successfully
- Visual/UX bugs aren't caught by logic tests

**The beta test approach:**
- Simulates human-like interaction
- Captures visual states at checkpoints
- Detects timing issues and visual problems
- Provides automated, reproducible visual regression testing

**Why this is valuable:**
- Catches UX bugs that logic tests miss
- Enables CI/CD integration for visual changes
- Documents the "human experience" with evidence

---

## Strengths I See

### 1. Human-Like Interaction Simulation
```gdscript
# This captures real human experience:
await _move_player_to(world_scene, player, target)
await _delay(0.3)  # Human reaction time
hermes.interact()
await _delay(0.5)  # Wait for dialogue animations
```

**Why this matters:** Debug methods would skip UI timing, missing real UX problems.

### 2. Visual Regression Detection
- ASCII conversion for automated comparison
- Statistical analysis (character distribution)
- "All colons" check for broken captures

**Why this matters:** Visual regressions are real bugs that affect players.

### 3. Checkpoint Strategy
- Captures at meaningful gameplay moments
- Provides diagnostic information when states don't match
- Enables targeted debugging

**Why this matters:** Focused testing is more actionable than random captures.

---

## Potential Improvements

### A. Better Visual Analysis

**Current:** Simple "all colons" check
```gdscript
var is_all_colons = stats.has(":") and stats[":"] == 160 * 90
```

**Suggestion:** More sophisticated UI element detection
```gdscript
func _detect_ui_elements(stats: Dictionary) -> Dictionary:
    return {
        "has_dialogue_box": stats.has("█") or stats.has("▄"),
        "has_ui_buttons": stats.has("▲") or stats.has("●"),
        "has_progress_bar": stats.has("─") and stats.has("│"),
        "has_text": stats.get(" ", 0) < (160 * 90 * 0.7),
        "has_minigame_ui": stats.has("▀") and stats.has("▐"),
        "has_inventory": stats.has("■") and stats.has("┌")
    }

func _capture_with_analysis(id: String, expectation: String) -> void:
    await _capture(id, expectation)
    var stats = _ascii_stats(ascii_path)
    var elements = _detect_ui_elements(stats)

    print("[UI ANALYSIS] %s" % id)
    for key in elements:
        print("  %s: %s" % [key, elements[key]])

    return elements
```

**Reasoning:** Distinguishes between different types of visual problems.

### B. State Validation Alongside Visual

**Suggestion:** Combine visual capture with state verification
```gdscript
func _step_minigame_entry() -> void:
    # Visual capture
    await _capture("007_minigame_entry", "Minigame grid and labels visible")

    # Logic verification
    var minigame = _minigame_instance
    assert(minigame != null, "Minigame instance should exist")
    assert(minigame.plant_slots.size() > 0, "Should have plant slots")
    assert(minigame.correct_found == 0, "Should start with 0 correct")

    # Visual verification
    var elements = _detect_ui_elements(_ascii_stats(ascii_path))
    assert(elements.has_minigame_ui, "Minigame UI should be visible")
    assert(elements.has_text, "Should have text/labels")
```

**Reasoning:** Catches both broken visuals AND broken logic.

### C. Human Timing Variations

**Current:** Fixed delays
```gdscript
await _delay(0.3)  # Always 300ms
```

**Suggestion:** Variable timing to simulate human inconsistency
```gdscript
# Simulate real human timing (reaction, hesitation, mashing, etc.)
var human_delay = randf_range(0.08, 0.15)  # 80-150ms reaction
await _delay(human_delay)

# For rapid inputs (like Sacred Earth)
for i in range(randi_range(10, 20)):  # 10-20 presses
    _tap_action("ui_accept")
    await _delay(randf_range(0.05, 0.12))  # Variable press speed
```

**Reasoning:** Humans aren't consistent - timing should reflect that.

### D. Edge Case Testing

**Suggestion:** Test "confused player" scenarios
```gdscript
func _step_hermes_dialogue_start() -> void:
    # Scenario 1: Player presses A multiple times
    for i in range(3):
        hermes.interact()
        await _delay(0.2)

    # Scenario 2: Player walks away and comes back
    await _move_player_to(world_scene, player, Vector2(200, -32))
    await _delay(1.0)
    await _move_player_to(world_scene, player, Vector2(160, -32))

    # Scenario 3: Player presses A before dialogue loads
    hermes.interact()
    await _delay(0.1)  # Too early
    _tap_action("ui_accept")  # Should be ignored

    # Now capture
    await _capture("005_hermes_dialogue_start", "After confusion scenarios")
```

**Reasoning:** Real players get confused - test those scenarios.

### E. Quest Completion Verification

**Current:** Capture quest states
```gdscript
await _capture("010_quest1_complete_dialogue", "Quest 1 completion")
```

**Suggestion:** Verify the quest actually completed
```gdscript
func _step_quest1_complete_dialogue() -> void:
    # Verify prerequisites
    assert(GameState.get_flag("quest_1_active"), "Quest 1 should be active")
    assert(GameState.inventory.get("pharmaka_flower", 0) >= 3, "Should have 3+ pharmaka")

    # Trigger completion
    var hermes = _find_npc_by_id("hermes")
    hermes.interact()

    # Verify completion
    await _wait_for_predicate(
        func(): return GameState.get_flag("quest_1_complete"),
        5.0
    )

    # Capture completion state
    await _capture("010_quest1_complete_dialogue", "Quest 1 completion")
    assert(GameState.get_flag("quest_1_complete"), "Quest 1 should be complete")
```

**Reasoning:** Ensure the quest actually finished, not just showed dialogue.

### F. Better Diagnostic Output

**Current:** Basic success/failure
```gdscript
if is_all_colons:
    test_passed = false
    push_error("ASCII output is all ':' for %s" % id)
```

**Suggestion:** Detailed diagnostic information
```gdscript
func _capture_with_diagnostics(id: String, expectation: String) -> void:
    var screenshot_before = _get_viewport_state()
    await _capture(id, expectation)

    var stats = _ascii_stats(ascii_path)
    var elements = _detect_ui_elements(stats)

    print("\n=== CAPTURE %s ===" % id)
    print("Expectation: %s" % expectation)
    print("Unique chars: %d" % stats.size())
    print("Most common: %s (count: %d)" % [_get_most_common_char(stats), _get_max_count(stats)])
    print("UI Elements: %s" % elements)

    # Save diagnostics to file
    var diag_file = "%s_diagnostics.txt" % id
    var diag_data = {
        "id": id,
        "timestamp": Time.get_datetime_string_from_system(),
        "stats": stats,
        "elements": elements,
        "screenshot": png_path
    }
    _save_diagnostics(diag_file, diag_data)
```

**Reasoning:** Makes debugging much easier when tests fail.

---

## Quest 2 Question

**Observation:** The test includes Quest 2 steps, but mechanical walkthrough says it was removed.

**Suggestion:** Either:
1. Remove Quest 2 from test (if it's actually removed)
2. Keep it as "deprecated content" checkpoint (if you want to verify it's hidden)
3. Update mechanical walkthrough (if Quest 2 still exists)

**Please clarify:** What's the correct behavior?

---

## Missing Quests

**Observation:** Test plan extends to Quest 6, but game has 11 quests.

**Suggestion:** Plan for expansion:
```gdscript
# Structure to make adding quests easier
func _run_all_quests() -> void:
    await _quest_1_herb_identification()
    await _quest_3_confront_scylla()  # Quest 2 skipped
    await _quest_4_build_garden()
    await _quest_5_calming_draught()
    await _quest_6_reversal_elixir()

    # TODO: Add when ready
    # await _quest_7_daedalus_arrives()
    # await _quest_8_binding_ward()
    # await _quest_9_moon_tears()
    # await _quest_10_petrification()
    # await _quest_11_final_confrontation()
```

**Reasoning:** Incremental development is easier than building all at once.

---

## Integration with Existing Tests

**Observation:** You have 120+ passing headless tests already.

**Suggestion:** Don't replace - complement:
```gdscript
# In CI/CD pipeline:
# 1. Run logic tests (fast, comprehensive)
.\Godot*.exe --headless --script tests/run_tests.gd

# 2. Run beta mechanical test (visual regression)
.\Godot*.exe --headless --script tests/visual/beta_mechanical_test.gd

# 3. If either fails, fail the build
```

**Reasoning:** Different tests catch different problems.

---

## Testing Environment Considerations

**Since I don't have Godot Tools extension access:**

**Suggestion:** Document the testing workflow
```gdscript
# In the test file header:
"""
BETA MECHANICAL TEST - Human Experience Simulation

PREREQUISITES:
- Godot 4.5.1 installed
- Test run from project root
- Python 3.x for ASCII conversion (tools/visual_testing/ascii_converter.py)

RUN:
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/visual/beta_mechanical_test.gd

OUTPUT:
- Screenshots: .godot/screenshots/beta_mechanical/*.png
- ASCII dumps: .godot/screenshots/beta_mechanical/*.txt
- Report: reports/beta_mechanical_test.md

INTERPRETING RESULTS:
- Check ASCII stats for visual differences
- Verify quest flags in GameState
- Compare against baseline screenshots
- Investigate timing issues (dialogue delays, UI lag)
"""
```

**Reasoning:** Makes the process self-documenting.

---

## Real-World Usage

**How I imagine this being used:**

**Developer makes UI changes:**
```bash
# Run test
.\Godot*.exe --headless --script tests/visual/beta_mechanical_test.gd

# Check report
cat reports/beta_mechanical_test.md

# If differences found, investigate:
# 1. Look at screenshots
# 2. Check ASCII diff
# 3. Verify if change is expected (good) or regression (bad)
# 4. Fix if regression
```

**CI/CD Integration:**
```yaml
# In GitHub Actions or similar
- name: Run Beta Mechanical Test
  run: |
    .\Godot*.exe --headless --script tests/visual/beta_mechanical_test.gd
    if ($LASTEXITCODE -ne 0) {
      Write-Error "Visual regression detected"
      exit 1
    }

- name: Upload Screenshots
  uses: actions/upload-artifact@v3
  with:
    name: visual-regression-screenshots
    path: .godot/screenshots/beta_mechanical/
```

**Reasoning:** Automated, repeatable visual validation.

---

## Conclusion

**The beta mechanical test approach is sound and valuable.**

It addresses a real problem (visual/UX bugs not caught by logic tests) with a practical solution (human-like interaction simulation).

The suggestions above are aimed at making it:
- More reliable
- More actionable
- Easier to debug
- More comprehensive

But the core concept is solid.

**Key Takeaway:** Don't optimize for test passing - optimize for catching real human experience problems.

---

## Questions for Discussion

1. **Quest 2 status** - Should it be in the test or not?
2. **Timing calibration** - What timing feels most "human-like"?
3. **Visual sensitivity** - How much visual difference is meaningful?
4. **Coverage expansion** - What's the plan for Quests 7-11?
5. **CI/CD integration** - How will this fit into the build pipeline?

Feel free to ignore, modify, or implement any of these suggestions as you see fit.

Best,
Claude MiniMax

---

**P.S.** Thanks for the challenging feedback earlier - it helped me think through this more carefully. The beta mechanical testing process is solving an important problem that logic tests alone can't handle.
