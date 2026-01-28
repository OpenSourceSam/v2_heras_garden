# Agent Onboarding

**Environment:** Cursor (not VS Code) | **MCP:** `.cursor/mcp.json` | **Godot 4.5.1**

**Last Updated:** 2026-01-28

---

## 🚀 Quick Start (New Agents)

1. **Read Session Manifest:** `.session_manifest.json` - Check time commitment
2. **Read Current Status:** `docs/Development/CURRENT_STATUS.md` - What's happening now
3. **Read Testing Guide:** Below - How to test effectively
4. **Check Skills:** `.claude/skills/` - Available capabilities

---

## 📊 Current Project Status

**Game:** Circe's Garden v2  
**Phase:** 8 (Visual Development)  
**Story:** ✅ 100% Complete (49/49 beats, 11 quests)  
**Code:** ✅ Tests passing (5/5)  
**Visuals:** 🔄 In Progress (sprites improved, composition review needed)

**Last Work:** 2026-01-28 - 45+ sprites improved to production quality

**See:** `docs/Development/DEVELOPMENT_HUB.md` for full details

---

## 🎮 Testing Guide (HPV - Headed Playability Validation)

### Quick Test
```bash
# Run tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# Launch game (if MCP available)
npx -y godot-mcp-cli run_project --headed

# Check scene
npx -y godot-mcp-cli get_runtime_scene_structure

# Simulate input
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"
```

### Testing Methods

| Method | Use When | Command |
|--------|----------|---------|
| **HLC** (Headless) | Unit tests, logic | `--headless --script tests/run_tests.gd` |
| **HPV** (Headed) | Game state, flow | `run_project --headed` + MCP tools |
| **DAP** (Debugger) | Breakpoints, variables | F5 in VSCode |

### Key MCP Commands
```bash
# Inspection
npx -y godot-mcp-cli get_runtime_scene_structure
npx -y godot-mcp-cli get_input_actions

# Input
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"
npx -y godot-mcp-cli simulate_action_tap --action "interact"
npx -y godot-mcp-cli simulate_action_tap --action "ui_up"
```

### VSCode Debugger (F5)
- Set breakpoints by clicking line numbers
- Inspect Variables panel for `GameState.quest_flags`
- Modify flags directly to skip minigames

**Full Guide:** `docs/agent-instructions/TESTING_WORKFLOW.md`

---

## 📁 Essential File Locations

### Must Know
| File | Location | Purpose |
|------|----------|---------|
| **Current Status** | `docs/Development/CURRENT_STATUS.md` | What's happening now |
| **Dev Hub** | `docs/Development/DEVELOPMENT_HUB.md` | Quick reference |
| **Roadmap** | `docs/execution/DEVELOPMENT_ROADMAP.md` | Full status |
| **Story** | `docs/Development/Storyline.md` | 49 beats, narrative |
| **Playtesting** | `docs/playtesting/PLAYTESTING_ROADMAP.md` | Quest walkthrough |
| **Visual QA** | `docs/qa/VISUAL_IMPROVEMENTS_2026-01-28.md` | Sprite status |

### Game Code
| Directory | Contents |
|-----------|----------|
| `game/features/world/` | World scene, player, NPCs |
| `game/features/locations/` | Scylla Cove, Sacred Grove, House |
| `game/features/cutscenes/` | All cutscenes |
| `game/shared/resources/dialogues/` | 80+ dialogue files |
| `assets/sprites/placeholders/` | 45+ improved sprites |

### Test & QA
| File | Purpose |
|------|---------|
| `tests/run_tests.gd` | Core test suite |
| `docs/playtesting/HPV_GUIDE.md` | Detailed HPV patterns |

---

## 🛠️ Development Workflow

### Compound Engineering
1. **Plan** - Confirm scope, track work
2. **Delegate** - MiniMax for research, MCP for testing
3. **Assess** - Verify with small headed check
4. **Codify** - Record in ROADMAP and PLAYTESTING_ROADMAP

### Conventions
- **GDScript:** snake_case (vars/functions), PascalCase (nodes), UPPER_SNAKE (constants)
- **Commits:** Scoped commits, avoid rewrites
- **Branches:** Work in current branch unless Sam asks
- **New .md files:** Request permission in planning phase

---

## ⏰ Time Gate Rules (CRITICAL)

```
1. At session START: Read .session_manifest.json
2. During work: Re-read after context restart
3. Every ~30 min: Note remaining time
4. When "done": MUST use finish-work skill
5. If finish-work says CONTINUE: Continue - no exceptions
```

**DO NOT:**
- Claim completion without finish-work skill
- Stop because "you're done" - always more to do
- Make excuses - work the full duration

**When "Done" But Time Remains:**
- Review code for issues
- Add documentation
- Run more tests
- Refactor for clarity
- Check edge cases
- Optimize performance

**See:** `.claude/skills/finish-work/SKILL.md`

---

## 🔧 MCP Tools

### Available
- `mcp__godot__get_runtime_scene_structure` - Full scene tree
- `mcp__godot__simulate_action_tap` - Input simulation
- `mcp__MiniMax-Wrapper__coding_plan_general` - Planning
- `mcp__MiniMax-Wrapper__coding_plan_execute` - Execution

### If MCP Unavailable
Use PowerShell wrapper: `scripts/mcp-wrapper.ps1`

---

## 📚 Skill Inventory

### Superpowers Skills
- `brainstorming` - Explore ideas
- `writing-plans` - Create plans
- `executing-plans` - Execute plans
- `subagent-driven-development` - Subagent patterns
- `test-driven-development` - TDD
- `systematic-debugging` - Debug workflows
- `verification-before-completion` - Verify before claiming done
- `finish-work` - Time gate enforcement

### Project-Specific
- `longplan` - Multi-step planning (1A2A)
- `ralph` - Autonomous coding loop
- `minimax-mcp` - MiniMax integration
- `godot` - Godot guidance
- `godot-gdscript-patterns` - Patterns
- `godot-mcp-dap-start` - MCP/DAP startup
- `playtesting` - HPV workflows
- `glm-image-gen` - Image generation
- `troubleshoot-and-continue` - Recovery

---

## 🚨 Critical Rules

1. **Time Gates** - Work full duration, use finish-work skill
2. **Visual Validation** - Screenshots required for visual claims
3. **Tests** - Run tests before claiming completion
4. **Documentation** - Update ROADMAP with decisions
5. **MCP Issues** - Ask Sam to restart, don't troubleshoot long

---

## 📞 When to Ask Sam

- MCP/debugger not working after quick check
- Need to create new .md files
- Unsure about scope or approach
- Blocked >30 minutes
- Before major structural changes

---

**See Also:**
- `CLAUDE.md` - Detailed project rules
- `docs/agent-instructions/AGENTS_README.md` - Full instructions hub
- `docs/agent-instructions/TESTING_WORKFLOW.md` - Testing details
