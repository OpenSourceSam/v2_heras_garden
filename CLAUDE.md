# Project Directives (Claude & Kimi Code CLI)

**Environment:** Cursor (not VS Code) | **MCP:** `.cursor/mcp.json` | **Godot 4.5.1**

**Last Updated:** 2026-01-28

---

## 📋 Project Context

**What is this project?**
- "Circe's Garden" - A 2D Godot game about Circe from Greek mythology
- Narrative farming sim with dialogue choices and consequences
- **Phase 7 COMPLETE** (story), **Phase 8 IN PROGRESS** (visuals)

**Who is Sam?**
- Project owner and CEO
- Non-technical stakeholder who directs agent work
- Favor clear language, explicit steps, visible evidence

**How this project runs:**
- Work is executed by autonomous AI agents
- Agents operate in Cursor, VS Code, Claude Desktop, Terminal
- Models: MiniMax M.21, Claude, Kimi Code CLI, Codex (rotation)

**Current Status (2026-01-28):**
- Story: 100% (49/49 beats, 11 quests, both endings)
- Code: Tests passing (5/5), no TODOs, no fake UIDs
- Visuals: 45+ sprites improved, overall composition review needed
- Last Work: Sprite improvements (10 commits)

---

## 🎯 Compound Engineering

**Philosophy:** Each unit of work should make future work easier.

**Core Loop:**
1. **Plan** - Confirm scope, track work (TodoWrite or plan tool)
2. **Delegate** - MiniMax for research/image analysis; MCP for testing
3. **Assess** - Verify with small headed check
4. **Codify** - Record in `docs/execution/DEVELOPMENT_ROADMAP.md`

---

## 🎮 Testing Workflows

### HPV (Headed Playability Validation) - Primary Method

**What it is:** Programmatic testing using MCP to inspect state and simulate input

**What it is NOT:** Full human-level playthroughs, "beating the game manually"

**Workflow:**
```
1. Launch: F5 debugger or run_project --headed
2. Inspect: get_runtime_scene_structure for game state
3. Act: simulate_action_tap --action "ui_accept" for input
4. Verify: Check scene structure for state changes
5. Skip: Use debugger to set quest flags (minigames)
6. Document: Log in PLAYTESTING_ROADMAP.md
```

### MCP Commands Quick Reference

```bash
# Launch
npx -y godot-mcp-cli run_project --headed

# Inspection
npx -y godot-mcp-cli get_runtime_scene_structure
npx -y godot-mcp-cli get_input_actions

# Input
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"
npx -y godot-mcp-cli simulate_action_tap --action "interact"
npx -y godot-mcp-cli simulate_action_tap --action "ui_up"
```

### VSCode Debugger (F5)

All agents can use VSCode debugger:
1. Press F5 to start debugging
2. Set breakpoints by clicking line numbers
3. Inspect Variables panel for `GameState.quest_flags`
4. Modify values directly (e.g., set `quest_1_complete = true`)

### Testing Methods Decision Tree

```
Need to test something?
│
├─ Unit test / logic only? → HLC (headless)
│   .\Godot*\Godot*.exe --headless --script tests/run_tests.gd
│
├─ Need game state? → HPV with MCP
│   Launch: npx -y godot-mcp-cli run_project --headed
│   Inspect: get_runtime_scene_structure
│   Input: simulate_action_tap
│
└─ Need breakpoints? → DAP (Desktop only)
│   F5 in VSCode, set breakpoints, inspect variables
```

**Full Guide:** `docs/agent-instructions/TESTING_WORKFLOW.md`

---

## 📁 Essential File Locations

### Current Status & Planning
| File | Purpose |
|------|---------|
| `.session_manifest.json` | Session time commitment (READ FIRST) |
| `docs/Development/CURRENT_STATUS.md` | Current project status |
| `docs/Development/DEVELOPMENT_HUB.md` | Quick reference hub |
| `docs/execution/DEVELOPMENT_ROADMAP.md` | Full roadmap |
| `docs/Development/Storyline.md` | 49 beats, narrative |

### Testing & QA
| File | Purpose |
|------|---------|
| `docs/playtesting/PLAYTESTING_ROADMAP.md` | Quest walkthrough |
| `docs/playtesting/HPV_GUIDE.md` | Detailed HPV patterns |
| `tests/run_tests.gd` | Core test suite |

