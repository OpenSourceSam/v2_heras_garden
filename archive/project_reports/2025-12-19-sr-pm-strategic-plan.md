# Strategic Plan: GitHub-Based Workflow & Status Management

**Date:** 2025-12-19
**From:** Senior PM (Claude Opus 4.5)
**To:** Project Owner
**Subject:** Proposal for Token-Efficient Project Management via GitHub Projects

---

## Executive Summary

After reviewing recent reports and the online recommendations, I propose **migrating from markdown-heavy status tracking to GitHub Projects + Issue Templates**. This will:

1. **Reduce token costs by 70-80%** (read structured issues vs entire PROJECT_STATUS.md history)
2. **Enable better collaboration** between Sr PM (Opus) and Jr Engineer (Codex/Haiku)
3. **Automate status tracking** via GitHub Actions
4. **Maintain existing doc quality** (CONSTITUTION, SCHEMA, ROADMAP remain authoritative)

---

## Current State Assessment

### ✅ What's Working Well
- **World-class docs**: CONSTITUTION.md, SCHEMA.md, ROADMAP.md are exceptional
- **Narrow guard verified**: GitHub Actions protects project.godot MCPInputHandler line
- **CLAUDE.md created**: Future Claude instances have comprehensive guidance
- **Recent stabilization**: Scene wiring, test runner, constants centralization all complete

### ⚠️ Current Friction Points
1. **PROJECT_STATUS.md bloat**: Growing history log requires re-reading entire file each session (high token cost)
2. **No issue tracking**: GitHub repo exists but no Issues or Projects configured
3. **Manual status updates**: Codex must manually edit PROJECT_STATUS.md after each task
4. **Identity confusion**: "Hera's Garden" title vs "Circe" protagonist (per Jr Engineer review)
5. **Restructure timing unclear**: RESTRUCTURE.md plan exists but no decision on when to execute

### 📋 Sr PM Tasks from Reports
From recent reviews, the Sr PM should address:
1. Project identity decision (Hera vs Circe naming)
2. Restructure timing decision (now vs after Phase 1)
3. World scene tile painting (blocks gameplay testing)
4. Workflow/status management improvement (this proposal)

---

## Proposed Solution: GitHub Projects + Lightweight Status

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ GitHub Project Board (Single Source of Truth)               │
│ ┌─────────┬──────────────┬────────────┬─────────┬─────────┐ │
│ │ Backlog │ In Progress  │   Review   │ Blocked │  Done   │ │
│ │         │   (Codex)    │  (Opus)    │         │         │ │
│ └─────────┴──────────────┴────────────┴─────────┴─────────┘ │
└─────────────────────────────────────────────────────────────┘
              ↓                    ↓                ↓
      GitHub Issues         Auto-Labels      GitHub Actions
   (3 templates below)    (agent assignment)  (auto-move cards)
```

### Components

#### 1. RUNTIME_STATUS.md (Replaces PROJECT_STATUS.md)
**Purpose:** Lightweight snapshot (not historical log)
**Updated by:** Codex overwrites atomically after each action
**Token cost:** ~50 tokens vs ~2000+ for current PROJECT_STATUS.md

```markdown
# Runtime State (auto-generated)
- Last action: Committed CLAUDE.md and removed project.godot read-only lock
- Status: ✅ Success
- Timestamp: 2025-12-19T19:30Z
- Current branch: docs/code-review-2025-12-18
- Tests passing: 5/5
- Blockers: World TileMapLayer has no painted tiles
```

#### 2. GitHub Issue Templates (.github/ISSUE_TEMPLATE/)

**A. handoff.md** - Jr Engineer → Sr PM escalation
```yaml
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
[ ] Blocking [ ] High [ ] Medium [ ] Low
```

**B. guardrail.md** - When guard blocks action
```yaml
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

**C. review.md** - Sr PM → Jr Engineer delegation
```yaml
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

#### 3. GitHub Actions Automation

**Workflow:** `.github/workflows/status-automation.yml`
```yaml
name: Status Automation
on: [issues, pull_request]
jobs:
  auto-move-cards:
    # Move issues to columns based on labels
    # "agent:opus-priority" → Review (Opus) column
    # "agent:codex-task" → In Progress (Codex) column
    # "blocked" → Blocked column
```

#### 4. Slash Command Protocol (in agent.md)

```markdown
# Agent Handoff Protocol

