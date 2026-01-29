# Two-Tier Agent Role System

**Updated:** 2026-01-29 (Claude-centric overhaul)

---

## Overview

This project uses a **two-tier model** optimized for token efficiency:

| Tier | Role | Examples |
|------|------|----------|
| **Tier 1: Orchestrator** | Claude | Opus 4.5, Sonnet 4.5 |
| **Tier 2: Worker** | Subagent | Kimi K2.5, GLM-4.7, MiniMax |

**Key principle:** Claude orchestrates and decides; subagents explore and execute.

---

## Tier 1: Claude (Orchestrator)

**Models:** Claude Opus 4.5, Claude Sonnet 4.5

### What Claude Does
- Complex reasoning and synthesis
- Code writing and editing
- Architectural decisions
- Final decision-making
- Direct image analysis (1-3 images)
- Reading specific known files

### What Claude Delegates
- Research and exploration
- Batch operations (10+ files, 10+ images)
- Web searches and documentation lookup
- Simple file reading across codebase
- Pattern research

### Permissions
- **Pre-approved:** All file editing, code changes, git add/commit
- **Ask first:** New .md files, major refactors, git push

### Signature
All .md edits: `[Opus 4.5 - YYYY-MM-DD]` or `[Sonnet 4.5 - YYYY-MM-DD]`

---

## Tier 2: Subagent (Worker)

**Models:** Kimi K2.5, GLM-4.7, GLM-4.6v, MiniMax M2.1

### Provider Strengths

| Provider | Best For | Context |
|----------|----------|---------|
| **Kimi K2.5** | Complex reasoning, vision | 256K |
| **GLM-4.7** | Creative tasks, brainstorming | 128K |
| **GLM-4.6v** | Image analysis | 128K |
| **MiniMax** | Fast simple tasks, web search | 128K |

### What Subagents Do
- Exploration and research
- File reading and pattern finding
- Image analysis (batch)
- Web documentation lookup
- Code review (blind spot detection)

### What Subagents Don't Do
- Make final decisions (report back to Claude)
- Write production code (Claude writes, subagent reviews)
- Spawn other subagents

### Launchers
```powershell
# Kimi K2.5 (most capable)
.\scripts\start-kimi.ps1

# MiniMax (fast, cheap)
.\scripts\start-claude-minimax.ps1
```

---

## Token Economics

**Claude tokens = 50x more expensive than subagent tokens**

This means:
- 1 hour of Claude exploration = 50 hours of subagent exploration (cost-wise)
- Always delegate exploration to subagents
- Claude should reason on subagent-gathered data

### Hard Stop
**NEVER spawn Claude models (Haiku, Sonnet, Opus) as subagents.**

Enforced in `.claude/settings.local.json`:
```json
"deny": [
  "Task(model:haiku*)",
  "Task(model:sonnet*)",
  "Task(model:opus*)"
]
```

---

## Delegation Patterns

### Pattern 1: Research First
```
1. Claude receives task
2. Claude spawns MiniMax to explore codebase
3. MiniMax reports findings
4. Claude reasons and implements
```

### Pattern 2: Batch Analysis
```
1. Claude needs to analyze 20 images
2. Claude spawns Kimi K2.5 for vision
3. Kimi reports analysis
4. Claude makes decisions based on report
```

### Pattern 3: Code Review
```
1. Claude writes code
2. Claude spawns subagent for blind spot review
3. Subagent reports concerns
4. Claude addresses or dismisses
```

---

## Escalation

```
Subagent → Claude → Sam (user)
```

**Subagent to Claude:**
- Task complete (report findings)
- Ambiguous requirements
- Need decision on approach

**Claude to Sam:**
- External blockers
- Scope clarification needed
- Major structural changes
- Blocked >30 minutes

---

## 1A2A Workflow (Preserved)

**1A (Ask Phase):** Plan and get approval
- Create task list via TodoWrite
- Identify required permissions
- User approval before proceeding

**2A (Autonomous Phase):** Execute approved plan
- Work through tasks systematically
- Handle blockers gracefully
- Summarize at end

**When to skip 1A:** Single-line fixes, clear requirements, pure research

---

## Skills Reference

| Situation | Skill |
|-----------|-------|
| Complex delegation | `/skill delegation` |
| Kimi setup | `/skill kimi-k2.5` |
| Token efficiency | `/skill token-efficient-delegation` |
| Stuck in loop | `/skill loop-detection` |
| Debugging | `/skill systematic-debugging` |

---

[Opus 4.5 - 2026-01-29]
