# GEMINI REVIEW PROTOCOL
**For Junior Project Manager (Gemini - Web-Based)**

**Purpose:** Guide Antigravity AI when stuck, looping, or encountering errors
**Your Role:** Code reviewer, debugger, root cause analyst
**Your Limitation:** Web-based (can't run code), must guide Antigravity to test

---

## When to Use This Protocol

Use this when Antigravity:
- ✅ Is looping (trying same fix 3+ times)
- ✅ Reports bugs but can't fix them
- ✅ Breaks previously working code
- ✅ Asks for help after 2 failed fix attempts
- ✅ Creates duplicate systems instead of using existing ones

---

## Step 1: GATHER EVIDENCE

**Ask Antigravity to provide:**

### 1A. Git History
```bash
# What changed recently?
git log --oneline -10
git diff HEAD~3  # Last 3 commits worth of changes
```

### 1B. Current State
```bash
# What's uncommitted?
git status
git diff

# Are systems healthy?
./scripts/health_check.sh
./scripts/validate_schema.sh
```

### 1C. Error Details
**Template for Antigravity:**
```markdown
## Bug Report

**What's Broken:**
- Feature: [e.g., "Dialogue system"]
- Symptom: [e.g., "Game crashes when pressing E"]
- Error message: [paste FULL error from console]

**When It Broke:**
- Last working commit: [hash]
- Breaking commit: [hash]
- What changed: [files modified]

**Attempted Fixes (with commit hashes):**
1. [Commit abc123] Tried: [what] → Result: [still broken]
2. [Commit def456] Tried: [what] → Result: [still broken]
```

### 1D. What Was Working Before
```bash
# Check PROGRESS.md
cat PROGRESS.md | grep "✅ DONE"

# Check recent commits that worked
git log --oneline --grep="feat:"
```

---

## Step 2: ANALYZE ROOT CAUSE

### Question Framework

**Q1: Is this a loop?**
- Check git log: Same file modified 3+ times in short period?
- Same error message across multiple commits?
- **If YES:** STOP fixes immediately → Go to Step 3 (Rollback)

**Q2: What type of error?**
- **Syntax Error:** Missing semicolon, typo, wrong type
  → Quick fix, guide Antigravity to correct line

- **Logic Error:** Wrong algorithm, incorrect state management
  → Requires understanding, check against DEVELOPMENT_ROADMAP.md template

- **Integration Error:** Systems not talking to each other
  → Check signal connections, autoload references, node paths

- **Property Name Error:** Using wrong property names
  → Check against SCHEMA.md, run validate_schema.sh

**Q3: Is code following templates?**
```markdown
Compare Antigravity's code to DEVELOPMENT_ROADMAP.md:
- Are property names EXACT matches to SCHEMA.md?
- Are section comments present (# ============)?
- Are @onready references used correctly?
- Are type hints present (param: String, -> void)?
```

**Q4: Did validation scripts pass?**
```bash
# If Antigravity didn't run these, they MUST run them now
./scripts/health_check.sh     # All files exist?
./scripts/validate_schema.sh  # Property names correct?
```

---

## Step 3: DECIDE STRATEGY

### Decision Tree

```
Is Antigravity looping (3+ failed fixes)?
├─ YES → Go to 3A (Emergency Rollback)
└─ NO
   ├─ Is error simple (typo, missing line)?
   │  └─ YES → Go to 3B (Direct Fix Guidance)
   └─ NO
      ├─ Is code diverging from template?
      │  └─ YES → Go to 3C (Template Adherence)
      └─ NO
         ├─ Is it an integration issue?
         │  └─ YES → Go to 3D (Integration Debugging)
         └─ NO → Go to 3E (Systematic Debug)
```

---

### 3A. Emergency Rollback (Loop Detected)

**Instructions for Antigravity:**

```markdown
STOP all fix attempts. You are looping.

1. Find last working commit:
   git log --oneline -20
   # Look for commit BEFORE the problem started

2. Test that commit:
   git checkout <hash>
   # Launch game, test if it works

3. If it works, create recovery branch:
   git checkout -b recovery-from-<hash>
   git push -u origin recovery-from-<hash>

4. Document what you learned:
   Create reports/loop_analysis.md:
   - What you were trying to do
   - Why it failed
   - Root cause (if known)
   - What to try differently

5. WAIT for senior engineer review
```

---

### 3B. Direct Fix Guidance (Simple Error)

**Template:**
```markdown
File: [exact path]
Line: [line number]
Error: [what's wrong]
Fix: [exact code change]

Example:
File: src/entities/player.gd
Line: 45
Error: Missing type hint on velocity parameter
Fix: Change `func set_velocity(v):` to `func set_velocity(v: Vector2) -> void:`
```

**After fix, Antigravity must:**
1. Test the change
2. Run validation scripts
3. Commit with: `fix: [description of what was fixed]`

---

### 3C. Template Adherence (Code Diverged)

**Compare side-by-side:**

**DEVELOPMENT_ROADMAP.md Template:**
```gdscript
@export var growth_stages: Array[Texture2D] = []
@export var days_to_mature: int = 7
```

**Antigravity's Code:**
```gdscript
@export var sprites: Array[Texture2D] = []  # ❌ WRONG
@export var growth_time: int = 7             # ❌ WRONG
```

**Guidance:**
```markdown
Your code doesn't match SCHEMA.md property names.

SCHEMA.md says:
- ✅ growth_stages (NOT "sprites")
- ✅ days_to_mature (NOT "growth_time")

Fix:
1. Open SCHEMA.md
2. Find the CropData section
3. Copy property names EXACTLY
4. Replace your property names with correct ones
5. Run ./scripts/validate_schema.sh
6. Must see: ✅ PASS

If validation fails, read the error message carefully.
```

---

### 3D. Integration Debugging (Systems Not Connecting)

**Common Integration Issues:**

**Issue 1: Autoload not found**
```gdscript
# Error: "GameState is not declared"
# Check: Is it registered in project.godot?
grep "GameState" project.godot
# Should see: autoload/GameState="*res://src/autoloads/game_state.gd"
```

**Issue 2: Signal not connected**
```gdscript
# Code tries: GameState.day_advanced.connect(_on_day_advanced)
# Error: Signal doesn't exist
# Check: Does game_state.gd have: signal day_advanced ?
grep "signal day_advanced" src/autoloads/game_state.gd
```

**Issue 3: Node path wrong**
```gdscript
# Error: "Node not found: $Panel/Label"
# Check: Open .tscn file in text editor
grep "Panel" scenes/ui/debug_hud.tscn
# Verify node hierarchy matches code
```

**Guidance Template:**
```markdown
Integration issue detected.

System A: [e.g., "Player controller"]
System B: [e.g., "GameState autoload"]
Expected: [e.g., "Player should emit interact signal"]
Actual: [e.g., "Signal not being received"]

Check:
1. Does System A emit the signal? (grep "signal" or ".emit()")
2. Does System B connect to it? (grep ".connect")
3. Are node paths correct? (check .tscn file)
4. Is autoload registered? (check project.godot)

Debug steps:
1. Add print() to System A: print("Emitting signal")
2. Add print() to System B: print("Signal received")
3. Test and check console output
4. Report which print() you see
```

---

### 3E. Systematic Debug (Complex Issue)

**Follow ANTIGRAVITY_FEEDBACK.md 7-Phase Debugging:**

**Guide Antigravity through:**

```markdown
Phase 1: STOP and DOCUMENT
- What were you trying to implement?
- What broke?
- Exact error message?

Phase 2: GATHER INFORMATION
- Run health_check.sh
- Run validate_schema.sh
- Check git diff
- Check recent commits

Phase 3: FORM HYPOTHESES
List 3 possible root causes:
1. [Hypothesis 1]
2. [Hypothesis 2]
3. [Hypothesis 3]

Phase 4: TEST HYPOTHESES
For each hypothesis:
- How to test it? (add print(), check file, etc.)
- What's the expected result?
- What's the actual result?

Phase 5: IDENTIFY ROOT CAUSE
Based on tests, which hypothesis is correct?

Phase 6: PLAN MINIMAL FIX
- What's the smallest change to fix it?
- Which file(s) to modify?
- Exact lines to change?

Phase 7: IMPLEMENT & VALIDATE
- Make the change
- Test it
- Run validation scripts
- Commit if working
```

---

## Step 4: COMMUNICATE FIX TO ANTIGRAVITY

### Effective Communication Format

**❌ BAD (Vague):**
```
"Fix the dialogue system. It's broken."
```

**✅ GOOD (Specific):**
```markdown
## Fix Required: Dialogue Box Not Showing

**File:** src/ui/dialogue_box.gd
**Line:** 44
**Issue:** hide() is called in _ready(), but show_dialogue() never calls show()

**Root Cause:**
The dialogue box is hidden on startup (line 44) but show_dialogue()
function (line 50-56) doesn't call self.show() to make it visible.

**Fix:**
In show_dialogue() function, add after line 55:
```gdscript
func show_dialogue(dialogue: DialogueData) -> void:
    current_dialogue = dialogue
    current_line_index = 0
    _show_line(dialogue.lines[0])
    self.show()  # ← ADD THIS LINE
```

**Testing:**
1. Save the file
2. Launch game
3. Interact with NPC (E key)
4. Verify: Dialogue box appears with text

**Validation:**
Run: ./scripts/health_check.sh (should still PASS)

**Commit:**
git add src/ui/dialogue_box.gd
git commit -m "fix: dialogue box now appears when show_dialogue() is called"
git push
```

---

## Step 5: VERIFY FIX

**Checklist for Antigravity:**

```markdown
After implementing fix:

[ ] Code compiles (no syntax errors)
[ ] Game launches without errors
[ ] Feature works as expected (test manually)
[ ] ./scripts/health_check.sh → PASS
[ ] ./scripts/validate_schema.sh → PASS
[ ] No new errors in console
[ ] Other features still work (regression test)
[ ] Committed with clear message
[ ] Pushed to remote

If ALL checked: Update PROGRESS.md, move to next task
If ANY fail: Report which step failed, what error
```

---

## Step 6: PREVENT RECURRENCE

**Root Cause Analysis:**

After successful fix, guide Antigravity to document:

```markdown
## Post-Fix Analysis

**What Went Wrong:**
[e.g., "Forgot to call self.show() in show_dialogue()"]

**Why It Happened:**
[e.g., "Template didn't explicitly mention show/hide, assumed automatic"]

**How to Prevent:**
[e.g., "Check if UI elements need manual show() call after hide()"]

**Updated Procedure:**
[e.g., "Add to PRE_COMMIT_CHECKLIST: Test UI visibility before commit"]
```

---

## Common Antigravity Mistakes & Fixes

### Mistake 1: Property Name Hallucination
**Symptom:** Uses `growth_time` instead of `days_to_mature`
**Detection:** `./scripts/validate_schema.sh` fails
**Fix:** Direct to SCHEMA.md, copy exact names

### Mistake 2: Skipping Validation Scripts
**Symptom:** Commits broken code without testing
**Detection:** Ask "Did you run validation scripts?"
**Fix:** Make Antigravity run them before every commit

### Mistake 3: Not Following Template
**Symptom:** Code structure different from DEVELOPMENT_ROADMAP.md
**Detection:** Compare side-by-side
**Fix:** Show template, ask to rewrite to match exactly

### Mistake 4: Testing Without Debug Tools
**Symptom:** Can't see what's happening in game state
**Detection:** Ask "Is Debug HUD visible?"
**Fix:** Guide to press F3, use Debug HUD to inspect state

### Mistake 5: Committing Without Testing
**Symptom:** "It should work" commits that don't
**Detection:** Check commit message vs actual testing
**Fix:** Enforce PRE_COMMIT_CHECKLIST.md before every commit

---

## Communication Templates

### Template: Request Evidence
```markdown
I need more information to help you debug this.

Please provide:
1. Last 10 commits: `git log --oneline -10`
2. Current changes: `git status && git diff`
3. Validation results: `./scripts/health_check.sh && ./scripts/validate_schema.sh`
4. Full error message from console (copy-paste entire error)
5. Which task from PROGRESS.md you're working on

Send all output as code blocks.
```

### Template: Loop Detection
```markdown
⚠️ LOOP DETECTED - STOP FIXES

You've modified [file.gd] 3 times in the last hour with same error.

This means your fix strategy isn't working.

STOP attempting fixes.
ROLLBACK to last working state:
1. `git checkout <hash-before-problem>`
2. Create recovery branch
3. Document what you tried in reports/loop_analysis.md
4. WAIT for senior engineer guidance

Do not attempt more fixes until root cause is understood.
```

### Template: Successful Fix Verification
```markdown
✅ Fix looks correct!

Before committing:
1. Test it manually (launch game, verify feature works)
2. Run `./scripts/health_check.sh` → must PASS
3. Run `./scripts/validate_schema.sh` → must PASS
4. Check console for errors
5. Test one other feature (regression test)

If all PASS:
git add [files]
git commit -m "fix: [clear description]"
git push

Then update PROGRESS.md with status.
```

---

## Advanced: Teaching Antigravity

When same mistake happens 2+ times:

### Create Custom Validation Rule

**Example:**
Antigravity keeps forgetting to call `self.show()` on UI elements.

**Add to validate_schema.sh:**
```bash
# Check for hide() without corresponding show()
HIDE_WITHOUT_SHOW=$(grep -l "hide()" src/ui/*.gd | xargs grep -L "show()")
if [ -n "$HIDE_WITHOUT_SHOW" ]; then
    echo "⚠️  WARNING: UI file has hide() but no show():"
    echo "$HIDE_WITHOUT_SHOW"
fi
```

### Update Documentation

**Add to PRE_COMMIT_CHECKLIST.md:**
```markdown
[ ] If UI element has hide() in _ready(), verify show() is called somewhere
```

---

## Red Flags (When to Escalate to Senior Engineer)

🚩 Antigravity is looping (3+ failed fixes)
🚩 Previously working code now broken, can't identify when
🚩 Validation scripts pass but game still broken
🚩 Multiple systems broken at once
🚩 Antigravity wants to rewrite large sections of scaffolding
🚩 Git history shows force pushes or deleted commits
🚩 Error messages don't match any known patterns

**In these cases:**
1. STOP all development
2. Create detailed recovery report
3. Tag current state: `git tag needs-senior-review`
4. Return to last known good checkpoint
5. Wait for senior engineer

---

**End of GEMINI_REVIEW_PROTOCOL.md**
