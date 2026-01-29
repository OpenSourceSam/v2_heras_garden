---
name: subagent-best-practices
description: Auto-injects subagent delegation best practices when agents, subagents, Task tool, or parallel execution is mentioned.
---

# Subagent Best Practices

Auto-inject when: User mentions "subagent", "Task tool", "spawn agent", "parallel"

## ⛔ HARD STOP: No Claude Subagents

**NEVER use Claude models (Haiku, Sonnet, Opus) as subagents.**

| ❌ FORBIDDEN | ✅ ALLOWED |
|--------------|-----------|
| `model="haiku"` | `model` omitted (default) |
| `model="sonnet"` | general-purpose agent |
| `model="opus"` | MiniMax, GLM, Kimi K2.5 |

**Preferred subagents:** Kimi K2.5 (complex), GLM (creative), MiniMax (fast)
**Enforced:** `.claude/settings.local.json` deny rules

---

## Two-Tier Model

| Tier | Role | Does | Doesn't |
|------|------|------|---------|
| **Claude** | Orchestrator | Reason, decide, write code | Explore, bulk read |
| **Subagent** | Worker | Explore, research, batch ops | Make final decisions |

See `.claude/roles/ROLES.md` for full details.

---

## Provider Selection

| Task | Provider |
|------|----------|
| Complex reasoning | Kimi K2.5 |
| Vision (batch) | Kimi K2.5 |
| Creative | GLM-4.7 |
| Fast/simple | MiniMax |

See `/skill delegation` for full matrix.

---

## Subagent Prompt Template

```
You are tasked with:
{Specific subtask description}

Search scope: {directories/files}
Output format: {table/list/JSON}

Return ONLY the requested output, nothing else.
```

---

## Parallel Execution

Launch independent tasks in single message:
```
Task(prompt="Research X")  ←─┐
Task(prompt="Research Y")  ←─┼─ Same message = parallel
Task(prompt="Research Z")  ←─┘
```

**Don't** chain sequentially when parallel is possible.

---

## Quick Checklist

Before spawning:
- [ ] Can I decompose into independent chunks?
- [ ] Clear deliverables defined?
- [ ] Right provider for task type?

When spawning:
- [ ] Specific prompt with scope
- [ ] Single message for parallel tasks
- [ ] No Claude models

After results:
- [ ] Aggregate without re-running
- [ ] Claude makes final decision

---

[Opus 4.5 - 2026-01-29]
