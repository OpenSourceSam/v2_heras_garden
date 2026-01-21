# MiniMax HPV Testing Guide

**Last Updated:** 2026-01-15
**Target Agent:** MiniMax (RooCode Harness)
**Purpose:** Complete reference for running Headed Playability Validation (HPV) tests

---

## Quick Start (5 Minutes)

### Prerequisites Checked
- ✅ BOM corruption fixed in house_door.tscn and aiaia_arrival.tres
- ✅ .gitattributes rules added to prevent recurrence
- ✅ MCP server functional in Cursor environment

### Launch Your First HPV Test

```bash
# Terminal 1: Start game
npx -y godot-mcp-cli run_project --headed

# Terminal 2: Verify MCP works
npx -y godot-mcp-cli get_runtime_scene_structure

# Terminal 2: Start new game
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"
```

**Expected Result:** Game window opens, you see title screen, pressing ui_accept starts the game.

---

## MCP Commands Reference

### Runtime Inspection

| Command | Purpose | Example Output |
|---------|---------|----------------|
| `get_runtime_scene_structure` | Full scene tree with all nodes, properties, visibility | Scene: MainMenu, Nodes: NewGameButton (visible=true, position=[100,200]) |
| `get_input_actions` | List all available input actions | ui_accept, ui_cancel, ui_left, ui_right, ui_up, ui_down, interact, ui_inventory |
| `get_project_info` | Project settings and configuration | Project name, version, Godot version |

### Input Simulation

| Command | Godot Action | Gamepad Equivalent | Use Cases |
|---------|--------------|-------------------|-----------|
| `simulate_action_tap --action "ui_accept"` | ui_accept | A button | Confirm, interact, advance dialogue |
| `simulate_action_tap --action "ui_cancel"` | ui_cancel | B button | Cancel, back |
| `simulate_action_tap --action "ui_select"` | ui_select | X button | Alternate select |
| `simulate_action_tap --action "ui_left"` | ui_left | D-pad ← | Move left, navigate menus |
| `simulate_action_tap --action "ui_right"` | ui_right | D-pad → | Move right, navigate menus |
| `simulate_action_tap --action "ui_up"` | ui_up | D-pad ↑ | Move up, navigate menus |
| `simulate_action_tap --action "ui_down"` | ui_down | D-pad ↓ | Move down, navigate menus |
| `simulate_action_tap --action "interact"` | interact | A button / E key | Same as ui_accept for interactions |
| `simulate_action_tap --action "ui_inventory"` | ui_inventory | X button / I key | Toggle inventory |

---

## Codex's Proven HPV Workflow

### The Pattern That Works

1. **Launch Game** → `run_project --headed`
2. **Inspect State** → `get_runtime_scene_structure` (verify expected scene/nodes)
3. **Simulate Input** → `simulate_action_tap --action "ui_accept"` (perform action)
4. **Verify Result** → `get_runtime_scene_structure` again (confirm state changed)
5. **Document** → Report what you observed
6. **Repeat** → Continue through game flow

### Why This Works
- **Visual validation** - You see the game respond in real-time
- **Programmatic verification** - Scene structure confirms internal state
- **No custom commands needed** - Uses standard MCP tools only
- **Works in any harness** - Cursor, VS Code, RooCode all support these commands

---

## Complete HPV Test Example: Quest 0 & 1

### Step-by-Step Commands

```bash
# 1. Start game (Terminal 1 - keep running)
npx -y godot-mcp-cli run_project --headed

# 2. Verify title screen
npx -y godot-mcp-cli get_runtime_scene_structure

# 3. Start new game
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"

# 4. Advance prologue (repeat 10-15 times, 1 sec apart)
# Optional fast path: tap ui_cancel once to skip the prologue cutscene.
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"

# 5. Verify World scene loaded
npx -y godot-mcp-cli get_runtime_scene_structure

# 6. Move player north (10 presses)
npx -y godot-mcp-cli simulate_action_tap --action "ui_up"
```

---

## Skipping to Late-Game Quests

```powershell
# Kill running instances
Stop-Process -Name "Godot*" -Force -ErrorAction SilentlyContinue

# Run skip script
.\Godot_v4.5.1-stable_win64.exe --headless --script tests/skip_to_quest10_and_load_world.gd

# Launch headed mode
npx -y godot-mcp-cli run_project --headed
```

**Result:** Player at Quest 10 position with full inventory.

---

## MCP Troubleshooting Framework

### Quick Health Check

Before starting any HPV session, verify MCP is working:

