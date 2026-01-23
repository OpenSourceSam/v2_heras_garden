# Debugger-Based Integration Testing Guide

**Last Updated:** 2026-01-23
**Environment:** Cursor IDE / VS Code Extension
**Status:** Current - VSCode F5 workflow for mid-level testing

---

## Quick Start: When to Use Debugger Testing

| Test Type | Use Method | Example |
|-----------|------------|---------|
| **Pure logic** | Unit Tests (GdUnit4) | Inventory add/remove, flag operations |
| **Quest flags** | Debugger (F5) | Quest progression, dialogue routing |
| **Full gameplay** | HPV (MCP) | Input simulation, complete playthroughs |
| **Visual polish** | Manual testing | Animations, UI feedback, feel |

**Key Point:** Debugger testing fills the gap between fast unit tests and slow HPV.

---

## Environment-Specific Tool Access

### For Cursor/VS Code Agents (Current Environment)

**Available:**
- ✅ F5 Debugger (VSCode built-in)
- ✅ Variables Panel (runtime inspection/modification)
- ✅ Breakpoints (click line numbers)
- ✅ Debug Console (expression evaluation)
- ✅ MCP CLI (via PowerShell wrapper)

**NOT Available:**
- ❌ `mcp__godot__*` DAP tools (Claude Desktop only)
- ❌ Native MCP tools (use PowerShell wrapper instead)

### For Claude Desktop Agents

**Available:**
- ✅ All DAP tools (`godot_set_breakpoint`, `godot_get_variables`, etc.)
- ✅ Native MCP integration
- ✅ F5 debugger + Variables panel

### For Terminal Agents

**Available:**
- ✅ MCP CLI (direct subprocess access)
- ✅ F5 debugger (if VSCode installed)

---

## VSCode Debugger Workflow

### Step-by-Step Debugger Testing

**1. Start Debugger:**
```
Press F5 → Select "Debug Main Scene" → Game starts with debugger attached
```

**2. Set Breakpoints:**
```
Click in the gutter (left of line numbers) → Red dot appears
```

**3. Trigger Code Path:**
```
Perform action in-game that hits your breakpoint
```

**4. Inspect Variables:**
```
When paused, open Variables panel (bottom)
Expand self → quest_flags to see all game state
```

**5. Modify Values:**
```
Double-click any value in Variables panel to change it
Example: quest_2_complete: false → true
```

**6. Continue Execution:**
```
Press F5 to resume, F10 to step over, F11 to step into
```

---

## Key Breakpoint Locations

### Quest Progression Testing

**Primary Location:**
```
game/autoload/game_state.gd
- Line 152-156: set_flag() function - ALL quest flag changes pass through here
- Line 159-160: get_flag() function - flag retrieval
- Line 124-130: _check_quest4_completion() - auto-completion logic
```

**Quest Triggers:**
```
game/features/world/quest_trigger.gd
- Line 42-53: _try_trigger() function - automatic quest activation
- Line 51: GameState.set_flag() calls
```

**Variables to Inspect:**
- `GameState.quest_flags` - All quest states
- `GameState.inventory` - Item collection
- `current_quest` - Current active quest

### Dialogue Testing

**Primary Location:**
```
game/features/ui/dialogue_box.gd
- Line 25-32: start_dialogue() - Verify dialogue_id, dialogue_path
- Line 36-55: _show_dialogue_data() - Check flags_required
- Line 88-120: _show_choices() - Choice creation and filtering
- Line 142-151: _on_choice_selected() - Choice processing and routing
- Line 153-171: _unhandled_input() - Input handling for choices
```

**NPC Dialogue Initiation:**
```
game/features/npcs/npc_base.gd
- Line 84-90: interact() - Dialogue ID resolution
- Line 126-140: _resolve_dialogue_id() - Flag-based routing
```

**Variables to Inspect:**
- `current_dialogue` - Current dialogue object
- `current_line_index` - Position in dialogue
- `dialogue_data.choices` - Available choices
- `choice["next_id"]` - Next dialogue after choice

### Crafting/Minigame Testing

**Crafting Controller:**
```
game/features/ui/crafting_controller.gd
- Line 84-106: _on_crafting_complete() - Minigame success handling
- Line 88-90: Quest 10 (divine blood) completion
- Line 106: Quest 4 auto-completion check
```

---

## Testing Decision Flowchart

```
Need to test something?
│
├─ Pure function / isolated logic?
│  └─ → Unit Test (GdUnit4)
│     - test_player_moves_with_input()
│     - test_inventory_add_remove()
│     - test_quest_trigger_sets_flag()
│
├─ Quest flags / dialogue routing?
│  └─ → Debugger Test (F5 Breakpoints)
│     - Set breakpoint at GameState.set_flag()
│     - Inspect Variables panel for quest_flags
│     - Verify dialogue choices appear correctly
│
├─ Full gameplay / input handling?
│  └─ → HPV (MCP Simulation)
│     - Use simulate_action_tap for input
│     - Use get_runtime_scene_structure for state
│     - Teleport + flag-setting for efficiency
│
└─ Visual polish / feel?
   └─ → Manual Testing
      - Play through normally
      - Assess animations, timing, feedback
```

---

## Common Debugging Patterns

### Pattern 1: Quest Flag Verification

