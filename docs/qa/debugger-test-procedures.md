# Debugger Test Procedures

**Last Updated:** 2026-01-23
**Environment:** Cursor IDE / VS Code Extension
**Based on:** `DEBUGGER_TESTING_GUIDE.md`
**Purpose:** Specific, step-by-step procedures for testing game systems using F5 debugger breakpoints

---

## Table of Contents

1. [Quest Flag Testing](#quest-flag-testing)
2. [Dialogue Choice Testing](#dialogue-choice-testing)
3. [NPC Spawn Testing](#npc-spawn-testing)
4. [Cutscene Completion Testing](#cutscene-completion-testing)

---

## Quest Flag Testing

### Primary Breakpoint Location

**File:** `c:\Users\Sam\Documents\GitHub\v2_heras_garden\game\autoload\game_state.gd`

**Function:** `set_flag(flag: String, value: bool = true)`
**Breakpoint Line:** 152

### What to Inspect

When breakpoint hits at line 152, check the Variables Panel:

| Variable | Type | Description |
|----------|------|-------------|
| `flag` | String | The flag name being set |
| `value` | bool | The value being assigned (usually true) |
| `quest_flags` | Dictionary | All quest flags (expand to see all) |
| `self` | GameState | Expand to see full state |

### All Quest Flags to Verify

#### Quest Progression Flags (quest_0 through quest_11)

| Flag Name | Expected Set Location | How to Trigger |
|-----------|----------------------|----------------|
| `quest_0_active` | `game_state.gd:45` | New game start |
| `prologue_complete` | `game_state.gd:46` | New game start |
| `quest_1_active` | Set via dialogue | Complete prologue |
| `quest_1_complete` | `quest1_complete.tres:31` | Deliver correct herb to Hermes |
| `quest_1_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest1_complete dialogue ends |
| `quest_2_active` | `quest1_choice_*.tres:31` | Any Quest 1 choice (gift/honest/cryptic) |
| `quest_2_complete` | `crafting_controller.gd:82` | Complete moly_grind crafting minigame |
| `quest_3_active` | `quest3_start.tres:13` | Talk to Hermes after Quest 2 |
| `quest_3_complete` | `scylla_transformation.gd:23` | Scylla transformation cutscene ends |
| `quest_4_active` | Set via dialogue | Talk to Aeetes after Quest 3 |
| `quest_4_complete` | `game_state.gd:128` | Auto-completion: have 3+ moly, nightshade, golden_glow |
| `quest_4_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest4_complete dialogue ends |
| `quest_5_active` | Set via dialogue | Complete Quest 4 |
| `quest_5_complete` | `crafting_controller.gd:84` | Complete calming_draught crafting |
| `quest_5_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest5_complete dialogue ends |
| `quest_6_active` | Set via dialogue | Complete Quest 5 |
| `quest_6_complete` | `crafting_controller.gd:86` | Complete reversal_elixir crafting |
| `quest_6_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest6_complete dialogue ends |
| `quest_7_active` | Set via dialogue | Complete Quest 6 |
| `quest_7_complete` | Set via dialogue | Complete Daedalus quest (weaving minigame) |
| `quest_7_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest7_complete dialogue ends |
| `quest_8_active` | Set via dialogue | Complete Quest 7 |
| `quest_8_complete` | `crafting_controller.gd:88` | Complete binding_ward crafting |
| `quest_8_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest8_complete dialogue ends |
| `quest_9_active` | Set via dialogue | Complete Quest 8 |
| `quest_9_complete` | Set via dialogue | Collect moon tears (Sacred Grove) |
| `quest_9_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest9_complete dialogue ends |
| `quest_10_active` | Set via dialogue | Complete Quest 9 |
| `quest_10_complete` | `crafting_controller.gd:90` | Complete petrification_potion crafting |
| `quest_10_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest10_complete dialogue ends |
| `quest_11_active` | Set via dialogue | Complete Quest 10 |
| `quest_11_complete` | `scylla_petrification.gd:17` | Scylla petrification cutscene ends |
| `quest_11_complete_dialogue_seen` | `dialogue_box.gd:183` | Auto-set when quest11_complete dialogue ends |

#### Completion Dialogue Seen Flags

These track which completion dialogues have been shown:

| Flag Name | Purpose |
|-----------|---------|
| `quest_1_complete_dialogue_seen` | Marks quest1_complete.tres as viewed |
| `quest_2_complete_dialogue_seen` | Marks quest2_complete dialogue as viewed (if exists) |
| `quest_3_complete_dialogue_seen` | Marks quest3_complete dialogue as viewed (if exists) |
| `quest_4_complete_dialogue_seen` | Marks quest4_complete.tres as viewed |
| `quest_5_complete_dialogue_seen` | Marks quest5_complete.tres as viewed |
| `quest_6_complete_dialogue_seen` | Marks quest6_complete.tres as viewed |
| `quest_7_complete_dialogue_seen` | Marks quest7_complete.tres as viewed |
| `quest_8_complete_dialogue_seen` | Marks quest8_complete.tres as viewed |
| `quest_9_complete_dialogue_seen` | Marks quest9_complete.tres as viewed |
| `quest_10_complete_dialogue_seen` | Marks quest10_complete.tres as viewed |
| `quest_11_complete_dialogue_seen` | Marks quest11_complete.tres as viewed |

**Note:** These are auto-set by `dialogue_box.gd:173-183` when a dialogue ending with `_complete` ends.

#### Ending and Special Flags

| Flag Name | Set Location | Purpose |
|-----------|--------------|---------|
| `transformed_scylla` | `scylla_transformation.gd:22` | Marks that Scylla was transformed |
| `scylla_petrified` | `scylla_petrification.gd:16` | Marks that Scylla was petrified |
| `game_complete` | `scylla_petrification.gd:18` | Main story completed |
| `epilogue_seen` | `epilogue_circe.tres:31` | Epilogue dialogue viewed |
| `epilogue_cutscene_seen` | `epilogue.gd:34` | Epilogue cutscene viewed |
| `free_play_unlocked` | `epilogue_ending_*.tres:17` | Post-game unlocked |
| `ending_witch` | `epilogue_ending_witch.tres:17` | Chose witch ending |
| `ending_healer` | `epilogue_ending_healer.tres:17` | Chose healer ending |

### Test Procedure

1. **Set breakpoint** at `game_state.gd:152`
2. **Start game** with F5 (Debug Main Scene)
3. **Trigger quest action** (e.g., talk to NPC, complete crafting)
4. **When breakpoint hits:**
   - Check `flag` parameter shows expected flag name
   - Check `value` is `true` (or expected value)
   - Expand `quest_flags` to verify flag appears
5. **Press F5** to continue
6. **Verify flag persists** by checking `quest_flags` in Variables panel after game resumes

### Common Test Patterns

**Pattern 1: Skip to Quest X (for testing later content)**
```
1. Set breakpoint at game_state.gd:152 (set_flag)
2. Start game with F5
3. When breakpoint hits on initial flags, press F5 to continue
4. After game loads, open Variables panel
5. Expand self.quest_flags
6. Double-click values to modify:
   - quest_1_complete: false → true
   - quest_2_active: false → true
7. Press F5 to resume
```

**Pattern 2: Verify Quest 4 Auto-Completion**
```
1. Set breakpoint at game_state.gd:152 (set_flag)
2. Set breakpoint at game_state.gd:124 (_check_quest4_completion)
3. Start game and progress to Quest 4
4. Use Variables panel to add items:
   - moly: 3
   - nightshade: 3
   - golden_glow: 3
5. Trigger any add_item() call
6. Verify breakpoint at line 124 hits
7. Continue and verify quest_4_complete flag is set
```

---

## Dialogue Choice Testing

### Primary Breakpoint Locations

**File:** `c:\Users\Sam\Documents\GitHub\v2_heras_garden\game\features\ui\dialogue_box.gd`

**Key Functions:**
- `start_dialogue(dialogue_id: String)` - Line 25
- `_show_choices()` - Line 88
- `_on_choice_selected(index: int, choice: Dictionary)` - Line 142

### What to Inspect

When breakpoint hits at line 142, check the Variables Panel:

| Variable | Type | Description |
|----------|------|-------------|
| `index` | int | Index of selected choice (0-based) |
| `choice` | Dictionary | Full choice data |
| `choice["text"]` | String | Display text of choice |
| `choice["next_id"]` | String | Dialogue ID this choice leads to |
| `choice["flag_required"]` | String | Flag required to show this choice |
| `current_dialogue` | DialogueData | Current dialogue object |
| `current_dialogue.choices` | Array | All available choices |

### Quest 1 Choices (Hermes - After Herb Identification)

**Dialogue ID:** `quest1_complete` or `quest1_choice_*` dialogues

**Breakpoint:** `dialogue_box.gd:142` (`_on_choice_selected`)

**Choices to Test:**

| Choice Text | Dialogue ID | Expected Next Dialogue | Expected Flags Set |
|-------------|-------------|------------------------|-------------------|
| "I brought you a gift." | N/A (not applicable for Quest 1) | N/A | N/A |
| "To be honest, Scylla sent me." | N/A | N/A | N/A |
| "Just experimenting." | N/A | N/A | N/A |

**Note:** Quest 1 completion (`quest1_complete.tres`) does NOT have branching choices. The choices in Quest 1 happen during the herb identification phase. Check `quest1_choice_honest.tres`, `quest1_choice_lying.tres`, `quest1_choice_dismissive.tres` - these all set `quest_2_active` at line 31.

**Test Procedure:**
1. Set breakpoint at `dialogue_box.gd:142`
2. Start game and complete Quest 1 herb identification
3. When dialogue with choices appears, select a choice
4. When breakpoint hits, inspect `choice` dictionary
5. Verify `choice["next_id"]` matches expected dialogue
6. Press F5 and verify next dialogue loads correctly

### Quest 3 Choices (Confronting Scylla)

**Dialogue ID:** `act1_confront_scylla`

**Breakpoint:** `dialogue_box.gd:142` (`_on_choice_selected`)

**Choices to Test:**

| Choice Text | Next Dialogue ID | Expected Outcome |
|-------------|------------------|------------------|
| "I brought you a gift." | `act1_confront_scylla_gift` | Scylla transformation cutscene triggers |
| "You took him from me." | `act1_confront_scylla_honest` | Scylla transformation cutscene triggers |
| "I am here to fix a mistake." | `act1_confront_scylla_cryptic` | Scylla transformation cutscene triggers |

**Test Procedure:**
1. Set breakpoint at `dialogue_box.gd:142`
2. Progress to Quest 3 (Scylla confrontation)
3. Set `quest_2_complete = true` in Variables panel to skip ahead
4. Talk to Circe to trigger `quest3_confrontation`
5. Travel to Scylla's Cove and talk to Scylla
6. When dialogue choices appear, select a choice
7. When breakpoint hits:
   - Check `choice["text"]` matches your selection
   - Check `choice["next_id"]` matches expected dialogue
8. Press F5 and verify correct dialogue loads
9. After dialogue ends, verify `scylla_transformation.tscn` cutscene plays

**Expected Flags After Cutscene:**
- `transformed_scylla = true` (set at `scylla_transformation.gd:22`)
- `quest_3_complete = true` (set at `scylla_transformation.gd:23`)

### Quest 11 Choices (Final Confrontation)

**Dialogue ID:** `act3_final_confrontation`

**Breakpoint:** `dialogue_box.gd:142` (`_on_choice_selected`)

**Choices to Test:**

| Choice Text | Next Dialogue ID | Purpose |
|-------------|------------------|---------|
| "I'll understand if you hate me." | `act3_final_confrontation_understand` | Narrative variation |
| "This is the only mercy I can offer." | `act3_final_confrontation_mercy` | Narrative variation |
| "Tell me what you want." | `act3_final_confrontation_request` | Narrative variation |

**Test Procedure:**
1. Set breakpoint at `dialogue_box.gd:142`
2. Skip to Quest 11 by setting flags in Variables panel:
   - `quest_10_complete = true`
   - `quest_11_active = true`
   - Add `petrification_potion` to inventory (use `inventory` dict)
3. Go to Scylla's Cove and talk to Scylla
4. When dialogue choices appear, select a choice
5. When breakpoint hits:
   - Check `choice["text"]` matches your selection
   - Check `choice["next_id"]` matches expected dialogue
6. Press F5 and verify correct dialogue loads
7. After dialogue ends, verify `scylla_petrification.tscn` cutscene plays

**Expected Flags After Cutscene:**
- `scylla_petrified = true` (set at `scylla_petrification.gd:16`)
- `quest_11_complete = true` (set at `scylla_petrification.gd:17`)
- `game_complete = true` (set at `scylla_petrification.gd:18`)

### Epilogue Choices (Ending Selection)

**Dialogue ID:** `epilogue_ending_choice`

**Breakpoint:** `dialogue_box.gd:142` (`_on_choice_selected`)

**Choices to Test:**

| Choice Text | Next Dialogue ID | Expected Flags Set |
|-------------|------------------|-------------------|
| "I'll continue learning witchcraft. Help those who come to me." | `epilogue_ending_witch` | `ending_witch = true`, `free_play_unlocked = true` |
| "I will seek redemption. Use my magic only for good." | `epilogue_ending_healer` | `ending_healer = true`, `free_play_unlocked = true` |

**Test Procedure:**
1. Set breakpoint at `dialogue_box.gd:142`
2. Skip to epilogue by setting flags:
   - `quest_11_complete = true`
   - `game_complete = true`
3. Talk to Circe to trigger `epilogue_circe` dialogue
4. After dialogue ends, epilogue cutscene plays
5. After cutscene, `epilogue_ending_choice` dialogue appears
6. When dialogue choices appear, select a choice
7. When breakpoint hits:
   - Check `choice["text"]` matches your selection
   - Check `choice["next_id"]` matches expected dialogue
8. Press F5 and verify ending dialogue loads
9. After dialogue ends, check Variables panel for ending flags

**Expected Flags After Epilogue:**
- `epilogue_seen = true` (set by `epilogue_circe.tres:31`)
- `epilogue_cutscene_seen = true` (set by `epilogue.gd:34`)
- `ending_witch = true` OR `ending_healer = true` (set by ending dialogue)
- `free_play_unlocked = true` (set by ending dialogue)

### General Dialogue Choice Test Pattern

**For ANY dialogue with choices:**

1. Set breakpoint at `dialogue_box.gd:142`
2. Start dialogue with choices
3. Select a choice in-game
4. When breakpoint hits, verify:
   ```
   choice["text"] == "Expected choice text"
   choice["next_id"] == "expected_next_dialogue_id"
   choice.get("flag_required", "") == "" (or expected flag)
   ```
5. Press F5 to continue
6. Verify next dialogue loads correctly

---

## NPC Spawn Testing

### Primary Breakpoint Location

**File:** `c:\Users\Sam\Documents\GitHub\v2_heras_garden\game\features\npcs\npc_spawner.gd`

**Key Functions:**
- `_ready()` - Line 13 (initial spawn check)
- `_on_flag_changed(_flag: String, _value: bool)` - Line 17 (reactive spawn check)
- `_update_npcs()` - Line 20 (main spawn logic)
- `_spawn_npc(npc_id: String)` - Line 56 (individual NPC spawn)

### What to Inspect

When breakpoint hits at line 20 (`_update_npcs`), check the Variables Panel:

| Variable | Type | Description |
|----------|------|-------------|
| `spawned_npcs` | Dictionary | Currently spawned NPCs (key = npc_id, value = Node) |
| `GameState.quest_flags` | Dictionary | All quest flags |
| `self` | NPCSpawner | Spawn point references |

### Hermes Spawn Testing

**Spawn Conditions:**
```gdscript
# npc_spawner.gd:22-26
_set_npc_visible("hermes",
    (GameState.get_flag("prologue_complete") and
     not GameState.get_flag("quest_3_complete")) or
    (GameState.get_flag("quest_3_complete") and
     not GameState.get_flag("quest_4_active")))
```

**Test Cases:**

| Test Case | Flags to Set | Expected Result |
|-----------|--------------|-----------------|
| Hermes appears after prologue | `prologue_complete = true` | Hermes spawned |
| Hermes disappears after Quest 3 | `quest_3_complete = true` | Hermes despawned |
| Hermes reappears before Quest 4 | `quest_3_complete = true`, `quest_4_active = false` | Hermes spawned |
| Hermes gone after Quest 4 starts | `quest_4_active = true` | Hermes despawned |

**Test Procedure:**
1. Set breakpoint at `npc_spawner.gd:20`
2. Start game with F5
3. When breakpoint hits, check `spawned_npcs` dictionary
4. Verify Hermes appears when expected
5. Modify flags in Variables panel and trigger flag change
6. Verify breakpoint hits again and Hermes spawns/despawns correctly

### Aeetes Spawn Testing

**Spawn Conditions:**
```gdscript
# npc_spawner.gd:28-33
_set_npc_visible("aeetes",
    (GameState.get_flag("quest_3_complete") and not GameState.get_flag("quest_7_active")) or
    GameState.get_flag("quest_4_active") or
    GameState.get_flag("quest_5_active") or
    GameState.get_flag("quest_6_active"))
```

**Test Cases:**

| Test Case | Flags to Set | Expected Result |
|-----------|--------------|-----------------|
| Aeetes appears after Quest 3 | `quest_3_complete = true` | Aeetes spawned |
| Aeetes present during Quest 4 | `quest_4_active = true` | Aeetes spawned |
| Aeetes present during Quest 5 | `quest_5_active = true` | Aeetes spawned |
| Aeetes present during Quest 6 | `quest_6_active = true` | Aeetes spawned |
| Aeetes disappears after Quest 6 | `quest_6_complete = true`, `quest_7_active = false` | Aeetes spawned |
| Aeetes gone after Quest 7 starts | `quest_7_active = true` | Aeetes despawned |

**Test Procedure:**
1. Set breakpoint at `npc_spawner.gd:20`
2. Skip to Quest 3 completion by setting flags:
   - `prologue_complete = true`
   - `quest_3_complete = true`
3. Trigger flag change by modifying any flag
4. When breakpoint hits, check `spawned_npcs` contains "aeetes"
5. Progress through quests 4-6, verify Aeetes remains spawned
6. Set `quest_7_active = true` and verify Aeetes despawns

### Daedalus Spawn Testing

**Spawn Conditions:**
```gdscript
# npc_spawner.gd:35-38
_set_npc_visible("daedalus",
    GameState.get_flag("quest_7_active") or
    GameState.get_flag("quest_8_active"))
```

**Test Cases:**

| Test Case | Flags to Set | Expected Result |
|-----------|--------------|-----------------|
| Daedalus not present before Quest 7 | `quest_6_complete = true` | Daedalus not spawned |
| Daedalus appears during Quest 7 | `quest_7_active = true` | Daedalus spawned |
| Daedalus present during Quest 8 | `quest_8_active = true` | Daedalus spawned |
| Daedalus disappears after Quest 8 | `quest_8_complete = true` | Daedalus despawned |

**Test Procedure:**
1. Set breakpoint at `npc_spawner.gd:20`
2. Skip to Quest 7 by setting flags:
   - `quest_6_complete = true`
   - `quest_7_active = true`
3. Trigger flag change
4. When breakpoint hits, check `spawned_npcs` contains "daedalus"
5. Set `quest_8_active = true` and verify Daedalus remains
6. Set `quest_8_complete = true` and verify Daedalus despawns

### Scylla Spawn Testing

**Spawn Conditions:**
```gdscript
# npc_spawner.gd:40-45
_set_npc_visible("scylla",
    GameState.get_flag("quest_8_active") or
    GameState.get_flag("quest_9_active") or
    GameState.get_flag("quest_10_active") or
    GameState.get_flag("quest_11_active"))
```

**Test Cases:**

| Test Case | Flags to Set | Expected Result |
|-----------|--------------|-----------------|
| Scylla appears during Quest 8 | `quest_8_active = true` | Scylla spawned |
| Scylla present during Quest 9 | `quest_9_active = true` | Scylla spawned |
| Scylla present during Quest 10 | `quest_10_active = true` | Scylla spawned |
| Scylla present during Quest 11 | `quest_11_active = true` | Scylla spawned |
| Scylla disappears after Quest 11 | `quest_11_complete = true` | Scylla despawned |

**Test Procedure:**
1. Set breakpoint at `npc_spawner.gd:20`
2. Skip to Quest 8 by setting flags:
   - `quest_7_complete = true`
   - `quest_8_active = true`
3. Trigger flag change
4. When breakpoint hits, check `spawned_npcs` contains "scylla"
5. Progress through quests 9-11, verify Scylla remains spawned
6. Set `quest_11_complete = true` and verify Scylla despawns

### NPC Spawn Test Pattern

**For ANY NPC spawn verification:**

1. Set breakpoint at `npc_spawner.gd:20`
2. Start game with F5
3. When breakpoint hits on `_ready()`, check initial `spawned_npcs`
4. Modify quest flags in Variables panel
5. Trigger flag change by calling `GameState.set_flag("any_flag", true)` in Debug Console
6. When breakpoint hits on `_on_flag_changed()`, check updated `spawned_npcs`
7. Verify NPCs match expected spawn conditions
8. Press F5 to continue

---

## Cutscene Completion Testing

### Primary Breakpoint Locations

**File:** Various cutscene scripts in `game/features/cutscenes/`

**Pattern:** All cutscenes end with flag-setting and `cutscene_finished.emit()`

### What to Inspect

When breakpoint hits at a cutscene's final flag set, check the Variables Panel:

| Variable | Type | Description |
|----------|------|-------------|
| `GameState.quest_flags` | Dictionary | All quest flags (expand to see updates) |
| `current_cutscene` | Node | Current cutscene instance |

### Cutscene List and Expected Flags

#### 1. Prologue Opening

**File:** `c:\Users\Sam\Documents\GitHub\v2_heras_garden\game\features\cutscenes\prologue_opening.gd`

**Breakpoint Line:** Find the final `GameState.set_flag()` call

**Expected Flags:**
- `prologue_complete = true`

**Test Procedure:**
1. Set breakpoint at final `GameState.set_flag()` call in `prologue_opening.gd`
2. Start new game with F5
3. When breakpoint hits, verify `prologue_complete` is being set
4. Press F5 to continue
5. Verify game loads into World scene

#### 2. Scylla Transformation

**File:** `c:\Users\Sam\Documents\GitHub\v2_heras_garden\game\features\cutscenes\scylla_transformation.gd`

**Breakpoint Lines:** 22-23

**Expected Flags:**
- `transformed_scylla = true` (line 22)
- `quest_3_complete = true` (line 23)

**Test Procedure:**
1. Set breakpoints at `scylla_transformation.gd:22` and `:23`
2. Skip to Quest 3 by setting flags:
   - `quest_2_complete = true`
   - `quest_3_active = true`
3. Go to Scylla's Cove and complete confrontation dialogue
4. When cutscene plays, verify both breakpoints hit
5. Check Variables panel after each breakpoint
6. Verify scene changes to `scylla_cove.tscn` after cutscene

#### 3. Scylla Petrification

**File:** `c:\Users\Sam\Documents\GitHub\v2_heras_garden\game\features\cutscenes\scylla_petrification.gd`

**Breakpoint Lines:** 16-18

**Expected Flags:**
- `scylla_petrified = true` (line 16)
- `quest_11_complete = true` (line 17)
- `game_complete = true` (line 18)

**Test Procedure:**
1. Set breakpoints at `scylla_petrification.gd:16`, `:17`, `:18`
2. Skip to Quest 11 by setting flags:
   - `quest_10_complete = true`
   - `quest_11_active = true`
   - Add `petrification_potion` to inventory
3. Go to Scylla's Cove and complete final confrontation
4. When cutscene plays, verify all three breakpoints hit in order
5. Check Variables panel after each breakpoint
6. Verify scene changes to World after cutscene

#### 4. Epilogue

**File:** `c:\Users\Sam\Documents\GitHub\v2_heras_garden\game\features\cutscenes\epilogue.gd`

**Breakpoint Line:** 34

**Expected Flags:**
- `epilogue_cutscene_seen = true` (line 34)

**Test Procedure:**
1. Set breakpoint at `epilogue.gd:34`
2. Skip to epilogue by setting flags:
   - `quest_11_complete = true`
   - `game_complete = true`
3. Talk to Circe to trigger `epilogue_circe` dialogue
4. When dialogue ends, epilogue cutscene plays
5. When breakpoint hits, verify `epilogue_cutscene_seen` is being set
6. Press F5 to continue
7. Verify `epilogue_ending_choice` dialogue starts automatically

#### 5. Failed Minigame Cutscenes

**Files:**
- `calming_draught_failed.gd`
- `reversal_elixir_failed.gd`
- `binding_ward_failed.gd`

**Breakpoint Location:** Final `GameState.set_flag()` call in each

**Expected Behavior:** These cutscenes typically don't set completion flags, but may set retry flags or reset quest state

**Test Procedure:**
1. Set breakpoint at final flag set in failed cutscene
2. Start corresponding minigame
3. Intentionally fail the minigame
4. When breakpoint hits, verify appropriate flags are set
5. Press F5 to continue
6. Verify player can retry the minigame

### Cutscene Completion Test Pattern

**For ANY cutscene:**

1. Locate cutscene script in `game/features/cutscenes/`
2. Find the final `GameState.set_flag()` calls
3. Set breakpoints at each flag set
4. Trigger cutscene (skip to required quest state if needed)
5. When breakpoints hit:
   - Verify flag name is correct
   - Verify value is `true`
   - Check `quest_flags` in Variables panel to confirm flag is set
6. Press F5 to continue
7. Verify `cutscene_finished.emit()` is called
8. Verify scene transition occurs (if applicable)

---

## Quick Reference: Common Breakpoints

| Purpose | File | Line | Function |
|---------|------|------|----------|
| All flag changes | `game_state.gd` | 152 | `set_flag()` |
| Flag retrieval | `game_state.gd` | 159 | `get_flag()` |
| Quest 4 auto-completion | `game_state.gd` | 124 | `_check_quest4_completion()` |
| Dialogue starts | `dialogue_box.gd` | 25 | `start_dialogue()` |
| Choices shown | `dialogue_box.gd` | 88 | `_show_choices()` |
| Choice selected | `dialogue_box.gd` | 142 | `_on_choice_selected()` |
| Dialogue ends | `dialogue_box.gd` | 173 | `_end_dialogue()` |
| NPC spawn updates | `npc_spawner.gd` | 20 | `_update_npcs()` |
| NPC spawns | `npc_spawner.gd` | 56 | `_spawn_npc()` |
| NPC despawns | `npc_spawner.gd` | 64 | `_despawn_npc()` |
| Cutscene plays | `cutscene_manager.gd` | 7 | `play_cutscene()` |

---

## Troubleshooting

### Breakpoint Not Hitting

**Problem:** Set breakpoint but it never triggers

**Solutions:**
1. Verify debugger is running (F5, not just Play)
2. Check correct file is being executed (use print statements to verify)
3. Verify line numbers match (code may have changed)
4. Check for conditional breakpoints that might not be met

### Variables Panel Read-Only

**Problem:** Can't modify values in Variables panel

**Solutions:**
1. Game must be paused at a breakpoint
2. Set breakpoint first, then inspect variables
3. Double-click value to edit (don't right-click)

### Can't Find quest_flags

**Problem:** Don't see quest_flags in Variables panel

**Solutions:**
1. Make sure you're expanded the correct node (look for `self` → `quest_flags`)
2. Use Debug Console to execute: `GameState.quest_flags`
3. Check that GameState autoload is loaded

### Wrong Scene Debugging

**Problem:** Breakpoint hits in wrong scene

**Solutions:**
1. Use "Debug Main Scene" not "Play"
2. Check launch configuration in `.vscode/launch.json`
3. Verify Main Scene is set in Project Settings

---

## Additional Resources

**Related Documentation:**
- `DEBUGGER_TESTING_GUIDE.md` - Overall debugger testing workflow
- `TESTING_WORKFLOW.md` - Complete testing methodology
- `HPV_GUIDE.md` - Human-verified playtesting procedures
- `DEVELOPMENT_ROADMAP.md` - Current development priorities

**Key Source Files:**
- `game/autoload/game_state.gd` - Central state management
- `game/features/ui/dialogue_box.gd` - Dialogue system
- `game/features/npcs/npc_base.gd` - NPC dialogue routing
- `game/features/npcs/npc_spawner.gd` - NPC spawn conditions
- `game/autoload/cutscene_manager.gd` - Cutscene system

**Test Scripts:**
- `tests/gdunit4/` - Unit test suite
- `tests/debugger/` - Debugger test procedures (this file)

---

**Last Updated:** 2026-01-23
**Synthesized from:** Source code analysis and existing documentation
**Maintained by:** QA team via autonomous code review
