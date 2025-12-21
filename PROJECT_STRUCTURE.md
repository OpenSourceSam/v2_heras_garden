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
|-- .github/                     [current]  Issue templates and workflows
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
|-- docs/                        [current]  Canonical documentation
|-- _docs/                       [current]  Long-form docs and archives
|-- tools/                       [current]
|-- scripts/                     [current]  Helper scripts
|-- game/                        [current]  Feature-based game structure
|   |-- autoload/                [current]  GameState, SaveController, etc.
|   |-- features/                [current]  player, farm_plot, ui, world, etc.
|   `-- shared/resources/        [current]  .tres data files
|-- src/                         [current]  Resource class scripts (legacy)
|   `-- resources/               [current]  crop_data.gd, item_data.gd, etc.
|-- assets/                      [current]
|-- tests/                       [current]
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


| Type | Extension | Location | Example |
|------|-----------|----------|---------|
| Script (gameplay) | .gd | `game/` | `game/features/player/player.gd` |
| Script (resource class) | .gd | `src/resources/` | `src/resources/crop_data.gd` |
| Scene | .tscn | `game/features/` | `game/features/player/player.tscn` |
| Data | .tres | `game/shared/resources/` | `game/shared/resources/crops/wheat.tres` |
| Asset | .png/.wav/.ttf | `assets/` | `assets/sprites/tiles/grass.png` |

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
2) Feature scenes and scripts live together under `game/features/`.
3) If a scene exists without a script, it must be called out in docs/execution/PROJECT_STATUS.md.
4) Never embed scripts directly in .tscn files; always reference files under `game/` (or `src/resources` for resource classes).

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
- Required: docs/, game/autoload/, src/resources/, tests/.

Phase 1: Core Loop
- Required: game/features/player, game/features/farm_plot, game/features/world, game/features/ui.
- Status: files exist; validation and cleanup pending.

Phase 2: Persistence
- Required: save/load logic and tests (game/autoload/save_controller.gd, planned tests).
- Planned: `tests/test_save_load.gd`.

Phase 3: Content Expansion
- Required: game/features/npcs, dialogue data, additional crops in game/shared/resources.
- Planned: quest and NPC content expansion.

Phase 4: Polish
- Required: HUD/inventory UI in game/features/ui and audio assets in assets/audio.

---


## Structure Audit Checklist (New)

Use this before starting a new task or merging branches:

1) Root files exist: `project.godot`, `README.md`, `docs/execution/PROJECT_STATUS.md`.
2) `game/` contains `autoload/`, `features/`, and `shared/resources/`.
3) `src/resources/` exists for resource class scripts (until migrated).
4) Every implemented scene has a script attached under `game/features/`.
5) `game/shared/resources/` contains templates and at least one real example per type.
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
