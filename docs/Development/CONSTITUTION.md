# CIRCE'S GARDEN V2 - TECHNICAL CONSTITUTION

**Version:** 2.1
**Last Updated:** 2025-12-21
**Status:** IMMUTABLE - Do not modify without team consensus

---

## PURPOSE

This document defines the immutable technical rules for Circe's Garden V2.
Every agent and developer must follow these rules before writing code.

---

## 1) TILE SIZE (IMMUTABLE)

```gdscript
const TILE_SIZE: int = 32  # pixels
```

Rule: All tile-based calculations must use this constant (Constants.TILE_SIZE).

---

## 2) AUTOLOAD REGISTRATION (CRITICAL)

Rule: Autoloads must be registered in `project.godot` before any code references them.

Required autoloads:
```ini
[autoload]
GameState="*res://game/autoload/game_state.gd"
AudioController="*res://game/autoload/audio_controller.gd"
SaveController="*res://game/autoload/save_controller.gd"
SceneManager="*res://game/autoload/scene_manager.gd"
CutsceneManager="*res://game/autoload/cutscene_manager.gd"
Constants="*res://game/autoload/constants.gd"
```

Workflow:
1) Create autoload script
2) Register in project.godot
3) Restart Godot editor
4) Then reference it in other scripts

---

## 3) PROPERTY NAMING (STRICT)

Rule: Use exactly the property names defined in `docs/design/SCHEMA.md`.
Never guess or improvise property names.

---

## 4) FOLDER STRUCTURE (IMMUTABLE)

```
game/
  autoload/        # Singleton scripts
  features/        # Feature-based scenes + scripts
  shared/resources # .tres data files
src/resources/     # Resource class definitions (.gd)
assets/
  sprites/
  audio/
  fonts/
docs/
tests/
```

Rules:
- Scripts live in `game/` (except resource classes in `src/resources/`).
- Scenes live in `game/features/`.
- Data files live in `game/shared/resources/`.

---

## 5) RESOURCE WORKFLOW

Rule: Resource classes must exist before their .tres files.

Order:
1) Define class (e.g., `src/resources/crop_data.gd`)
2) Restart Godot editor
3) Create .tres data (e.g., `game/shared/resources/crops/wheat.tres`)

---

## 6) TILEMAP REQUIREMENTS

Rule: TileMapLayer nodes must have painted tiles before runtime.

Checklist:
- TileSet created with 32x32 grid
- Source image assigned
- Tiles painted in editor (not empty)

---

## 7) NODE PATH VALIDATION

Rule: @onready paths must match real node names exactly.
Verify in scene tree before writing code.

---

## 8) ANTI-PATTERNS (FORBIDDEN)

- Duplicate systems kept in parallel
- "Add it later" references to missing autoloads/resources
- Magic numbers instead of named constants
- Assumed existence of nodes or data

---

## 9) PHASES ARE SEQUENTIAL

Complete each phase fully before moving on.
Follow `docs/execution/DEVELOPMENT_ROADMAP.md` exactly.

---

## 10) TESTING REQUIREMENTS

Run:
```bash
godot --headless --script tests/run_tests.gd
```

If Godot is not on PATH:
```bash
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd
```

---

## 11) HANDOFF PROTOCOL

At the start of any session:
1) Read `CONTEXT.md`
2) Read `docs/execution/PROJECT_STATUS.md`
3) Read `docs/execution/DEVELOPMENT_ROADMAP.md`
4) Read `docs/design/SCHEMA.md`

---

End of CONSTITUTION.md


Edit Signoff: [Codex - 2026-01-12]

