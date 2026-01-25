# Agent Onboarding

Environment: Cursor (not VS Code) | MCP: `.cursor/mcp.json` | Godot 4.5.1

## Quick Start
- Read: docs/agent-instructions/AGENTS_README.md
- Testing: docs/playtesting/HPV_GUIDE.md
- Roadmap: docs/execution/DEVELOPMENT_ROADMAP.md

## Project Context
- This project is run by autonomous AI agents with Sam providing oversight.
- Sam has limited technical background; favor clear language, explicit steps, and visible evidence.
- Capture decisions and risks in docs so future agents can build on them.


## Repo Layout
game/ → gameplay code | docs/ → documentation | tests/ → test suites | addons/ → plugins

## Compound Engineering (Lightweight)

**Philosophy:** Each unit of work should make future work easier.

**Core Loop (Plan → Delegate → Assess → Codify):**
1. **Plan**: Confirm scope and constraints, then track work (use TodoWrite or the built-in plan tool).
2. **Delegate**: Use MiniMax for research or image analysis; use MCP for headed smoke checks.
3. **Assess**: Verify the change worked (small headed check, targeted runtime inspection).
4. **Codify**: Record outcomes in `docs/execution/DEVELOPMENT_ROADMAP.md` and (if HPV-related) `docs/playtesting/PLAYTESTING_ROADMAP.md`.

**Todo Tracking (approved):**
- Use `todos/` for unresolved issues and long-tail work.
- Start from `todos/template.md` (full template) and keep entries actionable.
- Template is manual (no automation); copy the file and fill it out.

## Common Solutions (Living Log)

**Template (copy for new entries):**
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
**Problem:** New Game could load the prologue but leave the runtime scene on main menu or prologue; the world loaded in the tree but wasn’t current.

**Solution:** Route intro transitions through `get_tree().change_scene_to_file(...)` for both the main menu and prologue skip/end, and keep `SceneManager` current-scene updates centralized.

**Key Files Changed:**
- `game/features/ui/main_menu.gd` — New Game now loads the prologue via `change_scene_to_file`.
- `game/features/cutscenes/prologue_opening.gd` — Skip/end now load world via `change_scene_to_file`.
- `game/autoload/scene_manager.gd` — Centralized current scene updates in `_finalize_scene_change`.
- `game/autoload/cutscene_manager.gd` — Ensures cutscene cleanup after await.

**Lessons Learned:**
- `get_tree().change_scene_to_file(...)` reliably updates `current_scene` for top-level transitions.
- Signal-only cleanup can leave nodes lingering if the connection doesn’t land; prefer deterministic cleanup.

**Use This When:** Intro/cutscene transitions leave multiple root scenes visible or cause black screens.

### 2026-01-25: Map layout guidance overlay
**Problem:** World layout lacked a strong visual guide aligned to concept art.

**Solution:** Add a low-opacity concept art overlay in `world.tscn` and dim the ground tiles to make the layout read while keeping gameplay visible.

**Key Files Changed:**
- `game/features/world/world.tscn` — Added `MapReference` sprite and reduced `Ground` alpha.

**Lessons Learned:**
- Low-opacity overlays are a fast, reversible way to guide layout before a full tile pass.

**Use This When:** You need quick spatial guidance before committing to a full tile/asset pass.

## Skills Sharing (Claude <-> Codex)
- Source of truth: `.claude/skills/`
- Codex mirror: `.codex/skills/` (keep in sync with `.claude/skills/`)
- Preferred sync: `scripts/sync-skills.ps1` (supports `-DryRun`, `-Prune`)
- Slash commands live in `.claude/commands/` (ported as skills only when needed)

## MCP Tools

**IMPORTANT: Different agent types have DIFFERENT MCP access.**

### For IDE Extension Agents (Cursor, VS Code)
- **MCP Tools Available:** `mcp__MiniMax*`, web reader, image analysis
- **NOT Available:** `mcp__godot__*` tools (godot-mcp MCP server is NOT configured)
- **Use PowerShell wrapper for godot-mcp CLI:**
  ```bash
  powershell -Command "scripts/mcp-wrapper.ps1 -McpCommand 'get_project_info'"
  ```
- See: [docs/agent-instructions/tools/mcp-wrapper-usage.md](docs/agent-instructions/tools/mcp-wrapper-usage.md)

### For Terminal Agents (RooCode, GPT Codex)
- **MCP Tools Available:** Possibly `mcp__godot__*` tools (if configured)
- **Use direct npx CLI commands:**
  ```bash
  npx -y godot-mcp-cli@latest get_project_info
  ```
- DO NOT use PowerShell wrapper (you have direct subprocess access)

### For Claude Desktop Agents
- **MCP Tools Available:** Both MiniMax and godot-mcp MCP servers
- **Use native MCP tools:** `mcp__godot__*`, `mcp__MiniMax*`
- DO NOT use PowerShell wrapper (you have native access)

