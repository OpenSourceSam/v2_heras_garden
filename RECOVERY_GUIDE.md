# RECOVERY GUIDE

**Purpose:** What to do when something breaks
**Audience:** Antigravity AI (autonomous agent)
**Rule:** Follow this workflow BEFORE asking for help

---

## When to Use This Guide

Use this guide if:
- ✅ Game won't launch (errors on startup)
- ✅ Feature you just implemented is broken
- ✅ Tests that passed before now fail
- ✅ You're not sure what you changed
- ✅ You accidentally deleted/modified critical files

**DO NOT use this guide for:**
- ❌ Expected errors during implementation (fix normally)
- ❌ TODO markers (that's future work, not breakage)

---

## Recovery Workflow

### Step 1: STOP and ASSESS

**DO NOT:**
- ❌ Keep coding to "fix it quickly"
- ❌ Commit broken code
- ❌ Try multiple random fixes
- ❌ Delete files in panic

**DO:**
```bash
# Take a breath, then:
git status          # What changed?
git diff            # What's different?
```

**Document the issue:**
```bash
# Create recovery log
mkdir -p reports
cat > reports/recovery_log.md << 'EOF'
# Recovery Log - [Date]

## What I Was Trying To Do
- Task: [e.g., "Implement farm plot tilling"]
- Expected: [e.g., "Player presses E, plot becomes tilled"]

## What Broke
- Symptom: [e.g., "Game crashes on launch with error: ..."]
- Error message: [paste full error]

## What I Changed
- Files modified: [list from git status]
- Last working commit: [run: git log --oneline -1]

## Recovery Attempts
- [ ] Attempt 1: [what you tried]
- [ ] Attempt 2: [what you tried]
EOF
```

---

### Step 2: RUN DIAGNOSTICS

```bash
# Run health check
./scripts/health_check.sh

# Run schema validation
./scripts/validate_schema.sh

# Check git status
git status

# See recent changes
git diff

# See recent commits
git log --oneline -5
```

**Record results in recovery_log.md**

---

### Step 3: IDENTIFY SCOPE

**Question:** When did it break?

**Option A: "Just now, I was working on it"**
→ Go to Step 4A (Revert Recent Changes)

**Option B: "It was working earlier today"**
→ Go to Step 4B (Find Last Working Commit)

**Option C: "I don't know when it broke"**
→ Go to Step 4C (Systematic Rollback)

**Option D: "I deleted/modified a critical file by accident"**
→ Go to Step 4D (Restore Specific File)

---

### Step 4A: REVERT RECENT CHANGES

**If you haven't committed yet:**
```bash
# See what changed
git diff

# Restore specific file
git restore src/entities/farm_plot.gd

# OR restore ALL uncommitted changes (nuclear option)
git restore .

# Test if this fixes it
# If yes: Start over more carefully
# If no: Go to Step 4B
```

**If you already committed:**
```bash
# Revert the last commit (creates new commit)
git revert HEAD

# Push the revert
git push

# Test if this fixes it
# If yes: Good, now re-implement correctly
# If no: Go to Step 4B
```

---

### Step 4B: FIND LAST WORKING COMMIT

```bash
# See recent commits
git log --oneline -10

# Example output:
# a1b2c3d feat: add broken feature     ← Current (broken)
# e4f5g6h feat: add working feature    ← Maybe this works?
# i7j8k9l docs: update README
# m1n2o3p feat: implement farm plots   ← Or this?

# Test a previous commit (read-only)
git checkout e4f5g6h

# Launch game, test functionality
# Does it work?

# If YES:
git checkout claude/access-data-bnkZr        # Return to current branch
git revert a1b2c3d                           # Revert broken commit
git push

# If NO:
git checkout claude/access-data-bnkZr        # Return to current branch
# Try an earlier commit (repeat process)
```

---

### Step 4C: SYSTEMATIC ROLLBACK

**If you can't identify when it broke:**

```bash
# Return to last tagged checkpoint
git tag -l                                    # See available tags

# Example: phase-1-complete
git checkout phase-1-complete

# Test if this works
# If YES:
# - This tag is your "known good state"
# - Create recovery branch
git checkout -b recovery-from-phase1 phase-1-complete

# - Cherry-pick good commits from broken branch
git log claude/access-data-bnkZr --oneline   # See commits
git cherry-pick e4f5g6h                       # Pick good commits

# If NO:
# - Even the tagged checkpoint is broken (very rare)
# - Go to Step 5 (Ask for Help)
```

---

### Step 4D: RESTORE SPECIFIC FILE

**If you accidentally modified/deleted a critical file:**

```bash
# Restore from previous commit
git checkout HEAD~1 -- src/autoloads/game_state.gd

# Restore from specific tag
git checkout phase-1-complete -- src/autoloads/game_state.gd

# Test if this fixes it
# If yes:
git add src/autoloads/game_state.gd
git commit -m "fix: restore accidentally modified game_state.gd"
git push
```

---

### Step 5: TEST THE FIX

**After any recovery attempt:**

```bash
# Run validation scripts
./scripts/health_check.sh
./scripts/validate_schema.sh

# Launch game
# - Does it start without errors?
# - Press F3 (Debug HUD works?)
# - Press F4 (Day advances?)
# - Test the feature you were working on

# If ALL tests pass:
# - Document what worked in recovery_log.md
# - Commit the fix
# - Push to remote

# If tests FAIL:
# - Try next recovery option
# - Document attempt in recovery_log.md
```

---

### Step 6: PREVENT RECURRENCE

**After successful recovery, analyze WHY it broke:**

```markdown
## Root Cause Analysis (add to recovery_log.md)

1. What was the root cause?
   - [ ] Property name didn't match SCHEMA.md
   - [ ] Forgot to run validation scripts
   - [ ] Didn't test before committing
   - [ ] Modified file I shouldn't have
   - [ ] Skipped pre-commit checklist
   - [ ] Other: _______________

2. How to prevent this in the future?
   - Action 1: [e.g., "Always run validate_schema.sh before commit"]
   - Action 2: [e.g., "Test with Debug HUD visible"]

3. Update procedures if needed
   - [ ] Added check to PRE_COMMIT_CHECKLIST.md
   - [ ] Added validation to scripts/validate_schema.sh
   - [ ] Updated ANTIGRAVITY_FEEDBACK.md
```

---

## Emergency: "Everything is Broken, I'm Stuck"

**If you've tried everything and nothing works:**

### 1. Create Detailed Recovery Report

```bash
cat > reports/emergency_recovery.md << 'EOF'
# EMERGENCY RECOVERY REQUEST

## Summary
[1-2 sentences: what broke, when, why I'm stuck]

## What I Was Doing
- Task: [from DEVELOPMENT_ROADMAP.md]
- Files modified: [list]
- Last working state: [commit hash or tag]

## What's Broken
- Symptom: [describe]
- Error messages: [paste FULL errors]
- Screenshots: [if relevant]

## Diagnostics
- health_check.sh result: [PASS/FAIL - paste output]
- validate_schema.sh result: [PASS/FAIL - paste output]
- git status: [paste output]
- git log -5: [paste output]

## Recovery Attempts
1. [What I tried]
   Result: [What happened]

2. [What I tried]
   Result: [What happened]

## Current State
- Can game launch? [YES/NO]
- Last known working commit: [hash]
- Current branch: [name]
- Uncommitted changes? [YES/NO]

## Question for Senior Engineer
[Specific question, not "please fix it"]
EOF
```

### 2. Return to Safe State

```bash
# Preserve your work
git stash                                    # Save uncommitted changes

# Return to last tag
git checkout phase-1-complete

# Create recovery branch
git checkout -b emergency-recovery

# Test if tag works
# If yes: work from here temporarily
# If no: something is very wrong
```

### 3. Wait for Senior Engineer Review

**DO NOT:**
- ❌ Keep trying random fixes
- ❌ Commit broken code
- ❌ Delete the repository
- ❌ Force push

**DO:**
- ✅ Document everything in recovery_log.md
- ✅ Wait for guidance
- ✅ Preserve all evidence (don't delete branches/commits)

---

## Quick Reference: Common Scenarios

| Scenario | Quick Fix |
|----------|-----------|
| "Game won't launch" | `git restore .` then re-test |
| "Just committed broken code" | `git revert HEAD && git push` |
| "Deleted file by accident" | `git checkout HEAD~1 -- <file>` |
| "Don't know what changed" | `git diff` then `git restore .` |
| "Everything worked yesterday" | `git log --oneline -10` then `git checkout <hash>` |
| "Need to start over" | `git checkout phase-1-complete` |

---

## Recovery Commands Cheat Sheet

```bash
# Diagnostics
git status                               # What changed?
git diff                                 # What's different?
git log --oneline -10                    # Recent commits

# Undo uncommitted changes
git restore <file>                       # Restore specific file
git restore .                            # Restore all files

# Undo committed changes
git revert HEAD                          # Undo last commit
git revert <hash>                        # Undo specific commit

# Time travel (read-only)
git checkout <hash>                      # Go to specific commit
git checkout <tag>                       # Go to tag

# Return to present
git checkout claude/access-data-bnkZr    # Back to current branch

# Stash (temporary save)
git stash                                # Save uncommitted changes
git stash pop                            # Restore stashed changes

# Nuclear option (DANGEROUS)
git reset --hard HEAD                    # Delete ALL uncommitted changes
```

---

**Remember:**
- Git never truly deletes anything (reflog keeps history)
- Tags are your checkpoints (phase-1-complete, etc.)
- Document recovery attempts (helps senior engineer help you)
- When in doubt, `git checkout <last-working-tag>`

---

**End of RECOVERY_GUIDE.md**