**Goal:** Verify quest flag is set correctly

**Steps:**
1. Set breakpoint at `game_state.gd:152` (set_flag function)
2. Trigger action that should set flag
3. When breakpoint hits, check Variables panel:
   - `flag_name` parameter
   - `quest_flags` dictionary after set_flag call
4. Press F5 to continue

**Expected:** Flag appears in quest_flags with correct value

### Pattern 2: Dialogue Choice Routing

**Goal:** Verify dialogue choice leads to correct next dialogue

**Steps:**
1. Set breakpoint at `dialogue_box.gd:147` (_on_choice_selected)
2. Trigger dialogue with choices
3. Select a choice in-game
4. When breakpoint hits, inspect:
   - `choice["next_id"]` - Where this choice leads
   - `choice["flag_required"]` - Was flag check correct?
5. Press F5 and verify next dialogue loads

**Expected:** next_id matches expected dialogue

### Pattern 3: Minigame Skipping (for quest flow testing)

**Goal:** Skip minigame to test quest continuation

**Steps:**
1. Start game with F5 debugger
2. Set breakpoint at `game_state.gd:_ready()` or `new_game()`
3. When breakpoint hits, open Variables panel
4. Expand `self.quest_flags`
5. Double-click values:
   - `quest_1_complete`: false → true
   - `quest_2_active`: false → true
6. Press F5 to resume

**Expected:** Quest progresses to next state without minigame

### Pattern 4: NPC Appearance Verification

**Goal:** Verify NPC spawns based on quest flags

**Steps:**
1. Set breakpoint at `npc_spawner.gd:_ready()` or spawn condition check
2. Modify quest_flags in Variables panel to required state
3. When breakpoint hits, inspect spawn condition logic
4. Verify NPC is created/spawned

**Expected:** NPC appears only when correct flags are set

---

## Troubleshooting

| Problem | Check | Fix |
|---------|-------|-----|
| Breakpoint not hitting | Verify debugger running | Check port 6007, use "Attach to Running Game" |
| Variables panel read-only | Game must be paused | Set breakpoint first, then inspect |
| Can't find quest_flags | Wrong node expanded | Look for self.quest_flags in Variables panel |
| LSP not working | Godot not running | Start Godot, check Output → GDScript Language Server |
| Wrong scene debugging | Check launch configuration | Use "Debug Main Scene" not "Play" |

---

## Hybrid Workflow: Debugger + MCP

For Cursor/VS Code agents, the most efficient workflow combines both tools:

**Phase 1: Setup with Debugger**
1. Start game with F5
2. Set initial quest flags in Variables panel
3. Set breakpoints at key locations

**Phase 2: Test with MCP**
1. Use MCP `simulate_action_tap` for input simulation
2. Use MCP `get_runtime_scene_structure` for state inspection
3. Trigger gameplay actions

**Phase 3: Debug with Breakpoints**
1. When issue occurs, breakpoint hits automatically
2. Inspect full state in Variables panel
3. Step through code to understand issue

**Phase 4: Modify and Continue**
1. Modify values in Variables panel
2. Press F5 to continue execution
3. Verify fix works

---

## Test Categorization Examples

### ✅ Use Unit Tests (GdUnit4) For:

- `test_inventory_add_remove()` - Isolated mechanics
- `test_quest_trigger_sets_flag()` - Flag operations
- `test_crafting_recipe_validation()` - Data validation
- `test_player_movement_response()` - Input handling
- `test_day_night_progression()` - State machines

### 🔍 Use Debugger Testing For:

- Quest progression through multiple flags
- Dialogue choice branching and routing
- NPC spawn conditions and interactions
- Crafting/minigame completion flow
- Cutscene triggering and state changes
- Save/load integrity (checkpoint verification)

### 🎮 Use HPV (MCP) For:

- Full quest playthroughs
- Input simulation during gameplay
- Complete narrative flow validation
- Player movement and collision testing
- Scene transition verification

### 👁️ Use Manual Testing For:

- Visual polish (animations, transitions)
- Audio timing and voice lines
- UI feedback and feel
- Performance profiling
- Accessibility testing

---

## Files to Reference

**Primary Documentation:**
- `TESTING_WORKFLOW.md` - Overall testing methods
- `godot-tools-extension-hpv-guide.md` - VSCode debugger details
- `DEVELOPMENT_ROADMAP.md` - Current phase and tasks
- `PLAYTESTING_ROADMAP.md` - Testing blockers and findings

**Test Infrastructure:**
- `tests/gdunit4/` - Unit test suite
- `tests/debugger/` - Debugger test procedures (to be created)

---

## Summary

**Debugger Testing** is the mid-level testing approach that uses VSCode's F5 debugger with breakpoints and the Variables panel. It's ideal for:

- Quest flag state verification
- Dialogue routing validation
- NPC spawn condition testing
- Integration testing between systems

**For Cursor/VS Code agents:** This is your primary integration testing method. Use it in combination with MCP CLI for comprehensive testing coverage.

**For Claude Desktop agents:** You have access to both DAP tools and the F5 debugger. Use DAP for programmatic control, F5 for interactive debugging.

---

**Last Updated:** 2026-01-23
**Synthesized from:** Phase 0 analysis by 5 parallel subagents
