# Project Review Report - Circe's Garden v2 (2025-12-20)

## Scope
This report re-evaluates the project using the third-party draft as a rough input, verifies against the current repo state, and identifies serious risks. It also proposes two plausible answers for each open question so work can proceed without waiting on decisions.

## Executive Summary
The project is advanced beyond the stated Phase 0/1 documentation. The codebase now uses a feature-based `game/` layout, but multiple canonical docs still mandate the old `src/` + `scenes/` + `resources/` layout. This is the single biggest process risk because it causes new contributors (and AI agents) to place files in the wrong locations and contradicts the "immutable" Constitution. There are also two core gameplay risks: (1) farm plot planting uses a seed ID to fetch crop data (wrong ID), and (2) farm plot state is duplicated between GameState and FarmPlot nodes, so advancing the day does not update the actual plot nodes. These will break the core loop once playtesting begins.

## Assumed Answers (Best and Second Best)
These are provided so progress can continue even without explicit decisions.

1) Canonical folder structure
- Best answer: Declare the `game/` feature-based structure as canonical and update all governance docs accordingly.
- Second best: Revert code, scenes, and resources to the old `src/`, `scenes/`, `resources/` layout and remove `game/` from the canonical docs.

2) Phase 2 definition and sequencing
- Best answer: Phase 2 equals Persistence (save/load), per Constitution, and Phase 2 work should not proceed until Phase 1 is complete.
- Second best: Accept Phase 2 as Story Implementation (as in ROADMAP/PROJECT_STATUS), update the Constitution, and explicitly permit overlap with Phase 1 with a clear rule set.

3) FarmPlot.plant input type
- Best answer: `FarmPlot.plant(seed_item_id)` is allowed, but it must map seed -> crop by searching CropData where `seed_item_id` matches. (No ItemData schema change required.)
- Second best: `FarmPlot.plant(crop_id)` only; the caller converts seed -> crop via a new mapping stored in GameState (or an ItemData field added to SCHEMA).

4) Farm plot state ownership
- Best answer: GameState is the single source of truth. FarmPlot nodes read/write state through GameState, and the day-advance logic updates those nodes (signals or direct callbacks).
- Second best: FarmPlot nodes are authoritative; GameState aggregates their state only for save/load and UI.

## Findings (ordered by severity)

### Critical
1) Governance docs contradict the actual repo layout.
- Constitution, Project Structure, README, and Roadmap still describe the old folder layout, but the live project uses `game/` and points `project.godot` to `game/` paths.
- This invalidates the "immutable" structure rules and will cause new work to be placed incorrectly.
- References: `docs/design/CONSTITUTION.md:71`, `PROJECT_STRUCTURE.md:71`, `docs/execution/ROADMAP.md:100`, `README.md:27`, `project.godot:15`.

### High
2) FarmPlot.plant uses a seed ID as a crop ID.
- `plant(seed_id)` calls `GameState.get_crop_data(seed_id)` even though CropData IDs are crop IDs (e.g., "moly"), and seed IDs are separate ("moly_seed").
- This will fail silently for most seeds and blocks the core farming loop.
- References: `game/features/farm_plot/farm_plot.gd:47`, `docs/design/SCHEMA.md:17`.

3) Farm plot state is duplicated and desynchronized.
- GameState stores farm plots and updates them on `advance_day()`, but FarmPlot nodes keep their own local state and are not updated by day advancement.
- The Sundial advances day via GameState only; plots in the scene will not grow.
- References: `game/autoload/game_state.gd:21`, `game/autoload/game_state.gd:129`, `game/autoload/game_state.gd:151`, `game/features/farm_plot/farm_plot.gd:25`, `game/features/world/sundial.gd:3`.

4) Phase sequencing rules conflict across canonical docs.
- Constitution says Phase 2 is Persistence and phases are sequential; Roadmap and Project Status say Phase 2 is Story Implementation and already in progress.
- This undermines the workflow guardrails that are meant to prevent V1 failures.
- References: `docs/design/CONSTITUTION.md:181`, `docs/execution/ROADMAP.md:61`, `docs/execution/PROJECT_STATUS.md:20`.

### Medium
5) Input action `ui_cancel` is referenced but not defined in project settings.
- Several scripts assume `ui_cancel`, but it is not defined in `project.godot`.
- This breaks debug HUD toggle and crafting input unless Godot defaults are relied on (not guaranteed).
- References: `project.godot:41`, `game/features/ui/debug_hud.gd:51`, `game/features/ui/crafting_minigame.gd:78`, `game/autoload/constants.gd:102`.

6) Automated guardrails are weaker than the draft review claims.
- There is no `validate_schema` script in `scripts/`, and tests do not validate all autoloads (SceneManager, Constants, CutsceneManager).
- This increases the risk of silent drift.
- References: `scripts/guards/check_project_godot_autoload.py`, `tests/run_tests.gd:56`, `project.godot:21`.

## Recommendations (actionable, aligned with best answers)
1) Declare the `game/` layout as canonical and update docs to match.
- Update `docs/design/CONSTITUTION.md`, `PROJECT_STRUCTURE.md`, `docs/execution/ROADMAP.md`, `docs/design/SCHEMA.md` examples, and `README.md` tree.
- This is the single highest-leverage fix to prevent new work from being misplaced.

2) Fix farm plot planting and unify farm plot state.
- Choose state ownership (best: GameState). Add a mapping from seed -> crop (best: scan CropData registry by `seed_item_id`).
- Ensure `advance_day()` updates visible FarmPlot nodes (signal or direct references).

3) Normalize phase definitions and sequencing rules.
- Either enforce Phase 2 = Persistence (per Constitution) or formally revise the Constitution.
- Update `PROJECT_STATUS.md` and `ROADMAP.md` accordingly.

4) Define missing input actions explicitly.
- Add `ui_cancel` to input map in `project.godot` or swap references to existing actions.

5) Expand the test/guard coverage.
- Update `tests/run_tests.gd` to assert all required autoloads.
- Add a minimal schema/property name validator script (optional but low effort and high value).

## Notes on the Third-Party Draft
The draft correctly praised the level of documentation and guardrails, but it missed the critical divergence between canonical docs and actual code layout, and it overstated the existence of schema validation tooling. Those two issues are now the largest process risks.

## Closing
The project is on a strong technical foundation, but the current doc drift and farm plot logic issues are serious enough to block Phase 1 quality. Addressing the layout canonicalization and farm loop integration should be treated as immediate priorities.
