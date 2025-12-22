# CONTEXT.md

This file provides static context for Circe's Garden v2. Read it once at the start of a session, then use docs/execution/ROADMAP.md for task steps.

---

## Project Overview

Circe's Garden is a narrative farming game built in Godot 4.5.1 for the Retroid Pocket Classic (Android 14, 1080x1240, d-pad only). The story is Greek mythology inspired and centers on jealousy, guilt, and redemption through farming pharmaka herbs and crafting potions.

Current Phase: Phase 4 (Prototype) - Ready to start

---

## Reading Order

1. CONTEXT.md (this file)
2. docs/execution/ROADMAP.md (current phase section only)
3. docs/design/SCHEMA.md (exact property names)
4. docs/design/Storyline.md (narrative context for story tasks)

---

## Development Commands

### Tests
```bash
godot --headless --script tests/run_tests.gd
# If godot is not on PATH, use the bundled executable:
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd
```

### Git Workflow
```bash
git status
git log --oneline -5

# Branch naming
# claude/<task-description>-<session-id>

# Commit format
# <type>: <summary>
#
# - Detail 1
# - Detail 2
#
# Generated with Claude Code (if applicable)
# Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
#
# Types: feat, fix, refactor, docs, test, chore
```

### Editor Notes
- project.godot is writable; a narrow guard protects critical autoload lines.
- Close the Godot editor before moving files to preserve history.

---

## Architecture and Structure

### Feature-Based Layout (current)
```
game/
  autoload/
    game_state.gd
    save_controller.gd
    scene_manager.gd
    audio_controller.gd
    constants.gd
  features/
    player/
    farm_plot/
    world/
    ui/
  shared/resources/
src/resources/  # Resource class scripts (until migrated)
```

### Key Architectural Patterns
- Autoloads are registered in project.godot. Verify registration before use.
- Resource classes live in src/resources and .tres data lives in game/shared/resources.
- Constants are centralized in game/autoload/constants.gd (use Constants.TILE_SIZE, no magic numbers).
- GameState autoload owns inventory, gold, quest flags, and farm plot state.
- SaveController persists GameState to user://savegame.json.

### Save System Notes
- Save path: user://savegame.json
- Save version: 2
- Save and load serialize the full GameState.

---

## Critical Technical Rules

- TILE_SIZE is 32. Use Constants.TILE_SIZE for all tile math.
- Register autoloads in project.godot before referencing them, then restart the editor.
- Property names are exact. Always check docs/design/SCHEMA.md.
- Resource workflow: create class -> restart Godot -> create .tres data.
- TileMapLayer nodes must have painted tiles before runtime.
- @onready paths must match real node names exactly.
- Do not keep duplicate systems. Remove old implementations before replacing them.
- Use named constants for values; avoid magic numbers.
- Complete phases sequentially; do not half-implement future phases.

---

## Data Schema Quick Reference

For full details, see docs/design/SCHEMA.md.

### CropData
- id: String
- display_name: String
- growth_stages: Array[Texture2D]
- days_to_mature: int
- harvest_item_id: String
- seed_item_id: String
- sell_price: int
- regrows: bool
- seasons: Array[String]

### ItemData
- id: String
- display_name: String
- description: String
- icon: Texture2D
- stack_size: int
- sell_price: int
- category: String

### RecipeData
- id: String
- display_name: String
- description: String
- ingredients: Array[Dictionary]
- grinding_pattern: Array[String]
- button_sequence: Array[String]
- timing_window: float
- result_item_id: String
- result_quantity: int

### DialogueData
- id: String
- lines: Array[Dictionary]
- choices: Array[Dictionary]
- flags_required: Array[String]
- flags_to_set: Array[String]
- next_dialogue_id: String

### NPCData
- id: String
- display_name: String
- sprite_frames: SpriteFrames
- default_dialogue_id: String
- gift_preferences: Dictionary
- schedule: Array[Dictionary]

### GameState (autoload)
- current_day: int
- current_season: String
- gold: int
- inventory: Dictionary
- quest_flags: Dictionary
- farm_plots: Dictionary

PlotData structure:
```
{
  "crop_id": String,
  "planted_day": int,
  "current_stage": int,
  "watered_today": bool,
  "ready_to_harvest": bool
}
```

Signals:
- inventory_changed(item_id, new_quantity)
- gold_changed(new_amount)
- day_advanced(new_day)
- flag_changed(flag, value)
- crop_planted(plot_id, crop_id)
- crop_harvested(plot_id, item_id, quantity)

### SaveController (autoload)
- SAVE_PATH: "user://savegame.json"
- SAVE_VERSION: 2
- save_game(), load_game(), save_exists(), delete_save()

---

## Development Workflow (All Tasks)

1. Read the relevant section in docs/execution/ROADMAP.md.
2. Verify prerequisites (autoloads, file paths, dependencies).
3. Check docs/design/SCHEMA.md for property names.
4. Implement using the exact template; fill placeholders only.
5. Validate: file locations, property names, template match, tests.
6. Commit with the standard format; keep commits small.
7. Update status notes (ROADMAP checkpoints at 50% and 100%; RUNTIME_STATUS.md after each action).
8. Report completion and wait for approval; do not auto-continue.

