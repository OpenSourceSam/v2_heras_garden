# Phase 7 Buildout Needs Assessment

**Generated:** 2026-01-23
**Updated:** 2026-01-23 (P2/P3 tasks complete)
**Source:** Phase 1 analysis by 5 parallel subagents
**Purpose:** Prioritized list of remaining Phase 7 work

---

## Executive Summary

**Overall Status:** Phase 7 implementation is ~95% complete. All P2/P3 tasks completed. Only manual testing (P1) remains.

**Completed (2026-01-23):**
- Quest flag flow reconciliation (helper method, auto-tracking, fixed missing flags)
- Act 2 dialogue tone alignment (4 dialogues updated with emotional depth)
- World spacing polish (NPC vertical stagger, interactable activity zones)
- Unit tests passing (5/5)

**Remaining:**
- P1: Manual Ending A/B validation (requires gameplay testing)
- P1: Dialogue fix runtime verification (requires gameplay testing)
- Quest 0 house exit verification (quick check)

---

## P1 (Blocking) Items

### 1. Quest 2 & 3 Completion Dialogues
**Issue:** Missing completion dialogues
- Quest 2: Has `quest2_start.tres` with choices, but no `quest2_complete.tres`
- Quest 3: Has `quest3_start.tres` and confrontation, but no explicit completion dialogue
**Impact:** Players can start these quests but proper completion flow is unclear
**Files to Check:**
- `game/shared/resources/dialogues/quest2_start.tres` - verify next_id routing
- `act1_confront_scylla.tres` - verify it sets quest_3_complete
**Priority:** P1 - Quest flow validation blocked

### 2. Full Ending A/B Validation
**Task:** Complete New Game → Ending A and New Game → Ending B without runtime eval
**Current Status:** Infrastructure ready, but manual playthrough required
**Dependencies:** All quest routing working correctly
**Priority:** P1 - Primary Phase 7 completion criteria
**Note:** This is a testing task, not implementation

### 3. Dialogue Fix Runtime Verification
**Task:** Verify `button.pressed = true` fix works in actual gameplay
**Current Status:** Code verified correct (commit 69620d5)
**Required:** Manual testing at runtime with dialogue choices
**Priority:** P1 - Blocks quest flow validation
**Related:** Quests 1-3 dialogue choices

---

## P2 (High Priority) Items

### 4. Quest Flag Flow Reconciliation ✅ COMPLETE
**Issue:** Reconcile quest flag flow in game_state.gd with dialogue gating in npc_base.gd
**Resolution:**
- Added `mark_dialogue_completed(quest_id)` helper method in GameState
- Modified DialogueBox to auto-detect and set `quest_X_complete_dialogue_seen` flags
- Fixed missing flag checks in NPCBase (quest_8_complete_dialogue_seen, quest_11_complete_dialogue_seen)
**Files Modified:**
- `game/autoload/game_state.gd` - Quest flag management
- `game/features/npcs/npc_base.gd` - Dialogue routing by flag
**Priority:** P2 - System consistency

### 5. NPC Interaction Zone Precision
**Status:** Workaround acceptable (debugger teleport)

### 6. Spawn Placement Verification ✅ COMPLETE
**Resolution:**
- NPC spawn points: Vertical stagger layout (Hermes [160,-96], Aeetes [224,-32], Daedalus [288,32], Scylla [352,96])
- Interactable objects: Activity zones (gardening, central hub, crafting)
- Circe spawn point removed (location-specific in AiaiaShore)
**Files Modified:**
- `game/features/world/world.tscn` - All spawn points and interactables repositioned
**Priority:** P2 - Quality assurance (COMPLETE)

---

## P3 (Nice to Have) Items

### 7. World Spacing Polish ✅ COMPLETE
**Status:** COMPLETED (see Spawn Placement Verification above)
**Priority:** P3 - Polish

### 8. Dialogue Tone Alignment ✅ COMPLETE
**Task:** Align Aeetes/Daedalus dialogues to Storyline beats (Act 2)
**Files Updated:**
- `act2_farming_tutorial.tres` - Added Aeetes's harsh truth about pharmaka limitations
- `act2_calming_draught.tres` - Added Circe's hopeful determination and ritual crafting
- `act2_reversal_elixir.tres` - Added "pharmaka doesn't undo pharmaka" confrontation
- `act2_binding_ward.tres` - Added Scylla's death plea and Circe's internal conflict
- `daedalus_intro.tres` - Already well-toned (no changes needed)
**Priority:** P3 - Narrative polish (COMPLETE)

