# Godot Tools Extension: Complete Testing Guide

**Status:** Critical workflow component (installed but previously unused)
**Version:** 2.0 (Full Godot 4 Support)
**Extension:** `geequlim.godot-tools` by geequlim
**Installation:** ✅ Already installed in VS Code

---

## Executive Summary

The Godot Tools extension provides **integrated GDScript development and debugging** directly in VS Code. It's **more stable than godot-mcp** and was installed weeks ago but never utilized.

**Key Features:**
- GDScript LSP (Language Server Protocol) for autocomplete and go-to-definition
- VS Code debugger with breakpoints and variable inspection
- Scene preview in VS Code
- Headless LSP mode (no editor window required)

**Why This Matters:**
Instead of jumping between VS Code and Godot editor, you can:
1. Write GDScript in VS Code with full autocomplete
2. Press F5 to debug with breakpoints
3. Inspect game state in real-time
4. Fix bugs without switching windows

---

## Current Configuration

**File:** `.vscode/settings.json`
```json
{
    "godotTools.editorPath.godot4": "c:\\Users\\Sam\\Documents\\GitHub\\v2_heras_garden\\Godot_v4.5.1-stable_win64.exe\\Godot_v4.5.1-stable_win64.exe",
    "godotTools.lsp.serverPort": 6005,
    "godotTools.lsp.headless": false,
    "godotTools.debugger.serverPort": 6007,
    "godotTools.editor.execFlags": "{project} --goto {file}:{line}:{col}",
    "[gdscript]": {
        "editor.formatOnSave": true
    }
}
```

**Status:** ✅ Already configured correctly
**LSP Mode:** Requires Godot editor open (headless mode disabled)

---

## Feature Overview

### 1. GDScript Language Features

#### Autocomplete & Intellisense
```gdscript
# Type "GameState." and get full list of methods/properties
GameState.add_item()  # Full autocomplete with parameter hints
```

**Available:**
- Function signatures with parameter hints
- Variable type inference
- Built-in Godot class members
- Custom script members (with caveats for dynamic code)
- Doc comments in hover previews

**Enable Smart Mode for better dynamic typing:**
- Godot Editor → Editor Settings → Language Server
- Enable "Smart Resolve"
- Better member resolution for untyped variables

#### Go-to-Definition
```
Ctrl+Click on any symbol to jump to definition
```

**Works for:**
- Custom functions and variables
- Godot built-in classes (opens documentation)
- Resource paths (`res://path/to/file.tscn`)
- External script imports

#### Hover Previews
```
Hover over any symbol to see definition
```

**Shows:**
- Function signatures
- Variable types
- Doc-comments
- Resource paths with previews

#### Script Warnings & Errors
- Real-time inline error reporting
- Missing variables, type mismatches, unused variables
- Similar to Godot editor diagnostics

#### Switch Between Script and Scene
```
Alt+O - Toggle between .gd and related .tscn file
```

#### Builtin Code Formatter
```
Format on Save: enabled (configured)
```

---

### 2. GDScript Debugger (Completely Rewritten in v2.0)

**Major Improvements:**
- Greatly improved reliability
- Simple configuration (just hit F5!)
- Multiple launch targets

#### Debugger Features

**Breakpoints**
- Click left gutter to set breakpoint
- Breakpoints persist across runs
- Conditional breakpoints (right-click on breakpoint)

**Step Controls**
- F10: Step over (current line)
- F11: Step in (enter function)
- Shift+F11: Step out (exit function)
- Continue (F5 while in debug session)

**Variable Inspection**
- Watch panel shows all in-scope variables
- Click expand arrows to drill down into objects
- Edit values: click pencil icon next to integer/float/string/boolean

**Call Stack**
- See function call hierarchy
- Click any frame to jump to that location

**Active Scene Tree**
- View all nodes in current scene
- Refresh with button in top-right
- Click Eye icon to inspect node in Inspector

**Inspector**
- View node properties
- Edit properties during debugging
- Useful for checking node states

#### Quick Start: 5-Minute Setup

**Step 1: Create Launch Configuration**

