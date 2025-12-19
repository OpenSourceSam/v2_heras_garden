# Project Update Report and Consolidation Proposal - Hera's Garden v2

Date: 2025-12-19
Prepared by: Codex (junior PM mode)
Scope: repo audit, report corrections, branch consolidation plan, documentation consolidation plan, and forward plan.

---

## Executive Summary

The project is in an advanced scaffolding state with partial Phase 1 work. Some scripts exist but are not wired to scenes, several key systems are still TODO stubs, tests appear broken due to encoding corruption, and documentation is inconsistent on project identity and file reality. There is a more advanced branch (`origin/claude/phase1-clean`) that includes Phase 1 implementations and TileMap fixes, which should be evaluated and likely promoted as the integration base. A consolidation pass is required to align branches, fix documentation drift and encoding, and stabilize the core loop before feature expansion.

---

## Work Log (Steps Taken)

1) Read all existing reports in `reports/` to identify outdated or incorrect claims.
2) Audited core docs for identity, phase status, and structure drift: `README.md`, `PROJECT_STATUS.md`, `DEVELOPMENT_ROADMAP.md`, `DEVELOPMENT_WORKFLOW.md`, `PROJECT_SUMMARY.md`, `PROJECT_STRUCTURE.md`, `PLAYTESTER_GUIDE.md`, `ANTIGRAVITY_FEEDBACK.md`.
3) Inspected current code and scenes for wiring and completeness: `scenes/`, `src/`, `project.godot`, `tests/`.
4) Reviewed branch history and divergence between current branch and `origin/claude/phase1-clean`.

---

## Current State Snapshot (Facts Only)

### Identity and Naming
- `project.godot` uses "Hera's Garden" as the config name.
- `README.md`, `DEVELOPMENT_WORKFLOW.md`, `PROJECT_STRUCTURE.md` still say "Hera's Garden".
- Repository name is `v2_heras_garden`, which conflicts with in-game name.

### Scene Wiring (Actual)
- Script attached: `scenes/entities/player.tscn` -> `src/entities/player.gd`.
- Scripts NOT attached:
  - `scenes/entities/farm_plot.tscn` (no `src/entities/farm_plot.gd` attached).
  - `scenes/ui/main_menu.tscn` (no `src/ui/main_menu.gd` attached).
  - `scenes/ui/dialogue_box.tscn` (no `src/ui/dialogue_box.gd` attached).
  - `scenes/_debug/debug_hud.tscn` (no `src/ui/debug_hud.gd` attached).
- `scenes/world.tscn` contains a `TileMapLayer` with no tiles painted (empty visual world).

### Script Completeness (Actual)
- `src/entities/player.gd`: movement implemented, interaction system still TODO.
- `src/entities/farm_plot.gd`: full crop lifecycle is TODO stub.
- `src/ui/main_menu.gd`, `src/ui/dialogue_box.gd`: TODO stub.
- `src/ui/debug_hud.gd`: implemented, but scene not wired.
- `src/autoloads/scene_manager.gd`: stub with TODO for fade transitions.

### State and Constants Drift
- `src/core/constants.gd` defines `TILE_SIZE`, save path, and save version.
- `src/autoloads/game_state.gd` defines its own `TILE_SIZE`.
- `src/autoloads/save_controller.gd` uses different save path/version from `src/core/constants.gd`.

### Tests (Actual)
- `tests/run_tests.gd` contains broken string formatting and corrupted characters, which will fail parsing.
- `tests/test_game_state.gd` is referenced in docs but does not exist.
- `tests/smoke_test_scene.gd` checks for node presence only, not script attachment or behavior.

### Data and Assets
- Resource data exists for crops/items/dialogues/npcs, but textures are null in many `.tres` files (placeholders).
- `_docs/` is effectively empty, despite multiple docs claiming it holds the canonical documentation set.

### Branch Landscape (From git log)
- Current branch: `docs/code-review-2025-12-18` (scaffolding + docs + reports).
- `origin/claude/phase1-clean`: contains Phase 1 implementations (player, farming, crafting, dialogue), TileMap fixes, and removal of a large tracked executable.

---

## Corrections to Prior Reports

1) `reports/2025-12-18-code-review.md`
   - Outdated: Player scene now has a script attached (`scenes/entities/player.tscn` -> `src/entities/player.gd`).
   - Still correct: farm plot, main menu, dialogue box, and debug HUD scenes remain unwired.

2) `reports/antigravity_stability_review.md`
   - Incorrect: `src/entities/player.gd` and `src/entities/farm_plot.gd` do exist (they are stubs, but present).
   - Incorrect: references to `scripts/health_check.sh` and `scripts/validate_schema.sh` are invalid (no `scripts/` directory).

3) `reports/project_recommendations_dec_2025.md`
   - Largely still valid: identity drift, doc duplication, and scene-template mismatch remain.
   - Some items need updating: tests are broken by syntax/encoding rather than only lacking coverage.

---

## Key Gaps and Risks (Near-Term)

1) **Scene wiring gap**: Several critical scenes are not wired to their scripts, preventing any real gameplay loop.
2) **Test reliability gap**: `tests/run_tests.gd` appears invalid, which breaks automated validation and undermines confidence.
3) **Documentation drift**: Identity conflict and file claims do not match reality, confusing contributors.
4) **State duplication**: `GameState` and `FarmPlot` both store crop state with no synchronization.
5) **World visual gap**: `TileMapLayer` is empty on the current branch; `phase1-clean` has fixes.

---

## Branch Consolidation Plan (Proposal)

