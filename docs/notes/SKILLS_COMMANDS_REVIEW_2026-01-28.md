# Skills & Commands Review: Contradictions and Improvement Suggestions

**Date:** 2026-01-28  
**Scope:** 33 Claude skills, 5 GitHub skills, 9 commands  
**Purpose:** Identify contradictions, overlaps, and suggest improvements for longer autonomous work

---

## 🚨 Critical Contradictions Found

### 1. **Finish-Work Gate vs /finish Command**

| Skill/Command | What It Says |
|---------------|--------------|
| `finish-work` skill | "NO WORK COMPLETION WITHOUT PASSING THE FINISH-WORK GATE" - Must check `.session_manifest.json` before claiming completion |
| `/finish` command | Comprehensive wrap-up protocol with documentation updates, handoff docs - NO mention of time gate |

**Contradiction:** `/finish` doesn't reference the finish-work skill, creating a bypass path.

**Fix:** Update `/finish` command to include as Step 0:
```markdown
### 0. Time Gate Verification (REQUIRED)
Before proceeding, verify minimum work duration via finish-work skill:
- Read `.session_manifest.json`
- Calculate elapsed time
- If remaining_minutes > 0: Cannot finish yet
- If remaining_minutes <= 0: Proceed with wrap-up
```

---

### 2. **longplan vs ralph vs subagent-driven-development vs executing-plans**

Four different skills for "execute a plan with subagents" - confusing overlap:

| Skill | Use Case | Subagent Strategy | Session |
|-------|----------|-------------------|---------|
| `longplan` | Multi-step work | 5-10+ parallel waves, MiniMax | Same session |
| `ralph` | Batch asset generation | Automatic MiniMax orchestration | Same session |
| `subagent-driven-development` | Implementation plans | Fresh subagent per task + 2 reviewers | Same session |
| `executing-plans` | Implementation plans | Parallel session (separate window) | New session |

**Contradictions:**
1. `longplan` says "spawn 5-10+ subagents" but `subagent-driven-development` says "DON'T dispatch multiple implementation subagents in parallel (conflicts)"
2. `ralph` extends `/longplan` but has different checkpointing (progress file vs operation count)
3. When to use which is unclear - all sound similar

**Fix:** Create clear decision matrix at top of each skill:
```markdown
## When to Use This vs Alternatives

| Your Situation | Use This | Not These |
|----------------|----------|-----------|
| 10+ similar assets to generate | `/ralph` | `/longplan` (overkill) |
| Complex feature, multi-file | `/longplan` | `/ralph` (wrong tool) |
| Plan exists, want fresh subagent per task + review | `subagent-driven-development` | `executing-plans` (if staying in session) |
| Plan exists, want parallel session | `executing-plans` | `subagent-driven-development` (if new session) |
| Debugging/investigating | `systematic-debugging` | Any of above |
```

---

### 3. **systematic-debugging vs troubleshoot-and-continue**

| Skill | Approach | When Blocked |
|-------|----------|--------------|
| `systematic-debugging` | 4-phase scientific method | "If 3+ fixes failed: STOP and question architecture" |
| `troubleshoot-and-continue` | Resource inventory | "Spawn 3 MiniMax subagents in parallel, try all suggestions, THEN consider stopping" |

**Contradiction:** 
- `systematic-debugging` says STOP after 3 failed fixes and question architecture
- `troubleshoot-and-continue` says keep going, spawn more subagents, exhaust all resources

**Fix:** Clarify hierarchy in both skills:
```markdown
# In systematic-debugging Phase 4:
**If Fix Doesn't Work:**
- Count: How many fixes have you tried?
- If < 3: Return to Phase 1, re-analyze
- If ≥ 3: Use troubleshoot-and-continue protocol FIRST
  - Spawn MiniMax subagents for alternative approaches
  - Exhaust all resources per troubleshoot-and-continue
  - THEN if still blocked: Question architecture
```

---

### 4. **Checkpoint/Context Management Contradictions**

| Skill | Checkpoint Trigger | Method |
|-------|-------------------|--------|
| `longplan` | 3 writes OR 5 read/write ops | `/context clear` or restart |
| `ralph` | Not explicitly defined | Progress file |
| `subagent-driven-development` | After each task (human review) | Natural breakpoint |

**Contradiction:** `longplan` says "Checkpoint after 3 writes" but also "DON'T stop for summaries or check-ins" - checkpointing requires a pause.

**Fix:** Clarify in `longplan`:
```markdown
**Checkpointing is NOT stopping:**
- You're not asking the user anything
- You're not providing a summary to the user  
- You're clearing token bloat to continue working
- Work continues uninterrupted (just in a fresh context)
```

---

### 5. **dispatching-parallel-agents vs longplan Parallel Delegation**

Both advocate parallel subagents but with different constraints:

