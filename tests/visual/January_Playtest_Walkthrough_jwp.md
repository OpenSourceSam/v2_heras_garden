# January Playtest Walkthrough - First 3 Quests (Draft)

**Date Started:** 2026-01-02
**Purpose:** Draft and iterate comprehensive playtesting methodology
**Scope:** First 3 quests ONLY (1, 3, 4) - perfecting the process
**Status:** 🚧 DRAFT - Testing and iteration phase
**Next Step:** Once process is perfected, expand to remaining quests (5-11)

---

## Overview

This document establishes a **human-like playtesting workflow** that will catch UX issues that logic tests miss.

**The Goal:**
- Playtest each quest in isolation
- Identify and fix UX/playability issues
- Perfect the testing process with first 3 quests
- Document what works and what's clunky
- Build repeatable methodology
- Then expand to remaining quests

**The Challenge:**
- Game logic is solid (118/118 tests pass)
- But human playability is incomplete
- UX is broken in places (UI timing, visual feedback, clarity)
- Need systematic approach to find and fix these issues

**The Approach:**
1. Use **Godot Tools VS Code debugger** (F5, breakpoints, variable inspection)
2. Run **headed visual tests** (actual rendering, see what players see)
3. Manually **playthrough each quest** (human-like interaction)
4. Document **what breaks and why**
5. Fix bugs iteratively
6. Refine process after each quest
7. Once perfect, expand to all quests

---

## Testing Tools & Setup

### Primary Tool: Godot Tools Debugger

**Quick Start:**
```
1. Open quest test file in VS Code
2. Set breakpoints (click left gutter)
3. Press F5 to debug
4. Step through with F10/F11
5. Inspect variables in Watch panel
6. Fix bugs in real-time
```

**Why This Over CLI?**
- See actual game state (variable inspection)
- Pause execution at any point
- Step through quest logic line-by-line
- Edit values during debugging to test edge cases
- Watch scene tree during gameplay
- See errors as they happen

### Secondary Tool: Headed Beta Mechanical Test

**Command:**
```powershell
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --path . --script tests/visual/beta_mechanical_test.gd --quit-after 900
```

**Why:**
- Validates entire quest flow runs
- Captures screenshots for UX review
- Tests human-like timing and input
- Provides regression baseline

### Manual Playthrough

**How:**
1. Open game in Godot editor
2. Play through quest manually
3. Note every UI issue, timing problem, unclear feedback
4. Document what feels wrong

---

## Testing Methodology Cardinal Rules

**Context:** Game logic tests pass (118/118) but human playability has UX issues. We need human-like validation.

### Strongly Recommended Approach

**For UX/Playability Validation:**
- **Preferred:** Headed visual testing with programmatic debugging
- **Tools:** Godot Tools VS Code debugger, remote debug protocol, enhanced test scripts
- **Capabilities:** Visual rendering, variable inspection, breakpoint debugging, screenshot capture
- **Purpose:** Catch UI visibility issues, timing problems, visual feedback gaps

**Why This Approach:**
- Agents can see what renders on screen
- Can inspect game state at any moment
- Can validate UI elements are actually visible
- Can capture screenshots programmatically
- Simulates human visual experience

### When Headless Testing is Appropriate

**For Logic Validation Only:**
- Quest flag progression (quest_1_complete → quest_3_active)
- Inventory state changes
- Save/load data integrity
- Crafting recipe logic
- Day advancement mechanics
- Fast regression testing

**Why Headless Works Here:**
- No visual output needed
- State validation only
- Fast execution
- CI/CD friendly

### Critical Distinction

**Avoid falling back to headless CLI log parsing when the goal is UX validation.**

Headless log parsing can tell you IF something broke, but not WHY the human experience is broken. When testing human playability:

❌ **Don't:** Run headless test → parse logs → guess at UX issues
✅ **Do:** Run headed test → inspect visual state → document UX issues

**The Gap:**
- Headless logging: "Dialogue box timeout error"
- Headed inspection: "Dialogue box has visible=false when it should be true on line 42"

### Programmatic Debugging for Autonomous Testing

**Agents can use debugging capabilities autonomously:**

