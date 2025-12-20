# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**Circe's Garden** is a narrative farming game built in Godot 4.5.1, targeting the Retroid Pocket Classic (Android, 1080Ã—1240, d-pad only). Players experience a Greek mythology-inspired story about jealousy, guilt, and redemption through farming pharmaka herbs and crafting potions.

**Current Phase:** Phase 1 (Core Systems) - ~15% complete

---

## Essential Reading Order

Before making ANY changes, read these files in order:

1. **[docs/design/CONSTITUTION.md](docs/design/CONSTITUTION.md)** - Immutable technical rules (TILE_SIZE, autoload registration, property naming)
2. **[docs/design/SCHEMA.md](docs/design/SCHEMA.md)** - Exact property names for all data structures (never guess these!)
3. **[docs/execution/PROJECT_STATUS.md](docs/execution/PROJECT_STATUS.md)** - Current state, what's done, what's next
4. **[docs/execution/ROADMAP.md](docs/execution/ROADMAP.md)** - Step-by-step implementation guide with code templates

**Quick reference:** [agent.md](agent.md) provides a condensed workflow guide.

---

## Development Commands

### Testing
```bash
# Run all automated tests (5 tests: autoloads, resources, constants, GameState, scene wiring)
godot --headless --script tests/run_tests.gd
# If `godot` isn't on PATH, use the bundled executable:
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64_console.exe --headless --script tests/run_tests.gd
```

### Git Workflow
```bash
# Check current state
git status
git log --oneline -5

# Standard branch naming
# Format: claude/<task-description>-<session-id>
# Example: claude/implement-farm-plot-bnkZr

# Commit message format
# <type>: <summary>
#
# - Detail 1
# - Detail 2
#
# ðŸ¤– Generated with [Claude Code](https://claude.com/claude-code)
#
# Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>

# Types: feat, fix, refactor, docs, test, chore
```

### Editor Notes
- `project.godot` is writable; git hook guard protects critical autoload lines
- Close Godot editor before moving files with `git mv` to preserve history

---

## High-Level Architecture

### Feature-Based Structure (Post-Restructure)

The project uses a **feature-based organization** under `game/`, NOT traditional `src/` and `scenes/` separation:

```
game/
â”œâ”€â”€ autoload/              # Singleton scripts (GameState, SaveController, etc.)
â”‚   â”œâ”€â”€ game_state.gd      # Central state: inventory, gold, farm_plots, quest_flags
â”‚   â”œâ”€â”€ save_controller.gd # Save/load to user://savegame.json
â”‚   â”œâ”€â”€ scene_manager.gd   # Scene transitions
â”‚   â”œâ”€â”€ audio_controller.gd# Audio management
â”‚   â””â”€â”€ constants.gd       # ALL constants (TILE_SIZE=32, speeds, colors, paths)
â”œâ”€â”€ features/              # Game features (scenes + scripts together)
â”‚   â”œâ”€â”€ player/            # player.tscn + player.gd
â”‚   â”œâ”€â”€ farm_plot/         # farm_plot.tscn + farm_plot.gd
â”‚   â”œâ”€â”€ world/             # world.tscn (main game scene)
â”‚   â””â”€â”€ ui/                # UI scenes and scripts (main_menu, dialogue_box, debug_hud)
â””â”€â”€ shared/
    â””â”€â”€ resources/         # All .tres data files (crops/, items/, dialogues/, npcs/)
```

**Key architectural patterns:**
- **Autoloads are pre-registered** in `project.godot` - never create an autoload without registering it first
- **Resource classes** (CropData, ItemData, etc.) defined in root `src/resources/` but instantiated as `.tres` files in `game/shared/resources/`
- **Constants centralized** in `game/autoload/constants.gd` - use `Constants.TILE_SIZE` not magic numbers
- **State managed centrally** by `GameState` autoload - inventory, gold, quest flags, farm plots all stored there

### Critical Architectural Rules (from CONSTITUTION.md)

