# Dialogue Choice Test Procedures

**Last Updated:** 2026-01-23
**Purpose:** Debugger-based test procedures for dialogue choice routing

---

## Quest 2: Circe's Confrontation Choices

**Test Procedure:**
```
1. Set breakpoint at game/features/ui/dialogue_box.gd:142 (_on_choice_selected)
2. Load quest2_start dialogue (requires quest_1_complete)
3. Advance dialogue to choices (after line 16)
4. At breakpoint, verify:
   - current_dialogue.choices.size() == 3
   - Choice 0: next_id = "quest2_choice_dismissive"
   - Choice 1: next_id = "quest2_choice_lying"
   - Choice 2: next_id = "quest2_choice_honest"
5. Continue and verify correct next dialogue loads
6. Verify dialogue_ended signal emitted
```

**Expected Choices:**
- "I know what I am doing." → quest2_choice_dismissive
- "I am just experimenting." → quest2_choice_lying
- "She deserves it." → quest2_choice_honest

**Key Files:**
- `game/shared/resources/dialogues/quest2_start.tres`
- `game/features/ui/dialogue_box.gd:142-151` (_on_choice_selected)

---

## Quest 3: Scylla Confrontation Choices

**Test Procedure:**
```
1. Set breakpoint at game/features/ui/dialogue_box.gd:142 (_on_choice_selected)
2. Load act1_confront_scylla dialogue
3. Advance to choices (3 transformation options)
4. At breakpoint, verify:
   - current_dialogue.choices.size() == 3
   - Choice 0: next_id points to gift outcome
   - Choice 1: next_id points to honest outcome
   - Choice 2: next_id points to cryptic outcome
5. Continue and verify transformation cutscene plays
```

**Expected Choices:**
- Gift option → Transformation with gift
- Honest option → Transformation with honesty
- Cryptic option → Transformation with cryptic message

**Key Files:**
- `game/shared/resources/dialogues/act1_confront_scylla.tres`
- `game/features/cutscenes/scylla_transformation.tscn`

---

## Epilogue: Ending Choice

**Test Procedure:**
```
1. Set breakpoint at game/features/ui/dialogue_box.gd:85 (choices visibility check)
2. Set breakpoint at game/features/ui/dialogue_box.gd:142 (_on_choice_selected)
3. In Variables panel, set:
   - quest_11_complete = true
   - game_complete = true
4. Trigger epilogue (epilogue.tscn)
5. At breakpoint 1, verify:
   - current_line_index == 4 (last line)
   - current_dialogue.choices.size() == 2
6. At breakpoint 2, verify:
   - Choice 0: "I'll continue learning witchcraft..."
   - Choice 1: "I will seek redemption..."
   - next_id: "epilogue_ending_witch" / "epilogue_ending_healer"
```

**Expected Choices:**
- Witch ending → Sets ending_witch, free_play_unlocked
- Healer ending → Sets ending_healer, free_play_unlocked

**Key Files:**
- `game/shared/resources/dialogues/epilogue_ending_choice.tres`
- `game/shared/resources/dialogues/epilogue_ending_witch.tres`
- `game/shared/resources/dialogues/epilogue_ending_healer.tres`

---

## Debug Variables for Dialogue Testing

**At _show_choices() breakpoint (dialogue_box.gd:88):**
- `current_dialogue.id` - Current dialogue ID
- `current_line_index` - Position in dialogue
- `current_dialogue.choices.size()` - Number of choices
- `current_dialogue.choices[i]["text"]` - Choice display text
- `current_dialogue.choices[i]["next_id"]` - Routing target
- `current_dialogue.choices[i]["flag_required"]` - Access requirement

**At _on_choice_selected() breakpoint (dialogue_box.gd:142):**
- `index` - Selected choice index (0, 1, 2, etc.)
- `choice` - Full choice dictionary
- `choice_made` - Signal emission pending

---

## Dialogue Choice Routing Verification

**Step-by-Step Verification:**
```
1. Set breakpoint at dialogue_box.gd:142 (_on_choice_selected)
2. Load dialogue with choices
3. Advance to choice point
4. Inspect choices array in Variables panel
5. Note each choice's next_id value
6. Continue execution
7. Verify next dialogue loads with matching ID
8. Verify dialogue_ended signal fires
9. Verify any flags_to_set are applied
```

---

## Common Issues to Check

**Choices not appearing:**
- Check current_line_index vs lines.size()
- Verify choices array is not empty
- Check flag_required conditions are met

**Wrong dialogue loads:**
- Verify next_id values in choices
- Check dialogue file exists (dialogue_ID.tres)
- Verify dialogue resource path is correct

**Flags not setting:**
- Check flags_to_set array in dialogue resource
- Verify GameState.set_flag() is called
- Check for typos in flag names

---

**Next:** See [npc_spawn_test_procedures.md](npc_spawn_test_procedures.md) for NPC testing
