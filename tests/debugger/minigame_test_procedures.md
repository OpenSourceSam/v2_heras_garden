# Minigame Completion Test Procedures

**Last Updated:** 2026-01-23
**Purpose:** Debugger-based test procedures for minigame completion flow

---

## Herb Identification Minigame

**Test Procedure:**
```
1. Set breakpoint at game/features/minigames/herb_identification.gd:106 (success emit)
2. Set breakpoint at game/features/minigames/herb_identification.gd:94 (failure emit)
3. Trigger herb ID minigame (quest 1 or 6)
4. Complete minigame (or skip by setting completion flag)
5. At success breakpoint, verify:
   - success == true
   - items == ["pharmaka_flower", "pharmaka_flower", "pharmaka_flower"]
     OR ["saffron", "saffron", "saffron"]
6. At failure breakpoint (if triggered):
   - success == false
   - items == []
```

**Expected State:**
- Success: 3 items awarded to inventory
- Failure: No items, quest may not advance
- Quest 1: Awards pharmaka_flower (tutorial mode)
- Quest 6: Awards saffron (regular mode)

**Key Files:**
- `game/features/minigames/herb_identification.gd:94-106` (completion emits)

---

## Sacred Earth Minigame

**Test Procedure:**
```
1. Set breakpoint at game/features/minigames/sacred_earth.gd:81 (success emit)
2. Set breakpoint at game/features/minigames/sacred_earth.gd:89 (failure emit)
3. Trigger Sacred Earth minigame (quest 9)
4. Complete minigame (catch moon tears)
5. At success breakpoint, verify:
   - success == true
   - items == ["sacred_earth", "sacred_earth", "sacred_earth"]
6. At failure breakpoint (if time runs out):
   - success == false
   - items == []
```

**Expected State:**
- Success: 3 sacred_earth items awarded
- Failure: No items, time ran out
- Quest 9 completes on success

**Key Files:**
- `game/features/minigames/sacred_earth.gd:81-89` (completion emits)

---

## Weaving Minigame

**Test Procedure:**
```
1. Set breakpoint at game/features/minigames/weaving_minigame.gd:89 (success emit)
2. Set breakpoint at game/features/minigames/weaving_minigame.gd:96 (failure emit)
3. Trigger weaving minigame (quest 7)
4. Complete pattern matching minigame
5. At success breakpoint, verify:
   - success == true
   - items == ["woven_cloth"]
6. Continue and verify scene change to Constants.SCENE_WORLD
7. Verify quest_7_complete flag is set
```

**Expected State:**
- Success: 1 woven_cloth item awarded
- Failure: No items after 3 mistakes
- Auto scene transition to world
- Quest 7 completes on success

**Key Files:**
- `game/features/minigames/weaving_minigame.gd:89-96` (completion emits)

---

## Crafting Minigames (Grinding, Elixirs, Ward)

**Test Procedure:**
```
1. Set breakpoint at game/features/ui/crafting_controller.gd:84 (completion emit)
2. Trigger crafting minigame via mortar/pestle or crafting station
3. Complete crafting pattern
4. At breakpoint, verify:
   - crafted_item == expected item from recipe
   - quest flag set (if applicable)
```

**Crafting Minigames:**
- Grinding (quest 2): moly_grind → moly
- Calming Draught (quest 5): calming_draught
- Reversal Elixir (quest 6): reversal_elixir
- Binding Ward (quest 8): binding_ward
- Petrification Potion (quest 11): petrification_potion

**Expected State:**
- Success: Crafted item added to inventory
- Quest-specific flags may be set
- Failure cutscenes may trigger for quests 5/6/8

**Key Files:**
- `game/features/ui/crafting_controller.gd:84-106` (completion handling)

---

## Debug Variables for Minigame Testing

**At minigame_complete signal emit:**
- `success` - Boolean true/false
- `items` - Array of item IDs awarded
- `GameState.inventory` - Verify items added
- `GameState.quest_flags` - Verify quest completion

**Common Signal Pattern:**
```
minigame_complete.emit(success, items)
↓
Dialogue/quest system receives signal
↓
Items added to inventory
↓
Quest flags updated
↓
Next quest activated
```

---

## Minigame Completion Verification Steps

**Complete Minigame Flow Test:**
```
1. Set breakpoint at minigame completion emit
2. Set breakpoint at GameState.set_flag() for quest completion
3. Complete minigame (or skip via debugger)
4. At first breakpoint, verify:
   - success == true
   - items array is correct
5. At second breakpoint, verify:
   - quest_N_complete flag is set
   - Next quest flag may be activated
6. Check Variables panel for inventory updates
7. Verify scene returns to world (if applicable)
```

---

## Common Issues to Check

**Items not awarded:**
- Verify items array is not empty
- Check GameState.inventory after completion
- Verify item IDs match database

**Quest not advancing:**
- Check if quest flag is set after minigame
- Verify signal connection to quest system
- Check for failure conditions

**Scene not returning:**
- Verify scene change logic in minigame script
- Check Constants.SCENE_WORLD reference
- Verify cutscene doesn't block return

---

## Minigame Skip Testing

**Skip via Debugger Variables Panel:**
```
1. Start game with F5 debugger
2. Set breakpoint at any location
3. In Variables panel, find quest_flags
4. Double-click quest_N_complete: false → true
5. Press F5 to continue
6. Verify next quest activates
```

**Use for:**
- Testing quest flow without playing minigames
- Skipping to specific quest states
- Validating quest flag dependencies

---

**Next:** See [ending_test_procedures.md](ending_test_procedures.md) for ending testing