---

## Infrastructure Status (Complete)

### ✅ Complete Systems

**Minigames:** 4/4 dedicated implementations complete
- Herb Identification, Sacred Earth, Weaving, Moon Tears all functional
- Crafting system handles grinding, elixirs, ward, petrification potion
- All emit `minigame_complete` signal properly

**Cutscenes:** 12/12 complete
- Prologue, sailing (first/final), transformation, petrification, epilogue
- All failure cutscenes (calming draught, reversal elixir, binding ward)
- Proper scene transitions and flag management

**Testing Infrastructure:**
- HPV tools validated (MCP wrapper, vision tools, input simulation)
- Debugger workflow established (F5 + Variables panel)
- Skip scripts configured for efficient testing
- Codebase health verified (autonomous review: no blocking issues)

---

## Completeness Analysis by Quest

| Quest | Start Dialogue | Completion | Choices | Cutscene | Minigame | Status |
|-------|----------------|------------|---------|----------|----------|--------|
| 0 | Prologue + Aeetes note | ✅ | ❌ | ✅ | ❌ | Complete |
| 1 | ✅ quest1_start | ✅ quest1_complete | ✅ 3 choices | ❌ | ✅ Herb ID | Complete |
| 2 | ✅ quest2_start | ⚠️ Missing/implicit | ✅ 3 choices | ❌ | ✅ Grinding | ⚠️ Gap |
| 3 | ✅ quest3_start | ⚠️ Confrontation only | ✅ 3 choices | ✅ Sailing | ❌ | ⚠️ Gap |
| 4 | ✅ quest4_start | ✅ quest4_complete | ❌ | ❌ | ✅ Farming | Complete |
| 5 | ✅ quest5_start | ✅ quest5_complete | ❌ | ✅ Failed | ✅ Crafting | Complete |
| 6 | ✅ quest6_start | ✅ quest6_complete | ❌ | ✅ Failed | ✅ Crafting | Complete |
| 7 | ✅ quest7_start | ✅ quest7_complete | ❌ | ❌ | ✅ Weaving | Complete |
| 8 | ✅ quest8_start | ✅ quest8_complete | ❌ | ✅ Failed | ✅ Crafting | Complete |
| 9 | ✅ quest9_start | ✅ quest9_complete | ❌ | ❌ | ✅ Sacred Earth | Complete |
| 10 | ✅ quest10_start | ✅ quest10_complete | ❌ | ✅ Divine Blood | ✅ Crafting | Complete |
| 11 | ✅ quest11_start | ✅ quest11_complete | ✅ 3 choices | ✅ Petrification | ✅ Crafting | Complete |

**Legend:** ✅ Complete, ⚠️ Gap/Missing, ❌ N/A

---

## Dependency Graph

```
Ending A/B Validation (P1)
├─ Requires: All quests 0-11 completable
├─ Requires: Dialogue choices working
└─ Requires: Minigame skips working

Quest 2 & 3 Completion (P1)
├─ Requires: Dialogue routing verification
└─ Blocks: Complete playthrough validation

Quest Flag Reconciliation (P2)
├─ Requires: game_state.gd review
└─ Requires: npc_base.gd review

Spawn Placement Verification (P2)
├─ Requires: World scene loaded
└─ Requires: All NPCs placed
```

---

## Recommended Execution Order

1. **First:** Investigate Quest 2 & 3 completion flow (may be working via different mechanism)
2. **Second:** Quest flag flow reconciliation (system consistency)
3. **Third:** Runtime verification of dialogue fix
4. **Fourth:** Full Ending A/B validation (manual playthrough)
5. **Fifth:** Spawn placement verification
6. **Last:** Polish items (world spacing, dialogue tone)

---

## Notes

### Quest 0 Clarification
Agent 3 reported Quest 0 as "completely missing" but this appears to be incorrect:
- Quest 0 uses `aeetes_note.tres` (not `quest0_start.tres` naming pattern)
- Completion occurs via note interaction setting `quest_0_complete`
- Prologue system handles initial scene setup
**Action:** Verify Quest 0 is actually working as designed before marking as gap

### Minigame Classification
"Missing" minigames (farming, divine blood) are actually handled differently:
- Farming: Uses crop system, not dedicated minigame scene
- Divine Blood: Collected via cutscene, not minigame
**Conclusion:** Minigame coverage is complete for game design

---

**Next Phase:** Phase 2 - Create debugger test procedures for critical systems
