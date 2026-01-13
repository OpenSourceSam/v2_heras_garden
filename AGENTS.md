# Agent Runtime Rules

Last updated: [Sonnet 4.5 - 2025-12-29]

## Agent Role Hierarchy

Agents self-identify tier based on model name and follow corresponding permissions.

**Tier identification:**
- Tier 1: Codex, GPT-4 Turbo (Junior Engineer)
- Tier 2: Claude Sonnet 4.5 (Senior Engineer)
- Tier 3: Claude Opus 4.5 (Principal Architect)

**See `.claude/roles/ROLES.md` for complete role definitions, permissions, and escalation paths.**

**All agents must sign edits:** `[ModelName - YYYY-MM-DD]` at end of editing session

---

## Godot Testing (Hard Rules)

### Fast, low-impact checks (preferred during iteration)
- Baseline unit checks: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd`
- Smoke scene wiring: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30`
- Phase 3 scene-load smoke: `.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd`

### GdUnit4 suite
- Prefer a single suite run over per-file loops. Per-file loops spawn many Godot processes and will thrash CPU/GPU.
- Avoid `-d/--debug` when running GdUnit from the CLI; debug-mode + ANSI output + repeated launches can severely strain compute resources.
- Use `--quit-after` when launching a scene for smoke checks to avoid accidental "runs forever" loops.

---

## Local Git Hook (Optional)

- This repo includes `.githooks/post-commit` to auto-commit Godot `.uid` files after a normal commit.
- In a fresh clone, you can enable it with: `git config core.hooksPath .githooks`.
- If the hook is not enabled, `.uid` files may show up after commits and can be staged manually.

---

## Process Guardian Skills

**Before starting work:**
- Scan relevant skill files before starting new tasks to reuse known workflows
- Common starting points: `create-plan`, `godot-dev`, `godot-gdscript-patterns`, `test-driven-development`
- Check `.claude/learnings/INDEX.md` for relevant learnings to avoid known pitfalls

**While working:**
- Stuck in a loop? → `/skill loop-detection`
- Editing documentation? → `/skill confident-language-guard` (mandatory for Tier 1)
- Repeated similar errors? → `/skill skill-gap-finder`
- Debugging? → `/skill systematic-debugging`
- Completing work? → `/skill verification-before-completion`
- Completely blocked? → `/skill blocked-and-escalating`

**After work:**
- Create learning entries for bugs/loops/patterns in `.claude/learnings/`
- Update `.claude/learnings/INDEX.md`
- Check for similar learnings (2+ similar = invoke `/skill skill-gap-finder`)

**See `.claude/skills/` for complete skill documentation.**

---

## Learnings System

**Directory structure:**
```
.claude/learnings/
├── INDEX.md          # Fast lookup, check before starting work
├── bugs/             # Failed attempts and root causes
├── loops/            # Infinite loop patterns
└── patterns/         # Successful solutions
```

**When to create learnings:**
- Encountered a bug → create entry in `bugs/` using TEMPLATE.md
- Got stuck in loop → create entry in `loops/` using TEMPLATE.md
- Found successful solution → create entry in `patterns/` using TEMPLATE.md

**Always update INDEX.md when creating new entries.**

---

## Escalation Paths

```
Tier 1 (Codex) → Tier 2 (Sonnet 4.5) → Tier 3 (Opus 4.5) → User
```

**When to escalate:**
- After 3 attempts at same goal (loop detected)
- Permission denied for required action
- Architectural decision needed
- Completely blocked

**How to escalate:**
- Invoke `/skill blocked-and-escalating`
- Create structured escalation report in `.claude/learnings/bugs/`
- Update learnings INDEX
- Stop work on blocked task

---

## MCP Playthrough Reminders (High Level)

- Launch the project and navigate to the target scene via MCP.
- Use teleporting or direct calls for quick interaction checks.
- Read dialogue UI text nodes to confirm progression.
- Query GameState flags to confirm quest updates.

Edit Signoff: [Codex - 2025-12-29]
Edit Signoff: [Codex - 2026-01-12]
