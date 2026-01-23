# DAP Testing Procedures - Phase 7 Verification

**Date:** 2026-01-23
**Purpose:** Verify quest routing, dialogue choices, and ending paths using VSCode debugger (F5)

---

## Prerequisites

1. Open VSCode
2. Open the project folder
3. Press F5 to launch Godot with debugger attached
4. The game will start and pause at any breakpoints you set

---

## Test 1: Quest Flag Flow Verification

**Breakpoint Location:** `game/autoload/game_state.gd:set_flag()` (line ~25)

**Procedure:**
1. Set breakpoint at `game_state.gd:set_flag()`
2. Start NEW GAME
3. Walk through Prologue (house exit → Aeetes note)
4. Observe Variables panel for each breakpoint hit:

**Expected Flag Sequence:**
| Step | Flag Set | Value | Context |
|------|----------|-------|---------|
| 1 | `quest_0_active` | true | Game starts |
| 2 | `quest_0_complete` | true | Aeetes note read |
| 3 | `quest_1_active` | true | Quest 1 starts (Hermes) |

**Pass Criteria:** Each flag sets in correct order with expected values

---

## Test 2: Dialogue Choice Routing (Quest 1)

**Breakpoint Location:** `game/features/ui/dialogue_box.gd:_on_choice_selected()` (line ~80)

**Procedure:**
1. Start NEW GAME
2. Complete Prologue
3. Talk to Hermes in world (Quest 1 start)
4. Observe the 3 choice buttons appear
5. Click ANY choice (understand, refuse, threaten)
6. Observe Variables panel: `next_dialogue_id` should update

**Expected Flow:**
- Main dialogue: `quest1_start.tres`
- Choice 1 (understand) → `quest1_choice_understand.tres`
- Choice 2 (refuse) → `quest1_choice_refuse.tres`
- Choice 3 (threaten) → `quest1_choice_threaten.tres`
- All converge to: `quest1_complete.tres`

**Pass Criteria:**
- All 3 choices appear
- Clicking choice updates `next_dialogue_id`
- Convergence dialogue loads after branch

---

## Test 3: Dialogue Choice Routing (Quest 3 - Scylla)

**Breakpoint Location:** `game/features/ui/dialogue_box.gd:_on_choice_selected()` (line ~80)

**Procedure:**
1. Load savegame or progress through Quests 1-2
2. Start Quest 3 (Scylla confrontation in cove)
3. Observe 3 choice buttons appear
4. Click ANY choice
5. Verify convergence to transformation cutscene

**Expected Flow:**
- Main dialogue: `act1_confront_scylla.tres`
- Choice 1 (gift) → `act1_confront_scylla_gift.tres`
- Choice 2 (honest) → `act1_confront_scylla_honest.tres`
- Choice 3 (cryptic) → `act1_confront_scylla_cryptic.tres`
- All trigger: `scylla_transformation.tscn`

**Pass Criteria:** All choices trigger transformation cutscene

---

## Test 4: NPC Spawn Conditions (Hermes)

**Breakpoint Location:** `game/features/npcs/npc_base.gd:_ready()` (line ~15)

**Procedure:**
1. Start NEW GAME
2. Walk to world map
3. Check if Hermes appears (Quest 1 active)
4. Set flag in Debug Console: `GameState.set_flag("quest_2_complete", true)`
5. Exit and re-enter world
6. Hermes should NOT appear (between quests)

**Expected Behavior:**
| Quest | Hermes Visible | Reason |
|-------|----------------|--------|
| Quest 1 active | YES | Quest start |
| Quest 2 | YES | Tutorial |
| Quest 3 | NO | Scylla focus |
| Quest 4 | YES | Seeds delivery |
| Quest 5-6 | YES | Failed attempts |
| Quest 7-11 | NO | Aeetes/Daedalus focus |

**Pass Criteria:** Hermes appears only during specified quests

---

## Test 5: Cutscene Completion Flags