1. **TILE_SIZE = 32** - Immutable. Use `Constants.TILE_SIZE` in all calculations, never hardcode tile dimensions
2. **Autoload registration order matters** - Register in `project.godot` BEFORE referencing in code
3. **Property names are exact** - Check SCHEMA.md for precise property names (e.g., `growth_stages` NOT `sprites`, `days_to_mature` NOT `growth_time`)
4. **Resource workflow** - Define class â†’ Restart Godot â†’ Create .tres files (never create .tres before class exists)
5. **TileMapLayer requirement** - TileMaps MUST have painted tiles before runtime (empty TileMaps cause player to fall through world)
6. **Node path validation** - `@onready` paths must match actual scene structure exactly

### GameState Data Model

The `GameState` autoload (singleton) manages all game state:

```gdscript
# Core state properties
var current_day: int = 1
var current_season: String = "spring"
var gold: int = 100
var inventory: Dictionary = {}        # { "item_id": quantity }
var quest_flags: Dictionary = {}      # { "flag_name": bool }
var farm_plots: Dictionary = {}       # { Vector2i: PlotData }

# PlotData structure
{
    "crop_id": "wheat",           # CropData.id
    "planted_day": 1,             # Day planted
    "current_stage": 0,           # Current growth stage index
    "watered_today": false,       # Watered status
    "ready_to_harvest": false     # Harvestable flag
}
```

**Signals for reactive updates:**
- `inventory_changed(item_id, new_quantity)`
- `gold_changed(new_amount)`
- `day_advanced(new_day)`
- `flag_changed(flag, value)`
- `crop_planted(plot_id, crop_id)`
- `crop_harvested(plot_id, item_id, quantity)`

### Save System Architecture

Save/load handled by `SaveController` autoload:
- **Save path:** `user://savegame.json`
- **Save version:** 2 (for compatibility checks)
- **Save structure:** Serializes entire GameState (day, season, gold, inventory, flags, farm_plots) to JSON
- **Load workflow:** Deserialize JSON â†’ Restore GameState â†’ Rebuild game world from saved data

---

## Development Workflow

### Critical Workflow Rules

1. **ONE task at a time** - Never implement multiple roadmap subsections simultaneously
2. **Follow templates exactly** - Code templates in ROADMAP.md are tested and designed to work together
3. **Validate immediately** - Check file locations, property names, and code structure before committing
4. **Test in isolation** - Load scenes individually before integrating into main game
5. **Commit after each subsection** - Small, focused commits with clear messages
6. **Update PROJECT_STATUS.md** - Mark tasks complete and note any issues
7. **Keep docs in sync** - When completing tasks, update CLAUDE.md status/blockers if they've changed

### Workflow Steps (for ANY task)

```
1. Read ROADMAP.md section for your task
   - Understand goals, dependencies, and acceptance criteria
   - Copy code template exactly

2. Verify prerequisites
   - Check dependencies exist
   - Verify autoloads registered (grep project.godot)
   - Check SCHEMA.md for property names you'll use

3. Implement using EXACT template from ROADMAP.md
   - Don't add features beyond template
   - Don't "improve" or "optimize" unless explicitly requested
   - Fill placeholders only (scene paths, etc.)

4. Validate before committing
   - File in correct location (game/features/ for scenes+scripts)
   - Property names match SCHEMA.md
   - Code matches ROADMAP.md template
   - No TODO stubs left incomplete
   - Tests pass (godot --headless --script tests/run_tests.gd)

5. Commit with standard format
   - Type: feat/fix/refactor/docs/test/chore
   - Clear summary and details
   - Include "Generated with Claude Code" footer

6. Update PROJECT_STATUS.md
   - Mark task complete
   - Update progress percentage
   - Note any blockers or issues

7. Report and wait
   - Don't auto-continue to next task
   - Report completion and ask to proceed
```

### Known Failure Modes (Lessons from V1)

These architectural failures plagued V1 and are explicitly prevented in V2:

| Failure | Root Cause | Prevention |
|---------|------------|------------|
| Null autoload references | Autoload not registered in project.godot | Check project.godot FIRST before using autoload |
| Property not found errors | AI hallucinated property names | Check SCHEMA.md FIRST, copy exact names |
| Empty TileMap (player falls through) | TileMapLayer never painted in editor | Test scene in isolation, verify tiles painted |
| Misaligned sprites/collision | Mixed 16px/32px tile sizes | Use Constants.TILE_SIZE (32) exclusively |
| Duplicate systems | "We'll migrate later" approach | Delete old system completely before building new |
| Race conditions on init | Improper _ready() order | Use autoloads for shared state |