```bash
# Run health check
powershell -ExecutionPolicy Bypass -File scripts/mcp-health-check.ps1

# For JSON output (parsing)
powershell -ExecutionPolicy Bypass -File scripts/mcp-health-check.ps1 -JSON
```

**Expected output:** Status should be `healthy`, all checks should pass.

### Health Check Status

| Status | Meaning | Action |
|--------|---------|--------|
| `healthy` | All systems go | Proceed with playtesting |
| `degraded` | Partial failure | Follow recommendations |
| `down` | Complete failure | Run recovery script |

### Recovery Procedures

**Level 1: Light Recovery** (Single command timeout)
```bash
# Just retry the command
npx -y godot-mcp-cli@latest get_project_info
```

**Level 2: Medium Recovery** (Port 9080 not listening)
```bash
# Check for duplicate Godot processes
tasklist | findstr /i "Godot"

# If duplicates found, kill all and restart
Stop-Process -Name "Godot*" -Force
powershell -File .claude/skills/godot-mcp-dap-start/scripts/ensure_godot_mcp.ps1
```

**Level 3: Heavy Recovery** (Complete MCP failure)
```bash
# Full automated recovery
powershell -ExecutionPolicy Bypass -File .claude/skills/mcp-recovery/scripts/recover.ps1
```

### Common Error Patterns

| Error | Cause | Solution |
|-------|-------|----------|
| "Port 9080 not listening" | Godot not running or MCP addon not loaded | Start Godot with MCP |
| "Connection refused" | Duplicate Godot processes | Kill duplicates, restart one |
| "Unknown command" | MCP CLI not installed | `npx -y godot-mcp-cli@latest --version` |
| "Timeout on get_runtime_scene_structure" | Game not started | `run_project --headed` |
| "Multiple Godot processes" | Previous sessions didn't close | `Stop-Process -Name "Godot*" -Force` |

### Escalation Criteria

Ask user for help when:
- Recovery script fails 3 times in a row
- Godot fails to start after heavy recovery
- MCP addon shows errors in Godot console
- Script errors prevent MCP from loading

### Verification After Recovery

Always run health check after recovery:
```bash
powershell -ExecutionPolicy Bypass -File scripts/mcp-health-check.ps1
```

---

## Common Issues & Solutions

### "Unknown command" Error
**Solution:** Check `.cursor/mcp.json` exists, restart Cursor

### Game Window Doesn't Open
**Solution:** Use full Godot path: `.\Godot_v4.5.1-stable_win64.exe --path .`

### Dialogue Not Advancing
**Solution:** Verify DialogueBox visible with `get_runtime_scene_structure`, use "ui_accept" not "A"

### Parse Errors After BOM Fix
**Solution:** Delete `.godot/` folder, reopen project to rebuild cache

### "Connection Refused" on MCP Commands
**Solution:** Check Godot console for "WebSocket server started on port 9080"

---

## Input Action Reference

- **ui_accept** - A button (confirm, dialogue advance)
- **ui_cancel** - B button (cancel, back)
- **ui_select** - X button (alternate select)
- **ui_left/right/up/down** - D-pad navigation
- **interact** - E key / A button (interactions)
- **ui_inventory** - I key / X button (toggle inventory)

---

## What NOT to Do

❌ Don't use custom runtime_state_commands (get_flag, set_flag) - not exposed in RooCode CLI
❌ Don't build PowerShell wrappers - standard tools sufficient
❌ Don't modify MCP server code - works correctly
❌ Don't assume file paths - use Glob first
❌ Don't repeat failed commands 10+ times - stop at 3, ask for help

---

## Success Criteria

✅ Start game via MCP without errors
✅ Navigate menus with simulate_action_tap
✅ Advance all dialogue types
✅ Complete minigames using inputs
✅ Verify state with get_runtime_scene_structure
✅ Skip to any quest using scripts
✅ Document findings in reports

---

## File References

- **This Guide:** `docs/playtesting/HPV_GUIDE.md`
- **Plan:** `.claude/plans/tender-swinging-trinket.md`
- **Quest Flow:** `docs/playtesting/PLAYTESTING_ROADMAP.md`
- **Input Config:** `project.godot` (lines 68-124)
- **Skip Scripts:** `tests/skip_to_quest10.gd`, `tests/skip_to_quest10_and_load_world.gd`

---

**Guide Version:** 1.0
**Created:** 2026-01-15
**Author:** Senior Engineer (Claude Sonnet 4.5)
**Estimated Time to Proficiency:** 2-3 HPV sessions (1-2 hours each)
