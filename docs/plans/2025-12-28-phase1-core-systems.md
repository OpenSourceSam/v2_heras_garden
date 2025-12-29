# Implementation Plan: Phase 1 Core Systems Verification

## Overview
Close out Phase 1 by wiring missing farm loop UI, confirming D-pad-only navigation in key UI flows, and updating Retroid input mappings. Work follows the existing lane structure with separate dev lanes and a tester lane for validation and roadmap updates.

## Context
- Phase 1 scope and manual status table live in `docs/execution/ROADMAP.md:90`.
- Farm plot lifecycle logic lives in `game/features/farm_plot/farm_plot.gd:46`.
- Seed selection UI exists in `game/features/ui/seed_selector.gd:17`.
- World UI and inventory toggle live in `game/features/world/world.gd:3`.
- Retroid input mapping validation expects joypad bindings in `tests/run_input_map_test.gd:7`.
- Dialogue choices are generated dynamically in `game/features/ui/dialogue_box.gd:75`.

## Design Decision
Use minimal wiring (Option A) to connect farm plots to the existing SeedSelector, add Retroid joypad mappings directly in `project.godot`, and ensure dialogue choice buttons support D-pad focus without introducing a new UI routing layer.

## Implementation Phases

### Phase 1A: Lane A - Farm Loop Wiring (branch: lane-p1-farm-loop)

**Objective**: Make the in-world farm loop playable via D-pad with seed selection, day advance, and harvest.

**Tasks**:
- [ ] Add SeedSelector to the World UI scene and wire it up (`game/features/world/world.tscn`, `game/features/world/world.gd`).
- [ ] Emit a seed selection request when interacting with tilled plots (`game/features/farm_plot/farm_plot.gd`).
- [ ] Connect SeedSelector callbacks to plant the selected seed (`game/features/world/world.gd`).
- [ ] Add Retroid joypad mappings for `interact` and `ui_inventory` (`project.godot`).
- [ ] Add or update GdUnit4 coverage for seed selection -> plant flow as needed (`tests/gdunit4/farm_plot_test.gd` or a new focused test).

**Success Criteria**:

Automated Verification:
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_input_map_test.gd` passes.
- [ ] GdUnit4 suite passes for updated farm/seed tests.

Manual Verification:
- [ ] In `res://game/features/world/world.tscn`, interact with a tilled plot, pick a seed via D-pad, and see the crop appear.
- [ ] Advance day via sundial and confirm growth stage updates visually.
- [ ] Harvest a mature crop and verify inventory increments.

### Phase 1B: Lane B - Minigames + Dialogue (branch: lane-p1-minigames-dialogue)

**Objective**: Verify Moon Tears success path and add D-pad focus support for dialogue choices.

**Tasks**:
- [ ] Ensure dialogue choice buttons are focusable and first choice is focused by default (`game/features/ui/dialogue_box.gd`).
- [ ] Verify Moon Tears success path; if `catch_chime` is missing, log as follow-up and treat gameplay success as the Phase 1 requirement (`game/features/minigames/moon_tears_minigame.gd`).
- [ ] Update GdUnit4 coverage for dialogue choice focus/navigation as needed (`tests/gdunit4/dialogue_box_test.gd`).

**Success Criteria**:

Automated Verification:
- [ ] GdUnit4 suite passes for dialogue choice focus coverage.

Manual Verification:
- [ ] Dialogue choices can be navigated and selected via D-pad.
- [ ] Moon Tears minigame can be completed successfully.

### Phase 1C: Tester Lane - Phase 1 Close-Out (branch: lane-test-phase1)

**Objective**: Validate results and update the roadmap.

**Tasks**:
- [ ] Run `tests/run_tests.gd` and the full GdUnit4 suite after each lane merge.
- [ ] Update the Phase 1 manual results table and checkpoint in `docs/execution/ROADMAP.md`.

**Success Criteria**:

Automated Verification:
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd` passes 5/5.
- [ ] GdUnit4 suite passes.

Manual Verification:
- [ ] Phase 1 status table reflects verified systems with notes.

## Dependencies
- Godot 4.5.1 editor/headless binary available for automated runs.
- D-pad input actions mapped consistently in `project.godot`.

## Risks and Mitigations
- **Risk**: Dialogue focus does not move as expected with D-pad in dynamic button lists.  
  **Mitigation**: Explicitly set focus mode and grab focus on the first choice button.
- **Risk**: Farm loop still feels incomplete without seed consumption.  
  **Mitigation**: Keep loop functional for Phase 1; track seed consumption as Phase 2/3 tuning.
- **Risk**: Missing `catch_chime` SFX masks Moon Tears feedback.  
  **Mitigation**: Treat gameplay success as primary; log missing SFX for later polish.
