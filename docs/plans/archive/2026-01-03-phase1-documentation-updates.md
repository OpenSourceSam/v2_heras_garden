# Implementation Plan: Phase 1 - Documentation & Roadmap Updates

**Date:** 2026-01-03
**Objective:** Correct ROADMAP.md misrepresentation and add testing warnings

---

## Context

**Problem:** ROADMAP.md claims "Phase 6.75 - Content Expansion" with "Phases 0-6.5 COMPLETE" but the game functionally only completes part of Quest 1.

**Evidence:**
- ROADMAP.md line 22-23: "Current Phase: Phase 6.75 - Content Expansion, Status: Phases 0-6.5 COMPLETE"
- Actual game state: Missing prologue content, missing Quest 2, only part of Quest 1 works
- playthrough_guide.md shows expected flow: Prologue → Aeëtes note → Quest 1 → Quest 2 → Quest 3
- Current code: Quest 2 removed (npc_base.gd line 147 comment confirms), no Helios palace cutscene

**Goal:** Update documentation to reflect accurate state and add warnings about testing limitations.

---

## Implementation Phases

### Phase 1A: Update ROADMAP.md Phase Status

**File:** `docs/execution/ROADMAP.md`

**Current (INCORRECT):**
```
Last Updated: 2025-12-30
Current Phase: Phase 6.75 - Content Expansion
Status: Phases 0-6.5 COMPLETE. Now expanding dialogue/content before export.
```

**New (CORRECTED):**
```
Last Updated: 2026-01-03
Current Phase: Phase 0.5 - Missing Content Implementation
Status: Phases 0-1.5 COMPLETE. Missing prologue content, Quest 2, and significant game flow.

**CRITICAL GAP IDENTIFIED (2026-01-03):**
- Missing: Full prologue cutscene (Helios's palace, Aeëtes note)
- Missing: Quest 2 "Extract the Sap" (mortar & pestle crafting)
- Actual: Game only completes part of Quest 1 functionally
- Reference: tests/visual/playthrough_guide.md defines correct flow
```

**Actions:**
1. Update line 21 (Last Updated date)
2. Update line 22 (Current Phase to Phase 0.5)
3. Update line 23 (Status description)
4. Add CRITICAL GAP section after line 37

### Phase 1B: Add Testing Warnings to Core Test Files

**Files to Update:**

#### 1. `tests/run_tests.gd`

**Add at top (after line 3):**
```gdscript
## ⚠️ IMPORTANT: Testing Limitations
## This file contains HEADLESS tests only.
## Headless tests verify logic and mechanics but CANNOT validate:
## - UI visibility and rendering
## - Human playability
## - Visual feedback and polish
## - Game feel and pacing
##
## For playability validation, you MUST run HEADED tests:
## godot --path . --script tests/visual_walkthrough_test.gd
## godot --path . --script tests/autonomous_playthrough_quest3.gd
```

#### 2. `tests/phase3_dialogue_flow_test.gd`

**Add at top:**
```gdscript
## ⚠️ IMPORTANT: Headless Test Limitations
## This test verifies dialogue flag logic but does NOT test:
## - Visual dialogue rendering
## - Text readability
## - Choice UI visibility
## - Player experience flow
##
## Run headed tests for playability validation:
## godot --path . --script tests/visual_walkthrough_test.gd
```

#### 3. `tests/phase3_minigame_mechanics_test.gd`

**Add at top:**
```gdscript
## ⚠️ IMPORTANT: Headless Test Limitations
## This test verifies minigame logic but does NOT test:
## - Visual minigame rendering
## - Player can see/tap targets
## - Timing feels fair
## - UI feedback is clear
##
## Run headed tests for playability validation
```

#### 4. `tests/autonomous_playthrough_quest3.gd`

**Add at top:**
```gdscript
## ⚠️ IMPORTANT: Headed Testing Required
## This test runs in headless mode for logic verification.
## For playability testing, you MUST run in HEADED mode:
##
## Run with headed mode (RECOMMENDED):
## godot --path . --script tests/autonomous_playthrough_quest3.gd --quit-after 60
##
## This validates:
## - UI actually renders
## - Player can see game elements
## - Visual feedback works
## - Game is human-playable
```

#### 5. `tests/visual_walkthrough_test.gd`

**Add at top:**
```gdscript
## ✅ HEADED VISUAL TESTING
## This test runs with Godot rendering enabled.
## Purpose: Validate human playability, UI visibility, and visual feedback.
##
## Run with headed mode:
## godot --path . --script tests/visual_walkthrough_test.gd
##
## This is the ONLY way to verify:
## - Game is actually playable by humans
## - UI elements are visible
## - Visual feedback works
## - Player experience is good
```

### Phase 1C: Add "Testing Requirements" Section to ROADMAP.md

**Add after Phase 0 section (around line 152):**

```markdown
## ⚠️ TESTING REQUIREMENTS (CRITICAL)

### Headless vs Headed Testing

**Headless Tests** (e.g., `tests/run_tests.gd`):
- ✅ Verify logic, mechanics, and code structure
- ✅ Fast automated validation
- ❌ CANNOT verify human playability
- ❌ CANNOT verify UI visibility
- ❌ CANNOT verify visual feedback

**Headed Tests** (e.g., `tests/visual_walkthrough_test.gd`):
- ✅ Verify actual game rendering
- ✅ Validate human playability
- ✅ Confirm UI visibility and feedback
- ⚠️ Slower but REQUIRED for game validation

### When to Use Each

**Use Headless Tests For:**
- Logic validation during development
- CI/CD automated checks
- Quick regression testing
- Verifying mechanics work

**Use Headed Tests For:**
- Playability validation (MANDATORY)
- UI/UX verification
- Visual polish checking
- Human experience validation

### Running Tests

```bash
# Headless (logic only)
godot --headless --script tests/run_tests.gd

