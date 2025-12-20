# CIRCE'S GARDEN V2 - PROJECT STRUCTURE (SOURCE OF TRUTH)

Purpose: Define canonical repo layout and file placement rules for Circe's Garden.
Scope: This document must be updated before structural changes are made.

---

## Document Outline (Authoritative)

1) Canonical folder tree (current + planned)
2) File placement rules
3) Scene/script wiring rules
4) Naming conventions
5) Phase-based file map (required by phase end)
6) Structure audit checklist
7) Change control

---

## Canonical Folder Tree

Legend:
- [current] exists in repo
- [planned] expected by design, not yet present
- [optional] useful but not required
- [local-only] not part of the repo source of truth

```
v2_heras_garden/
|-- .mcp.json                    [current]  MCP tooling config
|-- .claude/                     [current]  Assistant config (optional use)
|-- project.godot                [current]  Godot project config
|-- icon.svg                     [current]
|-- icon.svg.import              [current]  Godot import metadata
|-- .gitignore                   [current]
|-- README.md                    [current]
|-- agent.md                     [current]
|-- RESTRUCTURE.md               [current]  Repo restructure instructions
|-- PROJECT_STRUCTURE.md         [current]
|-- TEST_SCRIPT.gd               [current]  Legacy validation script
|-- TEST_SCRIPT.gd.uid           [current]  Godot UID metadata
|-- reports/                     [current]
|   |-- 2025-12-18-code-review.md [current]
|   |-- antigravity_stability_review.md [current]
|   |-- project_recommendations_dec_2025.md [current]
|   |-- 2025-12-19-project-update.md [current]
|   |-- 2025-12-19-stopgap-roadmap.md [current]
|   `-- 2025-12-19-structure-audit.md [current]
|-- docs/                        [current]  Canonical documentation
|   |-- overview/
|   |   |-- DOCS_MAP.md          [current]
|   |   `-- README.md            [current]
|   |-- design/
|   |   |-- CONSTITUTION.md      [current]
|   |   |-- SCHEMA.md            [current]
|   |   `-- Storyline.md         [current]
|   `-- execution/
|       |-- PROJECT_STATUS.md    [current]
|       `-- ROADMAP.md           [current]
|-- _docs/                       [current]  Long-form docs and archives
|   |-- WORKFLOW_GUIDE.md        [current]
|   `-- archive/                 [current]
|       |-- ANTIGRAVITY_FEEDBACK.md [current]
|       |-- ASSET_CHECKLIST.md   [current]
|       |-- DEVELOPMENT_WORKFLOW.md [current]
|       |-- PHASES_3_TO_5_OUTLINE.md [current]
|       |-- PHASE_2_ROADMAP.md   [current]
|       |-- PLAYTESTER_GUIDE.md  [current]
|       `-- PROJECT_SUMMARY.md   [current]
|-- tools/                       [current]
|-- src/                         [current]  All GDScript code
|   |-- autoloads/               [current]
|   |   |-- game_state.gd        [current]
|   |   |-- audio_controller.gd  [current]
|   |   |-- save_controller.gd   [current]
|   |   `-- scene_manager.gd     [current]
|   |-- core/                    [current]
|   |   `-- constants.gd         [current]
|   |-- resources/               [current]
|   |   |-- crop_data.gd         [current]
|   |   |-- item_data.gd         [current]
|   |   |-- dialogue_data.gd     [current]
|   |   `-- npc_data.gd          [current]
|   |-- entities/                [current]
|   |   |-- player.gd            [current]
|   |   |-- farm_plot.gd         [current]
|   |   |-- npc.gd               [planned]
|   |   `-- interactable.gd      [planned]
|   `-- ui/                      [current]
|       |-- main_menu.gd         [current]
|       |-- dialogue_box.gd      [current]
|       |-- debug_hud.gd         [current]
|       `-- inventory_ui.gd      [planned]
|-- scenes/                      [current]  All .tscn files
|   |-- entities/                [current]
|   |   |-- player.tscn          [current]
|   |   |-- farm_plot.tscn       [current]
|   |   `-- npc.tscn             [planned]
|   |-- ui/                      [current]
|   |   |-- main_menu.tscn       [current]
|   |   |-- dialogue_box.tscn    [current]
|   |   `-- hud.tscn             [planned]
|   |-- _debug/                  [current]
|   |   `-- debug_hud.tscn       [current]
|   `-- world.tscn               [current]
|-- resources/                   [current]  All .tres data files
|   |-- crops/                   [current]
|   |   |-- TEMPLATE_crop.tres   [current]
|   |   |-- wheat.tres           [current]
|   |   |-- moly.tres            [current]
|   |   |-- nightshade.tres      [current]
|   |   `-- tomato.tres          [planned]
|   |-- items/                   [current]
|   |   |-- TEMPLATE_item.tres   [current]
|   |   |-- wheat_seed.tres      [current]
|   |   |-- wheat.tres           [current]
|   |   |-- moly_seed.tres       [current]
|   |   |-- moly.tres            [current]
|   |   |-- nightshade_seed.tres [current]
|   |   `-- nightshade.tres      [current]
|   |-- dialogues/               [current]
|   |   |-- TEMPLATE_dialogue.tres [current]
|   |   `-- circe_intro.tres     [current]
|   `-- npcs/                    [current]
|       `-- circe.tres           [current]
|-- assets/                      [current]
|   |-- sprites/                 [current]
|   |   `-- PLACEHOLDER_README.md [current]
|   |-- audio/                   [current]
|   `-- fonts/                   [current]
|-- tests/                       [current]
|   |-- run_tests.gd             [current]
|   `-- smoke_test_scene.gd      [current]
|-- addons/                      [current]
|-- .vscode/                     [optional]
|-- .venv/                       [local-only]
|-- .godot/                      [local-only]
|-- Simple Testing for Godot/    [local-only]
|-- godot_state_charts_examples/ [local-only]
`-- Godot_v4.5.1-stable_win64.exe/ [local-only]
```

