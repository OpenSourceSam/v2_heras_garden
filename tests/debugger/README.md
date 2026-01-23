# Debugger Test Procedures

**Created:** 2026-01-23
**Purpose:** VSCode F5 debugger test procedures for Phase 7 validation

---

## Overview

This directory contains test procedures for debugger-based integration testing. These procedures use VSCode's F5 debugger with breakpoints and the Variables panel to verify game state at critical points.

**Environment:** Cursor IDE / VS Code Extension
**Method:** F5 Debugger + Variables Panel
**Target:** Mid-level testing between unit tests and HPV

---

## Test Procedure Files

| File | Purpose | Focus Area |
|------|---------|------------|
| [quest_test_procedures.md](quest_test_procedures.md) | Quest flag transitions | Quests 0-11 progression |
| [dialogue_test_procedures.md](dialogue_test_procedures.md) | Dialogue choice routing | Choice selection and flow |
| [npc_spawn_test_procedures.md](npc_spawn_test_procedures.md) | NPC spawn conditions | Hermes, Aeetes, Scylla, etc. |
| [minigame_test_procedures.md](minigame_test_procedures.md) | Minigame completion | Success/failure handling |
| [ending_test_procedures.md](ending_test_procedures.md) | Ending verification | Witch and Healer endings |

---

## How to Use These Procedures

### 1. Start Debugger
```
Press F5 → Select "Debug Main Scene"
```

### 2. Set Breakpoint
```
Click in gutter (left of line numbers) → Red dot appears
```

### 3. Inspect Variables
```
When paused, open Variables panel (bottom)
Expand self → quest_flags to see game state
```

### 4. Modify Values
```
Double-click any value in Variables panel to change it
Example: quest_2_complete: false → true
```

### 5. Continue Execution
```
Press F5 to resume, F10 to step over, F11 to step into
```

---

## Quick Reference: Common Breakpoints

**Quest Flag Changes:**
```
game/autoload/game_state.gd:152 - set_flag() function
game/autoload/game_state.gd:159 - get_flag() function
```

**Dialogue System:**
```
game/features/ui/dialogue_box.gd:142 - _on_choice_selected()
game/features/ui/dialogue_box.gd:88 - _show_choices()
game/features/ui/dialogue_box.gd:25 - start_dialogue()
```

**NPC Spawning:**
```
game/features/world/npc_spawner.gd:20 - _update_npcs()
game/features/world/npc_spawner.gd:54 - _spawn_npc()
```

**Minigame Completion:**
```
game/features/minigames/herb_identification.gd:106 - Success emit
game/features/minigames/sacred_earth.gd:81 - Success emit
game/features/ui/crafting_controller.gd:84 - Crafting complete
```

**Endings:**
```
game/features/cutscenes/epilogue.gd:40 - Ending choice dialogue
game/autoload/game_state.gd:152 - ending_witch/healer flags
```

---

## Test Coverage Summary

**Quests 0-11:** All quest progression paths covered
**Dialogue Choices:** Key decision points tested
**NPC Spawns:** Major NPCs (Hermes, Aeetes, Scylla, Daedalus)
**Minigames:** Herb ID, Sacred Earth, Weaving, Crafting
**Endings:** Both Witch and Healer paths verified

---

## When to Use Debugger Testing vs Other Methods

**Use Debugger Testing For:**
- ✅ Quest flag state verification
- ✅ Dialogue routing validation
- ✅ NPC spawn condition testing
- ✅ Minigame completion flow
- ✅ Integration between systems

**Use Unit Tests (GdUnit4) For:**
- ✅ Isolated mechanics (inventory, flag operations)
- ✅ Input response validation
- ✅ Data validation (recipes, items)

**Use HPV (MCP) For:**
- ✅ Full quest playthroughs
- ✅ Input simulation during gameplay
- ✅ Complete narrative flow validation
- ✅ Player movement and collision testing

**Use Manual Testing For:**
- ✅ Visual polish (animations, transitions)
- ✅ Audio timing and feel
- ✅ Performance profiling

---

## Documentation

**Primary Guide:**
[../../docs/agent-instructions/DEBUGGER_TESTING_GUIDE.md](../../docs/agent-instructions/DEBUGGER_TESTING_GUIDE.md)

**Related:**
[../../docs/agent-instructions/TESTING_WORKFLOW.md](../../docs/agent-instructions/TESTING_WORKFLOW.md)
[../../docs/agent-instructions/tools/godot-tools-extension-hpv-guide.md](../../docs/agent-instructions/tools/godot-tools-extension-hpv-guide.md)

---

## Phase 7 Status

**Created:** 2026-01-23 (Phase 2 of DAP Testing & Buildout Plan)
**Purpose:** Provide structured test procedures for P1 buildout validation
**Next Phase:** Phase 3 - Execute P1 buildout tasks using these procedures

---

**Last Updated:** 2026-01-23
**Synthesized from:** Phase 2 analysis by 5 parallel subagents