**Breakpoint Location:** `game/autoload/game_state.gd:set_flag()` (line ~25)

**Procedure:**
1. Set breakpoint at `set_flag()`
2. Progress through any cutscene (e.g., scylla_transformation.tscn)
3. Observe flag being set when cutscene ends

**Expected Cutscenes and Flags:**
| Cutscene | Flag Set | Next Quest |
|----------|----------|------------|
| scylla_transformation.tscn | quest_3_complete | Quest 4 |
| calming_draught_failed.tscn | quest_5_complete | Quest 6 |
| reversal_elixir_failed.tscn | quest_6_complete | Quest 7 |
| binding_ward_failed.tscn | quest_8_complete | Quest 9 |
| scylla_petrification.tscn | quest_11_complete, game_complete | Epilogue |

**Pass Criteria:** Each cutscene sets correct completion flag

---

## Test 6: Ending A Path (Witch Ending)

**Breakpoint Location:** `game/autoload/game_state.gd:set_flag()` (line ~25)

**Procedure:**
1. Progress through entire game to Quest 11 complete
2. Trigger epilogue_ending_choice.tres
3. Select "I choose power" (Witch ending)
4. Observe epilogue_ending_witch.tres
5. Verify flags in Variables panel

**Expected Flags:**
- `scylla_petrified`: true
- `quest_11_complete`: true
- `game_complete`: true
- `ending_chose_power`: true (if set)
- `free_play_unlocked`: true

**Pass Criteria:** All flags set, ending dialogue plays, free-play unlocked

---

## Test 7: Ending B Path (Healer Ending)

**Breakpoint Location:** `game/autoload/game_state.gd:set_flag()` (line ~25)

**Procedure:**
1. Progress through entire game to Quest 11 complete
2. Trigger epilogue_ending_choice.tres
3. Select "I choose healing" (Healer ending)
4. Observe epilogue_ending_healer.tres
5. Verify flags in Variables panel

**Expected Flags:**
- `scylla_petrified`: false
- `quest_11_complete`: true
- `game_complete`: true
- `ending_chose_healing`: true (if set)
- `free_play_unlocked`: true

**Pass Criteria:** All flags set, ending dialogue plays, free-play unlocked

---

## Test 8: Final Confrontation Convergence

**Breakpoint Location:** `game/features/ui/dialogue_box.gd:_end_dialogue()` (line ~120)

**Procedure:**
1. Progress to Quest 11 (final confrontation)
2. Start act3_final_confrontation.tres
3. Select ANY of the 3 choices (understand, mercy, request)
4. Verify convergence dialogue loads

**Expected Flow:**
1. Main dialogue: `act3_final_confrontation.tres`
2. Branch choice:
   - "I'll understand if you hate me" → `act3_final_confrontation_understand.tres`
   - "This is the only mercy I can offer" → `act3_final_confrontation_mercy.tres`
   - "Tell me what you want" → `act3_final_confrontation_request.tres`
3. **ALL converge to:** `act3_final_confrontation_convergence.tres` (19 lines)
4. Convergence ends → triggers `scylla_petrification.tscn`

**Pass Criteria:** All 3 choices lead to convergence dialogue, then petrification

---

## Test 9: Petrification Cutscene Dialogue

**Breakpoint Location:** `game/features/cutscenes/scylla_petrification.gd:_play_sequence()` (line ~6)

**Procedure:**
1. Trigger petrification cutscene (after final confrontation)
2. Observe all dialogue lines display in order
3. Verify cutscene ends with correct flags

**Expected Dialogue (7 lines):**
1. "The potion spills into the dark water."
2. "Scylla gasps as stone creeps across her skin."
3. "The sea grows still. The screams fade."
4. "Circe bows her head."
5. **"Rest now, Scylla."** (NEW)
6. **"No more pain. No more killing."** (NEW)
7. **"I'm so sorry."** (NEW)
8. **"I'll remember you. Always."** (NEW)
9. **"Not as a monster. But as... someone I wronged."** (NEW)
10. **"Someone who deserved better."** (NEW)

