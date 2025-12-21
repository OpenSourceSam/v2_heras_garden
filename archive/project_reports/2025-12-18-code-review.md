# Code Review and Recommendations - Hera's Garden v2

Date: 2025-12-18
Scope: Core scripts under `src/`, key scenes under `scenes/`, project config (`project.godot`), tests in `tests/`, and top-level docs.

## Executive Summary
The foundation layer (autoloads, resource classes, tests) exists, but the project cannot currently exercise any of the planned gameplay because core scenes are not wired to scripts and the roadmap does not match the scene node structure. Documentation is also inconsistent on project identity and contains encoding corruption, which will mislead new contributors. The next milestone should focus on wiring and alignment before any new feature work.

## Findings (ordered by severity)

### Critical
1. Core scenes are not attached to their scripts, so intended behavior cannot run.
   - `scenes/entities/player.tscn` has no script attached even though `src/entities/player.gd` exists.
   - `scenes/entities/farm_plot.tscn` has no script attached even though `src/entities/farm_plot.gd` exists.
   - `scenes/ui/main_menu.tscn` has no script attached even though `src/ui/main_menu.gd` exists.
   - `scenes/ui/dialogue_box.tscn` has no script attached even though `src/ui/dialogue_box.gd` exists.
   - `scenes/_debug/debug_hud.tscn` has no script attached even though `src/ui/debug_hud.gd` exists.

2. Roadmap expectations do not match scene node names, which will break template code and @onready paths.
   - `DEVELOPMENT_ROADMAP.md` specifies a `Sprite` node and `Collision` node, but `scenes/entities/player.tscn` uses `Sprite2D` and `CollisionShape2D`.
   - `src/entities/player.gd` comments and warnings check for `Sprite2D`, while the roadmap template uses `Sprite`.
   - This mismatch guarantees that copy-pasted code from the roadmap will fail until names are aligned.

3. Two sources of truth exist for crop state with no synchronization.
   - `src/entities/farm_plot.gd` models plot state locally (state enum, planted_day, growth stage).
   - `src/autoloads/game_state.gd` maintains a separate `farm_plots` dictionary with its own state.
   - There is no integration layer to keep these in sync, which will cause divergence when both are implemented.

### High
4. Documentation identity and phase status drift creates onboarding confusion.
   - `README.md` and `DEVELOPMENT_WORKFLOW.md` use "Hera's Garden" while `PROJECT_STATUS.md` and `DEVELOPMENT_ROADMAP.md` use "Hera's Garden".
   - Phase 0 is marked in progress in `README.md`, but complete in `PROJECT_STATUS.md`.

5. Widespread encoding corruption in docs and comments makes guidance hard to read.
   - Garbled symbols appear in `README.md`, `PROJECT_STATUS.md`, `DEVELOPMENT_WORKFLOW.md`, `DEVELOPMENT_ROADMAP.md`, and comments in `src/entities/farm_plot.gd`.
   - This looks like an encoding conversion issue (likely Windows-1252 to UTF-8) and should be corrected.

6. Constants and save configuration are duplicated and inconsistent.
   - `src/autoloads/game_state.gd` defines `TILE_SIZE`, while `src/core/constants.gd` also defines `TILE_SIZE` and other shared values.
   - `src/autoloads/save_controller.gd` uses `SAVE_PATH = user://savegame.json` and `SAVE_VERSION = 2`, while `src/core/constants.gd` defines different save path and version.
   - This will lead to drift and inconsistent behavior when more systems reference constants.

### Medium
7. SceneManager is a stub and uses brittle scene discovery.
   - `src/autoloads/scene_manager.gd` uses the last root child as the current scene and lacks a fade overlay.
   - This is adequate for testing, but fragile once more autoloads or scenes are added.

8. Tests do not verify scene wiring or node name alignment.
   - `tests/run_tests.gd` only validates autoloads and basic GameState behavior.
   - `tests/smoke_test_scene.gd` checks for a `Player` node and `Ground`, but does not confirm scripts are attached or node paths exist.

### Low
9. Placeholder data blocks visual validation.
   - Crop `growth_stages` textures are null in `resources/crops/*.tres` and item icons are null in `resources/items/*.tres`.
   - This is fine for Phase 0 but limits feedback once movement and interaction are implemented.

## Recommendations (prioritized)
1. Wire scenes to scripts and align node names to the roadmap before any new logic.
   - Attach scripts to `scenes/entities/player.tscn`, `scenes/entities/farm_plot.tscn`, `scenes/ui/main_menu.tscn`, and `scenes/ui/dialogue_box.tscn`.
   - Rename nodes to match the roadmap or update the roadmap templates to reflect actual node names.

2. Choose a single source of truth for crop state and persist it consistently.
   - Option A: Treat `GameState` as authoritative and make `FarmPlot` a view/controller that mirrors it.
   - Option B: Treat `FarmPlot` as authoritative and remove `GameState.farm_plots`, storing only derived data.
   - Whichever path you choose, update save/load to serialize the authoritative state only.

3. Consolidate and clean documentation for identity, phase status, and process.
   - Standardize on "Hera's Garden" across `README.md`, `PROJECT_STATUS.md`, `DEVELOPMENT_WORKFLOW.md`, and `DEVELOPMENT_ROADMAP.md`.
   - Fix encoding corruption to restore readable text.
   - Add a short "Current Implementation State" table to `PROJECT_STATUS.md` so contributors can see what is stubbed.

4. Unify constants and configuration.
   - Move shared constants into `src/core/constants.gd` and reference it from `GameState`, `SaveController`, and tests.
   - Align save path/version and `TILE_SIZE` to a single definition.

5. Expand tests to protect wiring.
   - Add a test that instantiates `player.tscn` and asserts script + node paths.
   - Add a test that instantiates `farm_plot.tscn` and asserts script + child nodes.
   - Update `tests/run_tests.gd` to verify `TILE_SIZE` exists without relying on always-true checks.

## Suggested Implementation Sequence (next contributor)
1. Documentation cleanup and encoding fixes.
2. Scene wiring and node name alignment.
3. Implement Phase 1 tasks in order (movement -> interaction -> farm plot logic), update `PROJECT_STATUS.md` after each subsection.
4. Unify constants and save config.
5. Add/extend tests for wiring and state sync.

## Open Questions
- Should `GameState` or `FarmPlot` be authoritative for crop lifecycle state?
- Do you want `Constants` to be an autoload singleton or referenced by `class_name` only?
- Should docs live under `_docs/` with top-level shortcuts, or remain at the repo root?
