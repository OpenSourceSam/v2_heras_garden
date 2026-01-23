# Quest Progression Test Procedures

**Last Updated:** 2026-01-23
**Purpose:** Debugger-based test procedures for quest flag transitions

---

## Quest 1: Herb Collection (Hermes Introduction)

**Test Procedure:**
```
1. Set breakpoint at game/autoload/game_state.gd:152 (set_flag function)
2. In Variables panel, set: quest_0_complete = true
3. Trigger quest 1 start (talk to Hermes)
4. At breakpoint, verify:
   - flag_name == "quest_1_active"
   - value == true
5. Continue and complete herb ID minigame
6. At next breakpoint, verify:
   - flag_name == "quest_1_complete"
   - value == true
```

**Expected State:**
- quest_1_active: true after Hermes dialogue
- quest_1_complete: true after minigame
- Inventory contains pharmaka_flower or saffron

---

## Quest 2: Moly Grinding

**Test Procedure:**
```
1. Set breakpoint at game/autoload/game_state.gd:152 (set_flag function)
2. In Variables panel, set: quest_1_complete = true
3. Trigger quest 2 start (Hermes brings seeds)
4. At breakpoint, verify quest_2_active is set
5. Complete grinding minigame (crafting system)
6. At breakpoint, verify quest_2_complete is set
```

**Expected State:**
- quest_2_active: true after dialogue
- quest_2_complete: true after crafting
- 3 choices available in quest2_start dialogue

**Key Files:**
- `game/shared/resources/dialogues/quest2_start.tres` - Has 3 choices
- `game/features/ui/crafting_controller.gd` - Minigame handler

---

## Quest 3: Confrontation at Scylla's Cove

**Test Procedure:**
```
1. Set breakpoint at game/autoload/game_state.gd:152 (set_flag function)
2. In Variables panel, set: quest_2_complete = true
3. Use boat to travel to Scylla's Cove
4. At breakpoint, verify quest_3_active is set
5. Select dialogue choice (3 options)
6. At breakpoint, verify transformation cutscene triggers
7. After cutscene, verify quest_3_complete is set
```

**Expected State:**
- quest_3_active: true after boat travel
- Dialogue choices: gift, honest, cryptic (3 options)
- quest_3_complete: true after confrontation

**Key Files:**
- `game/shared/resources/dialogues/act1_confront_scylla.tres` - Confrontation dialogue
- `game/features/cutscenes/scylla_transformation.tscn` - Transformation

---

## Quest 4: Garden Building

**Test Procedure:**
```
1. Set breakpoint at game/autoload/game_state.gd:124 (_check_quest4_completion)
2. In Variables panel, set: quest_3_complete = true
3. Add required items to inventory (via Variables panel):
   - 3x moly
   - 3x nightshade
   - 3x golden_glow
4. At breakpoint, verify:
   - GameState._check_quest4_completion() is called
   - quest_4_complete: true
   - garden_built: true
```

**Expected State:**
- quest_4_active: true after Hermes dialogue
- quest_4_complete: true after items collected
- garden_built flag set

---

## Quest 10: Ultimate Crafting (Divine Blood)

**Test Procedure:**
```
1. Set breakpoint at game/features/ui/crafting_controller.gd:88
2. In Variables panel, set: quest_9_complete = true
3. Trigger quest 10 start
4. Divine blood cutscene should play automatically
5. At breakpoint, verify:
   - divine_blood_collected: true
   - quest_10_complete: true
   - quest_11_active: true (auto-activated)
```

**Expected State:**
- quest_10_active: true after dialogue
- Divine blood collected via cutscene
- quest_10_complete: true
- quest_11_active: true (final quest starts)

---

## Quest 11: Final Confrontation

**Test Procedure:**
```
1. Set breakpoint at game/autoload/game_state.gd:152 (set_flag function)
2. In Variables panel, set:
   - quest_10_complete = true
   - petrification_potion in inventory
3. Navigate to Scylla's Cave
4. At breakpoint, verify quest_11_active is set
5. Select final confrontation choice (3 options)
6. At breakpoint, verify:
   - scylla_petrified: true
   - quest_11_complete: true
   - game_complete: true
```

**Expected State:**
- quest_11_active: true
- 3 final choices available
- scylla_petrified: true after choice
- game_complete: true

**Key Files:**
- `game/shared/resources/dialogues/act3_final_confrontation.tres`
- `game/features/cutscenes/scylla_petrification.tscn`

---

## Common Quest Flag Variables

**Flag Naming Pattern:**
- `quest_N_active` - Quest is currently active
- `quest_N_complete` - Quest has been completed
- `met_npc_name` - NPC has been met
- `ending_witch` / `ending_healer` - Ending flags

**Key Inspection Points:**
- `game/autoload/game_state.gd:152` - set_flag() function
- `game/autoload/game_state.gd:159` - get_flag() function
- `game/features/world/quest_trigger.gd:42` - _try_trigger() function

---

**Next:** See [dialogue_test_procedures.md](dialogue_test_procedures.md) for dialogue choice testing
