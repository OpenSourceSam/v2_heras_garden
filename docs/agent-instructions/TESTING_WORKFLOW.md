# Testing Workflow Guide

**Last Updated:** 2026-01-23
**Status:** Current - Single source of truth for testing methods

---

## Quick Start: Which Testing Method Should I Use?

| Agent Type | Primary Method | Tools | When to Use |
|------------|----------------|-------|------------|
| **IDE Extension** (Cursor, VS Code) | MCP CLI + VSCode Debugger | `npx godot-mcp-cli`, PowerShell wrapper, F5 Variables panel | All testing - use MCP for inspection, debugger for flags |
| **Claude Desktop** | Native MCP + DAP Debugger | `mcp__godot__*` tools, F5 breakpoints | All testing - full tool access |
| **Terminal** (RooCode, GPT Codex) | MCP CLI | `npx godot-mcp-cli` | All testing - direct subprocess access |

**Key Point:** We use **efficient programmatic testing**, NOT full human-level playthroughs.

---

## Testing Methods Explained

### HPV (Headed Playability Validation) - Our Primary Method

**What it is:** Programmatic testing using MCP tools to inspect game state and simulate input

**What it is NOT:** Full human-level playthroughs, watching gameplay, "beating the game manually"

**Workflow:**
```
1. Launch: F5 debugger (VSCode) or run_project --headed (MCP)
2. Inspect: get_runtime_scene_structure for full game state
3. Act: simulate_action_tap --action "ui_accept" for input
4. Verify: Check scene structure again for state changes
5. Skip: Use VSCode Variables panel to set quest flags (minigames)
6. Document: Log findings in PLAYTESTING_ROADMAP.md
```

**When to use HPV:**
- Validating quest flow and progression
- Testing dialogue choices and branching
- Verifying scene transitions and triggers
- Checking NPC interactions and routing
- All Phase 7 validation tasks

**When NOT to use HPV:**
- Unit testing logic (use HLC/headless tests instead)
- Performance benchmarking
- Full "beaten the game" validation (use for quest flow, not completion)

### DAP (Debug Adapter Protocol) - Desktop Agents Only

**What it is:** Native debugger integration with breakpoints, step debugging, call stack

**Tools Available:**
- `godot_set_breakpoint` - Set breakpoint at file:line
- `godot_get_variables` - Inspect all variables
- `godot_get_stack_trace` - Get call stack
- `godot_evaluate` - Evaluate expressions
- `godot_set_variable` - Modify variable values

**When to use DAP:**
- Desktop agents (Claude Desktop) only
- Need true breakpoints (not scene inspection)
- Step debugging through code
- Inspecting call stacks and variable scopes

**When NOT to use DAP:**
- IDE extension agents (no DAP access)
- Simple state inspection (use MCP instead)
- Input simulation (use simulate_action_tap instead)

### HLC (Headless Logic Check) - Fast Unit Tests

**What it is:** Fast automated tests without graphics

**When to use HLC:**
- Testing individual functions
- Validating data structures
- Checking quest flag logic
- Running automated test suites

---

## Common Testing Patterns

### Pattern 1: Quest Progression Validation

**Goal:** Verify a quest completes correctly

```bash
# 1. Launch game
npx -y godot-mcp-cli run_project --headed

# 2. Get current state
npx -y godot-mcp-cli get_runtime_scene_structure

# 3. Navigate to quest trigger (or use VSCode debugger)
# In VSCode Variables panel: Set quest_N_active = true

# 4. Complete quest (skip minigame via debugger flags)
# In VSCode Variables panel: Set quest_N_complete = true

# 5. Verify state change
npx -y godot-mcp-cli get_runtime_scene_structure

# 6. Check next quest triggered
# Look for quest_N+1_active flag in scene structure
```

### Pattern 2: Dialogue Choice Testing

**Goal:** Verify dialogue choices work

```bash
# 1. Navigate to dialogue (using MCP input or teleport)
npx -y godot-mcp-cli simulate_action_tap --action "ui_up"  # Walk to NPC
npx -y godot-mcp-cli simulate_action_tap --action "interact"  # Talk to NPC

# 2. Advance dialogue to choices
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"  # Repeat through lines

# 3. Select choice (verify choice appears in scene structure)
npx -y godot-mcp-cli get_runtime_scene_structure  # Check choices visible

# 4. Test choice selection
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"  # Select choice

# 5. Verify next dialogue loads
npx -y godot-mcp-cli get_runtime_scene_structure  # Check new dialogue_id
```

