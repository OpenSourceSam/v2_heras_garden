# Implementation Plan: MCP Deep Manual Test Pass (Phase 1)

## Overview
Run a D-pad-only, MCP-driven manual test pass that mirrors human play to validate Phase 1 systems. The goal is to confirm real scene behavior (not just scripted tests), capture logs, and produce a clear PASS/FAIL report for each system.

## Context
- Phase 1 systems and manual verification requirements are defined in `docs/execution/ROADMAP.md:90`.
- MCP test capabilities and input simulation tooling are documented in `docs/MCP_SETUP.md:16`.
- D-pad-only input constraint for this project is listed under Phase 1 success criteria in `docs/execution/ROADMAP.md:110`.

## Design Decision
Use MCP to drive **D-pad + A/B/X/Y + Start/Select only**, avoiding mouse and L/R. Each test runs a real scene, simulates input sequences, and captures debug output. If runtime scene structure times out, fall back to debug output and visible UI responses for validation.

## Implementation Phases

### Phase 1: Harness and Input Baseline
**Objective**: Confirm MCP connection, input mappings, and logging reliability.

**Tasks**:
- [ ] Confirm MCP connectivity with `mcp__godot__get_project_info` and `mcp__godot__get_current_scene`.
- [ ] Capture input map via `mcp__godot__get_input_actions`; confirm `ui_up`, `ui_down`, `ui_left`, `ui_right`, `ui_accept`, `ui_cancel` exist.
- [ ] Start debug output streaming (`mcp__godot__stream_debug_output`) and verify `[MCP Input Handler] Input simulation ready` appears.

**Success Criteria**:

Automated Verification:
- [ ] N/A (manual pass only)

Manual Verification:
- [ ] MCP commands execute without connection errors.
- [ ] Input actions are available and respond during a running scene.

### Phase 2: Core World Loop + Day/Night + Farm
**Objective**: Validate the primary loop in real world scenes with D-pad inputs.

**Tasks**:
- [ ] Open and run `game/features/world/world.tscn` and verify movement with D-pad (no errors).
- [ ] Locate farm plot interaction in world; attempt **till -> plant -> advance day -> harvest** using D-pad + A/B.
- [ ] Use the sundial to advance day and confirm farm plot visuals update.
- [ ] Trigger boat travel and confirm location transitions (e.g., to `game/features/locations/scylla_cove.tscn` and `game/features/locations/sacred_grove.tscn`).
- [ ] Validate NPC spawning reacts to quest flags via normal interactions (no runtime errors).
- [ ] Attempt save/load flow via in-game UI (if available) using D-pad only.

**Success Criteria**:

Automated Verification:
- [ ] N/A (manual pass only)

Manual Verification:
- [ ] No runtime errors in debug output.
- [ ] Farm plot state changes are visible after each step.
- [ ] Day/night advance visibly affects world or farm plot state.
- [ ] Boat travel changes location without errors.
- [ ] Save/load preserves GameState (or is clearly unavailable).

### Phase 3: SceneManager Transitions
**Objective**: Confirm test scenes transition correctly using D-pad only.

**Tasks**:
- [ ] Run `game/features/ui/scene_test_a.tscn`; trigger its transition using D-pad inputs.
- [ ] Run `game/features/ui/scene_test_b.tscn`; trigger its transition using D-pad inputs.
- [ ] Confirm return triggers do not error.

**Success Criteria**:

Automated Verification:
- [ ] N/A (manual pass only)

Manual Verification:
- [ ] Scene transitions occur without errors and return triggers work.

### Phase 4: Dialogue Flow
**Objective**: Validate dialogue text scroll, choices, and flag gating.

**Tasks**:
- [ ] Run `game/features/ui/dialogue_box.tscn` and advance text with `ui_accept`.
- [ ] Verify text scrolls and choices appear where expected.
- [ ] Confirm any gating/branching responds to D-pad choice selection.

**Success Criteria**:

Automated Verification:
- [ ] N/A (manual pass only)

Manual Verification:
- [ ] Dialogue text scrolls and choices appear.
- [ ] Choice selection via D-pad is accepted without errors.

### Phase 5: Inventory + Crafting UI
**Objective**: Validate inventory navigation and crafting success/fail paths.

**Tasks**:
- [ ] Run `game/features/ui/inventory_panel.tscn`; open/close, navigate items, view details, and confirm gold display updates.
- [ ] Run `game/features/ui/crafting_controller.tscn` if it exposes a UI-driven crafting entry point.
- [ ] Run `game/features/ui/crafting_minigame.tscn`; complete **success** and **fail** paths using D-pad inputs.

**Success Criteria**:

Automated Verification:
- [ ] N/A (manual pass only)

Manual Verification:
- [ ] Inventory navigation is responsive to D-pad only.
- [ ] Crafting success and fail states are reachable and visible.

### Phase 6: Minigames (Success + Fail)
**Objective**: Validate minigame flow using D-pad only, including success and fail states.

**Tasks**:
- [ ] Herb identification: `game/features/minigames/herb_identification.tscn`.
- [ ] Moon tears: `game/features/minigames/moon_tears_minigame.tscn`.
- [ ] Sacred earth: `game/features/minigames/sacred_earth.tscn`.
- [ ] Weaving: `game/features/minigames/weaving_minigame.tscn`.
- [ ] For each minigame, intentionally trigger one **success** and one **fail** outcome.

**Success Criteria**:

Automated Verification:
- [ ] N/A (manual pass only)

Manual Verification:
- [ ] Each minigame accepts D-pad input, and both success and fail are reachable without errors.

### Phase 7: Cutscenes + Scene Flow
**Objective**: Validate cutscene transitions and ensure no runtime errors.

**Tasks**:
- [ ] Run `game/features/cutscenes/prologue_opening.tscn`; advance with D-pad inputs.
- [ ] Run `game/features/cutscenes/scylla_transformation.tscn`; advance with D-pad inputs.

**Success Criteria**:

Automated Verification:
- [ ] N/A (manual pass only)

Manual Verification:
- [ ] Cutscenes run and advance using D-pad-only input without errors.

## Dependencies
- Godot editor running with MCP plugin enabled and input handler active (`docs/MCP_SETUP.md:67`).

## Risks and Mitigations
- **Runtime scene structure timeouts**: Fall back to debug output and visible UI response; increase timeout if needed.
- **Unknown input actions**: Use `mcp__godot__get_input_actions` before testing and stick to `ui_*` actions.
- **UI focus issues**: If focus is lost, reset by restarting scene and using D-pad only.
