# Ending Test Procedures

**Last Updated:** 2026-01-23
**Purpose:** Debugger-based test procedures for ending verification

---

## Ending A: Witch Path

**Test Procedure:**
```
1. Set breakpoint at game/features/cutscenes/epilogue.gd:40 (dialogue start)
2. Set breakpoint at game/autoload/game_state.gd:152 (set_flag)
3. In Variables panel, set:
   - quest_11_complete = true
   - game_complete = true
   - scylla_petrified = true
4. Trigger epilogue cutscene
5. At breakpoint 1, verify:
   - epilogue_cutscene_seen: true
   - epilogue_ending_choice dialogue starts
6. Select "I'll continue learning witchcraft..." choice
7. At breakpoint 2, verify:
   - flag_name == "ending_witch"
   - value == true
   - flag_name == "free_play_unlocked"
   - value == true
```

**Expected State:**
- epilogue_cutscene_seen: true
- ending_witch: true
- free_play_unlocked: true
- ending_healer: false (should not be set)

**Key Files:**
- `game/features/cutscenes/epilogue.gd:34-40` (epilogue sequence)
- `game/shared/resources/dialogues/epilogue_ending_choice.tres`
- `game/shared/resources/dialogues/epilogue_ending_witch.tres`

---

## Ending B: Healer Path

**Test Procedure:**
```
1. Set breakpoint at game/features/cutscenes/epilogue.gd:40 (dialogue start)
2. Set breakpoint at game/autoload/game_state.gd:152 (set_flag)
3. In Variables panel, set:
   - quest_11_complete = true
   - game_complete = true
   - scylla_petrified = true
4. Trigger epilogue cutscene
5. At breakpoint 1, verify:
   - epilogue_cutscene_seen: true
   - epilogue_ending_choice dialogue starts
6. Select "I will seek redemption..." choice
7. At breakpoint 2, verify:
   - flag_name == "ending_healer"
   - value == true
   - flag_name == "free_play_unlocked"
   - value == true
```

**Expected State:**
- epilogue_cutscene_seen: true
- ending_healer: true
- free_play_unlocked: true
- ending_witch: false (should not be set)

**Key Files:**
- `game/features/cutscenes/epilogue.gd:34-40` (epilogue sequence)
- `game/shared/resources/dialogues/epilogue_ending_choice.tres`
- `game/shared/resources/dialogues/epilogue_ending_healer.tres`

---

## Epilogue Trigger Verification

**Test Procedure:**
```
1. Set breakpoint at game/features/world/quest_trigger.gd:42 (_try_trigger)
2. Set breakpoint at game/features/cutscenes/epilogue.gd:20 (_on_body_entered)
3. In Variables panel, set:
   - quest_11_complete = true
   - game_complete = true
   - epilogue_triggered = false
4. Navigate to epilogue trigger location
5. At breakpoint 1, verify trigger conditions:
   - required_flag == "game_complete"
   - set_flag_on_enter == "epilogue_triggered"
6. At breakpoint 2, verify epilogue cutscene starts
7. Continue and verify epilogue_triggered: true
```

**Expected State:**
- epilogue_triggered: true
- Epilogue cutscene plays
- Ending choice dialogue appears

**Key Files:**
- `game/features/world/quest_trigger.gd:42-53` (trigger logic)
- `game/features/cutscenes/epilogue.gd:20-50` (epilogue sequence)

---

## Debug Variables for Ending Testing

**At epilogue breakpoint (epilogue.gd:40):**
- `epilogue_cutscene_seen` - Epilogue played flag
- `dialogue_id` - Current dialogue ID
- `epilogue_triggered` - Epilogue trigger flag

**At set_flag breakpoint (game_state.gd:152):**
- `flag_name` - Flag being set
- `value` - Flag value (true/false)
- `quest_flags` - All quest flags

**Final GameState (after ending):**
- `ending_witch` OR `ending_healer` (exclusive)
- `free_play_unlocked` - Both endings set this
- `game_complete` - Game completed flag

---

## Ending Verification Checklist

**Ending A (Witch):**
☐ quest_11_complete is true
☐ game_complete is true
☐ scylla_petrified is true
☐ epilogue_cutscene_seen is true
☐ Witch choice selected
☐ ending_witch is true
☐ ending_healer is false
☐ free_play_unlocked is true

**Ending B (Healer):**
☐ quest_11_complete is true
☐ game_complete is true
☐ scylla_petrified is true
☐ epilogue_cutscene_seen is true
☐ Healer choice selected
☐ ending_healer is true
☐ ending_witch is false
☐ free_play_unlocked is true

---

## Common Issues to Check

**Wrong ending triggered:**
- Verify choice selection in epilogue_ending_choice
- Check next_id values in choice data
- Verify correct ending dialogue loads

**Both endings set:**
- Should be mutually exclusive
- Check for race conditions in flag setting
- Verify dialogue resource flags_to_set

**Free play not unlocked:**
- Verify free_play_unlocked is set in ending dialogues
- Check flags_to_set array in dialogue resources
- Verify set_flag() is called

**Epilogue doesn't trigger:**
- Verify quest_11_complete and game_complete flags
- Check epilogue trigger location
- Verify trigger conditions in quest_trigger.gd

---

## Quick Ending Test (Skip Method)

**Skip Directly to Ending Choice:**
```
1. Start game with F5 debugger
2. Set breakpoint at any location
3. In Variables panel, set:
   - quest_11_complete = true
   - game_complete = true
   - scylla_petrified = true
4. Load epilogue.tscn scene directly
5. Verify epilogue_ending_choice dialogue appears
6. Test both ending choices
7. Verify correct flags are set
```

---

**End of Debugger Test Procedures**

**Summary:**
- Quest progression testing: [quest_test_procedures.md](quest_test_procedures.md)
- Dialogue choice testing: [dialogue_test_procedures.md](dialogue_test_procedures.md)
- NPC spawn testing: [npc_spawn_test_procedures.md](npc_spawn_test_procedures.md)
- Minigame testing: [minigame_test_procedures.md](minigame_test_procedures.md)
- Ending testing: This file

**See Also:** [../../docs/agent-instructions/DEBUGGER_TESTING_GUIDE.md](../../docs/agent-instructions/DEBUGGER_TESTING_GUIDE.md)