# Headed (playability validation)
godot --path . --script tests/visual_walkthrough_test.gd
godot --path . --script tests/autonomous_playthrough_quest3.gd
```

**CRITICAL:** Never consider a feature "complete" without headed testing validation.
```

### Phase 1D: Create "Current State Assessment" Document

**Create:** `docs/execution/CURRENT_STATE_ASSESSMENT.md`

```markdown
# Current State Assessment (2026-01-03)

**Date:** 2026-01-03
**Assessor:** Claude Code (MiniMax)
**Reference:** tests/visual/playthrough_guide.md (source of truth)

## Summary

**ROADMAP Claim:** Phase 6.75 - Content Expansion (Phases 0-6.5 complete)
**Reality:** Much earlier phase, significant content missing

## What's Actually Implemented

### Working Systems (Verified)
- ✅ Basic player movement
- ✅ Simple inventory system
- ✅ Herb identification minigame (Quest 1)
- ✅ Basic dialogue system
- ✅ Scene transitions
- ✅ Save/load functionality

### Missing Critical Content

#### 1. Prologue (NOT IMPLEMENTED)
**Expected (from playthrough_guide.md):**
- Opening cutscene at Helios's palace
- Dialogue between Circe and Helios
- Arrival at Aiaia
- Aeëtes note on table

**Current State:**
- Missing: Helios palace cutscene
- Missing: Aeëtes note interaction
- Game starts directly in world

#### 2. Quest 1 (PARTIALLY IMPLEMENTED)
**Expected:**
- Player explores island
- Finds Aeëtes note about pharmaka
- Collects pharmaka flowers
- Hermes appears with warning dialogue
- Choice prompt

**Current State:**
- ✅ Can collect pharmaka flowers
- ❌ No Aeëtes note
- ❌ Hermes doesn't appear after collection
- ❌ No warning dialogue or choices

#### 3. Quest 2 (REMOVED/NOT IMPLEMENTED)
**Expected:**
- Hermes warns about pharmaka
- Player returns to house
- Mortar & pestle crafting minigame
- Extract transformation sap

**Current State:**
- ❌ Quest 2 completely missing
- npc_base.gd line 147: "# Quest 2 removed - skip directly to quest 3 start"
- quest2_start.tres exists but unused

#### 4. Quest 3 (BASIC IMPLEMENTATION)
**Expected:**
- Boat travel to Scylla's Cove
- Dialogue with choices
- Transformation cutscene

**Current State:**
- ✅ Boat travel works
- ⚠️ Dialogue/cutscene need verification

## Gap Analysis

**Claimed:** 11 quests implemented
**Reality:** ~2.5 quests functional

**Claimed:** Full game loop
**Reality:** Partial Quest 1 only

**Claimed:** Phase 6.75
**Reality:** Phase 0.5 or earlier

## Required Work

### Phase 0.5: Restore Missing Content
1. Implement prologue cutscene
2. Add Aeëtes note interaction
3. Fix Quest 1 flow (Hermes appearance, dialogue)
4. Restore Quest 2 (crafting minigame)
5. Complete Quest 3+ implementation

### Phase 1+: Content Expansion
- Only after core game flow is restored

## Recommendations

1. **Update ROADMAP.md** to reflect actual state
2. **Stop claiming Phase 6.75 completion** - misleading
3. **Focus on restoring missing content** before adding new features
4. **Use playthrough_guide.md** as implementation reference
5. **Validate every change with headed testing**

## Testing Evidence

**Files Tested:**
- tests/autonomous_playthrough_quest3.gd: "Skip Quest 2 (it's been removed)"
- tests/manual_playthrough_test.gd: Confirms quest flow issues

**Conclusion:** Game is much less complete than claimed in ROADMAP.md
```

---

## Success Criteria

### Automated Verification
- [ ] ROADMAP.md updated with accurate phase status
- [ ] Testing warnings added to all test files
- [ ] Testing requirements section added to ROADMAP.md
- [ ] Current state assessment document created

### Manual Verification
- [ ] ROADMAP.md clearly indicates actual phase
- [ ] All test files have prominent testing warnings
- [ ] Team understands gap between claimed and actual state
- [ ] Reference to playthrough_guide.md as source of truth

## Files to Modify

1. `docs/execution/ROADMAP.md` - Update phase status, add testing requirements
2. `tests/run_tests.gd` - Add testing warning
3. `tests/phase3_dialogue_flow_test.gd` - Add testing warning
4. `tests/phase3_minigame_mechanics_test.gd` - Add testing warning
5. `tests/autonomous_playthrough_quest3.gd` - Add testing warning
6. `tests/visual_walkthrough_test.gd` - Add headed testing notice
7. `docs/execution/CURRENT_STATE_ASSESSMENT.md` - Create new document

## Timeline

**Estimated Time:** 30-45 minutes
**Priority:** HIGH (Documentation accuracy is critical)
**Dependencies:** None

---

## Next Steps

After Phase 1 completion:
- Proceed to Phase 2: Implement missing prologue content
- Proceed to Phase 3: Restore Quest 2
- Use playthrough_guide.md as implementation reference
- Validate all changes with headed testing
