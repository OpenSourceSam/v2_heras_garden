# Godot Tools Extension for HPV Testing

**For:** HPV (Headed Playability Validation) Testing
**Extension:** [ankitpriyarup/godot-tools](https://github.com/ankitpriyarup/godot-tools) v2.5.1

---

## Overview

The Godot Tools extension provides LSP (Language Server Protocol) and debugging capabilities that can significantly improve HPV testing efficiency. This document explains how to leverage the extension for HPV workflow.

## Why Use the Extension for HPV?

| Problem | MCP Solution | Extension Solution | Better |
|---------|--------------|-------------------|--------|
| Set quest flags | ❌ Quote escaping fails | ✅ Debugger variables panel | Extension |
| Inspect GameState | ⚠️ JSON output, hard to read | ✅ Native VSCode UI | Extension |
| Modify variables at runtime | ❌ Not available | ✅ Debugger set value | Extension |
| Navigate codebase | ⚠️ Grep/search | ✅ F12 Go to Definition | Extension |
| Syntax errors | ⚠️ Runtime errors only | ✅ Real-time squiggles | Extension |

---

## Extension Features for HPV

### 1. LSP Features (Always Available)

**What it provides:**
- Syntax highlighting for GDScript
- Autocomplete for methods and properties
- Parameter hints
- "Go to Definition" (F12)
- Find all references
- Error squiggles before running

**How it helps HPV:**
- Faster navigation of quest code
- Catch syntax errors before testing
- Understand quest trigger code quickly

**Usage:**
```
1. Open any .gd file
2. Type "GameState." to see available methods
3. Press F12 on a method to jump to its definition
4. Hover over variables to see their types
```

### 2. Debugger Features (When Game is Running)

**What it provides:**
- Breakpoints (click in gutter)
- Variable inspection (Variables panel)
- Call stack navigation (Call Stack panel)
- Step through code (F10/F11)
- Set values during debugging

**How it helps HPV:**
- **Set quest flags directly** - Modify `quest_flags` dictionary in Variables panel
- **Inspect game state** - See all GameState variables in real-time
- **Pause at quest triggers** - Set breakpoints at quest trigger points
- **Understand quest flow** - Step through quest code line by line

---

## HPV Workflow: Debugger Flag-Setting

### The Problem MCP Can't Solve

MCP `execute_editor_script` fails with quote escaping:
```bash
# This FAILS:
execute_editor_script --code GameState.set_flag("quest_2_active", true)
# Error: Parse Error: Expected expression.
```

### The Debugger Solution

**Step 1: Start Game with Debugger**

1. Open VSCode/Cursor
2. Press **F5** or go to Run → Start Debugging
3. Select "Debug Main Scene"
4. Game starts with debugger attached

**Step 2: Set a Breakpoint**

1. Open `game/autoload/game_state.gd`
2. Find the `set_flag` function (line 152)
3. Click in the gutter (left of line number) to set breakpoint
4. Red dot appears = breakpoint set

**Step 3: Inspect and Modify quest_flags**

When breakpoint hits:
1. **Variables panel** shows all local variables
2. Expand `self` → `quest_flags` dictionary
3. Double-click any value to modify it
4. Change `false` to `true` for quest flags
5. Press **F5** to continue

**Alternative: Immediate Window**

1. Open the **Debug Console** (bottom panel)
2. Type directly into the console:
```
quest_flags["quest_2_active"] = true
```
3. Press Enter

---

## HPV Workflow: Quest Trigger Inspection

### Use Case: Understand Why Quest Won't Start

**Problem:** Quest trigger isn't firing, need to debug why.

**MCP Approach:**
```bash
get_runtime_scene_structure
# Output: Large JSON tree, hard to navigate
```

**Extension Approach:**

1. Find the quest trigger script (e.g., `QuestTrigger.gd`)
2. Set breakpoint on `_on_body_entered`
3. Walk into the trigger in-game
4. Breakpoint hits - inspect all variables:
   - `body` (is it the player?)
   - Quest state flags
   - Trigger state
5. Step through code to find the issue

---

## HPV Workflow: Skip Quests with Breakpoints

### Instead of Skip Scripts

**Current approach:**
```bash
# Run skip script headless
Godot.exe --headless --script tests/skip_to_quest3.gd
# Start game with MCP
```

**Debugger approach:**

1. Start game with debugger (F5)
2. Set breakpoint in `GameState._ready()` or early in `new_game()`
3. When breakpoint hits, modify `quest_flags`:
   ```
   quest_flags["quest_2_complete"] = true
   quest_flags["quest_3_active"] = true
   ```
4. Press F5 to continue
5. Game starts in the desired quest state

**Advantages:**
- No need for separate skip scripts
- Can modify any state dynamically
- Can inspect state before/after changes
- Hot-reload enabled during testing

---

## Comparison: Extension vs MCP

### Feature Comparison

| Feature | Extension | MCP | Notes |
|---------|-----------|-----|-------|
| **Flag-setting** | ✅ Variables panel | ❌ Quote escaping | Extension wins |
| **State inspection** | ✅ Native UI | ⚠️ JSON output | Extension wins |
| **Input simulation** | ❌ Not available | ✅ simulate_action_tap | MCP required |
| **Scene tree inspection** | ⚠️ Debugger only | ✅ get_runtime_scene | Both work |
| **Code navigation** | ✅ F12, autocomplete | ❌ Not available | Extension wins |
| **Hot-reload** | ✅ Built-in | ❌ Not available | Extension wins |
| **Autonomous testing** | ❌ Manual only | ✅ Can automate | MCP wins |

### When to Use Each

**Use Extension for:**
- Setting quest flags
- Inspecting GameState
- Debugging quest triggers
- Understanding code flow
- Hot-reload during testing

**Use MCP for:**
- Input simulation (button presses)
- Autonomous playtesting
- Scene structure inspection
- Game control (start/stop)

---

## Hybrid Workflow: Best of Both

### Optimal HPV Testing Setup

**Phase 1: Setup with Debugger**
1. Start game with VSCode debugger (F5)
2. Set breakpoint in `GameState.new_game()`
3. Modify `quest_flags` to skip to desired quest

**Phase 2: Playtest with MCP**
1. Use MCP for input simulation:
   ```bash
   simulate_action_tap --action ui_accept
   ```
2. Use MCP for scene inspection:
   ```bash
   get_runtime_scene_structure
   ```

**Phase 3: Debug Issues**
1. When something breaks, set breakpoint in relevant code
2. Use call stack to understand how you got there
3. Use Variables panel to inspect state
4. Fix and continue (hot-reload if needed)

---

## Manual Testing Checklist

### LSP Testing (Godot must be running)

- [ ] Open `game/autoload/game_state.gd`
- [ ] Type `GameState.` - verify autocomplete appears
- [ ] Press F12 on `get_flag` - should navigate to function
- [ ] Hover over `quest_flags` - should show type
- [ ] Type invalid code - should see red squiggle
- [ ] Check Output panel - no LSP errors

### Debugger Testing

- [ ] Open `game/autoload/game_state.gd`
- [ ] Set breakpoint on line 152 (`set_flag` function)
- [ ] Press F5 to start debugging
- [ ] Walk into any trigger that calls `set_flag`
- [ ] Verify breakpoint hits
- [ ] In Variables panel, expand `self` → `quest_flags`
- [ ] Double-click a value to modify it
- [ ] Press F5 to continue
- [ ] Verify modification persists

### HPV Integration Testing

- [ ] Start game with debugger
- [ ] Set breakpoint at quest start
- [ ] Modify `quest_flags` to skip quest
- [ ] Use MCP `simulate_action_tap` for button presses
- [ ] Verify hybrid workflow works

---

## Files Referenced

| File | Purpose |
|------|---------|
| `.vscode/settings.json` | Extension config |
| `.vscode/launch.json` | Debug configurations |
| `game/autoload/game_state.gd` | Main state singleton |
| `docs/playtesting/HPV_GUIDE.md` | HPV workflow guide |
| `docs/agent-instructions/tools/mcp-wrapper-usage.md` | MCP usage guide |

---

## Troubleshooting

### "LSP not working"

**Symptoms:** No autocomplete, no error squiggles

**Solutions:**
1. Verify Godot is running
2. Check Output panel → "GDScript Language Server" channel
3. Try: Reload Window (Ctrl+Shift+P → "Reload Window")
4. Verify `.vscode/settings.json` has correct Godot path

### "Breakpoint not hitting"

**Symptoms:** Breakpoint set but never triggers

**Solutions:**
1. Verify Godot debugger is running (port 6007)
2. Check you're debugging the right scene
3. Try "Attach to Running Game" configuration
4. Verify code path actually executes (function is called)

### "Can't modify variable in debugger"

**Symptoms:** Variables panel read-only

**Solutions:**
1. Game must be paused at breakpoint
2. Some variables can't be modified (constants, null)
3. Try modifying `quest_flags` dictionary entries instead of reassigning

---

## External References

- **Extension Repository:** https://github.com/ankitpriyarup/godot-tools
- **Godot LSP Documentation:** https://docs.godotengine.org/en/stable/tutorials/scripting/development_basics/using_code_editors.html
- **VSCode Debugging:** https://code.visualstudio.com/docs/editor/debugging
