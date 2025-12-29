# Process Review (Phase 3): Testing + Verification Workflow

Audience: Senior PM (Claude)  
Date: 2025-12-29  
Scope: How Phase 3 validation was executed in this session, where time/effort concentrated, what repeated actions appeared most, and what could be streamlined to catch bugs earlier with less iteration overhead.

## Summary

This Phase 3 pass used a “headless-first, manual-when-needed” approach:

- Fast headless checks for baseline health and scene wiring.
- Automation-assisted “manual playthrough” using Godot MCP runtime inspection + scripted interactions.
- Small gameplay fixes discovered via playthrough.
- Re-running the same headless checks after changes to reduce regression risk.

Two gameplay issues were found via playthrough (not caught by the headless checks used here):

- “New Game” did not reset `GameState` before loading the world.
- Planting did not consume seeds from inventory.

## Tests and Commands Used

### Headless checks (fast)

These were run repeatedly before and after gameplay changes:

1) Baseline unit checks
```
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd
```

2) Smoke scene wiring
```
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30
```

3) Phase 3 scene-load smoke runner
```
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd
```

### Runtime verification (automation-assisted manual)

This was done via Godot MCP (single running project instance):

- `run_project` to start runtime
- `get_runtime_scene_structure` to locate nodes and confirm scene transitions
- `simulate_action_tap` / `simulate_input_sequence` to exercise D-pad/button navigation
- `evaluate_runtime_expression` to:
  - assert state (`GameState.inventory`, flags, day, gold)
  - call gameplay hooks (`interact()`, `SceneManager.change_scene(...)`)
  - force edge-case validation (save/load, quest flag gating)

## Where Time and Tokens Concentrated

### 1) Runtime node discovery after scene changes

The most repeated, time-consuming step was “re-finding” node paths after `SceneManager.change_scene(...)`.

Practical impact:
- Frequent `get_runtime_scene_structure` calls.
- Increased output volume and iteration time.

### 2) Timing-sensitive inputs (crafting/minigames)

Automating sequences that depend on timing windows was a common friction point.

Observed pattern:
- The crafting minigame input sequence often failed under automation even when the sequence was logically correct.
- This required fallback verification by invoking completion handlers to validate reward/consumption logic.

This is useful for validating state changes, but it is not a full substitute for confirming “feel” and input timing on real hardware.

### 3) Re-running the same three headless checks

This was repeated after changes, and it was usually cheap (seconds), but it is still repetitive.

This repetition is typically good risk control, but it could be streamlined into a single wrapper command/script if desired.

## What Was Repeated the Most (Streamline Targets)

1) `get_runtime_scene_structure`
- Used to recover paths after every scene transition and to verify which nodes exist.

2) `evaluate_runtime_expression`
- Used for state assertions and to drive interactions when input simulation was flaky.

3) `simulate_input_sequence`
- Used for D-pad/menu traversal and attempted crafting sequences.

If the project continues to rely on MCP playthroughs, these three are likely to remain the primary “iteration hotspots.”

## Relative Value: Which Checks Found Issues vs. Gave Confidence

This is based on this session’s outcomes (not a general guarantee).

### Headless checks

**`tests/run_tests.gd`**
- Strength: fast, catches broken autoloads, script parse/load issues, and basic invariants.
- Limitation: low behavioral coverage; it did not detect “New Game doesn’t reset state” or “seeds aren’t consumed”.

**`tests/smoke_test.tscn`**
- Strength: confirms the project boots a real scene and basic wiring works.
- Limitation: does not validate gameplay correctness beyond “it runs.”

**`tests/phase3_scene_load_runner.gd`**
- Strength: tends to catch missing resources/scenes/instantiation errors across many scenes quickly.
- Limitation: does not validate mechanics or economy correctness.

### Automation-assisted manual playthrough

- Strength: tends to catch real integration issues (flow, UX, state wiring) that are hard to cover with shallow headless checks.
- Limitation: time-sensitive interactions can be flaky under automation; it can produce false negatives (“input failed” when the feature is otherwise OK).

### GdUnit4 suite (not executed in this session)

The roadmap notes the suite previously passed. In general, this is a strong candidate for “highest value per minute” for regression detection, especially when tests cover specific gameplay expectations (like state reset and inventory consumption).

## Concrete Streamlining Ideas (Recommended)

### 1) Add two small regression tests for the bugs found

These two issues were found via playthrough and are good candidates for deterministic tests:

- “New Game resets state and grants starter seeds”
- “Planting consumes one seed”

This would reduce reliance on manual playthrough to catch recurring regressions.

### 2) Reduce runtime path hunting

Options that typically reduce `get_runtime_scene_structure` usage:

- Register key nodes into groups (`"player"`, `"world"`, `"ui_inventory"`, `"crafting_controller"`) and look them up via group queries.
- Add a lightweight debug helper singleton that returns canonical nodes (by group or cached references).
- Create a single “test harness” scene with stable node names and a consistent root layout for automation.

### 3) Add deterministic automation hooks for timing-sensitive minigames (debug builds)

For example:
- A debug-only mode that advances crafting/minigame state on demand (or bypasses timing checks) so automated runs can validate reward/consumption logic without relying on timing.

This would not replace real input testing, but it could reduce automation churn.

### 4) Wrap the three headless checks into one runner

If repetition becomes burdensome, a small runner script (PowerShell or GDScript) could execute the three headless checks in sequence and return a single pass/fail summary.

## Notes for Planning/Scope

The current roadmap emphasizes system validation (Phase 3) and device build readiness (Phase 4) more than “world looks finished.” If visual map build-out becomes a priority earlier, it may be worth rebalancing scope so map/art work is not effectively deferred to Phase 5.

---

Edit Signoff: [GPT-5.2 - 2025-12-29]

