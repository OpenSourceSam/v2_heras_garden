# GIT WORKFLOW & ROLLBACK GUIDE

**Version:** 1.0
**Purpose:** Version control strategy for Antigravity AI
**Audience:** Antigravity AI (autonomous agent)

---

## Git Strategy

### Branching Model

**Current Branch:** `claude/access-data-bnkZr`
**Main Branch:** `main` (protected - do not push directly)

**Rules:**
1. Work on feature branch (current branch)
2. Commit after EACH task completion
3. Push to remote after EACH commit
4. NEVER force push (`git push --force` is FORBIDDEN)
5. NEVER amend commits that have been pushed

---

## Commit Workflow

### After Completing Each Task:

```bash
# 1. Check what changed
git status

# 2. Review changes
git diff

# 3. Stage files
git add <files>

# 4. Commit with format: "type: description"
git commit -m "feat: add farm plot tilling logic"

# 5. Push immediately
git push -u origin claude/access-data-bnkZr
```

### Commit Message Format:

```
type: brief description (50 chars max)

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- refactor: Code restructuring
- test: Testing additions
- chore: Maintenance tasks
```

**Examples:**
- ✅ `feat: implement crop growth state machine`
- ✅ `fix: correct inventory item duplication bug`
- ✅ `docs: update PROGRESS.md for Task 1.2.1`
- ❌ `updated stuff` (too vague)
- ❌ `feat: add tilling and planting and harvesting and UI` (too broad - should be 3 commits)

---

## Checkpointing (Tagging)

### Mark "Known Good States"

After completing each PHASE (not each task), create a tag:

```bash
# Complete Phase 1, all tests pass
git tag -a phase-1-complete -m "Phase 1: Core Systems Complete"
git push origin phase-1-complete
```

**When to Tag:**
- Phase 0 complete (foundation) → `phase-0-complete`
- Phase 1 complete (core systems) → `phase-1-complete`
- Phase 2 complete (story) → `phase-2-complete`
- Phase 3 complete (polish) → `phase-3-complete`

**List all tags:**
```bash
git tag -l
```

---

## Rollback Procedures

### Scenario 1: "I just committed something broken"

**If you haven't pushed yet:**
```bash
# Undo the commit, keep changes
git reset --soft HEAD~1

# Fix the code, then commit again
git add <files>
git commit -m "fix: corrected broken implementation"
```

**If you already pushed:**
```bash
# Create a revert commit (safe, preserves history)
git revert HEAD
git push
```

---

### Scenario 2: "I need to undo a specific commit"

```bash
# Find the commit hash
git log --oneline

# Example output:
# a1b2c3d feat: add broken feature
# e4f5g6h feat: add working feature
# i7j8k9l docs: update README

# Revert the specific commit
git revert a1b2c3d
git push
```

---

### Scenario 3: "I need to go back to last working state"

**Option A: Return to a tagged checkpoint**
```bash
# See available tags
git tag -l

# Create a new branch from the tag
git checkout -b recovery-branch phase-1-complete

# Test if this state works
# If yes, merge back or continue from here
```

**Option B: Find last working commit**
```bash
# See recent commits
git log --oneline -10

# Check out a specific commit (read-only)
git checkout e4f5g6h

# Test if this works
# If yes, create branch from here:
git checkout -b recovery-branch
```

---

### Scenario 4: "I accidentally changed a file I shouldn't have"

**Before committing:**
```bash
# Discard changes to specific file
git restore <file>

# Discard ALL uncommitted changes (dangerous!)
git restore .
```

**After committing:**
```bash
# Restore specific file from previous commit
git checkout HEAD~1 -- <file>
git add <file>
git commit -m "fix: restore accidentally modified file"
```

---

## Emergency Recovery

### "Everything is broken, I don't know what I did"

```bash
# Step 1: See what changed
git status
git diff

# Step 2: See recent commits
git log --oneline -5

# Step 3: Decide recovery strategy

# Option A: Undo all uncommitted changes
git restore .

# Option B: Return to last tag
git checkout phase-1-complete

# Option C: Ask senior engineer (create reports/recovery_log.md)
echo "# Recovery Log" > reports/recovery_log.md
echo "What I was trying to do: ..." >> reports/recovery_log.md
echo "What broke: ..." >> reports/recovery_log.md
echo "What I've tried: ..." >> reports/recovery_log.md
```

---

## Best Practices

### ✅ DO:
- Commit after each task (atomic commits)
- Write clear commit messages
- Push immediately after committing
- Tag after each phase completion
- Use `git revert` for undoing pushed commits
- Document recovery attempts in `reports/recovery_log.md`

### ❌ DON'T:
- Force push (`git push --force`)
- Amend pushed commits (`git commit --amend` after push)
- Work directly on `main` branch
- Commit broken/untested code
- Batch multiple tasks into one commit
- Delete commits (use revert instead)

---

## Quick Reference

```bash
# Status check
git status                    # See what changed
git log --oneline -5          # See recent commits
git diff                      # See uncommitted changes

# Commit workflow
git add <files>               # Stage files
git commit -m "type: desc"    # Commit
git push                      # Push to remote

# Tagging
git tag -a phase-1-complete -m "Phase 1 done"
git push origin phase-1-complete

# Rollback
git revert <commit-hash>      # Undo specific commit
git restore <file>            # Discard uncommitted changes
git checkout <tag>            # Return to checkpoint

# Recovery
git reflog                    # See ALL actions (last resort)
```

---

**End of GIT_WORKFLOW.md**