### Game Code
| Directory | Contents |
|-----------|----------|
| `game/features/world/` | World scene, player, NPCs |
| `game/features/locations/` | Scylla Cove, Sacred Grove, House |
| `game/features/cutscenes/` | All cutscenes |
| `game/shared/resources/dialogues/` | 80+ dialogue files |

### Visual Assets
| Directory | Contents |
|-----------|----------|
| `assets/sprites/placeholders/` | 45+ improved sprites |
| `docs/qa/VISUAL_IMPROVEMENTS_2026-01-28.md` | Sprite improvement log |
| `docs/reference/concept_art/HERAS_GARDEN_PALETTE.md` | Style guide |

---

## 📝 Common Solutions (Living Log)

### Template for New Entries
```
### YYYY-MM-DD: <Short Title>
**Problem:** <What was broken/needed>
**Solution:** <What was done and why>
**Key Files Changed:**
- <path> - <what changed>
**Lessons Learned:**
- <pattern>
- <gotcha>
**Use This When:** <future situations>
```

### 2026-01-25: Intro transition stuck after prologue
**Problem:** New Game could load prologue but leave runtime scene on main menu
**Solution:** Route transitions through `get_tree().change_scene_to_file(...)`
**Files:**
- `game/features/ui/main_menu.gd`
- `game/features/cutscenes/prologue_opening.gd`
- `game/autoload/scene_manager.gd`
**Lesson:** `change_scene_to_file` reliably updates `current_scene`

### 2026-01-26: Visual polish transparency fix
**Problem:** Sprites had blocky backgrounds (opaque instead of transparent)
**Solution:** Regenerated 22 assets with RGBA format
**Lesson:** Always verify transparency with check-transparency.ps1

### 2026-01-28: Sprite improvements with outlines
**Problem:** Placeholder sprites lacked outlines and shading
**Solution:** Created Python tools to generate production-quality sprites
**Tools:** `tools/improve_*.py` (9 scripts)
**Lesson:** Batch generation with proper style guide compliance

---

## ⏰ Time Gate Rules (ABSOLUTE)

```
1. At session START: Read .session_manifest.json
2. During work: RE-READ manifest after context restart
3. Every ~30 min: Note remaining time
4. When "done": MUST use finish-work skill
5. If finish-work says CONTINUE: YOU CONTINUE - no exceptions
```

**DO NOT:**
- Claim completion without finish-work skill
- Stop because "you're done"
- Make excuses - work the full duration

**When "Done" But Time Remains:**
- Review code for issues
- Add documentation
- Run more tests
- Refactor for clarity
- Check edge cases

**finish-work Skill:** `.claude/skills/finish-work/SKILL.md`

---

## 🛠️ Conventions

### GDScript
- **Variables/Functions:** snake_case
- **Nodes:** PascalCase
- **Constants:** UPPER_SNAKE

### Git
- Scoped commits preferred
- Avoid history rewrites unless asked
- Work in current branch
- Commit before pausing/ending

### New Files
- Request permission for new .md files in planning phase
- If created without approval: continue work, report at end

---

## 🚨 Critical Rules

1. **Visual Quality Gates** - Screenshots required for visual claims
2. **Narrative Consistency** - Check against Storyline.md
3. **Time Commitment** - Work full duration
4. **Testing** - Run tests before claiming completion
5. **MCP Issues** - Ask Sam to restart, don't troubleshoot long

---

## 📞 When to Escalate to Sam

- MCP/debugger not working after quick check
- Need to create new .md files
- Unsure about scope or approach
- Blocked >30 minutes
- Before major structural changes

---

## 🔗 Quick Links

- **Status:** `docs/Development/CURRENT_STATUS.md`
- **Dev Hub:** `docs/Development/DEVELOPMENT_HUB.md`
- **Roadmap:** `docs/execution/DEVELOPMENT_ROADMAP.md`
- **Testing:** `docs/agent-instructions/TESTING_WORKFLOW.md`
- **HPV Guide:** `docs/playtesting/HPV_GUIDE.md`
- **Skills:** `.claude/skills/`

---

**See Also:**
- `AGENTS.md` - Quick onboarding
- `docs/agent-instructions/AGENTS_README.md` - Full instructions hub