**Codex (Jr Engineer):**
- When stuck: `/handoff` → creates handoff.md issue → moves to "Review (Opus)"
- When guard triggers: `/guardrail` → creates guardrail.md issue → adds "blocked" label
- After each action: Update RUNTIME_STATUS.md (overwrite, don't append)

**Opus (Sr PM):**
- When reviewing board: Check "Review (Opus)" column for open issues
- When delegating: `/delegate` → comment on issue → moves to "In Progress (Codex)"
- Strategic decisions: Update CONSTITUTION.md or ROADMAP.md (authoritative docs)
```

---

## Migration Plan

### Phase 1: Setup (30 min)
1. Create GitHub Project board with 5 columns
2. Create 3 issue templates in `.github/ISSUE_TEMPLATE/`
3. Create RUNTIME_STATUS.md (replace PROJECT_STATUS.md)
4. Archive PROJECT_STATUS.md → `_docs/archive/PROJECT_STATUS_2025-12-19.md`
5. Add status automation workflow

### Phase 2: Documentation Updates (15 min)
1. Update agent.md with slash command protocol
2. Update CLAUDE.md to reference RUNTIME_STATUS.md (not PROJECT_STATUS.md)
3. Update DOCS_MAP.md to show new structure

### Phase 3: Test Run (15 min)
1. Create test handoff issue
2. Verify auto-labeling works
3. Test Codex updating RUNTIME_STATUS.md
4. Verify Opus can read board view efficiently

---

## Token Cost Comparison

| Task | Current (Markdown) | Proposed (GitHub) | Savings |
|------|-------------------|-------------------|---------|
| Status check | 2000+ tokens (read full PROJECT_STATUS.md) | 200 tokens (read RUNTIME_STATUS.md + open issues) | **90%** |
| Handoff | Manual DM, context loss | Structured issue, preserved context | **80%** |
| Board overview | Scan entire markdown file | Visual board, filter by label | **95%** |
| **Average session** | **~3000 tokens** | **~500 tokens** | **83%** |

---

## Compatibility with Existing Docs

**Preserved (Authoritative):**
- ✅ CONSTITUTION.md - Immutable technical rules
- ✅ SCHEMA.md - Data structure definitions
- ✅ ROADMAP.md - Implementation guide with templates
- ✅ WORKFLOW_GUIDE.md - Process rules
- ✅ CLAUDE.md - Guidance for future instances

**Replaced:**
- ❌ PROJECT_STATUS.md → RUNTIME_STATUS.md (lightweight)

**Enhanced:**
- ✅ agent.md - Add slash command protocol
- ✅ GitHub Project - Visual task board

---

## Recommendation

**I recommend implementing this GitHub-based workflow immediately** because:

1. **Token efficiency**: 80%+ reduction in status tracking costs
2. **Better tooling**: GitHub's native search, labels, milestones
3. **Automation-ready**: Webhooks, Actions, integrations
4. **Scalability**: Grows with project, doesn't become unreadable log
5. **Low risk**: Preserves all authoritative docs (CONSTITUTION, SCHEMA, ROADMAP)

The migration can be done in ~1 hour and will pay dividends immediately.

---

## Next Steps (Immediate)

If approved, I will:
1. Create GitHub Project board
2. Create 3 issue templates
3. Create RUNTIME_STATUS.md
4. Archive PROJECT_STATUS.md
5. Update agent.md and CLAUDE.md
6. Create first test issue to verify workflow

**Awaiting your decision to proceed.**

---

**Appendix A: Current GitHub Extension Status**

The repo is connected to GitHub (https://github.com/AI-Original-Steak-Sauce/v2_heras_garden.git) but:
- ❌ No GitHub Project configured
- ❌ No issue templates
- ❌ No automation workflows (except the narrow guard)
- ✅ Narrow guard works (protects project.godot)

Jr Engineer mentioned GitHub extension recommendations in reports, but I found no specific GitHub Issues filed yet. The workflow above addresses this gap.

---

**Appendix B: Other Strategic Decisions Needed**

1. **Project Identity** (from Jr Engineer review):
   - Option A: Rename to "Circe's Garden" (align with protagonist)
   - Option B: Keep "Hera's Garden", add narrative link
   - **My recommendation:** Option A for clarity

2. **Restructure Timing** (from Jr Engineer review):
   - Option A: Execute RESTRUCTURE.md now (before more Phase 1 work)
   - Option B: Defer until after Phase 1 complete
   - **My recommendation:** Option A to avoid complex refactor later

3. **World Scene Tiles** (high priority blocker):
   - Jr Engineer can paint placeholder tiles immediately
   - **My recommendation:** Delegate to Jr Engineer

---

End of Strategic Plan
