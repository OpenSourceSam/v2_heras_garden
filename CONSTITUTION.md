# HERA'S GARDEN V2 - TECHNICAL CONSTITUTION

**Version:** 2.0
**Last Updated:** December 16, 2025
**Status:** IMMUTABLE - Do not modify without team consensus

---

## PURPOSE

This document defines the **immutable technical rules** for Hera's Garden V2. Every AI agent and developer MUST reference this document before writing any code. These rules prevent the architectural failures that plagued V1.

---

## 1. TILE SIZE (IMMUTABLE)

```gdscript
const TILE_SIZE: int = 32  # pixels
```

**Rule:** ALL tile-based calculations MUST use this constant. Never hardcode 16, 32, or any other value.

**Violations in V1:**
- Random mix of 16px and 32px throughout codebase
- Magic numbers in position calculations
- Misaligned sprites and collision shapes

---

## 2. AUTOLOAD REGISTRATION (CRITICAL)

**Rule:** Autoloads MUST be registered in `project.godot` BEFORE any code references them.

### Required Autoloads (in order):

```ini
[autoload]
GameState="*res://src/autoloads/game_state.gd"
AudioController="*res://src/autoloads/audio_controller.gd"
SaveController="*res://src/autoloads/save_controller.gd"
```

**V1 Failure:** DialogueManager existed but wasn't registered → runtime crashes.

**Workflow:**
1. Create autoload script first
2. Register in project.godot immediately
3. Restart Godot editor
4. THEN reference it in other scripts

---

## 3. PROPERTY NAMING (STRICT)

**Rule:** Use EXACTLY the property names defined in `SCHEMA.md`. Never guess, never hallucinate.

### Canonical Property Names:

| Resource | Property | Type | V1 Hallucinations |
|----------|----------|------|-------------------|
| CropData | `growth_stages` | Array[Texture2D] | ❌ sprites, stages_textures |
| CropData | `days_to_mature` | int | ❌ growth_time, days |
| ItemData | `id` | String (snake_case) | ❌ item_id, name |
| GameState | `inventory` | Dictionary | ❌ player_inventory |
| GameState | `quest_flags` | Dictionary | ❌ flags, questFlags |

**Enforcement:** When referencing ANY property, check `SCHEMA.md` first.

---

## 4. FOLDER STRUCTURE (IMMUTABLE)

```
src/
  autoloads/     → Singleton scripts ONLY
  resources/     → Resource class definitions (.gd files)
  entities/      → Game object scripts (player.gd, npc.gd, etc.)
  ui/            → UI scripts

scenes/          → .tscn files ONLY
resources/       → .tres data files ONLY
assets/
  sprites/       → PNG/JPG sprite sheets
  audio/         → WAV/OGG sound files
  fonts/         → TTF font files

_docs/           → Documentation (markdown)
tests/           → Test scripts
```

**Rules:**
- Scripts (.gd) go in `src/`
- Scenes (.tscn) go in `scenes/`
- Data files (.tres) go in `resources/`
- NO mixing of scripts and scenes in same folder

---

## 5. RESOURCE WORKFLOW

**Rule:** Resource classes must be created BEFORE their data files.

### Correct Order:
1. Define class: `src/resources/crop_data.gd` (class_name CropData)
2. Restart Godot editor (or reload project)
3. Create data: `resources/crops/wheat.tres` (type: CropData)

**V1 Failure:** Created .tres files before class existed → corrupted resources.

---

## 6. TILEMAP REQUIREMENTS

**Rule:** TileMapLayer nodes MUST have painted tiles before runtime.

### Checklist:
- [ ] TileSet created with 32x32 grid
- [ ] Source image assigned
- [ ] Physics layer configured (if needed)
- [ ] Tiles PAINTED in editor (not empty)
- [ ] Layer tested in isolation

**V1 Failure:** Empty TileMapLayer → player fell through world.

---

## 7. NODE PATH VALIDATION

**Rule:** @onready node paths MUST match actual scene structure.

```gdscript
# GOOD: Verify path exists in scene tree
@onready var sprite: Sprite2D = $Sprite2D

# BAD: Assumed path without checking
@onready var sprite: Sprite2D = $Graphics/PlayerSprite  # May not exist!
```

