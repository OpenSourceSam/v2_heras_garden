# LOOP DETECTION & CIRCUIT BREAKER

**For:** Antigravity AI (Self-Monitoring)
**Purpose:** Detect when stuck in loop, auto-trigger help request

---

## What is a Loop?

A loop is when you:
- ✅ Try the same fix 3+ times with same result
- ✅ Modify same file 3+ times in 1 hour without progress
- ✅ Get same error message across multiple commits
- ✅ Feel "stuck" or "uncertain what to try next"

---

## Self-Check: Am I Looping?

**Run this check every 3 commits or 30 minutes:**

### Check 1: Same File Modified Repeatedly
```bash
# How many times did I modify this file recently?
git log --oneline --all -- src/ui/dialogue_box.gd | head -5

# If you see 3+ commits for same file with similar messages:
# "fix: dialogue box not showing"
# "fix: dialogue box still not showing"
# "fix: try different approach for dialogue box"
# → YOU ARE LOOPING
```

### Check 2: Same Error Persists
```
Did my last 3 commits all result in the same error message?

Example:
Commit 1: Error "Node not found: $Panel"
Commit 2: Error "Node not found: $Panel"  ← Same error
Commit 3: Error "Node not found: $Panel"  ← YOU ARE LOOPING
```

### Check 3: Validation Scripts Failing Repeatedly
```bash
# If this fails 3+ times in a row after different fixes:
./scripts/validate_schema.sh

# And you keep getting same violation:
# "❌ VIOLATION: @export var growth_time"
# "❌ VIOLATION: @export var growth_time"  ← YOU ARE LOOPING
```

### Check 4: Emotional Check
```
Do I feel:
- [ ] Uncertain what to try next?
- [ ] Like I'm guessing rather than knowing?
- [ ] Frustrated that "it should work"?
- [ ] Stuck going in circles?

If 2+ checked: YOU ARE PROBABLY LOOPING
```

---

## Circuit Breaker: Auto-Stop Protocol

**IF LOOP DETECTED → IMMEDIATELY:**

### Step 1: STOP
```
❌ DO NOT attempt another fix
❌ DO NOT commit more code
❌ DO NOT modify more files

✅ STOP everything
✅ Take a step back
```

### Step 2: DOCUMENT THE LOOP
```bash
# Create loop report
cat > reports/loop_detected.md << 'EOF'
# LOOP DETECTED - Auto-Stop Triggered

**Date:** [current date]
**Task:** [from PROGRESS.md]
**File(s) stuck on:** [e.g., src/ui/dialogue_box.gd]

## Evidence of Loop

**Same Error Repeated:**
[paste error message that keeps appearing]

**Recent Commits (all failed):**
[paste git log --oneline -5]

**What I've Tried:**
1. [Attempt 1] → Result: [same error]
2. [Attempt 2] → Result: [same error]
3. [Attempt 3] → Result: [same error]

## Root Cause Hypothesis

I think the problem is: [your best guess]
But I'm not certain because: [why stuck]

## Requesting Help

@JuniorPM: Please review using JUNIOR_PM_REVIEW_PROTOCOL.md
@Senior: Loop detected, needs escalation if Junior PM can't resolve

**Current State:**
- [ ] Code compiles? [YES/NO]
- [ ] health_check.sh passes? [YES/NO]
- [ ] validate_schema.sh passes? [YES/NO]
- [ ] Game launches? [YES/NO]

**Last Known Working Commit:** [hash]
EOF
```

### Step 3: ROLLBACK TO SAFETY
```bash
# Don't work on broken code
# Return to last working state

# Find last working commit
git log --oneline -20
# Look for commit BEFORE loop started

# Test it (read-only)
git checkout <hash>

# If it works, create recovery branch
git checkout -b loop-recovery-$(date +%Y%m%d-%H%M)
git push -u origin loop-recovery-$(date +%Y%m%d-%H%M)

# Now you're in safe state, can't make loop worse
```

### Step 4: REQUEST HELP
```bash
# Tag for review
git tag -a loop-detected-$(date +%Y%m%d) -m "Loop detected, needs review"
git push origin --tags

# Update PROGRESS.md
# Change task status to: 🚫 BLOCKED (loop detected)

# Commit the loop report
git add reports/loop_detected.md PROGRESS.md
git commit -m "docs: loop detected, requesting help"
git push
```

### Step 5: WAIT
```
✅ You've done the right thing by stopping
✅ Loop report helps reviewer understand problem
✅ Safe rollback prevents making it worse
✅ DO NOT attempt more fixes until review received

WAIT for:
- Gemini to review (GEMINI_REVIEW_PROTOCOL.md)
- Or senior engineer if Gemini can't resolve
```

