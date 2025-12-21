# Jr Engineer Handoff: Rename to Circe's Garden + Workflow Setup

**Date:** 2025-12-19
**From:** Senior PM (Claude Opus 4.5)
**Priority:** High
**Estimated Time:** 1.5 hours

---

## Task Summary

Rename project from "Hera's Garden" to "Circe's Garden" and set up GitHub-based workflow.

---

## STEP 1: Rename (30 min)

### Create Branch
```bash
git checkout -b chore/rename-circes-garden
```

### Files to Update (Find-Replace)

**Pattern:** `Hera's Garden` → `Circe's Garden`
**Pattern:** `HERA'S GARDEN` → `CIRCE'S GARDEN`

| Priority | File | Notes |
|----------|------|-------|
| 1 | `project.godot` | Line 13: `config/name="Circe's Garden"` |
| 1 | `game/features/ui/main_menu.tscn` | UI text for players |
| 1 | `README.md` | Title and description |
| 2 | `CLAUDE.md` | Title and overview |
| 2 | `agent.md` | Title line only |
| 2 | `docs/execution/PROJECT_STATUS.md` | Project Identity section |
| 2 | `docs/execution/ROADMAP.md` | Game Summary |
| 2 | `docs/design/CONSTITUTION.md` | Title |
| 2 | `docs/design/SCHEMA.md` | Title |
| 3 | `docs/overview/README.md` | Title |
| 3 | `docs/overview/DOCS_MAP.md` | Title |
| 3 | `PROJECT_STRUCTURE.md` | Title |
| 3 | `RESTRUCTURE.md` | Title |
| 3 | `_docs/WORKFLOW_GUIDE.md` | Title |
| 4 | `tests/run_tests.gd` | Print statement |
| 4 | `TEST_SCRIPT.gd` | Title if present |

**DO NOT CHANGE:**
- `reports/*.md` (historical)
- `_docs/archive/*.md` (archived)
- GitHub repo name (would break links)

### Verify
```bash
grep "config/name" project.godot
# Should show: config/name="Circe's Garden"

grep -ri "Hera's Garden" . --include="*.md" --include="*.godot" --include="*.tscn" --include="*.gd" | grep -v reports | grep -v archive
# Should return nothing (or minimal historical refs)
```

---

## STEP 2: Rewrite agent.md for Junior Engineer (10 min)

**NOTE:** agent.md is for Codex (Jr Engineer), NOT Claude Code. Different agent, different role.

Replace entire contents of `agent.md` with:

```markdown
# AGENT.MD - Circe's Garden v2 (Junior Engineer)

You are the **Junior Engineer (Codex)**. Follow these rules strictly.

## Your Role
- Execute tasks from ROADMAP.md exactly as written
- Do NOT make strategic decisions
- Escalate to Sr PM (via GitHub Issue) when stuck
- Update RUNTIME_STATUS.md after every action

## Before ANY Task
1. Read docs/execution/PROJECT_STATUS.md - current state
2. Find your task in docs/execution/ROADMAP.md
3. Check docs/design/SCHEMA.md for exact property names
4. Follow docs/design/CONSTITUTION.md rules

## Workflow Rules
- ONE subsection at a time (e.g., 1.1.1 only)
- Copy code templates EXACTLY from ROADMAP.md
- Do NOT add features beyond template
- Validate before commit
- Report completion and WAIT for approval

## When Stuck
1. Create GitHub Issue using `handoff.md` template
2. Label: `agent:opus-priority`
3. Update RUNTIME_STATUS.md with blocker
4. STOP and wait for Sr PM decision

## When Guard Triggers
1. Create GitHub Issue using `guardrail.md` template
2. Label: `blocked`
3. Do NOT try to work around the guard
4. Wait for Sr PM decision

## After Each Action
Overwrite RUNTIME_STATUS.md (don't append):
- Last action: [what you did]
- Status: ✅ Success / ❌ Failed / ⚠️ Blocked
- Timestamp: [ISO 8601]
- Tests passing: [X/5]
- Blockers: [any blockers]
```

---

## STEP 3: Add Sr PM Oversight Section to CLAUDE.md (15 min)

**NOTE:** CLAUDE.md is for Claude Code (Sr PM/Opus). Add oversight protocol.

Add this section before "## When Stuck or Uncertain":

