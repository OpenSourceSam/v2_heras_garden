# HPV Quick Reference

**For:** Headed Playability Validation (HPV) with Godot MCP
**Last Updated:** 2026-01-21

---

## Vision: How to "See" the Game

### Primary Vision Tool: get_runtime_scene_structure

```bash
get_runtime_scene_structure
```

**What it returns:** Complete scene tree with every node's position, visibility, and properties.

**Example output:**
```
World/Player: position=[384, 96], visible=true
World/NPCs/Hermes: position=[400, 100], visible=true
World/UI/DialogueBox: visible=false
World/GameState: quest_flags={"quest_2_active": false}
```

### Alternative: Debugger Variables Panel

1. Start game with debugger (F5)
2. Set breakpoint anywhere
3. Check Variables panel
4. Expand `self` → `quest_flags`

---

## Finding Things in the Game

### Find Player Position

```bash
get_runtime_scene_structure
# Look for: World/Player: position=[x, y]
```

### Find NPC Positions

```bash
get_runtime_scene_structure
# Look for: World/NPCs/[NPC Name]: position=[x, y]
```

Common NPCs:
- Hermes: `World/NPCs/Hermes`
- Aeetes: `World/NPCs/Aeetes`
- Circe: `World/NPCs/Circe`
- Daedalus: `World/NPCs/Daedalus`
- Scylla: `World/NPCs/Scylla`

### Find Quest Triggers

```bash
get_runtime_scene_structure
# Look for: World/QuestTriggers/Quest[0-11]
```

### Find Interaction Points

```bash
get_runtime_scene_structure
# Look for: World/Interactables/
```

- HouseDoor: `World/Interactables/HouseDoor`
- Boat: `World/Interactables/Boat`
- AeetesNote: `World/Interactables/AeetesNote`

---

## Quest Flags Reference

### Progression Flags

| Flag | Purpose |
|------|---------|
| `prologue_complete` | Prologue finished |
| `met_hermes` | Hermes first interaction |
| `quest_N_active` | Quest N started |
| `quest_N_complete` | Quest N finished |

### Checking Quest Flags

**Via Debugger:**
1. F5 to start debugging
2. Check Variables panel → `quest_flags` dictionary

**Via MCP (if game running):**
```bash
get_runtime_scene_structure
# Look for World/GameState → quest_flags
```

---

## Navigation Methods

### Method 1: Walk (Input Simulation)

```bash
# Movement
simulate_action_tap --action ui_up
simulate_action_tap --action ui_down
simulate_action_tap --action ui_left
simulate_action_tap --action ui_right

# Interact
simulate_action_tap --action interact

# Advance dialogue
simulate_action_tap --action ui_accept
```

### Method 2: Teleport (Runtime Eval)

**Prerequisite:** Know the world index (check with `get_runtime_scene_structure`)

```gdscript
# Teleport player (replace WORLD_INDEX as needed)
get_tree().root.get_child(3).get_node("Player").set_global_position(Vector2(384, 96))

# Or find world by name
get_tree().root.find_child("World", true, false).get_node("Player").set_global_position(Vector2(384, 96))
```

**Common Positions:**
- Hermes area: `[384, 96]`
- Boat: `[384, 160]`
- House entrance: `[256, 96]`

### Method 3: Skip Scripts

```bash
# Run skip script headless
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/skip_to_quest2.gd

# Then start game
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'run_project --headed'"
```

---

## Dialogue Testing

### Advance Dialogue

```bash
# Press A button
simulate_action_tap --action ui_accept
```

### Check Dialogue Text

```bash
get_runtime_scene_structure
# Look for: World/UI/DialogueBox/Panel/Text
# Read the `text` property value
```

### Select Dialogue Choices

```bash
# First verify DialogueBox is visible
get_runtime_scene_structure

# Use debugger or runtime eval to show choices
# Then press ui_accept to confirm
```

---

## Common Node Paths

### World Structure
- World: `get_tree().root.get_child(3)` or `get_child(4)`
- Player: `World/Player`
- UI: `World/UI`
- DialogueBox: `World/UI/DialogueBox`

### Quest Triggers
- `World/QuestTriggers/Quest0` through `Quest11`
- `World/QuestTriggers/Epilogue`

### NPCs
- `World/NPCs/Hermes`
- `World/NPCs/Aeetes`
- `World/NPCs/Circe`
- `World/NPCs/Daedalus`
- `World/NPCs/Scylla`

---

## Debugger Flag-Setting (Alternative to MCP)

MCP `execute_editor_script` fails with quote escaping. Use debugger instead:

1. **Start game with debugger** (F5)
2. **Set breakpoint** anywhere (e.g., `GameState._ready`)
3. **When paused**, go to Variables panel
4. **Expand** `self` → `quest_flags`
5. **Double-click** any value to modify
6. **Press F5** to continue

**Or use Debug Console:**
```
quest_flags["quest_2_active"] = true
```

---

## Quick Commands Reference

### IDE Extension Agents (Cursor, VSCode)

```bash
# Health check
powershell -ExecutionPolicy Bypass -File scripts/mcp-health-check.ps1

# Start game
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'run_project --headed'"

# See scene structure
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_runtime_scene_structure' -Quiet"

# Simulate input
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'simulate_action_tap --action ui_accept'"
```

### Terminal Agents

```bash
# Start game
npx -y godot-mcp-cli@latest run_project --headed

# See scene structure
npx -y godot-mcp-cli@latest get_runtime_scene_structure

# Simulate input
npx -y godot-mcp-cli@latest simulate_action_tap --action "ui_accept"
```

---

## Troubleshooting

### "Can't see player position"

**Solution:**
```bash
get_runtime_scene_structure
# Look for World/Player: position=[x, y]
```

### "Don't know where NPC is"

**Solution:**
```bash
get_runtime_scene_structure
# Look for World/NPCs/[Name]: position=[x, y]
```

### "Can't set quest flags"

**Solution:** Use debugger instead of MCP
1. F5 to start debugging
2. Set breakpoint
3. Variables panel → quest_flags → double-click to modify

### "get_runtime_scene_structure unavailable"

**Solution:** Game not running. Start game first:
```bash
powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'run_project --headed'"
```

---

## File References

- **Full guide:** `docs/playtesting/HPV_GUIDE.md`
- **Skill:** `.claude/skills/playtesting/SKILL.md`
- **MCP wrapper:** `docs/agent-instructions/tools/mcp-wrapper-usage.md`
- **Godot Tools:** `docs/agent-instructions/tools/godot-tools-extension-hpv-guide.md`
- **Roadmap:** `docs/playtesting/PLAYTESTING_ROADMAP.md`

---

## Key Insight

**You are NOT "blind" when testing games.**

`get_runtime_scene_structure` IS your vision - it shows you:
- Where the player is (position)
- Where NPCs are (position)
- What's visible (visibility property)
- Quest state (quest_flags)
- Inventory items
- Dialogue text
- Everything in the scene tree

Use this to navigate and test efficiently!