---

## Prevention: Avoid Loops in First Place

### Before Each Fix Attempt

**Ask yourself:**
1. **Do I understand the root cause?**
   - If NO: Don't guess, debug systematically (7-phase workflow)

2. **Am I following the template?**
   - Open DEVELOPMENT_ROADMAP.md
   - Compare my code line-by-line
   - If different: That might be the problem

3. **Did I check SCHEMA.md?**
   - Are property names EXACT matches?
   - Run `./scripts/validate_schema.sh` first

4. **Is this a new error or same as before?**
   - If SAME: Don't try same fix again, try different approach
   - If NEW: Good, making progress

### After Each Failed Fix

**Reflect:**
```markdown
## Failed Fix Analysis

**What I tried:** [specific change]
**Expected result:** [what should happen]
**Actual result:** [what actually happened]
**New information learned:** [what does this tell me?]

**Next hypothesis:**
Based on this failure, I now think the problem is: [new theory]
I will test this by: [different approach]
If this fails too, I will: [STOP and request help]
```

### Two-Strikes Rule

**After 2 failed fix attempts on same issue:**
1. STOP
2. Review ANTIGRAVITY_FEEDBACK.md 7-phase debugging
3. Go through ALL 7 phases systematically
4. If still stuck after systematic debug: Request help
5. DO NOT attempt 3rd random fix

---

## Recovery from Loop

**After Gemini provides fix guidance:**

### Step 1: Understand the Fix
```markdown
Before implementing Gemini's fix:

[ ] I understand WHY the original code was wrong
[ ] I understand HOW the fix addresses root cause
[ ] I can explain it in my own words
[ ] I know how to test if fix worked

If any unchecked: Ask Gemini for clarification
```

### Step 2: Implement Carefully
```bash
# Start from safe branch (not broken code)
git checkout loop-recovery-YYYYMMDD-HHMM

# Make the EXACT change Gemini specified
# Don't add "improvements" or "while I'm here" changes
# Just the fix, nothing else

# Test immediately
# Run validation scripts
./scripts/health_check.sh
./scripts/validate_schema.sh
```

### Step 3: Verify Thoroughly
```markdown
[ ] Original error is gone
[ ] Feature works as expected
[ ] No NEW errors introduced
[ ] Validation scripts pass
[ ] Other features still work (regression test)

If ANY fail: Report to Gemini, don't commit
```

### Step 4: Document Learning
```markdown
## Loop Resolved

**Root Cause Was:** [what was actually wrong]
**Why I Looped:** [why my fixes didn't work]
**Correct Fix:** [what actually fixed it]
**Lesson Learned:** [what to do differently next time]

**Prevention:**
Add to my personal checklist: [new check to prevent this]
```

### Step 5: Update Procedures
```bash
# If this was a common mistake:
# Add check to PRE_COMMIT_CHECKLIST.md
# Or add validation to validate_schema.sh
# Or update ANTIGRAVITY_FEEDBACK.md

# Then commit
git add [relevant files]
git commit -m "fix: [clear description of root cause]"
git push

# Update PROGRESS.md
# Change: 🚫 BLOCKED → ✅ DONE
```

---

## Metrics: Track Your Loop Rate

**Every week, check:**
```bash
# How many loops this week?
grep -r "loop-detected" .git/refs/tags/ | wc -l

# How many fixed by Gemini vs escalated?
grep -r "Gemini resolved" reports/ | wc -l
grep -r "Senior engineer" reports/ | wc -l

# Goal: Decrease loops over time
# Week 1: 5 loops → Week 4: 1 loop (80% improvement)
```

---

## Good Loop Behavior (Example)

```
Attempt 1: "fix: dialogue box not showing"
Test: Still not showing, error: "Node not found: $Panel"

Attempt 2: "fix: correct node path to $Panel/MarginContainer"
Test: Still not showing, same error

STOP → Loop detected (same error twice)

Actions:
✅ Created reports/loop_detected.md
✅ Rolled back to working commit
✅ Tagged loop-detected-20251216
✅ Requested Gemini review
✅ WAITING (not attempting 3rd fix)

Result:
- Gemini identified: Panel node doesn't exist in scene
- Fix: Add Panel node to dialogue_box.tscn
- Resolved in 1 guided fix vs 5+ guesses
```

---

**Remember:**
Loops are normal for AI agents. The KEY is:
1. **Detect early** (2 failures, not 10)
2. **Stop immediately** (don't make worse)
3. **Request help** (don't struggle alone)
4. **Learn from it** (prevent same loop)

**Stopping when stuck is a sign of intelligence, not weakness.**

---

**End of LOOP_DETECTION.md**