```markdown
---

## Senior PM Oversight Protocol

### Reviewing Jr Engineer Work
1. Check "Review (Opus)" column in GitHub Project
2. Read the handoff issue for context
3. Review code changes (if any) against ROADMAP.md template
4. Decide: Approve, Request Changes, or Take Over

### When to Intervene
- Architectural decisions (affects CONSTITUTION.md)
- Strategic direction changes
- Guardrail violations
- Jr Engineer blocked >2 attempts

### When to Delegate Back
- Task is well-defined in ROADMAP.md
- No architectural implications
- Jr Engineer has all needed context
- Create `review.md` issue with clear action items

### GitHub Project Board Columns
| Column | Owner | Purpose |
|--------|-------|---------|
| Backlog | Sr PM | Prioritized tasks |
| In Progress (Codex) | Jr Eng | Active work |
| Review (Opus) | Sr PM | Needs decision |
| Blocked | Either | Waiting on external |
| Done | Auto | Completed |
```

---

## STEP 4: Create Issue Templates (15 min)

### Create Directory
```bash
mkdir -p .github/ISSUE_TEMPLATE
```

### Create `.github/ISSUE_TEMPLATE/handoff.md`
```markdown
---
name: Handoff to Senior PM
about: Junior engineer needs guidance or decision from senior PM
labels: ["agent:opus-priority", "needs-decision"]
assignees: []
---

## Problem Summary
[What I encountered]

## Approaches Tried
[What I attempted]

## Token Cost So Far
[Estimated tokens spent]

## Decision Needed
[What I need Sr PM to decide]

## Urgency
- [ ] Blocking
- [ ] High
- [ ] Medium
- [ ] Low
```

### Create `.github/ISSUE_TEMPLATE/guardrail.md`
```markdown
---
name: Guardrail Triggered
about: A project guardrail blocked an action
labels: ["guardrail", "blocked"]
assignees: []
---

## Guard Name
[e.g., project.godot MCPInputHandler guard]

## File/Line Blocked
[What was trying to change]

## Reason
[Why guard triggered]

## Next Step
[What should happen to resolve]
```

### Create `.github/ISSUE_TEMPLATE/review.md`
```markdown
---
name: Task Delegation
about: Senior PM delegates task back to junior engineer
labels: ["agent:codex-task"]
assignees: []
---

## Decision
[What Sr PM decided]

## Rationale
[Why this approach]

## Action Items for Junior
- [ ] Task 1
- [ ] Task 2
- [ ] Update RUNTIME_STATUS.md when done
```

---

## STEP 5: Create RUNTIME_STATUS.md (5 min)

Create `RUNTIME_STATUS.md` in repo root:

```markdown
# Runtime State (auto-generated)

Lightweight status snapshot. Overwrite after each action (don't append).

- **Last action:** Renamed project to Circe's Garden
- **Status:** ✅ Success
- **Timestamp:** 2025-12-19T20:00Z
- **Current branch:** chore/rename-circes-garden
- **Tests passing:** 5/5
- **Blockers:** World TileMapLayer has no painted tiles
```

---

## STEP 6: Test and Commit (10 min)

```bash
# Run tests
godot --headless --script tests/run_tests.gd

# Check status
git status

# Stage all
git add -A

# Commit
git commit -m "chore: rename project to Circe's Garden + add workflow setup

- Rename all docs and config from Hera's Garden to Circe's Garden
- Simplify agent.md to pointer file
- Add Agent Collaboration Protocol to CLAUDE.md
- Create GitHub issue templates (handoff, guardrail, review)
- Create RUNTIME_STATUS.md for lightweight status tracking

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push
git push -u origin chore/rename-circes-garden
```

---

## Verification Checklist

- [ ] `project.godot` shows `config/name="Circe's Garden"`
- [ ] Main menu displays "Circe's Garden" in UI
- [ ] README.md title updated
- [ ] CLAUDE.md title updated + workflow section added
- [ ] agent.md simplified with handoff protocol
- [ ] Tests still pass (5/5)
- [ ] No "Hera's Garden" in Tier 1-4 files
- [ ] Reports/archives unchanged
- [ ] `.github/ISSUE_TEMPLATE/` has 3 files
- [ ] `RUNTIME_STATUS.md` exists

---

## After Completion

1. Create PR to merge into main branch
2. Update RUNTIME_STATUS.md with completion status
3. Report back to Sr PM for review

---

End of Handoff