Open `.vscode/launch.json` (or create if missing):

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Current File",
      "type": "godot",
      "request": "launch",
      "scene": "current"
    }
  ]
}
```

**Step 2: Set a Breakpoint**
1. Open any `.gd` file
2. Click left gutter (next to line number) to place red dot
3. Breakpoint is set

**Step 3: Start Debugging**
1. Press F5
2. Godot launches with debugger attached
3. Game runs until it hits your breakpoint
4. VS Code pauses execution
5. Inspect variables in Watch panel
6. Press F5 to continue or F10 to step

#### Advanced: Multiple Launch Targets

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Current Scene",
      "type": "godot",
      "request": "launch",
      "scene": "current"
    },
    {
      "name": "Debug Pinned File",
      "type": "godot",
      "request": "launch",
      "scene": "pinned"
    },
    {
      "name": "Debug Main Scene",
      "type": "godot",
      "request": "launch",
      "scene": "main"
    },
    {
      "name": "Debug Test Script",
      "type": "godot",
      "request": "launch",
      "scene": "res://tests/run_tests.gd"
    },
    {
      "name": "Attach to Running Game",
      "type": "godot",
      "request": "attach",
      "address": "127.0.0.1",
      "port": 6007
    }
  ]
}
```

**Using Multiple Configs:**
- Click Run and Debug view in VS Code sidebar
- Select configuration from dropdown
- Press F5 to launch

#### Pin/Unpin Files for Quick Debugging

**Command Palette:**
```
Ctrl+Shift+P → "Godot Tools: Pin/Unpin the current .tscn/.gd file for debugging"
```

**Why Useful:**
- Test same file repeatedly without opening it
- Quickly switch between frequently-tested files
- View pinned file: `Godot Tools: Open the pinned file`

---

### 3. GDResource Language Features (.tscn and .tres)

#### Syntax Highlighting
- Color-coded for scene files
- Clear structure visualization

#### Symbol Navigation
```
Ctrl+Click on res:// paths or symbols to open/navigate
```

#### Hover Previews
- External and Sub-resource information
- Inlay hints for resource visualization

#### In-Editor Scene Preview
- View `.tscn` structure in VS Code
- No need to open Godot editor just to check scene layout
- Useful for quick scene reference

---

### 4. Command Palette Commands

Press `Ctrl+Shift+P` and type "Godot Tools":

```
> Godot Tools: Open workspace with Godot editor
  → Launches Godot editor for this project

> Godot Tools: List Godot's native classes
  → Search and view Godot built-in class documentation

> Godot Tools: Debug the current .tscn/.gd file
  → Launches debugger for current file

> Godot Tools: Debug the pinned .tscn/.gd file
  → Launches debugger for pinned file

> Godot Tools: Pin/Unpin the current .tscn/.gd file for debugging
  → Marks file for quick debug access

> Godot Tools: Open the pinned file
  → Jump to currently pinned file
```

---

## Testing Workflow: HLC vs HPV

### When to Use HLC (Headless Logic Check)

**Purpose:** Logic validation, state correctness
**Speed:** ⚡ Fast (seconds to minutes)
**Tools:** CLI only (no debugger needed)

```powershell
# Run logic tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_dialogue_flow_test.gd
```

**Use for:**
- Quest flag progression
- Inventory state changes
- Save/load integrity
- Crafting recipe logic
- Day advancement and crop growth
- Soft-lock prevention
- Any logic that doesn't require visual output

**Advantages:**
- Runs in seconds
- No window overhead
- Can run in CI/CD pipeline
- Fast feedback loop during development

**Limitations:**
- Typically does not capture viewport textures
- No visual UI verification
- No human experience simulation
- Typically does not detect UI rendering issues

### When to Use HPV (Headed Playability Validation)

**Purpose:** Visual UX validation, human playability
**Speed:** 🐢 Slower (minutes to hours)
**Tools:** Godot Tools debugger (F5 in VS Code)

```powershell
# Run visual tests with debugger attached
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --path . --remote-debug tcp://127.0.0.1:6007
```

**Use for:**
- Minigame UI visibility and clarity
- Dialogue text readability
- Crafting pattern display
- UI element positioning and contrast
- Animation timing and responsiveness
- Button press feedback
- Overall human experience

