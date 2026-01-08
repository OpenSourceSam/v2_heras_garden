---
name: loop-detection
description: Use when (1) same action attempted 3+ times, (2) test keeps failing after fixes, (3) agent feels stuck without progress, (4) same goal attempted with varying approaches. Triggers on repeated failures and stagnation. Prevents infinite loops and creates structured escalation reports.
---

# Loop Detection

## Overview

Random fixes without progress waste time and create frustration. Continuing to try "one more approach" when stuck is a loop.

**Core principle:** After 3 attempts at same goal → STOP and document.

## The Iron Law

```
AFTER 3 ATTEMPTS AT SAME GOAL → STOP AND DOCUMENT
(Track by intent, not exact action)
```

If you haven't detected the loop, you cannot claim you're making progress.

## When to Use

Use for ANY situation where progress has stalled:
- Test fails → fix attempt → test fails → different fix → test fails (loop!)
- Same file edited 3+ times in one session without success
- Same goal with varying approaches that don't work
- Feeling "stuck" or uncertain what to try next
- About to say "let me try one more approach"

**Use this ESPECIALLY when:**
- Under pressure to get tests passing
- "Just one more fix" seems worth trying
- You've already tried multiple approaches
- Not following `/skill systematic-debugging`
- Making changes without root cause investigation

**Don't skip when:**
- Issue seems simple (simple loops still waste time)
- You're in a hurry (loops waste MORE time)
- You think you know what's wrong (but fixes aren't working)

## The Iron Law Enforcement

You MUST complete this process when loop detected.

### Detection: Recognize the Loop

**Triggers (any of these):**
1. Same action attempted 3+ times
2. Same test failing after multiple different fixes
3. Same goal attempted with varying approaches (intent matters, not method)
4. Same file edited 3+ times without achieving goal
5. Feeling stuck or uncertain

**Track by INTENT, not exact action:**
- Goal: "Make boat_travel_test.gd pass"
- Attempt 1: Fix autoload registration
- Attempt 2: Change autoload order
- Attempt 3: Verify project settings
- **This is a loop** even though methods differ - same goal, no progress

###Response: STOP and Document

**IMMEDIATELY when loop detected:**

1. **STOP** all work on this goal
2. **DO NOT** try "one more fix"
3. **DO NOT** create workaround documentation
4. **DO** create loop report (next section)

### Create Loop Report

**Location:** `.claude/learnings/loops/YYYY-MM-DD-description.md`

**Use template:** `.claude/learnings/loops/TEMPLATE.md`

**Must include:**
- What goal was being attempted
- All approaches tried (list all 3+)
- Why agent is blocked
- Reproduction steps (exact commands)
- Whether `/skill systematic-debugging` was followed
- Related files with file:line references
- Escalation plan

**FORBIDDEN in report:**
- Workaround suggestions
- "I'll try X next" proposals
- Documentation of new process rules

### Check for Similar Loops

**After creating report:**

1. Read `.claude/learnings/INDEX.md`
2. Look in loops category for similar patterns
3. If similar loop exists:
   - Check if existing skill addresses this
   - OR invoke that skill
   - OR escalate to higher tier
4. If no similar loop:
   - Create new INDEX entry
   - Escalate with structured report

### Escalate

**Escalation path:** Ask User directly

**Method:**
- Explain what you tried (all 3+ attempts)
- Show the error/blocker clearly
- Ask user for guidance or permission to try different approach
- OR create GitHub issue if user unavailable

**After escalation:**
- Update `.claude/learnings/INDEX.md` with loop entry
- STOP work on this task
- Move to different task OR wait for guidance

## Red Flags - STOP and Use This Skill

If you catch yourself thinking:
- "Let me try one more approach"
- "Maybe if I adjust..."
- "This should work" (after 2+ failed attempts)
- Same file open for editing 3rd time
- Same test failing after multiple fixes
- "I don't fully understand but this might work"
- Proposing fixes without root cause investigation
- Skipping `/skill systematic-debugging`