1. **Launch with remote debug:**
   ```powershell
   Godot*.exe --path . --remote-debug tcp://127.0.0.1:6007 --script tests/visual/beta_mechanical_test.gd
   ```

2. **Enhanced test scripts:**
   - Modify test scripts to capture full state at each step
   - Print game variables, UI visibility flags, node properties
   - Take programmatic screenshots (headed mode supports this)
   - Report findings in structured format

3. **State inspection without human interaction:**
   - Test script can check `dialogue_box.visible`
   - Test script can verify `minigame_node != null`
   - Test script can capture and analyze screenshots
   - All without human clicking F5

**The Key Insight:**
Human-like testing can be done autonomously. The limitation is NOT that agents need humans to press F5. The limitation is that headless mode CAN'T capture visual state. Use headed mode programmatically.

### Summary

- **Goal:** Human-like playability validation
- **Preferred Tool:** Headed testing with programmatic state inspection
- **When to use headless:** Logic validation only (not UX validation)
- **Why it matters:** Can't fix what you can't see

This approach enables agents to autonomously validate the human experience without falling back to inferior headless log parsing.

---

## Automated Test Results (2025-12-29)

**Baseline unit checks (headless)**
- Command:
  ```powershell
  .\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd
  ```
- Result: Exit 0; no stdout.

**Smoke scene wiring (headless)**
- Command:
  ```powershell
  .\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30
  ```
- Result: Exit 0; Godot version banner only.

**Phase 3 scene-load smoke (headless)**
- Command:
  ```powershell
  .\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd
  ```
- Result: Exit 0; Godot version banner only.

**Headed beta mechanical test (scripted, non-interactive)**
- Command:
  ```powershell
  .\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --path . --script tests/visual/beta_mechanical_test.gd --quit-after 30
  ```
- Result: Exit 0; Godot version banner only.
- Note: This run did not include manual UX validation.

---

## Quest 1: Herb Identification (Hermes)

### 1.1 Pre-conditions

**Starting State:**
- Game boot (Title → New Game)
- Player spawns in world
- Prologue complete flag set
- Inventory: 3× wheat_seed, 100g gold

**Verify Before Testing:**
```gdscript
# Check these in debugger before starting quest
assert(GameState.prologue_complete == true)
assert(GameState.get_item_count("wheat_seed") == 3)
assert(GameState.gold == 100)
assert(GameState.quest_1_active == true or GameState.quest_1_complete == false)
```

### 1.2 Test Steps (Human-Like Interaction)

**Step 1: Spawn and Navigation**
- Player spawns in world
- Expected: Player visible at spawn point
- Issue Check: Does player render? Can you see them?
- Timing: Should be instant

**Step 2: Navigate to Hermes**
- Player moves to Hermes location
- Expected: Can move smoothly with D-pad
- Issue Check: Movement responsive? No lag?
- Visual Check: World renders correctly?

**Step 3: Interact with Hermes**
- Press A button on Hermes NPC
- Expected: Dialogue box appears
- Issue Check: Does dialogue appear immediately? Text readable?
- Timing Check: Any delay in dialogue opening?
- Visual Check: Dialogue box positioned correctly?

**Step 4: Read Dialogue**
- Dialogue explains Quest 1 (Herb Identification)
- Expected: Text clear and readable
- Issue Check: Text too small? Colors unclear?
- Timing Check: Text scrolling speed appropriate?

**Step 5: Accept Quest**
- Press A to confirm quest acceptance
- Expected: quest_1_active flag set
- Dialogue closes, player returns to world
- Issue Check: Smooth transition back to world?
- Visual Check: Any lingering UI elements?

**Step 6: Trigger Minigame**
- Player re-interacts with Hermes or goes to minigame location
- Expected: Herb ID minigame starts
- Issue Check: Does minigame UI load? Is it visible?
- Visual Check: Minigame instructions clear?

**Step 7: Play Minigame**
- 3 rounds of herb identification
- Expected: Player can identify golden pharmaka among gray plants
- Issue Check: Can you see the plants? Are colors distinct?
- Timing Check: Does minigame feel rushed?
- Feedback Check: Do you know when you're right/wrong?

