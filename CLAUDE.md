# Claude Code Directives

**Env:** Cursor | **MCP:** `.cursor/mcp.json` | **Godot 4.5.1** | **Updated:** 2026-01-29

---

## Project Context

**Circe's Garden** - 2D Godot narrative farming sim about Circe from Greek mythology.
- Phase 7 COMPLETE (story: 49/49 beats, 11 quests, both endings)
- Phase 8 IN PROGRESS (visuals: world composition needs work)
- Visual target: Harvest Moon quality (warm, detailed, lived-in)

**Sam** = Non-technical owner/CEO. Favor clear language, explicit steps, visible evidence.

---

## Claude's Role: Orchestrator

**Claude (Opus/Sonnet) handles:**
- Complex reasoning and synthesis
- Code writing and editing
- Architectural decisions
- Final decision-making

**Claude delegates to subagents:**
- Research and exploration
- Batch operations (file reading, image analysis)
- Web searches and documentation lookup

---

## Provider Strength Matrix

| Task Type | Best Provider | Fallback |
|-----------|--------------|----------|
| Complex reasoning | **Kimi K2.5** | GLM |
| Image/vision analysis | **Kimi K2.5** | GLM-4.6v |
| Creative/brainstorming | **GLM-4.7** | Kimi |
| Web research | **MiniMax** | GLM |
| Simple file exploration | **MiniMax** | any |
| Batch operations | **GLM** | MiniMax |

**Launchers:** `scripts/start-kimi.ps1`, `scripts/start-claude-minimax.ps1`

---

## Token Conservation (CRITICAL)

**Claude tokens = 50x more expensive than MiniMax/GLM/Kimi**

### Hard Stop: No Claude Subagents
NEVER spawn Claude models (Haiku, Sonnet, Opus) as subagents.
Enforced in `.claude/settings.local.json` deny rules.

### Delegation Patterns
```
Exploration/Research → Delegate (MiniMax/Kimi)
Reasoning/Decisions  → Claude does directly
10+ images           → Delegate to Kimi K2.5
Code changes         → Claude writes, subagent reviews
Tasks >30 seconds    → run_in_background=true + end turn
```

### Token Suspension (Background Execution)
For long-running subagent tasks: use `run_in_background=true`, end turn early, retrieve with `TaskOutput` on next turn. See `/skill delegation` for details.

---

## Testing (Quick Reference)

**HPV (Headed Playability Validation):**
```bash
npx -y godot-mcp-cli run_project --headed     # Launch
npx -y godot-mcp-cli get_runtime_scene_structure  # Inspect
npx -y godot-mcp-cli simulate_action_tap --action "ui_accept"  # Input
```

**Headless tests:** `.\Godot*\Godot*.exe --headless --script tests/run_tests.gd`

**Full guide:** `docs/agent-instructions/TESTING_WORKFLOW.md`

---

## Time Gates (ABSOLUTE)

1. Read `.session_manifest.json` at session start
2. Re-read after context restart
3. Note remaining time every ~30 min
4. **MUST use `/skill finish-work` before claiming done**
5. If finish-work says CONTINUE → YOU CONTINUE

---

## Critical Rules

1. **No Claude subagents** - Use MiniMax/GLM/Kimi only
2. **Visual validation** - Screenshots required for visual claims
3. **Time commitment** - Work full duration per manifest
4. **Tests before completion** - Run before claiming done
5. **Escalate >30min blocks** - Ask Sam, don't spin

---

## Essential Paths

| Purpose | Path |
|---------|------|
| Session manifest | `.session_manifest.json` |
| Roadmap | `docs/execution/DEVELOPMENT_ROADMAP.md` |
| Status | `docs/Development/CURRENT_STATUS.md` |
| Story | `docs/Development/Storyline.md` |
| Testing | `docs/agent-instructions/TESTING_WORKFLOW.md` |
| Visual targets | `docs/reference/visual_targets/README.md` |
| Skills | `.claude/skills/` |
| Roles | `.claude/roles/ROLES.md` |

---

## Conventions

**GDScript:** snake_case (vars/funcs), PascalCase (nodes), UPPER_SNAKE (constants)
**Git:** Scoped commits, work in current branch, commit before pausing
**New .md files:** Request permission first

---

## Escalate to Sam

- MCP/debugger issues after quick check
- Need new .md files
- Unclear scope/approach
- Blocked >30 minutes
- Major structural changes

---

## Skills Quick Reference

| Situation | Skill |
|-----------|-------|
| Ending session | `/skill finish-work` (MANDATORY) |
| Multi-step task | `/skill longplan` |
| Complex delegation | `/skill delegation` |
| Kimi setup | `/skill kimi-k2.5` |
| Debugging | `/skill systematic-debugging` |
| Code review | `/skill requesting-code-review` |

---

## See Also

- `AGENTS.md` - Quick onboarding
- `.claude/roles/ROLES.md` - 2-tier role system
- `docs/agent-instructions/AGENTS_README.md` - Full hub
- `docs/agent-instructions/common-solutions.md` - Historical fixes

[Opus 4.5 - 2026-01-29]