**Advantages:**
- Actual rendered output
- Can capture screenshots
- Tests human interaction
- Reveals UX issues that logic tests miss
- Can use debugger for interactive testing

**Limitations:**
- Slower (real rendering overhead)
- Requires visual inspection
- More complex to automate

### Recommended Workflow

1. **During Development (Daily)**
   - Write code in VS Code with Godot Tools LSP
   - Run HLC for quick logic validation
   - Use HPV when validating playability changes

2. **Before Commit**
   - Run relevant HLC suite
   - Include HPV if playability changes are in scope
   - Commit when logic is verified

3. **Weekly/Milestone**
   - Run HPV playability validation (example: `tests/autonomous_headed_playthrough.gd`)
   - Review screenshots and output
   - Use VS Code debugger to inspect UX issues
   - Fix visual/timing bugs
   - Re-run HPV to verify

4. **Pre-Release**
   - Run complete test suite (HLC + HPV)
   - Manual playthrough on target device
   - Final polish and validation

---

## Cardinal Rules: HPV for UX Validation

**Context:** Logic tests pass but human playability requires visual validation. The following rules ensure agents use the appropriate testing approach.

### Strongly Recommended for Human Playability Testing

**Prefer HPV over HLC log parsing when validating UX:**

- **HPV with Godot Tools** captures visual state, enables breakpoint debugging, allows variable inspection
- **HLC log parsing** can tell you IF something broke, but not WHY the human experience is broken
- **The gap:** HLC logging reports "Dialogue timeout error"; HPV inspection reveals "dialogue_box.visible=false when it should be true"

### When HLC is Appropriate

HLC works well for **logic validation only:**
- Quest flag progression
- Inventory state changes
- Save/load data integrity
- Crafting recipe logic
- Day advancement mechanics
- Fast regression testing

### Critical Distinction

**Avoid falling back to HLC log parsing when the goal is UX validation.**

When testing human playability:
- ❌ **Don't:** Run HLC → parse logs → guess at UX issues
- ✅ **Do:** Run HPV → inspect visual state → document issues

### Programmatic Debugging for Autonomous Testing

**Agents can validate UX autonomously using HPV (headed mode):**

1. **Launch with remote debug:**
   ```powershell
   Godot*.exe --path . --remote-debug tcp://127.0.0.1:6007
   ```

2. **Enhanced test scripts can capture state programmatically:**
   - Check `dialogue_box.visible` in test script
   - Verify `minigame_node != null`
   - Capture screenshots programmatically
   - Print game variables, UI flags, node properties
   - Report findings in structured format

3. **All without human interaction:**
   - No need for human to click F5
   - No need for human to set breakpoints
   - Test script automates state inspection
   - Test script documents findings

**The Key Insight:**
Human-like testing can be done autonomously. The limitation is NOT that agents need humans to press F5. The limitation is that HLC does not capture visual state. Use HPV programmatically.

### Summary

| Goal | Use | Rationale |
|------|-----|-----------|
| **Logic validation** | HLC (headless CLI) | Fast, no visual output needed |
| **UX validation** | HPV (headed visual) | Can see/inspect state, catch human experience issues |
| **Regression testing** | HLC (headless CLI) | Quick feedback on code changes |
| **Human playability** | HPV (headed programmatic) | Full state visibility, autonomous inspection |

---

## Advanced: Headless LSP Mode

**Available:** Godot 4.2+
**Purpose:** LSP without Godot editor window

### Enable Headless LSP

Edit `.vscode/settings.json`:
```json
{
    "godotTools.lsp.headless": true
}
```

**What happens:**
- Extension auto-launches windowless Godot instance
- LSP works without editor window
- Frees system resources
- Still supports debugging (requires running editor later)

**When to use:**
- Large projects where editor window causes lag
- Running on low-resource systems
- Want LSP without extra windows

**Trade-off:**
- Slightly slower initial connection (first use)
- Debugging still requires separate Godot instance

### Current Configuration
```json
"godotTools.lsp.headless": false  // Requires Godot editor open
```

---

## Troubleshooting

### LSP Not Connecting

**Problem:** "Failed to connect to language server"

