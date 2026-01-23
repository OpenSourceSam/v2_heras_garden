# Full Ending A/B Validation Checklist

**Purpose:** Complete playthrough validation for both Witch (A) and Healer (B) endings

**Last Updated:** 2026-01-23

---

## Prerequisites

### Required Flags Before Testing Endings
```
☐ prologue_complete: true (starting flag)
☐ quest_0_complete: true (tutorial complete)
☐ quest_1_complete: true (herb collection)
☐ quest_2_complete: true (moly grinding)
☐ quest_3_complete: true (confrontation at Scylla's Cove)
☐ quest_4_complete: true (garden built)
☐ quest_7_complete: true (Calming Draught)
☐ quest_8_complete: true (Binding Ward)
☐ quest_9_complete: true (Reversal Elixir)
☐ quest_10_complete: true (Divine Blood collected)
☐ quest_11_complete: true (final confrontation complete)
☐ scylla_petrified: true (final choice made)
☐ game_complete: true (game finished)
☐ epilogue_cutscene_seen: true (epilogue triggered)
```

### Required Inventory Items
```
☐ 3x moly (for quest 4)
☐ 3x nightshade (for quest 4)
☐ 3x golden_glow (for quest 4)
☐ petrification_potion (for quest 11)
```

### Key NPCs to Interact With
```
☐ Hermes (introduces quests 1-2)
☐ Scylla (confrontation in quest 3, final confrontation in quest 11)
☐ Aeetes (provides materials for quests 7-9)
☐ Daedalus (crafting system)
```

---

## Ending A: Witch Path Playthrough

### Phase 1: Quests 1-3 (Starting Path)
1. **Start Game**
   - Talk to Circe to complete prologue
   - flag: prologue_complete = true

2. **Quest 1: Herb Collection**
   - Talk to Hermes
   - flag: quest_1_active = true
   - Complete herb identification minigame
   - flag: quest_1_complete = true

3. **Quest 2: Moly Grinding**
   - Talk to Hermes (seeds appear)
   - flag: quest_2_active = true
   - Complete grinding minigame
   - flag: quest_2_complete = true

4. **Quest 3: Confrontation at Scylla's Cove**
   - Take boat to Scylla's Cove
   - flag: quest_3_active = true
   - Select one of 3 dialogue choices:
     - "I brought you a gift" (gift)
     - "I will be honest about my intentions" (honest)
     - "My business is my own" (cryptic)
   - Transformation cutscene plays
   - flag: quest_3_complete = true

### Phase 2: Quests 4-6 (Building the Garden)
5. **Quest 4: Garden Building**
   - Talk to Hermes
   - flag: quest_4_active = true
   - Collect 3x moly, 3x nightshade, 3x golden_glow
   - Garden automatically builds when items collected
   - flag: quest_4_complete = true
   - flag: garden_built = true

6. **Quest 5: Farming Tutorial**
   - Talk to Aeetes
   - flag: quest_5_active = true
   - Follow farming tutorial
   - flag: quest_5_complete = true

7. **Quest 6: Extract Sap**
   - Talk to Aeetes
   - flag: quest_6_active = true
   - Complete sap extraction process
   - flag: quest_6_complete = true

### Phase 3: Quests 7-9 (Potion Crafting)
8. **Quest 7: Calming Draught**
   - Talk to Aeetes
   - flag: quest_7_active = true
   - Collect ingredients and craft potion
   - flag: quest_7_complete = true

9. **Quest 8: Binding Ward**
   - Talk to Aeetes
   - flag: quest_8_active = true
   - Collect ingredients and craft potion
   - flag: quest_8_complete = true

10. **Quest 9: Reversal Elixir**
    - Talk to Aeetes
    - flag: quest_9_active = true
    - Collect ingredients and craft potion
    - flag: quest_9_complete = true

### Phase 4: Final Quests (10-11)
11. **Quest 10: Divine Blood**
    - Talk to Aeetes
    - flag: quest_10_active = true
    - Divine blood cutscene automatically plays
    - flag: quest_10_complete = true
    - flag: quest_11_active = true (auto-activated)

12. **Final Confrontation (Quest 11)**
    - Take boat to Scylla's Cave
    - flag: quest_11_active = true
    - Select final confrontation choice:
      - "I understand now" (understand ending)
      - "I show mercy" (mercy ending)
      - "I have a request" (request ending)
    - Petrification potion used
    - flag: scylla_petrified = true
    - flag: quest_11_complete = true
    - flag: game_complete = true

### Phase 5: Epilogue and Witch Ending
13. **Epilogue Trigger**
    - Navigate to epilogue trigger location
    - flag: epilogue_triggered = true
    - flag: epilogue_cutscene_seen = true
    - Epilogue dialogue starts

14. **Witch Ending Choice**
    - Select: "I'll continue learning witchcraft. Help those who come to me."
    - Triggers: epilogue_ending_witch dialogue
    - flag: ending_witch = true
    - flag: free_play_unlocked = true