| Skill | Parallelism | Constraints |
|-------|-------------|-------------|
| `dispatching-parallel-agents` | One agent per problem domain | "Don't use when failures are related" |
| `longplan` | 5-10+ agents in waves | "Massive parallel delegation" |

**Contradiction:** `subagent-driven-development` says "DON'T dispatch multiple implementation subagents in parallel (conflicts)" while `longplan` says "spawn 5-10+ subagents"

**Fix:** Distinguish "research/investigation" (safe parallel) from "implementation" (sequential per task):
```markdown
## Parallel vs Sequential Rules

**ALWAYS Parallel (no conflicts):**
- Research tasks
- Code analysis
- Independent investigations
- Asset generation (different files)

**SEQUENTIAL (avoid conflicts):**
- Implementation subagents modifying same codebase
- Multiple agents editing same files
- Code changes that might overlap

**In longplan:** Wave 1 (research) = 10 parallel agents ✓, Wave 2 (implementation) = sequential or file-partitioned
```

---

## 🔧 Improvements for Longer Autonomous Work

### Suggestion 1: **Unified Self-Review Protocol**

Create a new skill `self-review-protocol` that standardizes autonomous checking:

```markdown
# Autonomous Self-Review Protocol

## Every 30 Minutes (or 5 tasks)
Run this checklist WITHOUT STOPPING:

### Code Quality Check
- [ ] Re-read last 3 files modified
- [ ] Check for obvious errors (typos, missing imports)
- [ ] Verify tests still pass (if quick to run)

### Progress Verification  
- [ ] TodoWrite up to date?
- [ ] Plan file checkpoint updated?
- [ ] Any blockers to document?

### Direction Check
- [ ] Still aligned with original goal?
- [ ] No scope creep detected?
- [ ] Skills being used appropriately?

**If issues found:** Fix immediately, don't wait.
**If no issues:** Continue working.
```

---

### Suggestion 2: **Subagent Self-Review Loop**

For longer work blocks, implement automatic peer review:

```markdown
## Wave Implementation Pattern with Self-Review

### Wave 1: Implementation (Parallel)
Spawn 3-5 subagents for different aspects:
- Agent A: Core implementation
- Agent B: Tests  
- Agent C: Documentation

### Wave 2: Cross-Review (Parallel)
Before integrating, spawn review agents:
- Reviewer 1: Review Agent A's work (spawned with just that code)
- Reviewer 2: Review Agent B's work
- Reviewer 3: Review Agent C's work

### Wave 3: Integration (Sequential)
Main agent integrates all approved work.

**Benefit:** Catches errors without human intervention.
```

---

### Suggestion 3: **Compounding Documentation Protocol**

Current: Document at end of work block  
Proposed: Document continuously in `CLAUDE.md`:

```markdown
## Continuous Documentation Pattern

Every solved problem, add to CLAUDE.md "Common Solutions":

```markdown
### [Timestamp]: [Brief Problem Description]
**Context:** [What was being worked on]
**Blocker:** [What went wrong]
**Approaches Tried:** [List]
**Solution:** [What worked]
**Pattern:** [When this applies again]
```

**Benefit:** Future agents benefit immediately, not just at handoff.
```

---

### Suggestion 4: **Token Budget Management**

Add to `longplan` and `ralph`:

```markdown
## Token Budget Tracking

**GLM-4.7 Context: ~200K tokens**

### Budget Allocation
| Phase | Token Budget | Actions |
|-------|--------------|---------|
| 1A (Planning) | 20K | Research, ask questions, create plan |
| 2A Wave 1 | 50K | Research subagents, analysis |
| 2A Wave 2 | 80K | Implementation (heaviest) |
| 2A Wave 3 | 40K | Integration, tests, polish |
| Reserve | 10K | Contingency, final checks |

**Checkpoint when budget 80% consumed:**
- Clear context immediately
- Resume with fresh budget
```

---

### Suggestion 5: **Standardized Blocker Escalation**

Create consistent escalation path across all skills:

```markdown
## Blocker Escalation Ladder

### Level 1: Self-Solve (0-5 min)
- Try 2-3 alternative approaches
- Check skills documentation
- Re-read relevant code

### Level 2: Subagent Help (5-15 min)
- Spawn MiniMax research subagent
- Spawn MiniMax "devil's advocate" reviewer
- Try all subagent suggestions

### Level 3: Documentation Search (15-25 min)
- Search CLAUDE.md for similar issues
- Check docs/agent-instructions/
- Review similar implementations in codebase

### Level 4: Parallel Workaround (25-35 min)
- Document blocker with attempts made
- Skip to next independent task
- Circle back later with fresh perspective

### Level 5: User Escalation (35+ min only)
- All above exhausted
- Blocker documented with full attempt history
- Specific question prepared (not "what should I do?")

**NEVER escalate before Level 4 for autonomous work.**
```

