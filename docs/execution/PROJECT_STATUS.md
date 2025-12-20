# CIRCE'S GARDEN V2 - PROJECT STATUS

Last Updated: 2025-12-19
Current Phase: Phase 1 (in progress, scaffolding only)
Status: Documentation consolidated; restructure Phase 3-4 completed (paths updated)

Reference: docs/overview/DOCS_MAP.md
Senior PM Note: Review GitHub Issues for new error reports.
Note: `project.godot` is writable; the narrow guard in git hooks still protects critical autoload lines from unwanted changes.
Note: Local runtime snapshots (`RUNTIME_STATUS.md`) are ignored; use GitHub Issues + this file for reviewable status.

---

## Phase Completion

| Phase | Status | Progress |
|------|--------|----------|
| Phase 0: Foundation | Complete | 100% |
| Phase 1: Core Systems | In Progress (scaffolding only) | 15% |
| Phase 2: Story Implementation | In Progress (Prologue + cutscenes + NPCs started) | 15% |
| Phase 3: Minigames and Polish | Not Started | 0% |
| Phase 4: Content and Balance | Not Started | 0% |
| Phase 5: Deployment | Not Started | 0% |

---

## Recent Changes (2025-12-19)

### Documentation Consolidation (Complete)
- Archived 7 deprecated/redundant docs to `_docs/archive/`
- Renamed `DEVELOPMENT_ROADMAP.md` to `docs/execution/ROADMAP.md` (single source for all phases)
- Created `_docs/WORKFLOW_GUIDE.md` (consolidated workflow reference)
- Updated `docs/overview/DOCS_MAP.md` with new canonical structure
- Deleted junk files (nul, txt, tgz)

### Constants Drift Fix (Complete)
- Removed duplicate TILE_SIZE from `game_state.gd`
- Updated `save_controller.gd` to use `Constants.SAVE_FILE_PATH` and `Constants.SAVE_VERSION`
- All constants now centralized in `game/autoload/constants.gd`

### Scene Wiring (Complete - by Jr Engineer)
- Farm plot, main menu, dialogue box, and debug HUD scenes now have scripts attached

### Test Runner Repair (Complete - by Jr Engineer)
- Fixed encoding corruption in `tests/run_tests.gd`
- Added Test 5 for scene wiring validation

### Restructure Phase 3-4 (Complete)
- Moved game content into `game/` feature-based structure
- Updated `project.godot` autoload and main scene paths
- Updated tests and constants to new paths

### Guardrail: project.godot Autoload (Complete - by Jr Engineer)
- Added a narrow guard that blocks changes to `autoload/MCPInputHandler` in `project.godot`
- Guard runs in CI and can be enabled locally via git hooks

### Player Interaction System (Complete - by Jr Engineer)
- Added InteractionZone to player scene and interaction signal/logic
- Aligned player sprite node name to "Sprite" per template

### World Scene TileMap (Complete - by Jr Engineer)
- Created placeholder tileset and painted a 20x20 tile area in `world.tscn`

### Scene Manager Transition (Implemented - by Jr Engineer)
- Implemented SceneManager per template with fade stubs (manual transition test pending)

### Scene Transitions (Basic - by Jr Engineer)
- Implemented ColorRect + Tween fade in/out in SceneManager
- Headless tests pass; manual scene_test_a/b button validation still recommended

### Prologue Dialogue Data (In Progress - by Jr Engineer)
- Added initial prologue dialogue resources (Helios palace + Aiaia arrival)

### Cutscene System (In Progress - by Jr Engineer)
- Added cutscene base scene and script
- Added CutsceneManager autoload (registered in project.godot)

### NPC System (In Progress - by Jr Engineer)
- Added NPC base scene/script and placeholder NPC scenes
- Added NPC spawner and spawn points in world scene

### Farm Plot Lifecycle Script (Complete - by Jr Engineer)
- Implemented farm plot state machine and crop lifecycle per roadmap template

### Day/Night System (Complete - by Jr Engineer)
- Added Sundial interactable to advance the day and update crops

### main_menu.tscn Encoding Fix (Complete - by Jr Engineer)
- Removed UTF-8 BOM that caused a scene parse error during tests

### Input and Interaction Fixes (Complete - by Jr Engineer)
- Added WASD bindings to ui_left/right/up/down input actions
- Interaction now skips self and targets the first interactable body