**Expected Final State:**
```
ending_witch: true
ending_healer: false
free_play_unlocked: true
game_complete: true
quest_11_complete: true
scylla_petrified: true
```

---

## Ending B: Healer Path Playthrough

### Phase 1: Quests 1-3 (Starting Path)
1. **Start Game**
   - Talk to Circe to complete prologue
   - flag: prologue_complete = true

2. **Quest 1: Herb Collection**
   - Talk to Hermes
   - flag: quest_1_active = true
   - Complete herb identification minigame
   - flag: quest_1_complete = true

3. **Quest 2: Moly Grinding**
   - Talk to Hermes (seeds appear)
   - flag: quest_2_active = true
   - Complete grinding minigame
   - flag: quest_2_complete = true

4. **Quest 3: Confrontation at Scylla's Cove**
   - Take boat to Scylla's Cove
   - flag: quest_3_active = true
   - Select one of 3 dialogue choices:
     - "I brought you a gift" (gift)
     - "I will be honest about my intentions" (honest)
     - "My business is my own" (cryptic)
   - Transformation cutscene plays
   - flag: quest_3_complete = true

### Phase 2: Quests 4-6 (Building the Garden)
5. **Quest 4: Garden Building**
   - Talk to Hermes
   - flag: quest_4_active = true
   - Collect 3x moly, 3x nightshade, 3x golden_glow
   - Garden automatically builds when items collected
   - flag: quest_4_complete = true
   - flag: garden_built = true

6. **Quest 5: Farming Tutorial**
   - Talk to Aeetes
   - flag: quest_5_active = true
   - Follow farming tutorial
   - flag: quest_5_complete = true

7. **Quest 6: Extract Sap**
   - Talk to Aeetes
   - flag: quest_6_active = true
   - Complete sap extraction process
   - flag: quest_6_complete = true

### Phase 3: Quests 7-9 (Potion Crafting)
8. **Quest 7: Calming Draught**
   - Talk to Aeetes
   - flag: quest_7_active = true
   - Collect ingredients and craft potion
   - flag: quest_7_complete = true

9. **Quest 8: Binding Ward**
   - Talk to Aeetes
   - flag: quest_8_active = true
   - Collect ingredients and craft potion
   - flag: quest_8_complete = true

10. **Quest 9: Reversal Elixir**
    - Talk to Aeetes
    - flag: quest_9_active = true
    - Collect ingredients and craft potion
    - flag: quest_9_complete = true

### Phase 4: Final Quests (10-11)
11. **Quest 10: Divine Blood**
    - Talk to Aeetes
    - flag: quest_10_active = true
    - Divine blood cutscene automatically plays
    - flag: quest_10_complete = true
    - flag: quest_11_active = true (auto-activated)

12. **Final Confrontation (Quest 11)**
    - Take boat to Scylla's Cave
    - flag: quest_11_active = true
    - Select final confrontation choice:
      - "I understand now" (understand ending)
      - "I show mercy" (mercy ending)
      - "I have a request" (request ending)
    - Petrification potion used
    - flag: scylla_petrified = true
    - flag: quest_11_complete = true
    - flag: game_complete = true

### Phase 5: Epilogue and Healer Ending
13. **Epilogue Trigger**
    - Navigate to epilogue trigger location
    - flag: epilogue_triggered = true
    - flag: epilogue_cutscene_seen = true
    - Epilogue dialogue starts

14. **Healer Ending Choice**
    - Select: "I will seek redemption. Use my magic only for good."
    - Triggers: epilogue_ending_healer dialogue
    - flag: ending_healer = true
    - flag: free_play_unlocked = true

**Expected Final State:**
```
ending_witch: false
ending_healer: true
free_play_unlocked: true
game_complete: true
quest_11_complete: true
scylla_petrified: true
```

---

## Quest Completion Summary

### All Quests (0-11) Must Be Completed for Either Ending

| Quest | ID | Description | Key Items | Required Flags |
|-------|----|-------------|-----------|----------------|
| 0 | Tutorial | Prologue with Circe | - | prologue_complete |
| 1 | Herb Collection | Find 3 glowing herbs | pharmaka_flower | quest_1_complete |
| 2 | Moly Grinding | Grind moly seeds | moly, nightshade | quest_2_complete |
| 3 | Confrontation | Face Scylla at her cove | - | quest_3_complete |
| 4 | Garden Building | Build garden with all ingredients | 3x moly, 3x nightshade, 3x golden_glow | quest_4_complete |
| 5 | Farming Tutorial | Learn to farm crops | - | quest_5_complete |
| 6 | Extract Sap | Get transformation sap | trans_sap | quest_6_complete |
| 7 | Calming Draught | Craft with Aeetes | calming_draught | quest_7_complete |
| 8 | Binding Ward | Craft with Aeetes | binding_ward | quest_8_complete |
| 9 | Reversal Elixir | Craft with Aeetes | reversal_elixir | quest_9_complete |
| 10 | Divine Blood | Ultimate crafting | divine_blood | quest_10_complete |
| 11 | Final Confrontation | Petrify Scylla | petrification_potion | quest_11_complete |