---

## 📊 Skill Consolidation Recommendations

### High Priority Merges

1. **`troubleshoot-and-continue` INTO `systematic-debugging`**
   - `systematic-debugging` is more comprehensive
   - Add "Resource Exhaustion" phase that includes `troubleshoot-and-continue` protocol
   - Delete separate `troubleshoot-and-continue` skill

2. **`dispatching-parallel-agents` INTO `subagent-best-practices`**
   - Both about subagent delegation patterns
   - `subagent-best-practices` is more general, add parallel section
   - Keep `dispatching-parallel-agents` as focused reference

3. **`ralph` INTO `longplan`**
   - `ralph` is essentially `/longplan --mode autonomous --autodelegate`
   - Add `--delegate` flag to `/longplan`
   - Deprecate separate `/ralph` command

### Medium Priority Clarifications

4. **`finish-work` vs `finishing-a-development-branch`**
   - Rename `finishing-a-development-branch` to `complete-branch-workflow`
   - Clarify: `finish-work` = time gate, `complete-branch-workflow` = git workflow
   - Add cross-references

5. **`verification-before-completion` vs `finish-work`**
   - `verification-before-completion` = quality checks
   - `finish-work` = time gate
   - Both needed but clarify distinction

---

## 🎯 Quick Wins for Longer Autonomous Blocks

### 1. **Add "Autonomous Mode" Header to All Skills**

Standardize skills with autonomous work section:

```markdown
## Autonomous Work Mode

**When working without human interaction:**

### Self-Checkpoints (Every 30 min)
- [ ] Re-verify plan alignment
- [ ] Run quick tests
- [ ] Update progress tracking
- [ ] Clear context if needed

### Blocker Response (Without Asking)
1. Try 3 alternative approaches
2. Spawn MiniMax subagent
3. Document and skip to next task
4. Circle back later

### Quality Gates (Self-Enforced)
- [ ] All tests pass before declaring done
- [ ] Visual proof captured (for visual work)
- [ ] Narrative consistency checked (for story work)
- [ ] Time commitment fulfilled
```

### 2. **Standardize Progress File Format**

All long-work skills use same format:

```json
{
  "session_id": "unique-id",
  "skill_used": "longplan|ralph|subagent-driven-dev",
  "started_at": "ISO timestamp",
  "estimated_duration": "2 hours",
  "checkpoints": [
    {
      "timestamp": "ISO",
      "operations_count": 5,
      "files_modified": ["list"],
      "blockers": ["any"],
      "next_tasks": ["list"]
    }
  ],
  "completion_criteria": {
    "tests_pass": true,
    "visual_proof": "screenshot_path",
    "time_fulfilled": true
  }
}
```

### 3. **Create Master Decision Flowchart**

Single skill `which-skill-to-use.md`:

```markdown
# Which Skill Should I Use?

```
START
  ↓
Need to debug? → systematic-debugging
  ↓
Have plan ready?
  YES → Stay in session? → YES → subagent-driven-development
                    → NO → executing-plans
  NO → Need to plan?
    YES → Complex multi-step? → YES → /longplan
                       → NO → writing-plans
    NO → Quick task? → Just do it
```
```

---

## 📝 Commands Updates Needed

| Command | Issue | Fix |
|---------|-------|-----|
| `/finish` | No time gate check | Add Step 0: finish-work verification |
| `/ralph` | Overlaps with `/longplan` | Deprecate, add `--delegate` to `/longplan` |
| `/longplan` | Checkpoint vs no-stop contradiction | Clarify checkpointing is context management, not stopping |
| `/review` | Not reviewed yet | Check alignment with `requesting-code-review` skill |
| `/ground` | Not reviewed yet | Verify alignment with `brainstorming` skill |

---

## 🏁 Summary: Top 5 Actions

1. **Fix `/finish` command** - Add finish-work gate check as Step 0
2. **Merge `troubleshoot-and-continue`** into `systematic-debugging`
3. **Create unified decision matrix** in `longplan`, `ralph`, `subagent-driven-development`
4. **Add autonomous mode headers** to top 5 most-used skills
5. **Standardize progress file format** across all long-work skills

---

## 📈 Expected Impact

| Metric | Current | After Changes |
|--------|---------|---------------|
| Skill confusion | 4 overlapping execution skills | Clear decision matrix |
| Early stopping | Variable enforcement | Standardized 5-level ladder |
| Self-review | Inconsistent | Every 30 min protocol |
| Documentation | End-of-work only | Continuous in CLAUDE.md |
| Context management | Skill-specific | Unified checkpoint format |

---

**Next Steps:**
1. Review with user for approval
2. Create individual PRs for each change
3. Update skills incrementally to avoid disruption