### Pattern 3: Minigame Skipping (Debugger)

**Goal:** Skip minigames for quest flow testing

```
# In VSCode Debugger Variables Panel:
# Find: GameState.quest_flags
# Set: quest_1_complete = true
# Set: quest_2_complete = true
# etc.

# This skips the minigame but validates quest flow continues
```

**Note:** Minigames themselves are validated separately. Phase 7 focuses on quest wiring and flow.

---

## MCP Tool Reference

### Inspection Tools

| Tool | Purpose | Example Output |
|------|---------|----------------|
| `get_runtime_scene_structure` | Full scene tree | All nodes, positions, properties, visibility |
| `get_project_info` | Project settings | Godot version, scene paths |
| `get_input_actions` | Available inputs | ui_accept, ui_cancel, interact, etc. |

### Input Simulation

| Tool | Purpose | Example |
|------|---------|---------|
| `simulate_action_tap --action "ui_accept"` | Press accept | Advance dialogue, confirm |
| `simulate_action_tap --action "ui_cancel"` | Press cancel | Back, skip cutscene |
| `simulate_action_tap --action "ui_up"` | Move up | Walk north, navigate menu |
| `simulate_action_tap --action "interact"` | Interact | Talk to NPC, use object |

### PowerShell Wrapper (IDE Agents)

```bash
# For IDE extension agents that can't use npx directly:
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_runtime_scene_structure'"
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'simulate_action_tap --action ui_accept'"
```

---

## VSCode Debugger Reference (All Agents)

### Variables Panel Access

All agents can use VSCode debugger (F5) to inspect variables:

1. Press F5 to start debugging
2. Set breakpoints by clicking line numbers
3. When paused, inspect Variables panel
4. Find `GameState.quest_flags` dictionary
5. Modify values directly in the panel

### Common Flag Modifications

| Flag | Purpose |
|------|---------|
| `quest_N_active` | Activate quest N |
| `quest_N_complete` | Complete quest N (skip minigame) |
| `met_hermes` | Unlock Hermes NPC |
| `ending_witch` | Trigger witch ending |
| `ending_healer` | Trigger healer ending |

---

## Troubleshooting

| Problem | Check | Fix |
|---------|-------|-----|
| MCP not responding | Run health check | `powershell -File scripts/mcp-health-check.ps1` |
| Scene structure empty | Game not running | Launch with `run_project --headed` |
| Input not working | Wrong action name | Check `get_input_actions` for valid names |
| Breakpoints not hitting | Wrong file path | Verify scene is loaded, check file matches |
| Can't find quest flags | GameState not visible | Use `get_runtime_scene_structure` to find path |

---

## Documentation References

**Primary:**
- `CLAUDE.md` - Project rules and HPV Interaction Reminder (line 78)
- `DEVELOPMENT_ROADMAP.md` - Current phase and tasks
- `PLAYTESTING_ROADMAP.md` - HPV session logs and blockers

**Supplementary:**
- `HPV_GUIDE.md` - Detailed HPV patterns and commands
- `dap-integration.md` - DAP tools (Desktop agents only)
- `mcp-wrapper-usage.md` - PowerShell wrapper for IDE agents

**Outdated References (Ignore):**
- Old HPV patterns describing full human-level playthroughs
- Walking instructions (use teleports or debugger instead)
- Manual minigame completion (use debugger flags)

---

## Quick Decision Flow

```
Need to test something?
│
├─ Unit test / logic only? → Use HLC (headless tests)
│
├─ Need game state? → Use HPV with MCP
│   ├─ Desktop agent? → Use native MCP tools or DAP
│   └─ IDE agent? → Use MCP CLI or PowerShell wrapper
│
└─ Need breakpoints/step debug? → Use DAP (Desktop only)
```

---

**Remember:** Efficient programmatic testing, not full playthroughs. Skip minigames with debugger flags. Document findings in PLAYTESTING_ROADMAP.md.