Notes:
- The tree lists required and planned items; it is not an exhaustive listing of every asset.
- If a planned item becomes active work, update this file and docs/execution/PROJECT_STATUS.md together.

---

## File Placement Rules

### Rule 1: Scripts vs Scenes vs Data

| Type  | Extension | Location     | Example                          |
|-------|-----------|--------------|----------------------------------|
| Script | .gd     | `src/`        | `src/entities/player.gd`         |
| Scene  | .tscn   | `scenes/`     | `scenes/entities/player.tscn`    |
| Data   | .tres   | `resources/`  | `resources/crops/wheat.tres`     |
| Asset  | .png/.wav/.ttf | `assets/` | `assets/sprites/tiles/grass.png` |

### Rule 2: Script Attachment

- Scenes should reference scripts once that system is implemented.
- If a scene is a placeholder without a script, it must be noted in docs/execution/PROJECT_STATUS.md.

Example:
```
[node name="Player" type="CharacterBody2D"]
script = ExtResource("res://game/features/player/player.gd")
```

### Rule 3: Resource Loading

All .tres files load their class definition:
```
[gd_resource type="CropData" load_steps=5 format=3]
[ext_resource type="Script" path="res://src/resources/crop_data.gd"]
```

### Rule 4: Autoload Paths

Autoloads reference `game/autoload/*.gd`:
```ini
[autoload]
GameState="*res://game/autoload/game_state.gd"
```

---

## Scene and Script Wiring Rules

1) Node names in scenes must match `@onready` paths in scripts.
2) Debug scenes live under `scenes/_debug/` and scripts under `src/ui/`.
3) If a scene exists without a script, it must be called out in docs/execution/PROJECT_STATUS.md.
4) Never embed scripts directly in .tscn files; always reference `src/`.

---

## Naming Conventions

### Files

| Type      | Convention        | Example               |
|-----------|-------------------|-----------------------|
| Scripts   | `snake_case.gd`   | `game_state.gd`       |
| Scenes    | `snake_case.tscn` | `farm_plot.tscn`      |
| Resources | `snake_case.tres` | `wheat.tres`          |
| Assets    | `descriptive.png` | `hera_spritesheet.png`|

### Classes
```gdscript
class_name CropData  # PascalCase
```

### Variables
```gdscript
var current_day: int = 1          # snake_case
const TILE_SIZE: int = 32         # SCREAMING_SNAKE_CASE
```

### Functions
```gdscript
func add_item(item_id: String) -> void:  # snake_case
```

### Signals
```gdscript
signal inventory_changed(item_id: String)
```

### Node Names
```
Player              # PascalCase
Sprite              # PascalCase
CollisionShape2D    # Godot type name
```

---

## Phase-Based File Map (Required by End of Phase)

Phase 0: Foundation
- Required: docs, autoloads, resource classes, tests.

Phase 1: Core Loop
- Required: player, farm plot, world, interaction, dialogue UI basics.
- Status: files exist but wiring and implementations are incomplete.

Phase 2: Persistence
- Required: save/load logic and tests.
- Planned: `tests/test_save_load.gd`.

Phase 3: Content Expansion
- Required: npc, dialogue data, additional crops.
- Planned: `src/entities/npc.gd`, `scenes/entities/npc.tscn`.

Phase 4: Polish
- Required: HUD/inventory UI scenes and scripts, audio assets.
- Planned: `scenes/ui/hud.tscn`, `src/ui/inventory_ui.gd`.

---

## Structure Audit Checklist (New)

Use this before starting a new task or merging branches:

1) Root files exist: `project.godot`, `README.md`, `docs/execution/PROJECT_STATUS.md`.
2) `src/` contains `autoloads/`, `core/`, `resources/`, `entities/`, `ui/`.
3) `scenes/` contains `entities/`, `ui/`, `_debug/`, and `world.tscn`.
4) Every implemented system has a script attached to its scene.
5) `resources/` contains templates and at least one real example per type.
6) `assets/` contains placeholder or real assets for active features.
7) `tests/` has a runnable entry point and no syntax corruption.
8) Planned files are either created or explicitly listed in docs/execution/PROJECT_STATUS.md.
9) Any new directory is added to this file before use.

---

## Change Control

1) Update this file first for any structural changes.
2) Then create/move files to match the updated structure.
3) Finally, update docs/execution/PROJECT_STATUS.md to reflect actual state.

---

End of PROJECT_STRUCTURE.md
