# Quest 1 & Quest 2 Fixes Documentation

## Date: January 8, 2026
## Status: COMPLETED ✅

---

## Summary

Fixed critical bugs preventing Quest 1 and Quest 2 from being human playable. All headless tests pass, and the quests are now functionally complete.

---

## Issues Found

### Quest 1: Herb Identification
**Status:** ✅ WORKING

Quest 1 was already properly implemented:
- Dialog triggers herb identification minigame correctly
- Minigame awards 3 pharmaka flowers on completion
- Sets `quest_1_complete` flag properly
- No fixes needed

### Quest 2: Extract the Sap (Mortar & Pestle Crafting)
**Status:** ✅ FIXED

**Critical Bug Found:**
- `act1_extract_sap.tres` immediately completed the quest (`flags_to_set: ["quest_2_complete"]`)
- Players never got to use the mortar & pestle crafting minigame
- Quest was completable without any gameplay

**Root Cause:**
The dialogue file set `quest_2_complete` on load, bypassing the entire crafting system.

---

## Fixes Applied

### Fix 1: Remove Instant Quest Completion

**File:** `game/shared/resources/dialogues/act1_extract_sap.tres`

**Change:**
```diff
- flags_to_set = ["quest_2_complete"]
+ flags_to_set = []
```

**Also updated dialogue text:**
```diff
- "Use the blade and collect a small vial."
+ "Use the mortar and pestle to extract the essence."
```

**Reasoning:**
- Removed instant quest completion
- Let crafting system set flag on minigame success
- Updated text to be more accurate (mortar & pestle, not blade)

### Fix 2: Add Missing Dialogue State

**File:** `game/features/npcs/npc_base.gd`

**Change:**
```diff
+	if GameState.get_flag("quest_2_active") and not GameState.get_flag("quest_2_complete"):
+		return "act1_extract_sap"
```

**Location:** Line 150-151 in `_resolve_hermes_dialogue()`

**Reasoning:**
- Added check for active quest state
- Players now see crafting instructions if they talk to Hermes during Quest 2
- Prevents confusing "hermes_idle" dialogue during quest

### Fix 3: Create Missing Item Resource

**File:** `game/shared/resources/items/transformation_sap.tres` (CREATED)

**Content:**
```gdscript
[gd_resource type="Resource" script_class="ItemData" load_steps=2 format=3]
[ext_resource type="Script" path="res://src/resources/item_data.gd" id="1_item"]

[resource]
script = ExtResource("1_item")
id = "transformation_sap"
display_name = "Transformation Sap"
description = "A potent essence extracted from pharmaka flowers. Used for transformative magic."
icon = null
stack_size = 99
sell_price = 50
category = "material"
```

**Reasoning:**
- Quest 2 crafts "transformation_sap" but this item didn't exist
- Created item resource with appropriate properties
- Registered in item registry

### Fix 4: Register Item in GameState

**File:** `game/autoload/game_state.gd`

**Change:**
```diff
	"res://game/shared/resources/items/golden_glow.tres",
	"res://game/shared/resources/items/golden_glow_seed.tres",
+	"res://game/shared/resources/items/transformation_sap.tres"
```

**Location:** Line 81 in `_load_registries()`

**Reasoning:**
- Added transformation_sap to item registry
- Required for GameState to recognize the crafted item

---

## Test Results

### Headless Tests: ALL PASS ✅

```
[OK] ALL TESTS PASSED (5/5)
[OK] ALL DIALOGUE FLOW TESTS PASSED (29/29)
[OK] ALL MINIGAME MECHANICS TESTS PASSED (24/24)
```

### Verified Components

✅ Dialogue system routes correctly
✅ Quest flags progress properly
✅ Herb identification minigame exists
✅ Mortar & pestle exists in world
✅ Crafting system exists
✅ Moly grind recipe exists
✅ Transformation sap item created and registered
✅ Quest markers exist

---

## Quest Flow (Now Working)

### Quest 1: Herb Identification
1. Complete prologue → `prologue_complete = true`
2. Talk to Hermes → `quest1_start` dialogue → sets `quest_1_active`
3. Navigate to pharmaka field
4. Play herb identification minigame (3 rounds, find 3 pharmaka each)
5. On completion → awards 3 pharmaka flowers → sets `quest_1_complete`

### Quest 2: Extract the Sap
1. After Quest 1 complete, talk to Hermes → `quest2_start` dialogue → sets `quest_2_active`
2. Talk to Hermes again (optional) → `act1_extract_sap` dialogue → crafting instructions
3. Go to house, interact with mortar & pestle
4. Play crafting minigame (12 inputs: ↑→↓← pattern, A button)
5. On success → crafts transformation sap → sets `quest_2_complete` automatically
6. Talk to Hermes → `quest3_start` dialogue

---

## Known Issues & Limitations

### Headless Testing Limitations
- Headless tests only verify LOGIC, not actual gameplay
- Cannot verify:
  - UI visibility
  - Text readability
  - Visual feedback
  - Player experience

### Manual Testing Required
To ensure human playability, the following should be tested manually in HEEDED mode:

**Quest 1:**
- [ ] Dialog box appears and is readable
- [ ] Hermes spawns at correct location
- [ ] Quest marker appears on world map
- [ ] Pharmaka field is visible and navigable
- [ ] Herb identification minigame UI is clear
- [ ] Correct plants have visible gold glow
- [ ] D-pad navigation works in minigame
- [ ] A button selection works
- [ ] Success feedback is clear
- [ ] Quest completion message appears

**Quest 2:**
- [ ] After Quest 1, Hermes offers Quest 2
- [ ] Mortar & pestle is visible in house
- [ ] Interacting with mortar & pestle opens crafting UI
- [ ] Crafting pattern is visible and clear
- [ ] D-pad inputs register correctly
- [ ] A button timing window works
- [ ] Success/failure feedback is clear
- [ ] Transformation sap appears in inventory
- [ ] Talking to Hermes after completion advances to Quest 3

---

## Files Modified

1. `game/shared/resources/dialogues/act1_extract_sap.tres` - Removed instant completion
2. `game/features/npcs/npc_base.gd` - Added quest 2 in-progress dialogue check
3. `game/shared/resources/items/transformation_sap.tres` - Created new item
4. `game/autoload/game_state.gd` - Registered transformation_sap

---

## Conclusion

Both Quest 1 and Quest 2 are now fully functional from a logic standpoint. The headless test suite passes completely. However, MANUAL HEEDED TESTING is still required to verify actual human playability, UI visibility, and player experience.

The fixes ensure that:
- Players must actually play through each quest
- The crafting system works as intended
- Quest progression is logical and clear
- No quest can be completed without proper gameplay

**Next Steps:**
- Run manual headed testing
- Verify UI visibility and readability
- Test on actual target hardware (Retroid Pocket Classic)
- Fix any visual or UX issues discovered