---

## Common Patterns and Conventions

### Accessing GameState
```gdscript
# Add item to inventory
GameState.add_item("wheat", 5)

# Check if player has item
if GameState.has_item("watering_can"):
    # Can water crops

# Set quest flag
GameState.set_flag("met_medusa", true)

# Check quest flag
if GameState.get_flag("met_medusa"):
    # Show advanced dialogue
```

### Resource Loading Pattern
```gdscript
# CropData resources stored in game/shared/resources/crops/
var wheat_crop = load("res://game/shared/resources/crops/wheat.tres")

# Access properties (from SCHEMA.md)
var stages = wheat_crop.growth_stages  # Array[Texture2D]
var days = wheat_crop.days_to_mature   # int
```

### Scene Structure Pattern
All player-facing scenes follow this structure:
```
Player (CharacterBody2D)
â”œâ”€ Sprite (Sprite2D)          # Name must match @onready reference
â”œâ”€ Collision (CollisionShape2D)
â”œâ”€ Camera (Camera2D)
â””â”€ InteractionZone (Area2D)
   â””â”€ CollisionShape2D
```

**Script references:**
```gdscript
@onready var sprite: Sprite2D = $Sprite  # Node name MUST be "Sprite"
@onready var interaction_zone: Area2D = $InteractionZone
```

### Input Handling Pattern
```gdscript
# Use constants for input actions
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(Constants.INPUT_INTERACT):
        _try_interact()
```

### Constants Usage Pattern
```gdscript
# ALWAYS use Constants, NEVER hardcode values
extends CharacterBody2D

# GOOD âœ…
const SPEED: float = Constants.PLAYER_SPEED  # 100.0
position = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)

# BAD âŒ
const SPEED: float = 100.0  # Don't hardcode
position = Vector2(32, 32)  # Don't use magic numbers
```

---

## Testing Strategy

### Automated Tests (5 tests)

Run with: `godot --headless --script tests/run_tests.gd`

1. **test_autoloads** - Verify all autoloads (GameState, SaveController, SceneManager, AudioController, Constants) are accessible
2. **test_resources** - Verify resource class definitions (CropData, ItemData, DialogueData, NPCData) compile
3. **test_tile_size** - Verify Constants.TILE_SIZE = 32
4. **test_game_state_init** - Verify GameState initializes with correct defaults (gold=100, inventory={}, etc.)
5. **test_scene_wiring** - Verify key scenes have scripts attached (player, farm_plot, main_menu, dialogue_box, debug_hud)

### Manual Testing Checklist

Before any commit:
- [ ] Game launches without errors
- [ ] Can complete core loop (plant â†’ harvest) if applicable
- [ ] Save/load works (if persistence implemented)
- [ ] No console errors or warnings
- [ ] Scene loads in isolation (test individually before integrating)

---

## Phase Status and Next Steps

**Current Phase:** Phase 1 - Core Systems (~60% complete)

**What's Done:**
- Foundation (Phase 0): Docs, autoloads, resource classes, tests
- Player movement and interaction system
- Farm plot lifecycle (till, plant, grow, harvest)
- World scene TileMapLayer painted
- Dialogue system (scrolling text + choices)
- Scene transitions with fade
- Crafting minigame + recipe system
- Day/Night system (sundial)

**What's Next:**
1. Wire dialogue system to NPCs
2. Implement inventory UI
3. Connect crafting to gameplay loop

**Note:** Always check `docs/execution/PROJECT_STATUS.md` for current status - this section may lag behind.

---

## Important Project Constraints

### Platform Target: Retroid Pocket Classic
- **Display:** 1080Ã—1240 (portrait orientation, unusual aspect ratio)
- **Input:** D-pad only (no analog stick, no touch)
- **Performance:** Android 14, modest hardware - optimize for low-end mobile

### Design Philosophy
- **Narrative-driven:** Story is primary focus (65-90 min main story)
- **Cozy atmosphere:** Not difficult or stressful, therapeutic gameplay
- **Greek mythology theme:** Circe as protagonist, pharmaka herbs, mythological NPCs
- **Linear progression:** 11 main quests across 3 acts + prologue/epilogue

