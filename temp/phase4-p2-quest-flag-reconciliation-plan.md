# P2: Quest Flag Flow Reconciliation Plan

## Issues Found
From Phase 3 synthesis, these "complete_dialogue_seen" flag inconsistencies were identified:

1. `quest_8_complete_dialogue_seen`: Referenced in npc_base.gd but not defined in game_state.gd
2. `quest_11_complete_dialogue_seen`: Referenced in npc_base.gd but not defined in game_state.gd
3. `quest_3_complete_dialogue_seen`: Referenced in npc_base.gd but not defined in game_state.gd
4. No mechanism exists to SET `complete_dialogue_seen` flags after completion dialogues are shown
5. `quest_0_complete`: Initialized but never checked in dialogue gating (legacy?)
6. `garden_built`: Set in game_state.gd but never used in npc_base.gd

## Current Architecture

### How flags are set in game_state.gd:
- `quest_flags: Dictionary` stores all quest-related flags (line 20)
- `set_flag(flag: String, value: bool)` method handles flag setting and emits signal (lines 152-157)
- Flags are initialized in `new_game()` method (lines 36-46)
- Currently has no specific method for handling dialogue completion flags

### How flags are checked in npc_base.gd:
- Uses `GameState.get_flag(flag)` to check flag states throughout dialogue resolution
- Checks for `quest_X_complete_dialogue_seen` to prevent showing completion dialogues repeatedly (e.g., line 148)
- Missing quest_3_complete_dialogue_seen check in Scylla dialogue resolution (should be at line 220-222)
- Flags are used to determine which dialogue to return in `_resolve_X_dialogue()` methods

### How dialogue completion works in dialogue_box.gd:
- `_end_dialogue()` method sets flags via `flags_to_set` array (lines 175-176)
- Currently only sets flags defined in dialogue resources, no automatic handling for "complete_dialogue_seen" flags
- Emits `dialogue_ended` signal but doesn't track which dialogues have been seen

## Proposed Solution

1. **Add helper method in GameState** for setting dialogue completion flags consistently
2. **Auto-set dialogue completion flags** when dialogues end (if they represent quest completion)
3. **Fix missing flag references** in npc_base.gd
4. **Clean up unused flags** (quest_0_complete, garden_built)

## Implementation Steps

1. **Add helper method to GameState (game_state.gd)**
   - Add `mark_dialogue_completed(quest_id: String)` method
   - Automatically sets `quest_X_complete_dialogue_seen` flag when called
   - Returns boolean indicating if flag was newly set

2. **Modify DialogueBox to auto-track completion dialogues (dialogue_box.gd)**
   - Detect if current dialogue represents quest completion (via naming convention or explicit flag)
   - Call `GameState.mark_dialogue_completed()` when appropriate dialogues end
   - Track which quest completion dialogues have been shown

3. **Fix missing flag references in NPCBase (npc_base.gd)**
   - Add missing `quest_3_complete_dialogue_seen` check in Scylla dialogue resolution (around line 220-222)
   - Verify all `quest_X_complete_dialogue_seen` flags are properly referenced

4. **Update flag initialization (game_state.gd)**
   - Initialize all quest completion dialogue flags to false in `new_game()`
   - Clean up unused flags (quest_0_complete, garden_built) or implement their usage

5. **Add dialogue resource metadata support**
   - Add `is_quest_completion: bool` field to dialogue resources (optional)
   - Or use naming convention (dialogues ending with "_complete")

## Testing Approach

### Unit Tests
1. **Flag initialization test**
   - Verify all `quest_X_complete_dialogue_seen` flags are initialized to false in new_game()
   - Test flag persists through game state reset

2. **Dialogue completion tracking test**
   - Create test dialogue with quest completion marker
   - Verify `mark_dialogue_completed()` is called when dialogue ends
   - Check that completion flags are properly set

3. **NPC dialogue resolution test**
   - Verify NPCs don't repeat completion dialogues when flag is set
   - Test that new quests can still be triggered after completion

### Integration Tests
1. **Full quest flow test**
   - Complete Quest 1 through Hermes
   - Verify `quest_1_complete_dialogue_seen` is set
   - Confirm Quest 2 can still be triggered
   - Test Quest 1 completion dialogue only shows once

2. **Cross-quest verification**
   - Test multiple quest completions in sequence
   - Verify no dialogue mixing or flag conflicts
   - Check edge cases (completing quests in different order)

3. **Save/Load persistence test**
   - Complete quests, save game
   - Verify flags persist after loading
   - Test continuation from saved state

### Manual Testing Checklist
- [ ] Each quest completion dialogue shows exactly once
- [ ] NPCs return to idle dialogue after completion
- [ ] No errors when accessing non-existent flags
- [ ] Flag setting doesn't interfere with normal quest progression
- [ ] All quest_8, 9, 10, 11 completion dialogues work correctly

## Risk Assessment

### Low Risk
- Adding new helper method in GameState (backward compatible)
- Initialization of additional flags to false

### Medium Risk
- Modifying dialogue_box.gd auto-tracking logic
- Changes to npc_base.gd dialogue resolution logic

### Potential Issues
1. **Backward Compatibility**: Existing quest completion logic might expect manual flag handling
   - Mitigation: Use method name that indicates it's an "auto" or "helper" function
   - Make it opt-in initially

2. **Dialogue Resource Complexity**: Adding metadata to dialogue resources might be intrusive
   - Mitigation: Use naming convention detection as fallback
   - Add is_quest_completion field to dialogue schema

3. **Performance Impact**: Tracking additional flags might impact performance
   - Mitigation: Only track flags for actual completion dialogues
   - Benchmark before and after changes

4. **Edge Cases**: Quests that can be completed multiple times
   - Mitigation: Add check for quests that should allow repeated completion
   - Use different flag naming convention for repeatable quests

### Migration Strategy
1. Start with flag initialization fixes (lowest risk)
2. Add helper method with no auto-tracking initially
3. Implement auto-tracking with configuration option
4. Gradually enable auto-tracking for new quests