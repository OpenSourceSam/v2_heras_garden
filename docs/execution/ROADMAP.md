# CIRCE'S GARDEN - DEVELOPMENT ROADMAP

Version: 3.0
Last Updated: 2025-12-27
Status: CANONICAL - Baseline reset
Purpose: Accurate, test-based roadmap for the current repo state.

---

## How to Use This Roadmap

For all contributors:
- Read CONTEXT.md first.
- Use this file for priorities, status, and phase definitions.
- Do one task at a time.
- Add checkpoints only at 50% and 100% for each phase.

---

## Current Phase Status

Last Updated: 2025-12-27
Current Phase: Phase 1 - Core Systems Verification
Status: Phase 0 baseline completed. Automated tests pass (tests/run_tests.gd
5/5 and GdUnit4 suite 32/32). Legacy Phase 0 validator (TEST_SCRIPT.gd) was
removed because it was unreliable (autoload timing). The smoke test previously
printed "[SmokeTest] OK" with placeholder UID warnings; the placeholder UID
issue was fixed, but the smoke test has not been re-run since. Existing code
may be present for many systems, but do not assume it is working until
re-tested in Phase 1.

---

## Baseline Test Results (Automated)

- tests/run_tests.gd (headless): PASS 5/5
  - Autoloads registered
  - Resource classes compile
  - TILE_SIZE constant
  - GameState initialization
  - Scene wiring (player, farm_plot, main_menu, dialogue_box, debug_hud)
- GdUnit4 suite (res://tests/gdunit4): PASS 32/32
- Legacy Phase 0 validator removed (TEST_SCRIPT.gd was unreliable due to
  autoload timing).
- tests/smoke_test.tscn (F6 smoke test): PASS (previously warned on placeholder
  UID in sundial.tscn and boat.tscn; warning fixed, smoke test not re-run)

---

## Known Issues (Non-MCP)

- Invalid UID warning for uid://placeholder_circe in
  game/features/player/player.tscn (GitHub issue #4).
- Duplicate root .gdignore can appear after restructure and cause Godot to
  ignore the project; remove duplicate with editor closed.
- TEST_SCRIPT.gd removed due to early autoload checks (see git history).
- Crop growth stages and several item icons use placeholder textures until
  production art is ready.

---

## Phase Overview

Phase 0: Baseline Audit (current)
Phase 1: Core Systems Verification
Phase 2: Data and Content Integrity
Phase 3: Balance and QA
Phase 4: Android/Retroid Build and Testing
Phase 5: Final Polish and Release

---

## PHASE 0: BASELINE AUDIT (CURRENT)

Objective: Establish what actually works today using automated tests and a
minimal smoke pass. Fix or retire unreliable validation.

Tasks:
- Run tests/run_tests.gd headless and record results in Current Phase Status.
- Run smoke test scene tests/smoke_test.tscn and record results.
- Document Phase 0 validator removal in PROJECT_STRUCTURE.md and keep
  tests/run_tests.gd as the baseline until a replacement is written.
- Reconcile test scope so automated coverage reflects reality (no false
  positives).

Success Criteria:
Automated Verification:
- .\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless
  --script tests/run_tests.gd passes 5/5.
- GdUnit4 suite passes (res://tests/gdunit4).
- Legacy Phase 0 validator removal is documented, and no references remain.
Manual Verification:
- Smoke test prints "[SmokeTest] OK" with no errors.

---

## PHASE 1: CORE SYSTEMS VERIFICATION

Objective: Verify the core loop works in real scenes (not just scripts).
Note: Code exists for many of these systems. Treat all items as unverified
until each is re-tested and confirmed.

Tasks:
- Player movement and interaction in game/features/world/world.tscn.
- Farm plot lifecycle: till, plant, advance day, harvest.
- Day/Night system: sundial advances day and farm plots update visuals.
- SceneManager transitions using game/features/ui/scene_test_a.tscn and
  game/features/ui/scene_test_b.tscn.
- Dialogue box: load a DialogueData resource, scroll text, choices, flag
  gating.
- Inventory UI: open/close, selection, item details, gold display.
- Crafting minigame: start recipe, complete success and fail paths.
- Minigames: herb identification, moon tears, sacred earth, weaving.
- NPC spawning and boat travel respond to quest flags.
- Save/Load: basic save/load preserves GameState (if SaveController is present).

Success Criteria:
Manual Verification:
- No runtime errors in console for the above scenes.
- Core loop is playable: plant -> grow -> harvest -> craft -> dialogue.
- Interactions and UI respond to D-pad only.

---

## PHASE 2: DATA AND CONTENT INTEGRITY

Objective: Ensure resources are complete and not null or stubbed.

Tasks:
- Ensure all CropData growth_stages textures are non-null (placeholders ok).
- Ensure item icons are present for all inventory items and minigame rewards
  (placeholders ok).
- Verify recipe resources exist for all required potions.
- Verify dialogue resources are at least minimal playable (5+ lines) and flags
  are valid.
- Verify NPCData resources exist and have valid IDs and dialogue references.

Success Criteria:
Manual Verification:
- No missing resource loads during playthrough.
- No null textures on crops or item icons.

---

## PHASE 3: BALANCE AND QA

Objective: Tune difficulty and identify critical bugs before device testing.

Tasks:
- Adjust crop growth days, crafting timing windows, and minigame difficulty.
- Full PC playthrough from Prologue to Epilogue.
- Log all CRITICAL and HIGH issues.

Success Criteria:
Manual Verification:
- 30-45 minute playthrough without soft-locks.
- Difficulty curve feels playable on D-pad.

---

## PHASE 4: ANDROID/RETROID BUILD AND TESTING

Objective: Produce a testable APK and validate on hardware.

Tasks:
- Configure Android export preset in Godot.
- Build debug APK.
- Run on Retroid Pocket Classic and perform 15-30 minute test.
- Log issues, fix CRITICAL bugs, repeat as needed.

Success Criteria:
Manual Verification:
- App installs and runs on device.
- Controls responsive and stable for 30+ minutes.

---

## PHASE 5: FINAL POLISH AND RELEASE

Objective: Replace placeholders, finalize narrative, and ship.

Tasks:
- Production art and audio.
- Final narrative pass.
- Performance optimizations.
- Release packaging.

Success Criteria:
Manual Verification:
- Full playthrough with final assets.
- Release build stable.

---

## Checkpoint Template

<!-- PHASE_X_CHECKPOINT: 50%|100% -->
Checkpoint Date: YYYY-MM-DD
Verified By: Name

Systems Status
| System | Status | Notes |
|--------|--------|-------|
| System Name | OK/IN PROGRESS/NEEDS ATTENTION/BLOCKED | Brief note |

Blockers (if any)
- Blocker description - GitHub Issue #XX

Files Modified This Phase
- path/to/file.gd - what changed

Ready for Next Phase: Yes/No
<!-- END_CHECKPOINT -->

---

## Notes

- Legacy checkpoints were removed as inaccurate; do not use them as evidence of
  completion.
- MCP issues are intentionally excluded from this roadmap per current directive.