### Technical Constraints
- **Godot 4.5.1** - Don't use features from later versions
- **No external plugins** (except pre-installed: GDQuest formatter, godot_mcp)
- **Pixel art style** - 32px tile size, 2x camera zoom
- **Save system** - Single save slot, JSON format, user:// directory

---

## Anti-Patterns (Things to Avoid)

Based on project history, explicitly avoid:

1. **Scope creep** - Don't add features not in ROADMAP.md
2. **Template deviation** - Don't "improve" code templates
3. **Batching tasks** - Don't implement multiple subsections at once
4. **Property hallucination** - Don't guess property names, check SCHEMA.md
5. **Magic numbers** - Don't hardcode values, use Constants
6. **Premature optimization** - Implement functionality first, optimize later if asked
7. **Skipping validation** - Don't commit without running tests
8. **Autoload assumptions** - Don't reference autoloads without checking project.godot
9. **Empty scenes** - Don't create TileMapLayers without painting tiles
10. **Duplicate systems** - Delete old implementation before building new one

---

## Quick Reference

### File Locations
- **Scripts (.gd):** `game/autoload/` or `game/features/<feature>/`
- **Scenes (.tscn):** `game/features/<feature>/`
- **Resources (.tres):** `game/shared/resources/<type>/`
- **Tests:** `tests/`
- **Docs:** `docs/` (design/, execution/, overview/)

### Key Files
- `project.godot` - Godot config, autoload registration (READ-ONLY)
- `game/autoload/constants.gd` - All constants (TILE_SIZE, speeds, colors, paths)
- `game/autoload/game_state.gd` - Central state management
- `docs/design/SCHEMA.md` - Exact property names for all data structures
- `docs/execution/ROADMAP.md` - Implementation guide with code templates

### Common Item/Crop IDs
- **Crops:** wheat, tomato, carrot, moly, nightshade
- **Seeds:** wheat_seed, tomato_seed, moly_seed, nightshade_seed
- **Tools:** watering_can, hoe, sickle

### Quest Flags (examples)
- `met_medusa` - Triggered after first Medusa dialogue
- `first_harvest_complete` - Completed first crop harvest
- `unlocked_watering_can` - Player received watering can
- `game_complete` - Finished main storyline

---

## Senior PM Oversight Protocol

### Reviewing Jr Engineer Work
1. Check "Review (Opus)" column in GitHub Project
2. Read the handoff issue for context
3. Review code changes (if any) against ROADMAP.md template
4. Decide: Approve, Request Changes, or Take Over

### When to Intervene
- Architectural decisions (affects CONSTITUTION.md)
- Strategic direction changes
- Guardrail violations
- Jr Engineer blocked >2 attempts

### When to Delegate Back
- Task is well-defined in ROADMAP.md
- No architectural implications
- Jr Engineer has all needed context
- Create `review.md` issue with clear action items

### GitHub Project Board Columns
| Column | Owner | Purpose |
|--------|-------|---------|
| Backlog | Sr PM | Prioritized tasks |
| In Progress (Codex) | Jr Eng | Active work |
| Review (Opus) | Sr PM | Needs decision |
| Blocked | Either | Waiting on external |
| Done | Auto | Completed |

---

## When Stuck or Uncertain

1. Re-read ROADMAP.md section for your task
2. Check SCHEMA.md for correct property names
3. Check CONSTITUTION.md for rules that might apply
4. Look at existing implementations for patterns (e.g., player.gd for movement patterns)
5. Document the blocker in PROJECT_STATUS.md
6. **Ask for clarification rather than guessing** - property name hallucination was a major V1 failure mode

---

## Summary: Golden Rules

1. **Read CONSTITUTION.md and SCHEMA.md first** - Every single time
2. **ONE task at a time** - Never batch multiple roadmap subsections
3. **Follow templates exactly** - Copy from ROADMAP.md, don't deviate
4. **Validate before commit** - Tests pass, property names correct, files in right locations
5. **Use Constants for everything** - TILE_SIZE=32, no magic numbers
6. **Check autoload registration** - Grep project.godot before using autoloads
7. **Paint TileMapLayers** - Empty TileMaps cause runtime failures
8. **Test in isolation** - Load scenes individually before integrating
9. **Update PROJECT_STATUS.md** - Mark tasks complete, note blockers
10. **Report and wait** - Don't auto-continue, ask to proceed to next task

---

**End of CLAUDE.md**