**Step 8: Minigame Success**
- Complete all 3 rounds successfully
- Expected: Minigame closes
- Reward: 3× pharmaka_flower added to inventory
- Verification Check: `assert(GameState.get_item_count("pharmaka_flower") == 3)`
- Issue Check: Does completion feedback appear? Is it clear?

**Step 9: Quest Completion**
- quest_1_complete flag set
- Player returns to world
- Issue Check: Any visual feedback that quest is complete?
- Expected: quest_1_active becomes false

**Step 10: Inventory Check**
- Open inventory
- Expected: 3× pharmaka_flower visible
- Issue Check: Item icons clear? Counts correct?
- Visual Check: Inventory UI responsive?

### 1.3 Expected Outcomes

✅ **Success Criteria:**
- quest_1_active: false
- quest_1_complete: true
- Inventory contains 3× pharmaka_flower
- Player is back in world
- No crashes or soft-locks

❌ **Failure Signs:**
- Dialogue doesn't appear
- Minigame UI is invisible or unreadable
- Plants are indistinguishable
- Input doesn't register
- Inventory doesn't update
- Player gets stuck

### 1.4 Known Issues (To Investigate)

**Issue #1: Dialogue Display Timing**
- Status: Unknown
- Symptom: Dialogue might appear slowly
- Debug: Set breakpoint in dialogue_box.gd, check `visible` flag timing
- Expected Fix: Check animation timing, ensure instant display

**Issue #2: Minigame Visibility**
- Status: Unknown
- Symptom: Herb ID minigame might not be visible
- Debug: In debugger, check if minigame node exists and `visible == true`
- Expected Fix: Ensure minigame loads before rendering

**Issue #3: Plant Visual Distinction**
- Status: Unknown
- Symptom: Plants might look too similar to distinguish
- Debug: Run minigame visually, check color contrast
- Expected Fix: Adjust plant colors or add visual distinction

### 1.5 Debugging Workflow

**When stuck on this quest:**

1. **Open the test file in VS Code:**
   ```
   tests/visual/beta_mechanical_test.gd (search for Quest 1 steps)
   ```

2. **Set breakpoint in relevant game code:**
   ```gdscript
   # Dialogue issues? Set breakpoint here:
   game/features/ui/dialogue_box.gd:30  # In _ready or _show methods

   # Minigame issues? Set breakpoint here:
   game/features/minigames/herb_identification.gd:1  # In _ready

   # Quest completion? Set breakpoint here:
   game/features/ui/dialogue_box.gd  # In _end_dialogue (flags_to_set)
   ```

3. **Run quest with debugger (F5)**

4. **Step through (F10) to see exact failure point**

5. **Inspect variables:**
   ```gdscript
   # In Watch panel, add these:
   GameState.quest_1_active
   GameState.quest_1_complete
   GameState.get_item_count("pharmaka_flower")
   # Check minigame nodes exist
   # Check visibility flags
   ```

6. **Fix the bug**

7. **Re-run to verify fix**

### 1.6 Process Notes (What's Working/Not Working)

**After completing Quest 1, document:**
- ✅ What went smoothly?
- ❌ What was clunky?
- 🤔 What was unclear?
- 💡 How to improve the process?

Example:
```
✅ Dialogue system worked well - no timing issues
❌ Minigame visibility was unclear until I set breakpoint
🤔 Inventory doesn't show quest reward notification
💡 Should add visual feedback "Quest Complete!" message
```

---

## Quest 3: Confront Scylla (Boat Travel & Transformation)

### 2.1 Pre-conditions

**Required Before This Quest:**
- quest_1_complete: true (completed above)
- quest_2_complete: true (required by quest3_start dialogue gating)
- Player in world

**Verify Before Testing:**
```gdscript
assert(GameState.quest_1_complete == true)
assert(GameState.quest_3_active == false)
# Quest 2 is deprecated in design, but quest3_start currently requires quest_2_complete.
```

### 2.2 Test Steps (Human-Like Interaction)

**Step 1: Trigger Quest 3 Activation**
- Navigate to NPC that offers Quest 3
- Expected: Quest 3 becomes active
- Issue Check: Does NPC appear? Can you interact?
- Visual Check: Quest marker visible?