Known failure modes to avoid:
- Autoload not registered in project.godot
- Property name hallucinations
- Empty TileMapLayer (player falls through)
- Mixed tile sizes (16 vs 32)
- Duplicate systems kept in parallel

---

## Phase 2 Protocols (Mandatory for 2.x Tasks)

- Dialogue: use existing DialogueBox and DialogueData. Do not create a new system.
- Quests: use GameState.set_flag() and GameState.get_flag(). Do not create a Quest class.
- Camera: use create_tween(). Do not add camera plugins.
- Cutscenes: use AnimationPlayer and SceneManager. Do not add cutscene plugins.
- NPCs: extend CharacterBody2D with interact() and match player interaction patterns.
- Data: use .tres resources; verify property names in SCHEMA.md.

---

## Phase Checkpoint Protocol

Create checkpoints only at 50% and 100% completion of a phase.
Add to docs/execution/ROADMAP.md after the phase section.

```
<!-- PHASE_X_CHECKPOINT: 50%|100% -->
Checkpoint Date: YYYY-MM-DD
Verified By: Jr Eng Codex / Sr PM Opus

Systems Status
| System | Status | Notes |
|--------|--------|-------|
| System Name | OK/IN PROGRESS/NEEDS ATTENTION/BLOCKED | Brief note |

Blockers (if any)
- Blocker description - GitHub Issue #XX

Files Modified This Phase
- path/to/file.gd - what changed

Ready for Next Phase: Yes/No
<!-- END_CHECKPOINT -->
```

---

## Senior PM Oversight (Short Form)

- For new conversations: read ROADMAP status section, then find SR_PM_READING_MARKER if resuming mid-phase.
- Review work against ROADMAP templates; approve, request changes, or take over.
- Intervene on architectural decisions, guardrail violations, or blockers after two attempts.
- Delegate when the task is well-defined and no architecture changes are needed.

---

## Testing Strategy

### Automated Tests
Run: godot --headless --script tests/run_tests.gd
If godot is not on PATH: .\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

Tests cover:
- Autoload availability
- Resource class compilation
- TILE_SIZE constant
- GameState initialization
- Scene wiring

### Manual Testing Checklist
- Game launches without errors
- Core loop works (plant, grow, harvest)
- Save/load works (when implemented)
- No console errors or warnings
- Scenes load in isolation before integration

---

## Anti-Patterns (Things to Avoid)

1. Scope creep (adding features not in ROADMAP.md)
2. Template deviation ("improving" templates)
3. Batching multiple subsections at once
4. Property name guessing
5. Magic numbers
6. Premature optimization
7. Skipping validation
8. Autoload assumptions
9. Empty TileMapLayers
10. Duplicate systems

---

## Documentation Practices

**Keep the project streamlined - DO NOT create new documents unless absolutely necessary.**

- Add to existing frameworks and documents rather than creating new files
- Use existing docs:
  - CONTEXT.md for project-wide guidelines
  - ROADMAP.md for phase execution notes
  - SCHEMA.md for data structure definitions
  - Storyline.md for narrative context
  - PROJECT_STATUS.md for current state
- When troubleshooting or adding notes, integrate into relevant existing docs
- Avoid creating standalone README, GUIDE, or TROUBLESHOOTING files
- If a new doc is genuinely needed, ask first

**Examples:**
- ✅ Add troubleshooting notes to existing ROADMAP or feature docs
- ✅ Add architectural notes to CONTEXT.md
- ❌ Create new TROUBLESHOOTING.md when notes can go in feature doc
- ❌ Create new ARCHITECTURE.md when CONTEXT.md exists

---

## When Stuck or Guard Triggers

- Create a GitHub Issue using the handoff.md or guardrail.md template.
- Label appropriately (agent:opus-priority or blocked).
- Update RUNTIME_STATUS.md with the blocker.
- Stop and wait for Sr PM decision.

---

## Constraints

### Platform
- Retroid Pocket Classic (Android 14, 1080x1240)
- D-pad only
- Low-end performance target

### Design
- Narrative-driven, cozy tone
- Greek mythology theme
- Linear progression with 11 main quests

### Technical
- Godot 4.5.1 only
- No external plugins (except pre-installed tools)
- Pixel art style: 32px tiles, 2x camera zoom
- Single save slot, JSON format

---

## Quick Reference

### File Locations
- Scripts: game/autoload or game/features/<feature>/
- Scenes: game/features/<feature>/
- Resources: game/shared/resources/<type>/
- Tests: tests/
- Docs: docs/

### Key Files
- project.godot
- game/autoload/constants.gd
- game/autoload/game_state.gd
- docs/design/SCHEMA.md
- docs/execution/ROADMAP.md

### Common IDs
- Crops: wheat, tomato, carrot, moly, nightshade
- Seeds: wheat_seed, tomato_seed, moly_seed, nightshade_seed
- Tools: watering_can, hoe, sickle

### Quest Flags (examples)
- met_medusa
- first_harvest_complete
- unlocked_watering_can
- game_complete

---

## Golden Rules

1. Read CONTEXT.md and SCHEMA.md first.
2. One task at a time.
3. Follow ROADMAP templates exactly.
4. Validate before commit.
5. Use Constants for everything.
6. Check autoload registration.
7. Paint TileMapLayers before runtime.
8. Test scenes in isolation.
9. Update checkpoints and status notes.
10. Report and wait for approval.

---

End of CONTEXT.md