### Common Commands (All Agents)

**MCP Health Check:**
```bash
powershell -ExecutionPolicy Bypass -File scripts/mcp-health-check.ps1
```

**Start Godot with MCP:**
```bash
powershell -ExecutionPolicy Bypass -File .claude/skills/godot-mcp-dap-start/scripts/ensure_godot_mcp.ps1
```

**MCP Recovery:**
```bash
powershell -ExecutionPolicy Bypass -File .claude/skills/mcp-recovery/scripts/recover.ps1
```

If MCP issues persist after running recovery, see: `.claude/skills/mcp-recovery/error-patterns.md`

## MiniMax MCP
- Skill docs: `.claude/skills/minimax-mcp/SKILL.md`
- Terminal quick start (direct API via scripts):
  - `cd .claude/skills/minimax-mcp`
  - `./scripts/web-search.sh "query"`
  - `./scripts/analyze-image.sh "prompt" "image.png"`
- MCP server (desktop): see `SKILL.md` for env vars and `uvx minimax-coding-plan-mcp -y`
- Codex wrapper tools:
  - `mcp__MiniMax-Wrapper__coding_plan_general`
  - `mcp__MiniMax-Wrapper__coding_plan_execute`
- **Delegation guidance**: Prefer MiniMax for web search, image analysis, research tasks
- **Trusted domains** (auto-approved): docs.anthropic.com, platform.claude.com, docs.cursor.com, cursor.com, cookbook.openai.com, godotengine.org, api.minimax.io
- **Other domains**: Ask permission before searching outside trusted list
- Direct API (extension): Use Bash tool with curl (see SKILL.md), saves 85-90% tokens
- **Decision trigger**: Before using Grep/Glob for research, ask: "Would MiniMax handle this better?"

## Testing
Headless: `.\Godot*\Godot*.exe --headless --script tests/run_tests.gd`
Headed (HPV): Launch Godot, use MCP for input/inspection. Teleport-assisted HPV is the default unless a full walk is requested.

## HPV Interaction Reminder

- If `DialogueBox` is visible, clear it first; `interact` is ignored while dialogue is open.
- Use `get_runtime_scene_structure` once to locate World/Player/NPCs, then cache paths.
- Prefer teleport for speed unless you are validating movement feel.

## How Agents "See" and Navigate Games

**You are NOT "blind" when testing games.** The MCP tools provide complete visibility into the game state:

### How to "See" Game State

| Tool | What It Shows | Example Usage |
|------|---------------|--------------|
| **get_runtime_scene_structure** | Full scene tree with positions, visibility, properties | See where player/NPCs are, what's visible |
| **Debugger Variables panel** | All runtime variables including GameState flags | See quest progress, modify values |
| **Runtime eval patterns** | Direct access to game tree and nodes | Teleport player, read dialogue, trigger quests |

### Example: Finding Player Position

```bash
# Get scene structure - returns EVERYTHING with positions
get_runtime_scene_structure

# Output shows positions like:
# World/Player: position=[384, 96], visible=true
# World/NPCs/Hermes: position=[400, 100], visible=true
```

### Example: Finding NPC Positions

```bash
get_runtime_scene_structure
# Look for: World/NPCs/Hermes: position=[x, y]
# Then walk player there using: simulate_action_tap --action ui_up
```

### Example: Checking Quest State

```bash
# Option 1: Debugger (easiest)
# Press F5 → Set breakpoint → Check Variables panel → quest_flags dictionary

# Option 2: MCP (when game running)
get_runtime_scene_structure
# Look for: World/GameState → quest_flags in properties
```

### Example: Navigating to Targets

**Option 1: Teleport (fastest for HPV)**
```gdscript
# Find world index first with get_runtime_scene_structure
get_tree().root.get_child(3).get_node("Player").set_global_position(Vector2(384, 96))
```

**Option 2: Walk (for actual movement testing)**
```bash
# Move toward target using scene structure for guidance
simulate_action_tap --action ui_up
# Repeat as needed, verify with get_runtime_scene_structure
```

### Key Point

`get_runtime_scene_structure` IS your "vision" - it shows all nodes, positions, properties, and visibility in real-time. This is how you know where things are without seeing the screen.

## Conventions
- Follow patterns in nearby files
- GDScript: snake_case (vars/functions), PascalCase (nodes), UPPER_SNAKE (constants)

## Repo Rules
- When asked to commit, prefer scoped commits; avoid history rewrites unless asked
- When pausing or ending a work block, it is usually better to commit changes
  rather than leave them pending; ask if unsure
- Avoid creating or switching branches unless Sam explicitly asks; work in the
  current branch instead