**Expected Flags:**
- `scylla_petrified`: true
- `quest_11_complete`: true
- `game_complete`: true

**Pass Criteria:** All 10 dialogue lines display, all flags set correctly

---

## Test 10: Free-Play Unlock

**Breakpoint Location:** `game/autoload/game_state.gd:set_flag()` (line ~25)

**Procedure:**
1. Complete either ending (A or B)
2. Verify `free_play_unlocked` flag is set to true
3. Return to world map
4. Verify game continues (no forced ending)

**Expected Behavior:**
- After epilogue, player returns to world
- Quest log shows "Game Complete"
- Player can continue playing freely

**Pass Criteria:** Free-play flag set, game continues

---

## Debug Console Commands (for testing)

Use these in the Debug Console (F5 → Debug Console tab) to set flags manually:

```gdscript
# Skip to Quest 5
GameState.set_flag("quest_0_complete", true)
GameState.set_flag("quest_1_complete", true)
GameState.set_flag("quest_2_complete", true)
GameState.set_flag("quest_3_complete", true)
GameState.set_flag("quest_4_complete", true)
GameState.set_flag("quest_5_active", true)

# Skip to final quest
GameState.set_flag("quest_10_complete", true)
GameState.set_flag("quest_11_active", true)

# Check flag values
print(GameState.quest_flags)

# Teleport to world
get_tree().change_scene_to_file("res://game/features/world/world.tscn")
```

---

## Variables Panel Inspection (F5)

When paused at a breakpoint, check these values in the Variables panel:

**GameState Singleton:**
- `quest_flags` (Dictionary) - All quest progress flags
- `inventory` (Dictionary) - All held items
- `current_day` (int) - Current game day

**DialogueBox (if dialogue open):**
- `current_dialogue` (Resource) - Current dialogue file
- `next_dialogue_id` (String) - Next dialogue to load
- `choices` (Array) - Available choices

**NPCBase (if NPC interaction):**
- `npc_name` (String) - NPC identifier
- `current_dialogue_id` (String) - Current dialogue

---

## Test Summary Checklist

- [ ] Test 1: Quest flag flow (Prologue → Quest 1)
- [ ] Test 2: Dialogue choice routing (Quest 1)
- [ ] Test 3: Dialogue choice routing (Quest 3)
- [ ] Test 4: NPC spawn conditions (Hermes)
- [ ] Test 5: Cutscene completion flags
- [ ] Test 6: Ending A path (Witch)
- [ ] Test 7: Ending B path (Healer)
- [ ] Test 8: Final confrontation convergence
- [ ] Test 9: Petrification cutscene dialogue (10 lines)
- [ ] Test 10: Free-play unlock

---

## Unit Test Results (Automated)

**Date:** 2026-01-23
**Command:** `Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd`

| Test | Status | Details |
|------|--------|---------|
| Test 1: Autoloads | ✅ PASS | GameState, AudioController, SaveController found |
| Test 2: Resource Classes | ✅ PASS | All scripts compile |
| Test 3: TILE_SIZE | ✅ PASS | TILE_SIZE = 32 |
| Test 4: GameState Init | ✅ PASS | All fields initialized correctly |
| Test 5: Scene Wiring | ✅ PASS | All scenes have scripts |

**Result:** 5/5 tests passing (100%)

---

## Notes

- **DAP Testing** requires manual execution with F5 debugger
- **Unit Tests** verify code compilation and basic functionality
- **HPV (Headed Playability Validation)** is NOT required for Phase 7
- Use **Debug Console** to set flags for faster testing
- Use **Teleport** to skip between scenes for faster testing

---

**Document Version:** 1.0
**Last Updated:** 2026-01-23
**Phase:** 7 - Playable Story Completion
**Status:** Ready for manual DAP testing
**Final Commit:** 8380c4a

**Note:** All Phase 7 work completed with commit 8380c4a