**Step 2: Understand Quest Objective**
- Dialogue explains: Travel to Scylla's Cove and confront Scylla
- Expected: Clear instructions
- Issue Check: Dialogue readable?
- Visual Check: Map or waypoint guidance?

**Step 3: Navigate to Boat**
- Player moves to boat location
- Expected: Boat is at correct location
- Issue Check: Can you see boat? Is it interactive?

**Step 4: Interact with Boat**
- Press A on boat
- Expected: Boat checks `quest_3_active` flag
- Boat triggers scene transition
- Issue Check: Transition smooth? Any physics errors?
- Visual Check: Scene load animation?

**Step 5: Scene Transition to Scylla's Cove**
- Travel complete
- Expected: Player at Scylla's Cove
- Issue Check: New scene loads completely?
- Visual Check: Scylla visible? Environment rendered?
- Timing Check: Reasonable load time?

**Step 6: Encounter Scylla**
- Scylla NPC appears
- Expected: Scylla dialogue triggers
- Issue Check: Does Scylla dialog appear?
- Visual Check: Character sprite visible?

**Step 7: Dialogue Choices**
- 3 dialogue options (converge to same outcome)
- Expected: Player can select any option
- Issue Check: Dialogue choices visible? Selectable?
- Feedback Check: Does selection feel responsive?

**Step 8: Confrontation Cutscene**
- Non-interactive cutscene plays
- Scylla is transformed
- Expected: Cutscene plays smoothly
- Visual Check: Animation clear? Timing good?
- Issue Check: Can't skip accidentally? Completes properly?

**Step 9: Transformation Complete**
- transformed_scylla flag set
- quest_3_complete flag set
- Player still in Scylla's Cove
- Verification: `assert(GameState.transformed_scylla == true)`

**Step 10: Boat Return**
- Interact with boat again
- Expected: Boat checks `quest_3_complete`
- Returns player to world
- Issue Check: Return journey works? Physics clean?
- Visual Check: World scene loads properly?

### 2.3 Expected Outcomes

✅ **Success Criteria:**
- quest_3_complete: true
- transformed_scylla: true
- Player back in world
- No crashes, smooth scene transitions

❌ **Failure Signs:**
- Boat doesn't trigger scene change
- Scylla dialogue doesn't appear
- Transformation cutscene broken or invisible
- Scene transition causes physics errors
- Player stuck in Scylla's Cove

### 2.4 Known Issues (To Investigate)

**Issue #1: Scene Transition Physics Errors**
- Status: Known (146 errors logged)
- Symptom: Physics warnings during scene changes
- Root Cause: State changes during Godot physics flush
- Fix Needed: Use `call_deferred()` wrapper (documented in CLAUDE_REVIEW)
- Files: return_trigger.gd:8, scene_manager.gd:26