### Goal
Create one stable integration branch that contains the most complete gameplay state, then apply docs fixes and status alignment on top of it.

### Recommendation
Use `origin/claude/phase1-clean` as the integration base because it already includes Phase 1 implementations and TileMap fixes. Then cherry-pick or reapply the documentation updates and reports from the current branch.

### Steps
1) Freeze merges to avoid new divergence during consolidation.
2) Create `integration/consolidation` branch from `origin/claude/phase1-clean`.
3) Cherry-pick or manually port docs updates from `docs/code-review-2025-12-18`:
   - Reports under `reports/`
   - Any updates to workflow or guardrails that still apply
4) Validate on-device criticals:
   - World renders with tiles
   - Player moves and interacts
   - No scene load errors
5) Decide final branch to keep:
   - If validation passes, promote `integration/consolidation` to mainline.
   - Archive or delete stale branches after merge.
6) Tag a milestone (e.g., `phase1-core-loop-alpha`) for traceability.

### Decision Criteria
- Gameplay loop works in the world scene.
- No runtime errors at startup.
- Core systems are wired and testable.
- Docs and status reflect actual functionality.

---

## Documentation Consolidation Plan

### Goal
One canonical source of truth for identity, workflow, and status. Reduce duplication and fix encoding corruption.

### Actions
1) **Choose a single name**: Recommend "Hera's Garden" (aligned with storyline and in-game config).
2) **Define canonical docs** (top-level):
   - `README.md` (short overview + links)
   - `PROJECT_STATUS.md` (current state and next steps)
   - `DEVELOPMENT_WORKFLOW.md` (process rules)
   - `DEVELOPMENT_ROADMAP.md` (task templates)
   - `SCHEMA.md`, `CONSTITUTION.md`, `Storyline.md`
3) **Move or archive duplicates**:
   - Move legacy or verbose documents to `_docs/archive/`.
4) **Fix encoding corruption** in all docs and tests to restore readability.
5) **Update doc claims** to match reality:
   - Remove references to missing files
   - Update phase status and actual implementations
6) **Add a one-page doc map** (simple table of "file -> purpose") to prevent future drift.

---

## Forward Plan (Detailed)

### Phase A - Stabilize and Align (Week 1)
1) Consolidate branch as described above.
2) Fix scene wiring:
   - Attach scripts to `farm_plot.tscn`, `main_menu.tscn`, `dialogue_box.tscn`, `debug_hud.tscn`.
3) Fix tests:
   - Clean encoding and syntax in `tests/run_tests.gd`.
   - Add minimal wiring checks (script attached, node names aligned).
4) Resolve constants drift:
   - Centralize constants in `src/core/constants.gd`.
   - Align save path/version in `SaveController`.
5) Update docs:
   - Resolve identity drift and phase status.
   - Remove claims about missing files.

### Phase B - Core Loop (Weeks 2-3)
1) Player: finalize interaction system (input mapping, interact zone).
2) Farming: implement `FarmPlot` lifecycle and sync with `GameState`.
3) World: ensure tilemap is painted and playable on Retroid.
4) Crafting: make a minimal working minigame (one recipe).
5) Dialogue: basic dialogue flow with 1 NPC and 1 quest gate.

### Phase C - Story and Content (Weeks 4-7)
1) Implement storyline beats from `Storyline.md`.
2) Expand dialogue data and quest flags.
3) Add NPCs and basic schedules (lightweight).

### Phase D - Polish and Performance (Weeks 8-9)
1) Art pass on UI and key sprites.
2) Audio pass (music + SFX).
3) Performance profiling on Retroid device.

### Phase E - QA and Release (Week 10)
1) End-to-end testing on device.
2) Fix critical bugs and optimize load times.
3) Prepare final build and deployment checklist.

---

## Success Metrics and Goals

### Platform and Stability (Retroid)
- Game runs at stable 60 FPS on Retroid Pocket Classic.
- Memory stays below 512 MB peak.
- No crashes during a 60-minute continuous play session.
- Cold start time under 10 seconds on device.

### Core Experience
- Gameplay loop (plant -> grow -> harvest) works without errors.
- Narrative is coherent and faithful to "Circe" themes.
- Players report high emotional resonance and clarity of story beats.

### Art and Immersion
- Art style is consistent and intentionally "Circe-like" (mythic, moody, lush).
- All critical scenes have final art (no placeholder textures).
- World feels cohesive and inviting to explore.

### Joy and Gift Value
- Playtesters rate "overall enjoyment" at 4/5 or higher.
- At least 80 percent of testers would recommend it to a Greek mythology fan.
- The experience feels like a thoughtful gift to a "Circe" reader.

---

## Assumptions

1) Final title is "Hera's Garden" (matches storyline and project config).
2) Target device remains Retroid Pocket Classic (Android 14).
3) Scope remains a short, complete story with replayable free-play.
4) Existing placeholder assets will be replaced with final art by Phase D.

---

## Open Decisions Needed

1) Confirm final title and whether repo should be renamed to match.
2) Choose whether to adopt `origin/claude/phase1-clean` as the main base.
3) Decide the single source of truth for crop state: `GameState` vs `FarmPlot`.
4) Confirm acceptance timeline and any release constraints.

---

## Immediate Next Steps (Proposed Order)

1) Approve branch consolidation plan and base branch selection.
2) Assign doc cleanup and encoding fix as a priority task.
3) Wire missing scenes to scripts and validate in Godot.
4) Repair `tests/run_tests.gd` to regain automated validation.

---

End of report.