**Workflow:**
1. Open scene in editor
2. Check actual node names/paths
3. Write @onready paths to match EXACTLY
4. Test scene in isolation

---

## 8. ANTI-PATTERNS (FORBIDDEN)

### 8.1 Duplicate Systems
**Forbidden:** Two inventory systems, partial migration from old to new.

**Rule:** DELETE old system completely before implementing new one.

### 8.2 "Add It Later" Syndrome
**Forbidden:**
```gdscript
# TODO: Register this autoload later
var dialogue = DialogueManager.start_conversation()  # CRASHES
```

**Rule:** Never reference something that doesn't exist yet. Build foundation first.

### 8.3 Magic Numbers
**Forbidden:**
```gdscript
position = Vector2(16, 16)  # Why 16? Should be TILE_SIZE/2
```

**Rule:** Use named constants. If you're typing a number, ask "should this be a constant?"

### 8.4 Assumed Existence
**Forbidden:**
```gdscript
var crops = CropRegistry.get_all_crops()  # CropRegistry might not exist
```

**Rule:** Check SCHEMA.md and project.godot before assuming any global exists.

---

## 9. DEVELOPMENT PHASES (SEQUENTIAL)

**Rule:** Complete each phase FULLY before moving to next. No parallel half-implementations.

### Phase 0: Foundation
- [ ] Create all folders
- [ ] Write CONSTITUTION.md, SCHEMA.md
- [ ] Create project.godot with autoloads
- [ ] Create autoload scripts
- [ ] Test: Run game, check no errors

### Phase 1: Core Loop (Vertical Slice)
- [ ] Player movement
- [ ] Single crop type (wheat)
- [ ] Plant → Grow → Harvest
- [ ] Test: Can complete one crop cycle

### Phase 2: Persistence
- [ ] Save/Load system
- [ ] Test: Save, close, load, verify state

### Phase 3: Content Expansion
- [ ] More crops
- [ ] NPCs + Dialogue
- [ ] Quest system

### Phase 4: Polish
- [ ] UI/UX
- [ ] Audio
- [ ] Balance

**V1 Failure:** Tried to build everything at once → nothing worked.

---

## 10. TESTING REQUIREMENTS

**Rule:** Every phase must have automated tests.

### Test Runner:
```bash
godot --headless --script tests/run_tests.gd
```

### Required Tests:
- [ ] Autoloads exist and are accessible
- [ ] Resource classes compile
- [ ] TILE_SIZE constant defined
- [ ] No @onready null references

---

## 11. GIT WORKFLOW

### Branch Naming:
```
claude/<task-description>-<session-id>
```

### Commit Message Format:
```
<type>: <summary>

<details>

<breaking changes if any>
```

**Types:** feat, fix, refactor, docs, test, chore

---

## 12. AI AGENT HANDOFF PROTOCOL

**When starting a new conversation:**

1. Read CONSTITUTION.md (this file)
2. Read SCHEMA.md
3. Read PROJECT_STATUS.md
4. Ask user: "What phase are we in?"
5. Verify phase completion before proceeding

**Never assume:**
- What systems exist
- What properties are named
- What autoloads are registered

**Always verify:**
- Check actual files
- Check project.godot
- Check SCHEMA.md

---

## 13. CRITICAL FAILURE MODES (V1 LESSONS)

| Failure | Root Cause | Prevention |
|---------|------------|------------|
| Null autoload | Not registered in project.godot | Check project.godot FIRST |
| Property not found | AI hallucinated name | Check SCHEMA.md FIRST |
| Empty TileMap | Never painted in editor | Test scene in isolation |
| Misaligned sprites | Mixed 16px/32px | Use TILE_SIZE constant |
| Duplicate systems | "We'll migrate later" | Delete old before building new |
| Initialization order | _ready() race conditions | Use autoloads for shared state |

---

## QUICK REFERENCE CARD

**Before writing ANY code:**

```
□ Read CONSTITUTION.md
□ Read SCHEMA.md
□ Check project.godot for autoloads
□ Verify TILE_SIZE = 32
□ Check actual node paths in scenes
□ Use exact property names from SCHEMA.md
□ Test in isolation before integrating
```

**Golden Rule:**
> "If you're not sure, CHECK. Never assume, never guess, never hallucinate."

---

**End of CONSTITUTION.md**