**Issue #2: Quest 2 Routing**
- Status: Known
- Symptom: Quest 2 might appear in NPC dialogue (but shouldn't)
- Fix Needed: Update npc_base.gd to skip quest_2_active
- Verify: After fix, Hermes should offer Quest 1 → Quest 3 only

**Issue #3: Cutscene Playability**
- Status: Unknown
- Symptom: Cutscene might not be fully implemented
- Debug: Check if cutscene scene exists and plays
- Expected: Smooth non-interactive transformation

### 2.5 Debugging Workflow

**Scene transition physics errors:**
```gdscript
# Set breakpoint before scene change:
game/features/locations/return_trigger.gd:8

# Watch for this error:
# "Physics operation requested without engine singleton"

# Solution: Use call_deferred() to defer physics changes
```

**Cutscene issues:**
```gdscript
# Set breakpoint when cutscene starts:
game/features/cutscenes/scylla_transformation.tscn  # or relevant file

# Check in debugger:
# - Is cutscene node loaded?
# - Is animation playing?
# - Are flags being set correctly?
```

### 2.6 Process Notes

**After completing Quest 3:**
```
✅ What worked?
❌ What was clunky?
🤔 What was unclear?
💡 Improvements?
```

---

## Quest 4: Build a Garden (Farming & Day Advancement)

### 3.1 Pre-conditions

**Required Before This Quest:**
- quest_3_complete: true
- Player in world

**Game State:**
```gdscript
assert(GameState.quest_3_complete == true)
assert(GameState.quest_4_active == false)
# Aeëtes should be spawned in world
```

### 3.2 Test Steps (Human-Like Interaction)

**Step 1: Meet Aeëtes**
- Navigate to Aeëtes location
- Expected: Aeëtes appears (only after quest_3_complete)
- Issue Check: NPC visible? Dialogue triggers?

**Step 2: Accept Quest**
- Interact with Aeëtes
- Dialogue explains: Build a garden by tilling, planting, and watering
- Expected: quest_4_active set
- Receive seeds: 3× moly_seed, 3× nightshade_seed, 3× golden_glow_seed
- Verification: Check inventory has seeds

**Step 3: Till Soil**
- Navigate to garden area
- Press A on grass tiles to till soil
- Expected: Soil tilling works
- Feedback Check: Visual feedback? Sound feedback?
- Issue Check: Can till all 9 plots?

**Step 4: Plant Seeds**
- Press A on tilled soil to open seed selector
- Expected: Seed selector UI appears
- Issue Check: Seeds displayed clearly? Can select with D-pad?
- Plant 3 moly, 3 nightshade, 3 golden_glow
- Timing Check: Planting feels smooth?

**Step 5: Water Crops**
- Press A on planted crops to water
- Expected: Water animation plays
- Feedback Check: Visual feedback clear?
- Water all 9 crops at least once
- Verification: Crops show watering state

**Step 6: First Day Advancement**
- Navigate to Sundial
- Press START button to advance time
- Expected: Day advances (Day 1 → Day 2)
- Feedback Check: Visual feedback that day changed?
- Issue Check: Smooth state transition?

**Step 7: Second Day Advancement**
- Press START again at Sundial
- Expected: Day 2 → Day 3
- Crops should be mature after this

**Step 8: Crop Maturity & Harvest**
- Return to garden
- Expected: Crops show maturity (visual change?)
- Press A on mature crops to harvest
- Expected: Items added to inventory (moly, nightshade, golden_glow)
- Verification: Inventory has 3 of each crop

**Step 9: Quest Completion**
- After harvesting all crops
- Expected: quest_4_complete flag set
- Aeëtes might offer follow-up dialogue or next quest
- Issue Check: Clear quest completion feedback?

**Step 10: Economy Check**
- Verify you can afford to plant again
- Starter gold: 100g
- Seed costs reasonable?
- Crop profits sufficient?

### 3.3 Expected Outcomes

✅ **Success Criteria:**
- quest_4_complete: true
- Inventory has: 3× moly, 3× nightshade, 3× golden_glow
- Day counter advanced to day 3+
- Garden fully playable

❌ **Failure Signs:**
- Tilling doesn't work
- Seed selector broken or unclear
- Crops don't grow
- Day advancement doesn't work
- Harvest doesn't add items
- Economy broken (can't afford seeds)

### 3.4 Known Issues (To Investigate)

**Issue #1: Day Advancement Timing**
- Status: Unknown
- Symptom: Crops might not grow correctly
- Debug: Check if crop.days_remaining decreases on day change
- Expected: 3 days to mature

**Issue #2: Harvest Feedback**
- Status: Unknown
- Symptom: Might not be clear when crops are harvestable
- Debug: Check visual state change on maturity
- Expected: Clear visual difference between growing and mature

**Issue #3: Inventory Full During Harvest**
- Status: Unknown
- Symptom: What happens if inventory fills during harvest?
- Expected: Should fail gracefully with message
- Debug: Test with full inventory

### 3.5 Debugging Workflow

**For farming mechanics:**
```gdscript
# Set breakpoint in farm plot code:
game/features/farm_plot/farm_plot.gd

# Check in debugger:
# - Is plot state correct?
# - Do days_remaining decrement?
# - Does maturity trigger?

# Watch variables:
# GameState.day_count
# plot.days_remaining
# plot.is_mature
```

**For seed selection:**
```gdscript
# Set breakpoint in seed selector:
game/features/ui/seed_selector.gd

# Check:
# - Is UI visible?
# - Can you select seeds?
# - Are D-pad inputs registered?
```

### 3.6 Process Notes

**After completing Quest 4:**
```
✅ Farming is intuitive?
❌ What UI was confusing?
🤔 Is day advancement clear?
💡 How to improve crop feedback?
```

---

## Process Iteration & Refinement

### After All 3 Quests Complete

**Evaluate the Testing Process:**

1. **What Worked Well?**
   - Which tools were most helpful?
   - Which debugging techniques saved time?
   - What documentation was useful?

2. **What Was Clunky?**
   - Repetitive steps to fix?
   - Unclear how to debug certain issues?
   - Missing information?

3. **What To Standardize?**
   - Template for debugging each quest?
   - Consistent tool usage?
   - Standard bug report format?

4. **Game Issues Found:**
   - Critical bugs preventing quests?
   - UX issues making quests confusing?
   - Missing features or incomplete implementation?

### Iteration Plan

**Phase 1: Draft (This Document)**
- Test quests 1, 3, 4
- Identify issues
- Refine process
- Document learnings

**Phase 2: Refine (After Testing)**
- Fix critical bugs
- Improve process based on findings
- Create standardized quest template

**Phase 3: Expand (Once Perfect)**
- Add quests 5-11
- Use refined process
- Build complete walkthrough

**Phase 4: Complete**
- All 11 quests playable and polished
- Full game playtest working

---

## Bug Tracking Template

When you find an issue, use this format:

```
### Bug #[Number]: [Short Title]

**Severity:** CRITICAL / HIGH / MEDIUM / LOW
- CRITICAL: Game-breaking, soft-lock, crash
- HIGH: Feature broken, progression blocked
- MEDIUM: Works but has issues, workaround exists
- LOW: Polish, minor visual glitch

**Description:**
What happened? What should happen?

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected:**
What should happen

**Actual:**
What did happen

**Quest/File:**
Which quest/file is affected?

**Debugging Notes:**
- Debugger breakpoint findings
- Variables that were wrong
- Where the code failed

**Potential Fix:**
What code needs to change?

**Status:** OPEN / IN PROGRESS / FIXED
```

---

## Success Criteria for This Phase

✅ **Quest 1 Complete:**
- [ ] Hermes dialogue works
- [ ] Herb ID minigame visible and playable
- [ ] Reward items added correctly
- [ ] No soft-locks

✅ **Quest 3 Complete:**
- [ ] Boat scene transition works
- [ ] Scylla dialogue appears
- [ ] Transformation cutscene plays
- [ ] Return boat works
- [ ] Physics errors addressed

✅ **Quest 4 Complete:**
- [ ] Farming system fully functional
- [ ] Day advancement works
- [ ] Crop growth and harvest works
- [ ] Economy is balanced

✅ **Process Perfected:**
- [ ] Testing methodology is repeatable
- [ ] Documentation is clear
- [ ] Debugging workflow is efficient
- [ ] Ready to expand to remaining quests

---

## Next Steps

**Once All 3 Quests Verified Working:**

1. **Update January_Playtest_Walkthrough_jwp.md** with:
   - Lessons learned from first 3 quests
   - Refined process template
   - Bug fixes applied

2. **Create Quest 5-11 Sections** (same template as above):
   - Quest 5: Calming Draught (crafting)
   - Quest 6: Reversal Elixir (sacred earth + crafting)
   - Quest 7: Daedalus Arrives (weaving minigame)
   - Quest 8: Binding Ward (crafting)
   - Quest 9-10: Moon Tears (sacred grove, minigame)
   - Quest 11: Final Confrontation (ending)

3. **Build Complete Game Walkthrough** with perfected process

4. **Create Phase 7 (Android Build)** entry criteria

---

## Related Documents

- **GODOT_TOOLS_GUIDE.md** - How to use debugger and LSP
- **PHASE_4_TESTING_PLAN.md** - Full testing plan (legacy, being consolidated)
- **Beta_Mechanical_Testing_Learnings_Jr_Engineer_Brief.md** - Testing philosophy
- **CLAUDE_REVIEW_2026-01-02.md** - Known issues and recommendations

---

**Status:** 🚧 DRAFT - Ready for first playtest iteration
**Next Update:** After completing all 3 quests and refining process

[Codex - 2025-12-29]
[Claude Haiku 4.5 - 2026-01-02] - Added Testing Methodology Cardinal Rules section