- Ask before touching: .godot/, .venv/, archive/, .cursor/, .claude/roles/
- .uid files: use git hook (git config core.hooksPath .githooks) or stage manually
- Ask before creating new .md files; editing existing .md files is OK
- Exception: temp/plans/ files are allowed for long-running tasks or delegation tracking; delete them when the work finishes
- Prefer updating existing docs; doc sprawl causes drift and conflicting guidance. See docs/agent-instructions/AGENTS_README.md for rationale.
- Prefer clarifying questions BEFORE starting autonomous work
- During autonomous work (2A phase): work continuously, do not stop to summarize
- Default to working within the current structure; flag major structural changes

## After Completing Work
- Add a dated entry to **Common Solutions** if you solved a new problem.
- Log test findings in `docs/execution/DEVELOPMENT_ROADMAP.md` and (if HPV) `docs/playtesting/PLAYTESTING_ROADMAP.md`.
- If you encountered unresolved issues, note them in the roadmap (or `todos/` if approved).

## Planning Guidelines

**CRITICAL: How to structure implementation plans**

### What NOT to Use
- ❌ **Time estimates** (weeks, hours, days) - meaningless for AI work
- ❌ **Token estimates** - unreliable and unnecessary
- ❌ **Story points** - not applicable to AI agents

### What TO Use Instead

**Priority Levels (P0/P1/P2):**
- **P0** - Must have for feature to work (MVP core)
- **P1** - Makes it actually useful/enhanced
- **P2** - Nice to have, polish

**Step Numbers (1, 2, 3...):**
- Use when tasks have dependency order (B requires A)
- Simple linear sequence
- Easy to track progress

**Example:**

```
P0 (Must have):
- Step 1: Create basic structure
- Step 2: Implement core loop
- Step 3: Add minimal validation

P1 (Enhanced):
- Step 4: Add completion detection
- Step 5: Implement error recovery

P2 (Polish):
- Step 6: Add session resume
- Step 7: Advanced circuit breakers
```

### Rationale
- AI works in minutes, not weekly sprints
- No human scheduling constraints
- Priority makes scope flexible (stop after P0 if needed)
- Steps show dependencies clearly

---

## Autonomous Work (2A Phase)

**When working on a plan autonomously:**

### Core Rules
- DO NOT stop working to provide summaries, status updates, or "check-ins"
- DO NOT send progress updates until the task is fully complete, unless blocked or explicitly asked
- DO NOT stop when a task is slow, challenging, or time-consuming
- DO NOT stop when one approach fails - try alternatives
- ONLY stop for HARD STOPS (defined below)
- Update plan file (.claude/plans/*.md) with quick notes - keep working
- Continue through todos systematically - skip blocked items, circle back later

**Planning artifacts (approved):**
- A temp plan file under `temp/` is acceptable for longplan sessions.
- `update_plan` is a valid substitute for `TodoWrite` in Codex environments.

**New .md files (permission flow):**
- Ask for permission during 1A before creating any new .md files.
- If a new .md is created without prior approval, keep working and report it at
  the end of the work block for a keep/move/delete decision.

**Finish-game requests (default behavior):**
- Treat “finish the game / finish the roadmap” as a full local-beta scope unless the user narrows it.
- Include explicit success criteria and multi-phase steps in the plan.
- Avoid scope reduction unless the user explicitly approves it.

### HARD STOPS (Only stop for these)
- Creating NEW .md files (not edits)
- Editing .cursor/ directory
- Git push, force push, or branch operations
- Editing CONSTITUTION.md
- Actions outside approved scope
- Explicit user request to stop/pause

### CHALLENGES ≠ BLOCKS (Keep working, try alternatives)
- Slow operations (time ≠ stop)
- One approach failing (try 2-3 alternatives)
- Uncertain about next step (document uncertainty, pick reasonable path, continue)
- Sequential advancement taking time (skip to next todo, come back)

### Skip-Around Pattern
When stuck on a todo item:
1. Document the challenge in plan file (1-2 lines)
2. Move to next todo item
3. Circle back to stuck items after making progress elsewhere
4. Try 2-3 alternatives before documenting as pending

### TodoWrite Quote (For longplan mode)
Append this brief quote to every todo task (except final "keep working" task):

"Remember: Skip around stuck tasks. Try 2-3 alternatives. Move to next todo. Circle back. Keep working. Do not make major repo changes unless approved."

This reinforces the skip-around pattern and prevents getting stuck on challenging todos.

### Examples of "Keep Working"
- GOOD: Dialogue advancement slow → Skip to Quest 3, come back to Quest 2 later
- GOOD: MCP eval not working → Try different approach, document, move on
- GOOD: Uncertain about flag → Make reasonable assumption, note it, continue
- BAD: Stop and summarize → VIOLATION (unless HARD STOP)
- BAD: Ask if should continue → VIOLATION (unless HARD STOP)

### Skill Usage Note
- **create-plan skill**: For 1A (Planning Phase) - interactive, waits for user feedback
- **longplan slash command**: For 2A (Autonomous Execution) - continuous work, no stopping
- Use CLAUDE.md Autonomous Work section (above) during 2A phase

[Codex - 2026-01-17]
[Codex - 2026-01-22]