### Critical Flag Dependencies
- quest_1_complete → quest_2_active
- quest_2_complete → quest_3_active
- quest_3_complete → quest_4_active
- quest_4_complete → quest_5_active
- quest_5_complete → quest_6_active
- quest_6_complete → quest_7_active
- quest_7_complete → quest_8_active
- quest_8_complete → quest_9_active
- quest_9_complete → quest_10_active
- quest_10_complete → quest_11_active

---

## Verification Points

### During Final Confrontation (Quest 11)
```
☐ Check: 3 dialogue choices available
  - "I understand now" → act3_final_confrontation_understand
  - "I show mercy" → act3_final_confrontation_mercy
  - "I have a request" → act3_final_confrontation_request
☐ Check: petrification_potion in inventory
☐ Check: scylla_petrified flag set after choice
☐ Check: quest_11_complete flag set
☐ Check: game_complete flag set
```

### During Epilogue
```
☐ Check: epilogue_ending_choice dialogue appears
☐ Check: 2 choices available:
  - Witch choice: "I'll continue learning witchcraft..."
  - Healer choice: "I will seek redemption..."
☐ Check: Correct ending dialogue loads based on choice
☐ Check: Flags set in ending dialogue:
  - Witch: ending_witch, free_play_unlocked
  - Healer: ending_healer, free_play_unlocked
```

### After Ending Completion
```
☐ Check: Only one ending flag is set (not both)
☐ Check: free_play_unlocked is true for both endings
☐ Check: Opposite ending flag is false
☐ Check: Quest flags persist
☐ Check: Inventory remains intact
```

---

## Skip Method (For Faster Testing)

### Skip Directly to Ending Choice
```gdscript
# Use this script in debugger to skip to endings quickly
# Run from Godot console or as a temporary script

func quick_test_ending_witch():
    # Set all required flags
    get_node("/root/GameState").set_flag("quest_11_complete", true)
    get_node("/root/GameState").set_flag("game_complete", true)
    get_node("/root/GameState").set_flag("scylla_petrified", true)
    get_node("/root/GameState").set_flag("epilogue_cutscene_seen", true)
    get_node("/root/GameState").set_flag("epilogue_triggered", true)

    # Add required item
    get_node("/root/GameState").add_item("petrification_potion", 1)

    # Load epilogue scene
    get_tree().change_scene_to_file("res://game/features/cutscenes/epilogue.tscn")

    print("Ready for Witch ending test")

func quick_test_ending_healer():
    # Set all required flags
    get_node("/root/GameState").set_flag("quest_11_complete", true)
    get_node("/root/GameState").set_flag("game_complete", true)
    get_node("/root/GameState").set_flag("scylla_petrified", true)
    get_node("/root/GameState").set_flag("epilogue_cutscene_seen", true)
    get_node("/root/GameState").set_flag("epilogue_triggered", true)

    # Add required item
    get_node("/root/GameState").add_item("petrification_potion", 1)

    # Load epilogue scene
    get_tree().change_scene_to_file("res://game/features/cutscenes/epilogue.tscn")

    print("Ready for Healer ending test")
```

### Debugger Steps for Quick Testing
1. **Start Game**
   - Launch Godot with debugger (F5)
   - Create new script with quick_test_ending_witch() function

2. **Set Flags**
   - Open Variables panel
   - Manually set:
     - quest_11_complete = true
     - game_complete = true
     - scylla_petrified = true
     - epilogue_cutscene_seen = true

3. **Load Epilogue**
   - Use `get_tree().change_scene_to_file("res://game/features/cutscenes/epilogue.tscn")`
   - Or load scene via editor

4. **Test Choices**
   - Verify epilogue_ending_choice dialogue appears
   - Test both ending selections
   - Check flags are set correctly

---

## Common Issues to Verify

### Ending Choice Problems
- **Wrong dialogue loaded**: Check dialogue_id in Variables panel
- **Choice doesn't appear**: Verify quest_11_complete flag is true
- **Ending not triggered**: Check epilogue_triggered flag

### Flag Conflicts
- **Both endings set**: Should be mutually exclusive
- **Free play not unlocked**: Verify flags_to_set in ending dialogues
- **Quest flags reset**: Check game_complete flag setting

### Scene Trigger Issues
- **Epilogue doesn't start**: Verify trigger location and flags
- **Cutscene fails**: Check scene path and node references
- **Dialogue errors**: Verify dialogue resource paths

---

**Related Files:**
- `game/autoload/game_state.gd` - Flag management
- `game/features/cutscenes/epilogue.gd` - Epilogue sequence
- `game/features/world/quest_trigger.gd` - Trigger logic
- `game/shared/resources/dialogues/epilogue_ending_choice.tres`
- `game/shared/resources/dialogues/epilogue_ending_witch.tres`
- `game/shared/resources/dialogues/epilogue_ending_healer.tres`

**Testing Documentation:**
- [tests/debugger/ending_test_procedures.md](ending_test_procedures.md)
- [tests/debugger/quest_test_procedures.md](quest_test_procedures.md)