**Solutions (in order):**
1. Make sure Godot editor is running
2. Make sure project is open in Godot editor
3. Check `.vscode/settings.json` has correct port (6005)
4. Click "Retry" in VS Code status bar
5. Restart VS Code
6. Restart Godot editor

### IntelliSense Not Showing Members

**Problem:** Autocomplete only shows built-in functions, not custom members

**Solutions:**
1. Enable Smart Resolve in Godot editor:
   - Editor Settings → Language Server → Enable Smart Resolve
2. Use type hints in GDScript:
   ```gdscript
   # Better
   var state: GameState = GameState

   # Worse (LSP can't infer type)
   var state = GameState
   ```
3. Check script syntax errors (LSP may disable on parse errors)

### Debugger Not Starting

**Problem:** F5 doesn't launch debugger

**Solutions:**
1. Create `.vscode/launch.json` if missing
2. Check `godotTools.debugger.serverPort` is 6007
3. Make sure Godot editor is running
4. Try attaching instead of launching:
   ```json
   {
     "name": "Attach to Running Game",
     "type": "godot",
     "request": "attach"
   }
   ```

### Breakpoints Not Hit

**Problem:** Breakpoints set but code doesn't pause

**Solutions:**
1. Verify breakpoint is set (should be red dot)
2. Make sure you're running the correct file
3. Check if code path actually executes (add print statements)
4. Restart debugging session (stop with Shift+F5, start with F5)

---

## Quick Reference

### Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Go to Definition | Ctrl+Click |
| Find References | Shift+F12 |
| Symbol Search | Ctrl+T |
| Switch to Scene | Alt+O |
| Format Document | Shift+Alt+F |
| Start Debugging | F5 |
| Step Over | F10 |
| Step In | F11 |
| Step Out | Shift+F11 |
| Continue | F5 (when paused) |
| Stop Debugging | Shift+F5 |
| Toggle Breakpoint | Click left gutter |

### Testing Commands

```powershell
# HLC (headless logic checks)
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# HPV (headed playability validation) - with debugger
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --path . --remote-debug tcp://127.0.0.1:6007 --script tests/autonomous_headed_playthrough.gd

# Via Debugger (F5 in VS Code)
# Select "Debug Test Script" or "Attach to Running Game" from Run menu
```

---

## Integration with Project Workflow

### For GDScript Development
1. Open file in VS Code
2. Use Ctrl+Click for navigation
3. Hover for doc-comments
4. Format with Shift+Alt+F

### For Testing & Debugging
1. Set breakpoint (click gutter)
2. Press F5 to debug
3. Step with F10/F11
4. Watch variables in panel
5. Edit values during pause
6. Continue with F5

### For Scene Work
1. Open `.tscn` file in VS Code
2. Use Alt+O to switch from script to scene
3. View scene structure in editor
4. Use Ctrl+Click to navigate resources

---

## When to Use Godot Tools vs Godot Editor

| Task | Tool | Why |
|------|------|-----|
| Edit GDScript | Godot Tools | Better autocomplete, faster |
| Edit visual layout | Godot Editor | Drag-and-drop UI editing |
| Debug script behavior | Godot Tools | Breakpoints and stepping |
| Debug rendering | Godot Editor | Visual layout inspection |
| Quick scene check | Godot Tools | Scene preview in VS Code |
| Complex scene design | Godot Editor | Full editor features |
| Test logic | Godot Tools | Run HLC |
| Test visuals | Godot Tools | Run HPV with debugger |

---

## Summary

**Godot Tools enables:**
- ✅ Faster GDScript development (autocomplete, go-to-definition)
- ✅ Integrated debugging (breakpoints, stepping, variable inspection)
- ✅ Unified workflow (no window switching)
- ✅ Visual and logic testing (HPV and HLC)
- ✅ Scene preview without opening editor

**Key takeaway:**
> Press F5 to debug. Set breakpoints. Inspect state. Fix bugs. Repeat.

This is the primary workflow for game development and testing going forward.
[Claude Haiku 4.5 - 2026-01-02] - Added Cardinal Rules: HPV for UX Validation section
[Codex - 2025-12-29]
[Codex - 2026-01-08]