### Dialogue Box UI (Complete - by Jr Engineer)
- Rebuilt dialogue box layout to match roadmap node paths (Panel/SpeakerName, Text, Choices)
- Updated dialogue_box.gd base type to Control for future dialogue manager logic

### Dialogue Manager Logic (Complete - by Jr Engineer)
- Implemented scrolling text, choices, and flag gating per roadmap template

### Scene Manager Transition Test (Complete - by Jr Engineer)
- Added two test scenes to validate SceneManager transitions (manual test confirmed)

### Crafting Minigame (Complete - by Jr Engineer)
- Added crafting minigame scene and input logic per roadmap template

### Recipe System (Complete - by Jr Engineer)
- Added RecipeData resource class and placeholder recipe resource
- Added crafting controller scene/script to connect recipes, inventory, and minigame
- Updated SCHEMA.md with RecipeData properties

### Repo Hygiene (Complete - by Jr Engineer)
- Logged GitHub Issue #3 for `nul` file and `.claude/settings.local.json` noise
- Added `.claude/settings.local.json` to `.gitignore` and removed from tracking

### CLAUDE.md Created (Complete)
- Created comprehensive guidance file for future Claude Code instances
- Covers architecture, commands, workflow, patterns, and anti-patterns
- Highlights lessons learned from V1 failures

### project.godot Read-Only Lock Removed (Complete)
- Removed read-only attribute from `project.godot` to allow Godot editor to save normally
- Narrow guard in git hooks still protects critical autoload lines
- Resolves "safe save failed" editor errors

---

## Current Implementation Reality (Snapshot)

**Scenes and Wiring:**
- Player scene: Script attached, movement works
- Farm plot scene: Script attached (TODO stub)
- Main menu scene: Script attached (TODO stub)
- Dialogue box scene: Script attached (TODO stub)
- Debug HUD scene: Script attached to `game/features/ui/debug_hud.gd`
- World scene: TileMapLayer painted with placeholder tileset

**Scripts:**
- Player: Movement and interaction implemented
- Farm plot: Full lifecycle implemented
- Dialogue box: Scrolling text and choices implemented (not yet wired to NPCs)
- SceneManager: Template transition with fade stubs
- Constants: Centralized, used by GameState and SaveController
- Sundial: Interactable advances day via GameState

**Tests:**
- Test runner repaired and functional
- 5 tests: autoloads, resource classes, TILE_SIZE, GameState init, scene wiring

---

## Canonical Documentation (New Structure)

**Primary Docs:**
- `README.md` - Project overview
- `docs/design/CONSTITUTION.md` - Immutable technical rules
- `docs/design/SCHEMA.md` - Data structures
- `docs/execution/PROJECT_STATUS.md` - This file
- `docs/execution/ROADMAP.md` - All phase implementation details
- `docs/design/Storyline.md` - Narrative

**Workflow:**
- `_docs/WORKFLOW_GUIDE.md` - Process rules for contributors

**Archived Docs (in `_docs/archive/`):**
- DEVELOPMENT_WORKFLOW.md
- ANTIGRAVITY_FEEDBACK.md
- PHASE_2_ROADMAP.md
- PHASES_3_TO_5_OUTLINE.md
- PROJECT_SUMMARY.md
- PLAYTESTER_GUIDE.md
- ASSET_CHECKLIST.md

---

## Known Issues

**HIGH Priority:**
- None currently logged

**MEDIUM Priority:**
- Root `.gdignore` appeared twice during restructure (causes Godot to ignore project). Delete if it reappears; keep editor closed during moves.
- Unreviewed local modifications detected in `CLAUDE.md` and `agent.md`; Senior PM should review source and intent before merge.

**LOW Priority:**
- MCP runtime introspection times out

---

## Phase 1 Required Systems (High Level)

- [x] Player movement
- [x] Player interaction system
- [x] Farm plot lifecycle (till, plant, grow, harvest)
- [x] World scene setup and TileMap painting
- [x] Crafting minigame (minimal)
- [x] Dialogue system (minimal)
- [x] Scene transitions (basic)
 - [x] Day/Night system (advance_day + sundial)

---

## Next Steps (Immediate)

1. Implement scene transitions (basic)
2. Review whether to keep or remove SceneManager test scenes after validation

---

## Project Identity

- Title: Circe's Garden
- Main character: Circe
- Inspiration: Greek mythology and the novel "Circe"
- Platform: Retroid Pocket Classic (Android 14, 1080x1240, d-pad only)

---

End of PROJECT_STATUS.md