**ALL of these mean: STOP. You're in a loop. Use this skill.**

## Examples

### Example 1: Test Failure Loop (LOOP)

**Scenario:**
```
Attempt 1: Test fails with "Autoload not found"
→ Add autoload registration
→ Test still fails

Attempt 2: Test fails with same error
→ Change autoload order
→ Test still fails

Attempt 3: Test fails with same error
→ Verify project settings
→ Test still fails
```

**Action:** ✓ LOOP DETECTED. Stop. Create loop report. Escalate.

**Why:** Same goal (pass test), 3+ attempts, no progress.

### Example 2: Root Cause Investigation (NOT A LOOP)

**Scenario:**
```
Test fails → Invoke /skill systematic-debugging
→ Phase 1: Root cause investigation
→ Read error message carefully
→ Trace data flow
→ Find actual cause: resource path typo
→ Single fix addressing root cause
→ Test passes
```

**Action:** ✓ NOT A LOOP. Systematic approach, one targeted fix.

**Why:** Root cause found before fixing. Single attempt after investigation.

### Example 3: Progressive Debugging (NOT A LOOP)

**Scenario:**
```
Attempt 1: Add logging to understand data flow
→ Logs reveal variable is null at step 3

Attempt 2: Add null check before step 3
→ Test passes
```

**Action:** ✓ NOT A LOOP. Gathering evidence, then fixing.

**Why:** First "attempt" was investigation, not fix. Second was targeted fix.

### Example 4: Multi-Approach Loop (LOOP)

**Scenario:**
```
Goal: Load NPC resource without errors

Attempt 1: Change ResourceLoader path
→ Still fails

Attempt 2: Try preload instead
→ Still fails

Attempt 3: Add null check
→ Masks error, doesn't fix root cause
```

**Action:** ✓ LOOP DETECTED. Different methods, same goal, no root cause investigation.

**Why:** Trying different approaches without understanding why it's failing.

## Integration with Other Skills

**This skill works with:**

**systematic-debugging (`/sd`):**
- If following systematic-debugging Phase 1 properly, you rarely hit loops
- If loop detected → systematic-debugging was likely skipped
- Loop report should note whether systematic-debugging was followed

**When stuck after loop detection:**
- Ask user directly for guidance
- Don't invoke chains of skills - just stop and escalate to user

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Just one more try" | That's what you said 2 tries ago. Stop. |
| "This one will work" | Confidence without evidence. Stop. |
| "Different approach" | Same goal, no progress = loop. Stop. |
| "Almost there" | After 3+ attempts? You're stuck. Stop. |
| "Quick fix" | Quick fixes after 3 attempts are still loops. Stop. |
| "I know the problem now" | Then why didn't previous fixes work? Stop and investigate. |

## Quick Reference

| Situation | Action |
|-----------|--------|
| **3+ attempts at same goal** | STOP → Create loop report → Escalate |
| **Same test failing repeatedly** | STOP → Invoke /skill systematic-debugging → If already did, create loop report |
| **Feeling stuck** | STOP → Check if 3+ attempts made → If yes, loop detected |
| **About to try "one more fix"** | STOP → Count attempts → If ≥3, create loop report |
| **Different approaches, no progress** | STOP → Same goal = loop → Create report |

## Success Criteria

**You've successfully used this skill when:**
- ✓ Loop detected before 5+ attempts wasted
- ✓ Loop report created with all required sections
- ✓ `.claude/learnings/INDEX.md` updated
- ✓ Checked for similar loops
- ✓ Escalated appropriately
- ✓ Stopped work on blocked task
- ✓ NO workaround documentation created

## The Bottom Line

**After 3 attempts → STOP.**

Don't try "one more approach". Don't create workaround docs. Don't keep going.

Stop. Document. Escalate. Move on.

This is non-negotiable.
