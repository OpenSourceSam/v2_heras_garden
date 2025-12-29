# Implementation Plan: Phase 2 Data and Content Integrity

## Overview
Validate all Phase 2 resource data with automated checks and keep templates usable without blocking strict integrity rules. Work will run sequentially across the Phase 2 lanes because a single agent is executing all tasks.

## Context
- Phase 2 scope and lane definitions are in `docs/execution/ROADMAP.md:141`.
- Resource integrity tests live in `tests/gdunit4/resource_integrity_test.gd:1`.
- Resource class schemas are defined in `src/resources/crop_data.gd`, `src/resources/item_data.gd`, `src/resources/recipe_data.gd`, `src/resources/dialogue_data.gd`, and `src/resources/npc_data.gd`.

## Design Decision
Extend `tests/gdunit4/resource_integrity_test.gd` (Option A) to skip TEMPLATE `.tres` files in strict checks while still validating that templates remain loadable and clearly labeled.

## Manual/Visual Notes
- Verify crop growth stages and item icons are assigned in the Godot inspector (no null textures).
- Confirm placeholder assets from `docs/execution/PLACEHOLDER_ASSET_SPEC.txt` exist and are referenced in the resources/scenes.
- Open minigame + crafting scenes to confirm texture assignments and watch the Output panel for missing-resource warnings.

## Implementation Phases

### Phase 2A: Lane A - Crops + Items (branch: lane-p2-crops-items)

**Objective**: Ensure crop/item resources are complete and placeholder-safe without template noise.

**Tasks**:
- [ ] Add a strict integrity test that excludes TEMPLATE resources (write failing test first).
- [ ] Update crop and item integrity checks to use strict, non-template lists.
- [ ] Ensure TEMPLATE crop/item resources have template-prefixed IDs and load cleanly.

**Success Criteria**:

Automated Verification:
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd --run-tests` passes.
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd` passes 5/5.

Manual Verification:
- [ ] None (Phase 2 is automated integrity validation).

### Phase 2B: Lane B - Dialogues + NPCs (branch: lane-p2-dialogues-npcs)

**Objective**: Validate dialogue/NPC resources and template labeling without blocking strict checks.

**Tasks**:
- [ ] Extend strict integrity checks to dialogue and NPC resources (skip templates).
- [ ] Enforce minimum dialogue line counts for non-template resources.
- [ ] Validate NPC default_dialogue_id references existing dialogue IDs.
- [ ] Ensure TEMPLATE dialogue resources have template-prefixed IDs and load cleanly.

**Success Criteria**:

Automated Verification:
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd --run-tests` passes.
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd` passes 5/5.

Manual Verification:
- [ ] None (Phase 2 is automated integrity validation).

### Phase 2C: Tester Lane - Phase 2 Close-Out (branch: lane-test-phase2)

**Objective**: Verify tests and update Phase 2 results in the roadmap.

**Tasks**:
- [ ] Run `tests/run_tests.gd` and full GdUnit4 suite after merges.
- [ ] Update Phase 2 status table in `docs/execution/ROADMAP.md`.

**Success Criteria**:

Automated Verification:
- [ ] `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd` passes 5/5.
- [ ] GdUnit4 suite passes without failures.

Manual Verification:
- [ ] Phase 2 status table reflects updated results.

## Dependencies
- Godot 4.5.1 editor/headless binary available for tests.
- Existing resource data under `game/shared/resources/`.

## Risks and Mitigations
- **Risk**: Templates block strict checks due to placeholder content.  
  **Mitigation**: Skip TEMPLATE `.tres` in strict integrity tests and validate templates separately.
- **Risk**: Dialogue/NPC references drift over time.  
  **Mitigation**: Add cross-reference checks for dialogue IDs in strict tests.
