# Dialogue Fix Runtime Verification

**Commit:** 69620d5
**Fix Applied:** `emit_signal("pressed")` instead of `button.pressed = true` after dialogue choice selection

## Test Procedure

```
1. Set breakpoint at game/features/ui/dialogue_box.gd:129
   (focus_owner.emit_signal("pressed") line)
2. Set breakpoint at game/features/ui/dialogue_box.gd:137
   (first_button.emit_signal("pressed") line)
3. Set breakpoint at game/features/ui/dialogue_box.gd:142
   (_on_choice_selected function)
4. Start game or load scene with dialogue choices
5. Trigger a dialogue that presents choices
6. When choices appear, navigate to a choice using keyboard/UI
7. Press ui_accept (Enter) or interact button to select the choice
8. At breakpoint 129/137, verify:
   - focus_owner is a valid Button node
   - Button text matches expected choice
   - emit_signal("pressed") is being called instead of pressed = true
9. Continue execution
10. At breakpoint 142 (_on_choice_selected), verify:
    - index parameter matches the selected choice index
    - choice dictionary contains correct data
    - choice_made signal will be emitted
```

## Expected Behavior

**Before Fix (broken behavior):**
- Dialogue choices appear normally
- User can navigate choices with keyboard/d-pad
- When pressing ui_accept, choice selection appears to work (button shows as pressed)
- Dialogue does NOT advance to the next dialogue
- Player is stuck on the current choice screen

**After Fix (working behavior):**
- Dialogue choices appear normally
- User can navigate choices with keyboard/d-pad
- When pressing ui_accept, the button properly emits the "pressed" signal
- Dialogue advances to the next dialogue as expected
- Choice selection is properly registered and routed

## Breakpoint Verification

**Primary Breakpoints:**
- Line 129: `focus_owner.emit_signal("pressed")` - When focused choice is activated
- Line 137: `first_button.emit_signal("pressed")` - When first choice is activated (no focus)
- Line 142: `_on_choice_selected(index, choice)` - Verify choice processing

**Verification Points at Breakpoint:**
- At lines 129/137: Confirm `emit_signal("pressed")` is called (not `pressed = true`)
- At line 142: Verify `index` and `choice` parameters are correct
- Continue and confirm dialogue advances properly

## Debug Variables for Testing

**At _activate_choice_from_input() breakpoint:**
- `focus_owner.text` - The selected choice text
- `focus_owner.pressed` - Should be true after emit_signal
- `choices_container.visible` - Should be true
- `current_dialogue.choices.size()` - Number of available choices

**At _on_choice_selected() breakpoint:**
- `index` - Selected choice index (0, 1, 2...)
- `choice.text` - Selected choice display text
- `choice.next_id` - Next dialogue to load
- `current_dialogue.id` - Current dialogue ID

## Common Issues to Check

**Fix Not Working:**
- Verify breakpoint is being hit when ui_accept is pressed
- Check if focus_owner is properly set to a Button
- Ensure choices_container is visible
- Confirm Button node has proper signal connections

**Input Issues:**
- Verify ui_accept action is properly configured in Input Map
- Check if input is being handled correctly (viewport.set_input_as_handled())
- Test with both keyboard and gamepad input methods

**Dialogue Flow Issues:**
- Verify choice.next_id points to valid dialogue
- Check if dialogue resource exists (.tres file)
- Ensure _end_dialogue() and start_dialogue() are called properly

**Focus Issues:**
- Verify grab_focus() is called when choices appear
- Check if button focus is lost during gameplay
- Test fallback behavior when no button is focused

## Test Scenarios

**Scenario 1: Hermes Choice Dialogue (Phase 7 P1)**
1. Load quest requiring Hermes dialogue with choices
2. Navigate to choices section
3. Select choice using ui_accept
4. Verify dialogue advances correctly

**Scenario 2: Keyboard Navigation Test**
1. Start dialogue with multiple choices
2. Use Tab/Arrow keys to navigate between choices
3. Press Enter to select focused choice
4. Verify selection registers and advances dialogue

**Scenario 3: Gamepad Navigation Test**
1. Start dialogue with multiple choices
2. Use D-pad to navigate between choices
3. Press A button (or configured interact button) to select
4. Verify selection works with gamepad input

## Verification Checklist

- [ ] emit_signal("pressed") is called instead of pressed = true
- [ ] Focus management works correctly
- [ ] Both keyboard and gamepad inputs work
- [ ] Dialogue advances after choice selection
- [ ] Choice routing works correctly
- [ ] No stuck states or infinite loops
- [ ] Debug logs show correct activation sequence