# GIT PUSH FAILURE - RECOVERY INSTRUCTIONS
**For:** Antigravity AI (experiencing push failure)
**Issue:** Large file in git history blocking push, unauthorized filter-branch executed

---

## IMMEDIATE ACTIONS (Do These First)

### 1. Add Godot to .gitignore
```bash
# Prevent future tracking of large executable
echo "Godot_v4.5.1-stable_win64.exe/" >> .gitignore
echo "*.exe" >> .gitignore
git add .gitignore
git commit -m "chore: exclude Godot executable from git tracking"
```

### 2. Check Current State
```bash
# What branch are you on?
git branch

# Is BUG_REPORT.md committed locally?
git log --oneline -5 | grep -i bug

# If you see BUG_REPORT commit: Good, proceed to Step 3
# If you DON'T see it: It's uncommitted, add it first:
git add reports/BUG_REPORT.md
git commit -m "docs: add bug report for TileMapLayer visual regression"
```

---

## DECISION: Choose Recovery Path

### **PATH A: Use Cleaned History (Recommended)**
**Use this if:** filter-branch completed successfully

```bash
# 1. Verify large file is gone from history
git log --all --pretty=format: --name-only --diff-filter=A | \
  sort -u | grep -i "godot.*exe"

# If output is EMPTY: File successfully removed from history
# If output shows file: Filter-branch didn't work, use PATH B instead

# 2. Force push to new branch (safer than overwriting existing)
git checkout -b claude/phase1-clean
git push -u origin claude/phase1-clean

# 3. Notify PM: "Pushed to claude/phase1-clean with cleaned history"
```

**Result:** BUG_REPORT.md pushed, clean history, no large files

---

### **PATH B: Undo Filter-Branch (If A Fails)**
**Use this if:** You want to revert the history rewrite

```bash
# 1. Find original commit (before filter-branch)
git reflog | head -20

# Look for line BEFORE filter-branch, example:
# abc123 HEAD@{5}: commit: docs: add bug report
# def456 HEAD@{6}: filter-branch: rewrite  ← BEFORE this

# 2. Reset to original state
git reset --hard HEAD@{6}  # Use the number BEFORE filter-branch

# 3. Remove large file from tracking (keeps local copy)
git rm --cached -r Godot_v4.5.1-stable_win64.exe/
git commit -m "chore: remove Godot executable from git tracking"

# 4. Push to NEW branch (avoid conflicts)
git checkout -b claude/phase1-recovery
git push -u origin claude/phase1-recovery
```

**Result:** Original history restored, large file untracked, BUG_REPORT.md pushed

---

## PROTOCOL VIOLATION ACKNOWLEDGMENT

**What you did:** Executed `git filter-branch` (history rewrite)
**Protocol:** Should have asked PM/Senior before major git actions
**Why it's risky:** Can cause conflicts for anyone who cloned the branch

**Learning:**
- ✅ `git rm --cached` is SAFE (removes from tracking, keeps file)
- ❌ `git filter-branch` is MAJOR (requires PM approval)
- ✅ `git push --force` should NEVER be done without explicit permission

**Add to personal checklist:**
```
Before running git commands that:
- Rewrite history (filter-branch, rebase, reset --hard on pushed commits)
- Force push (--force, --force-with-lease)
- Delete remote branches

→ STOP and ask PM: "Is this authorized?"
```

---

## AFTER SUCCESSFUL PUSH

### 1. Verify
```bash
# Check GitHub shows your branch
git branch -r | grep phase1

# Check BUG_REPORT.md is there
# (View on GitHub web interface)
```

### 2. Document
```markdown
Add to reports/recovery_log.md:

## Git Push Failure - Resolved

**Date:** December 16, 2025
**Issue:** 156MB Godot executable in git history blocked push
**Unauthorized Action:** Ran git filter-branch without PM approval
**Recovery Path:** [A or B - which did you use?]
**Result:** Successfully pushed to branch: [branch name]

**Lesson Learned:**
- Always check .gitignore before committing large files
- Ask PM before git history rewrites
- Use `git rm --cached` not filter-branch for recent additions

**Prevention:**
- Updated .gitignore to exclude *.exe files
- Added git protocol check to personal checklist
```

### 3. Continue Work
```bash
# Update PROGRESS.md
# Mark any completed tasks from bug report
# Continue with next Phase 1 task
```

---

## QUICK REFERENCE

**Safe Git Commands (No PM Approval Needed):**
- `git add`, `git commit`, `git push` (to new branches)
- `git status`, `git log`, `git diff`
- `git rm --cached` (removes from tracking only)
- `git checkout -b` (new branch)

**Requires PM Approval:**
- `git filter-branch`, `git rebase` (on pushed commits)
- `git push --force`, `git push -f`
- `git reset --hard` (on pushed commits)
- `git branch -D` (deleting remote branches)

**When in doubt:** Ask first, act second.

---

**End of GIT_PUSH_RECOVERY.md**
