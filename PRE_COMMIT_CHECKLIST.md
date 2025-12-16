# PRE-COMMIT CHECKLIST

**Purpose:** Validation steps before every `git commit`
**Audience:** Antigravity AI (autonomous agent)
**Rule:** Complete ALL items before committing code

---

## ✅ BEFORE YOU COMMIT - CHECK ALL:

### 1. Search First (Prevent Duplicates)
```bash
[ ] Searched for existing implementation
    Command: grep -r "class_name" src/
    Command: grep -r "function_name" src/

[ ] Verified no duplicate autoload/system exists
[ ] Used existing stubs/templates from scaffolding
```

---

### 2. Property Name Compliance (SCHEMA.md)
```bash
[ ] All @export var names match SCHEMA.md exactly
    ✅ growth_stages (NOT "sprites")
    ✅ days_to_mature (NOT "growth_time")
    ✅ ingredients (NOT "items", "materials")
    ✅ crafting_time (NOT "time", "duration")
    ✅ objectives (NOT "tasks", "goals")

[ ] Ran validation script:
    ./scripts/validate_schema.sh
    Result: PASS ✅
```

---

### 3. Constants Usage (No Magic Numbers)
```bash
[ ] Used Constants.TILE_SIZE (NOT hardcoded 32, 16, 64)
[ ] Used Constants.PLAYER_SPEED (NOT hardcoded 100.0)
[ ] Used Constants.SCENE_* (NOT "res://scenes/...")
[ ] Used Constants.COLOR_* for UI colors
[ ] No hardcoded numbers in code (except 0, 1, -1)
```

---

### 4. Testing & Validation
```bash
[ ] Ran health check:
    ./scripts/health_check.sh
    Result: PASS ✅

[ ] Tested change with Debug HUD visible (F3)
    - Launched game without errors
    - Verified behavior works as expected
    - Checked Debug HUD shows correct state

[ ] If Phase 1: Tested day advancement (F4)
    - Crops advance growth stage
    - Season changes after day 28
    - Gold/inventory updates correctly
```

---

### 5. Code Quality
```bash
[ ] Followed DEVELOPMENT_ROADMAP.md template exactly
[ ] Added type hints to all functions
    func example(param: String) -> void:

[ ] Used @onready for node references
    @onready var label: Label = $Label

[ ] Added section comments (# ============)
[ ] No commented-out code (delete, don't comment)
[ ] No print() statements (use push_warning() for debug)
```

---

### 6. TODO Management
```bash
[ ] Marked completed TODOs as done (or deleted)
    # TODO (Phase 1): Implement X  → DELETE after implementing

[ ] Added new TODOs if creating stubs
    # TODO (Phase 2): Implement dialogue system

[ ] Updated TODO count in commit message if changed
```

---

### 7. Documentation Updates
```bash
[ ] Updated PROGRESS.md with task status
    Changed: ⬜ NOT_STARTED → ✅ DONE
    Added: Commit hash

[ ] If created new resource: Updated SCHEMA.md (if needed)
[ ] If found bug: Documented in reports/bug_log.md
```

---

### 8. Git Commit Format
```bash
[ ] Commit message follows format:
    type: brief description (50 chars max)

[ ] Type is correct:
    feat    - New feature
    fix     - Bug fix
    docs    - Documentation
    refactor - Code restructure
    test    - Testing
    chore   - Maintenance

[ ] Example:
    ✅ git commit -m "feat: implement farm plot tilling logic"
    ❌ git commit -m "updated code"
```

---

### 9. Files Staged Correctly
```bash
[ ] Checked git status
    git status

[ ] Only staging files related to current task
    ✅ src/entities/farm_plot.gd
    ❌ src/ui/random_unrelated_file.gd

[ ] No accidental files staged
    ❌ .env, credentials.json, .DS_Store
```

---

### 10. Push Readiness
```bash
[ ] Code compiles without errors
[ ] No merge conflicts
[ ] Branch is up to date with remote
    git pull origin claude/access-data-bnkZr
```

---

## Final Check

**Before running `git commit`:**

```bash
# Run both validation scripts
./scripts/validate_schema.sh && ./scripts/health_check.sh

# If both PASS ✅, proceed:
git add <files>
git commit -m "type: description"
git push -u origin claude/access-data-bnkZr

# Update PROGRESS.md
# Mark task as ✅ DONE
```

---

## If Any Item Fails

**STOP. DO NOT COMMIT.**

1. Fix the failing item
2. Re-run validation scripts
3. Re-check this checklist
4. Only commit when ALL items pass

---

**Remember:** One bad commit can break 10 future tasks.
**Take 2 minutes to validate now, save 2 hours debugging later.**

---

**End of PRE_COMMIT_CHECKLIST.md**
