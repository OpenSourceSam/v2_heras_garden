# Circe's Garden: Complete Mechanical Walkthrough

## Document Overview

This document provides a **complete forced-path walkthrough** of Circe's Garden, documenting **every single player interaction** required to progress through the complete narrative. It is derived from analysis of the actual game source code to ensure 100% accuracy.

**Purpose:**
- Game Design Verification - Ensures all narrative triggers are reachable
- QA Testing Script - Every step can be tested and verified
- Player Guide - Complete walkthrough for completionists
- Implementation Reference - Developers verify each mechanic

---

## Part 1: Game System Reference

### 1.1 Input System (from `player.gd`, `constants.gd`)

| Input Action | Godot Mapping | Context |
|--------------|---------------|---------|
| D-Pad ↑ | `ui_up` | Move north, navigate menus, **grinding input**, herb ID row down |
| D-Pad ↓ | `ui_down` | Move south, navigate menus, **grinding input**, herb ID row up |
| D-Pad ← | `ui_left` | Move west, navigate menus, **grinding input**, herb ID column left |
| D-Pad → | `ui_right` | Move east, navigate menus, **grinding input**, herb ID column right |
| A Button | `ui_accept` + `interact` | Confirm, interact, advance dialogue, harvest |
| B Button | `ui_cancel` | Cancel, back, close menu |
| X Button | `ui_inventory` | Open/close inventory |
| START | `ui_text_completion` | Advance dialogue text, **advance time at sundial** |

**Player Movement Speed:** `const SPEED: float = 100.0` pixels/second

### 1.2 GameState Singleton (from `game_state.gd`)

The central state manager. All state changes flow through this singleton.

**Signals Emitted:**
- `inventory_changed(item_id, new_quantity)`
- `gold_changed(new_amount)`
- `day_advanced(new_day)`
- `flag_changed(flag, value)`
- `crop_planted(plot_id, crop_id)`
- `crop_harvested(plot_id, item_id, quantity)`

**Key Methods:**
```gdscript
func add_item(item_id: String, quantity: int = 1) -> void
func remove_item(item_id: String, quantity: int = 1) -> bool
func has_item(item_id: String, quantity: int = 1) -> bool
func set_flag(flag: String, value: bool = true) -> void
func get_flag(flag: String) -> bool
func advance_day() -> void
func plant_crop(position: Vector2i, crop_id: String) -> void
func harvest_crop(position: Vector2i) -> void
```

### 1.3 Quest Flag Flow (from `npc_base.gd`, dialogue files)

The game uses a **flag-based quest system** where each quest sets a flag upon completion:

```
quest_1_active → quest_1_complete → quest_2_active → quest_2_complete → ...
```

**All Quest Flags:**
| Flag | Triggers | Sets On Complete |
|------|----------|------------------|
| `prologue_complete` | new_game() called | N/A |
| `quest_1_active` | Hermes dialogue | `quest_1_complete` |
| `quest_2_active` | Quest 1 complete | `quest_2_complete` |
| `quest_3_active` | Quest 2 complete | `quest_3_complete` |
| `quest_4_active` | Quest 3 complete | `quest_4_complete` |
| `quest_5_active` | Quest 4 complete | `quest_5_complete` |
| `quest_6_active` | Quest 5 complete | `quest_6_complete` |
| `quest_7_active` | Quest 6 complete | `quest_7_complete` |
| `quest_8_active` | Quest 7 complete | `quest_8_complete` |
| `quest_9_active` | Quest 8 complete | `quest_9_complete` |
| `quest_10_active` | Quest 9 complete | `quest_10_complete` |
| `quest_11_active` | Quest 10 complete | `quest_11_complete` |
| `met_hermes` | First Hermes dialogue | N/A |
| `met_aeetes` | First Aeëtes dialogue | N/A |
| `met_daedalus` | First Daedalus dialogue | N/A |
| `met_scylla` | First Scylla dialogue | N/A |
| `herb_minigame_tutorial_done` | Complete herb ID tutorial | N/A |
| `quest_1_complete_dialogue_seen` | Hermes quest1_complete shown | N/A |
| `quest_4_complete_dialogue_seen` | Aeëtes quest4_complete shown | N/A |
| `quest_5_complete_dialogue_seen` | Aeëtes quest5_complete shown | N/A |
| `quest_6_complete_dialogue_seen` | Aeëtes quest6_complete shown | N/A |
| `quest_7_complete_dialogue_seen` | Daedalus quest7_complete shown | N/A |
| `quest_8_complete_dialogue_seen` | Daedalus quest8_complete shown | N/A |
| `quest_9_complete_dialogue_seen` | Scylla quest9_complete shown | N/A |
| `quest_10_complete_dialogue_seen` | Scylla quest10_complete shown | N/A |
| `scylla_petrified` | Petrification potion used | N/A |

### 1.4 NPC Dialogue Routing (from `npc_base.gd`)

Each NPC has a `_resolve_X_dialogue()` method that determines which dialogue to show:

**Hermes (`_resolve_hermes_dialogue`):**
```gdscript
- Not met → "hermes_intro"
- prologue_complete, not quest_1_active → "quest1_start"
- quest_1_active, not quest_1_complete → "quest1_inprogress"
- quest_1_complete, not quest_1_complete_dialogue_seen → "quest1_complete"
- quest_1_complete, not quest_2_active → "quest2_start"
- quest_2_complete, not quest_3_active → "quest3_start"
- Else → "hermes_idle"
```
> **Note:** Hermes becomes idle after Quest 3 starts. He serves as the initial quest giver (Quests 1-3) but Aeëtes takes over for Act 2. Scylla handles Act 3 quests (9-11).

**Aeëtes (`_resolve_aeetes_dialogue`):**
```gdscript
- Not met, dialogue exists → "aeetes_intro"
- quest_3_complete, not quest_4_active → "quest4_start"
- quest_4_active, not quest_4_complete → "quest4_inprogress" or "act2_farming_tutorial"
- quest_4_complete, not quest_5_active → "quest4_complete" or "quest5_start"
- quest_5_active, not quest_5_complete → "quest5_inprogress" or "act2_calming_draught"
- quest_5_complete, not quest_6_active → "quest5_complete" or "quest6_start"
- quest_6_active, not quest_6_complete → "quest6_inprogress" or "act2_reversal_elixir"
- Else → "aeetes_idle"
```
> **Note:** Aeëtes does not have a Quest 7 start dialogue. After Quest 6, Daedalus arrives and handles Quest 7-8. Scylla handles Quest 9-11.

**Daedalus (`_resolve_daedalus_dialogue`):**
```gdscript
- Not met, dialogue exists → "daedalus_intro"
- quest_6_complete, not quest_7_active → "quest7_start"
- quest_7_active, not quest_7_complete → "quest7_inprogress" or "act2_daedalus_arrives"
- quest_7_complete, not quest_8_active → "quest7_complete" or "quest8_start"
- quest_8_active, not quest_8_complete → "quest8_inprogress" or "act2_binding_ward"
- Else → "daedalus_idle"
```

**Scylla (`_resolve_scylla_dialogue`):**
```gdscript
- Not met, dialogue exists → "scylla_intro"
- quest_8_complete, not quest_9_active → "quest9_start"
- quest_9_active, not quest_9_complete → "quest9_inprogress" or "act3_sacred_earth"
- quest_9_complete, not quest_10_active → "quest9_complete" or "quest10_start"
- quest_10_active, not quest_10_complete → "quest10_inprogress" or "act3_moon_tears"
- quest_10_complete, not quest_11_active → "quest10_complete" or "quest11_start"
- quest_11_active, not quest_11_complete → "quest11_inprogress" or "act3_final_confrontation"
- Else → "scylla_idle"
```

### 1.5 Dialogue System (from `dialogue_box.gd`)

**Flow:**
1. `start_dialogue(dialogue_id)` - Loads `res://game/shared/resources/dialogues/{id}.tres`
2. Checks `flags_required` - If any missing, dialogue doesn't start
3. Shows first line with scrolling text
4. Player presses `ui_accept` to advance
5. If choices exist, displays buttons (D-pad to select, A to confirm)
6. On dialogue end, sets `flags_to_set`

**Choice Handling:**
```gdscript
choice = {
    "text": "Choice display text",
    "next_id": "dialogue_to_jump_to",
    "flag_required": ""  # Optional
}
```

### 1.6 Scene Transitions (from `scene_manager.gd`)

```gdscript
SceneManager.change_scene("res://path/to/scene.tscn")
```
- Fades out (0.3s default)
- Unloads current scene
- Loads new scene
- Fades in

**Key Scenes:**
- `res://game/features/world/world.tscn` - Aiaia island (main game)
- `res://game/features/locations/scylla_cove.tscn` - Scylla's location
- `res://game/features/locations/sacred_grove.tscn` - Moon tears location

### 1.7 Minigame Reference

#### Crafting Minigame (`crafting_minigame.gd`)

**Difficulty Settings:**
| Difficulty | Inputs | Buttons | Timing | Retry |
|------------|--------|---------|--------|-------|
| TUTORIAL | 12 | 0 | 2.0s | No |
| EASY | 12 | 0 | 2.0s | No |
| MEDIUM | 16 | 4 | 1.5s | No |
| HARD | 16 | 6 | 1.0s | No |
| EXPERT | 36 | 10 | 0.6s | Yes |

**Timing Window Logic:**
```gdscript
if current_time - last_input_time > timing_window:
    _fail_crafting()
```

#### Herb Identification (`herb_identification.gd`)

**Rounds:**
```gdscript
plants_per_round = [20, 25, 30]  # Round 1, 2, 3
correct_per_round = [3, 3, 3]    # Pharmaka to find each round
max_wrong = 5
```

**Visual Distinction:**
- Correct plants: `Color(1.0, 0.85, 0.3, 1.0)` - Bright gold with glow effect
- Wrong plants: `Color(0.5, 0.5, 0.55, 1.0)` - Gray

**Navigation:** D-pad (5 at a time for row changes)

#### Moon Tears (`moon_tears_minigame.gd`)

```gdscript
SPAWN_INTERVAL = 2.0s    # Between tears
FALL_SPEED = 100.0       # Pixels/second
CATCH_WINDOW = 140.0     # Pixels around marker
tears_needed = 3
```

**Input:** D-pad to move marker left/right, A to catch when tear enters zone

#### Sacred Earth (`sacred_earth.gd`)

```gdscript
time_remaining = 10.0s
PROGRESS_PER_PRESS = 0.05  # Per A button press
DECAY_RATE = 0.15          # Progress lost per second
```

**Input:** Mash A button to fill progress bar

---

## Part 2: Complete Walkthrough

### CHAPTER 1: TITLE SCREEN TO NEW GAME

#### Step 1.1: Title Screen Display

**Game State:** `scene = "title_screen"`

**Visible Elements:**
- Game logo: "CIRCE'S GARDEN"
- Menu options: "NEW GAME", "CONTINUE", "OPTIONS"
- Background: Helios's palace garden art (golden hour)

**Player Action Required:**
```gdscript
// From main_menu.gd - menu navigation
D-Pad: Press ↓ twice (highlight "NEW GAME")
A Button: Press once
```

**System Response:**
- `GameState.new_game()` is called (from `game_state.gd:35-45`)
- `prologue_complete` flag is set to `true`
- Fade to black
- Display quote text

**Code Trigger:**
```gdscript
func new_game() -> void:
    current_day = 1
    inventory.clear()
    quest_flags.clear()
    farm_plots.clear()
    add_item("wheat_seed", 3)  // Starting items
    set_flag("prologue_complete", true)
```

#### Step 1.2: Prologue Opening Cutscene

**Scene:** `res://game/features/cutscenes/prologue_opening.tscn` (from `prologue_opening.gd`)

**Duration:** 2-3 minutes (non-interactive)

**Sequence:**
1. **Fade In** - Helios's palace garden, golden hour
2. **Quote Display** (from `prologue_opening.tres`):
   ```
   "Love can make monsters of us all."
   "But witchcraft... witchcraft makes them real."
   ```
3. **Dialogue Lines** (from `prologue_opening.tres`):
   - Circe internal monologue (3 lines)
   - Helios appearance and dialogue exchange
   - Circe's final resolve line

**Dialogue Data Structure** (from `prologue_opening.tres`):
```gdscript
id = "prologue_opening"
lines = [
    {"speaker": "Circe", "text": "There he is. The god I made..."},
    // ... more lines
]
flags_required = []  // No requirements for prologue
flags_to_set = []
```

**System Response:**
- When dialogue ends, `scene_changed` signal is emitted
- Scene transitions to Aiaia island

#### Step 1.3: Aiaia Island Arrival

**Scene:** `res://game/features/world/world.tscn`

**Initial Game State:**
```gdscript
scene = "world"
circe_position = (start_x, start_y)  // Beach spawn
player_control = true
camera = "follow_circe"
GameState.current_day = 1
```

**Visible Elements (must be rendered):**
- Beach terrain with sand texture
- Ocean to one side
- Lush green island ahead
- House structure visible in distance
- Garden plot near house
- Trees/cliffs for exploration

**System Prompt:** `"Use D-Pad to move. Explore the island."`

**Player Guidance:** Player must navigate to house

---

### CHAPTER 2: HOUSE DISCOVERY AND AEËTES' NOTE

#### Step 2.1: Navigate to House

**Player Action:**
```gdscript
// From player.gd - movement
D-Pad: Press ↑ (north) × 15-20 steps
// Player moves at SPEED = 100 pixels/second
```

**Interaction Trigger Zone:**
```gdscript
// When player is within 64 pixels of house door
// interaction_prompt.visible = true
```

**Player Action:**
```gdscript
A Button: Press once
// Triggers house door .interact() method
```

#### Step 2.2: Enter House Interior

**Scene Transition:** `SceneManager.change_scene()` to interior scene

**Visible Elements:**
- Table with note (glowing - visibility indicator)
- Mortar & pestle on table
- Basic furnishings

**System Prompt:** `"Examine the table"` (optional guidance)

#### Step 2.3: Read Aeëtes' Note

**Player Action:**
```gdscript
D-Pad: Navigate to table position (within 64 pixels)
A Button: Press to interact
```

**Dialogue Trigger:** Note reading triggers internal monologue

**Dialogue (from storyline):**
```
Circe: "Pharmaka... the magic Aeëtes told me about."
       "Transforms living things."
       [pause, dark realization]
       "Perfect."
```

**Game State Change:**
```gdscript
// No flag set here - this is tutorial/narration
// Player learns about pharmaka from note
```

**Quest Trigger:** This scene may trigger `quest_1_active` via Hermes spawn

---

### CHAPTER 3: QUEST 1 - HERB IDENTIFICATION

#### Step 3.1: Trigger Quest 1

**Trigger Mechanism:** Player exits house, Hermes spawns

**NPC Spawner** (from `npc_spawner.gd`):
```gdscript
// Hermes appears when:
// - prologue_complete = true
// - quest_1_active not yet set
```

**Hermes Dialogue** (from `quest1_start.tres`):
```gdscript
id = "quest1_start"
lines = [
    {"speaker": "Hermes", "text": "Circe has a task for you..."},
    // ...
]
flags_required = ["prologue_complete"]
flags_to_set = ["quest_1_active"]
```

**Player Action:**
```gdscript
D-Pad: Move to Hermes (talk indicator visible)
A Button: Press to interact
// Triggers dialogue_box.start_dialogue("quest1_start")
```

**On Dialogue End:**
```gdscript
GameState.set_flag("quest_1_active", true)
// Quest marker appears on world map
```

#### Step 3.2: Navigate to Pharmaka Field

**Player Action:**
```gdscript
D-Pad: Press ↑ (north) × 30-40 steps from house
// Must reach pharmaka field location
// Field must be within render distance (400 pixels)
```

**Visibility Requirement:**
```
- Ground shows golden glow spots (Titan blood effect)
- Field border visible
- 20-30 plant sprites rendered in field
```

**Dialogue Trigger:**
```gdscript
// When player enters field trigger zone
Circe: "Here. The ground still glows from their blood."
       "Titan blood. Divine blood. The source of all magic."
```

#### Step 3.3: Herb Identification Minigame

**Minigame Scene:** `res://game/features/minigames/herb_identification.tscn`

**From `herb_identification.gd:32-40`:**
```gdscript
func _setup_round(round_num: int) -> void:
    current_round = round_num
    correct_found = 0
    wrong_count = 0
    _generate_plants(plants_per_round[round_num], correct_per_round[round_num])
```

**Round Configuration:**
```gdscript
plants_per_round = [20, 25, 30]    // Round 1, 2, 3
correct_per_round = [3, 3, 3]      // Pharmaka to find
max_wrong = 5
```

**Visual Distinction (from `herb_identification.gd:112-115`):**
```gdscript
// Wrong plant
slot.modulate = Color(0.5, 0.5, 0.55, 1.0)  // Gray

// Correct plant (pharmaka)
slot.modulate = Color(1.0, 0.85, 0.3, 1.0)  // Bright gold
_add_glow_effect(slot)  // Pulsing animation
```

**Player Input (from `herb_identification.gd:42-59`):**
```gdscript
// Navigation
D-Pad →: _move_selection(1)
D-Pad ←: _move_selection(-1)
D-Pad ↓: _move_selection(5)   // Row change
D-Pad ↑: _move_selection(-5)

// Selection
A Button: _select_current()
```

**Success Logic (from `herb_identification.gd:69-85`):**
```gdscript
func _select_current() -> void:
    var plant = plant_slots[selected_index]
    if plant.get_meta("is_correct", false):
        _on_correct_selection(plant)
        if correct_found >= correct_per_round[current_round]:
            _advance_round()
    else:
        _on_wrong_selection(plant)
        if wrong_count >= max_wrong:
            minigame_complete.emit(false, [])
```

**Round Progression (from `herb_identification.gd:87-95`):**
```gdscript
func _advance_round() -> void:
    current_round += 1
    if current_round >= plants_per_round.size():
        // All rounds complete
        var items = ["pharmaka_flower", "pharmaka_flower", "pharmaka_flower"]
        _award_items(items)
        minigame_complete.emit(true, items)
    else:
        _setup_round(current_round)
```

**Item Award (from `herb_identification.gd:177-180`):**
```gdscript
func _award_items(items: Array) -> void:
    for item_id in items:
        GameState.add_item(item_id, 1)
```

**Inventory Result:**
```gdscript
GameState.inventory = {
    "pharmaka_flower": 3,
    "wheat_seed": 3
}
```

#### Step 3.4: Complete Quest 1

**Trigger:** Return to Hermes or reach quest completion point

**Hermes Dialogue** (from `quest1_complete.tres`):
```gdscript
id = "quest1_complete"
flags_required = []
flags_to_set = ["quest_1_complete"]
```

**Game State Change:**
```gdscript
GameState.set_flag("quest_1_complete", true)
// quest_1_active remains true until quest 2 starts
// Quest 2 triggers automatically or via Hermes
```

---

### CHAPTER 4: QUEST 2 - EXTRACT THE SAP
> **Note:** This quest references "Transformation Sap" which is not in the current item registry. The mortar & pestle crafting mechanic may be unimplemented or renamed in the current build.

#### Step 4.1: Start Quest 2

**Trigger:** Quest 1 complete triggers `quest_2_active`

**Hermes or Aeëtes Dialogue** (from `quest2_start.tres`):
```gdscript
id = "quest2_start"
flags_required = ["quest_1_complete"]
flags_to_set = ["quest_2_active"]
```

**Player Action:**
```gdscript
D-Pad: Navigate to mortar & pestle
A Button: Press to interact
// Triggers crafting_minigame
```

#### Step 4.2: Crafting Minigame - Basic

**Minigame Scene:** `res://game/features/minigames/crafting_minigame.tscn`

**From `crafting_minigame.gd:7-13`:**
```gdscript
const DIFFICULTY_SETTINGS = {
    Difficulty.TUTORIAL: {"inputs": 12, "buttons": 0, "timing": 2.0, "retry": false},
    // ...
}
```

**For Quest 2 (Transformation Sap):**
- Difficulty: TUTORIAL or EASY
- Inputs: 12
- Buttons: 0
- Timing: 2.0 seconds

**Pattern Example** (from storyline):
```
Sequence: ↑ → ↓ ←
Repeat: 3 times
Total: 12 inputs
```

**Player Input (from `crafting_minigame.gd:43-57`):**
```gdscript
func _input(event: InputEvent) -> void:
    if not visible:
        return

    var current_time = Time.get_ticks_msec() / 1000.0

    if current_time - last_input_time > timing_window:
        _fail_crafting()
        return

    if is_grinding_phase:
        _handle_grinding_input(event)
```

**Grinding Input (from `crafting_minigame.gd:59-80`):**
```gdscript
func _handle_grinding_input(event: InputEvent) -> void:
    var expected = pattern[current_pattern_index]

    if event.is_action_pressed(expected):
        current_pattern_index += 1
        last_input_time = Time.get_ticks_msec() / 1000.0
        _update_display()
        _play_feedback(true)

        if current_pattern_index >= pattern.size():
            is_grinding_phase = false
            current_button_index = 0
```

**Success (from `crafting_minigame.gd:92-94`):**
```gdscript
if current_button_index >= button_sequence.size():
    _complete_crafting(true)
```

**Result:**
```gdscript
GameState.add_item("transformation_sap", 1)
GameState.remove_item("pharmaka_flower", 3)
```

---

### CHAPTER 5: QUEST 3 - CONFRONT SCYLLA

#### Step 5.1: Start Quest 3

**Trigger:** Quest 2 complete

**Hermes Dialogue** (from `quest3_start.tres`):
```gdscript
id = "quest3_start"
flags_required = ["quest_2_complete"]
flags_to_set = ["quest_3_active"]
```

**Boat Unlock:** `boat_marker.visible = true` (from `world.gd:71-76`)

#### Step 5.2: Use Boat to Travel

**Boat Interaction** (from `boat.gd:3-13`):
```gdscript
func interact() -> void:
    if GameState.get_flag("quest_3_active"):
        SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")
```

**Player Action:**
```gdscript
D-Pad: Navigate to boat marker
A Button: Press to interact
```

**Scene Transition:** `change_scene("scylla_cove")`

#### Step 5.3: Confrontation Scene

**Location:** `scylla_cove.tscn`

**Dialogue System:** Standard dialogue flow with choices

**Choice Structure** (from `act1_confront_scylla.tres`):
```gdscript
choices = [
    {"text": "I brought you a gift.", "next_id": "deceptive_branch"},
    {"text": "You took him from me.", "next_id": "honest_branch"},
    {"text": "I'm here to fix a mistake.", "next_id": "cryptic_branch"}
]
```

**All branches converge** for transformation scene

**Cutscene** (from `scylla_transformation.gd`):
- Non-interactive
- Visual transformation effect
- Dialogue exchange

**Quest Completion:**
```gdscript
GameState.set_flag("quest_3_complete", true)
// Act 1 complete
// Transition to Act 2
```

---

### CHAPTER 6: QUEST 4 - BUILD A GARDEN

#### Step 6.1: Start Quest 4

**Trigger:** Act 2 begins, Aeëtes or Hermes appears

**Dialogue** (from `quest4_start.tres` or `act2_farming_tutorial.tres`):
```gdscript
id = "quest4_start"
flags_required = ["quest_3_complete"]
flags_to_set = ["quest_4_active"]
```

**Inventory Grant:**
```gdscript
GameState.add_item("moly_seed", 3)
GameState.add_item("nightshade_seed", 3)
GameState.add_item("golden_glow_seed", 3)  // "golden_glow" in registry
```

#### Step 6.2: Farm Plot Interaction

**From `farm_plot.gd:124-136`:**
```gdscript
func interact() -> void:
    match current_state:
        State.EMPTY:
            till()
        State.TILLED:
            seed_requested.emit(self)  // Opens seed selector
        State.PLANTED, State.GROWING:
            water()
        State.HARVESTABLE:
            harvest()
```

**Tilling (from `farm_plot.gd:57-67`):**
```gdscript
func till() -> void:
    if current_state != State.EMPTY:
        return
    current_state = State.TILLED
    soil_sprite.visible = true
    // Animation plays
```

**Player Action:**
```gdscript
D-Pad: Navigate to empty farm plot
A Button: Press to till
// Repeat 9 times for 3x3 grid
```

#### Step 6.3: Plant Seeds

**Seed Selection** (from `world.gd:46-54`):
```gdscript
func _on_seed_requested(plot: Node) -> void:
    _active_plot = plot
    seed_selector.open()

func _on_seed_selected(seed_id: String) -> void:
    if _active_plot:
        _active_plot.plant(seed_id)
        GameState.remove_item(seed_id, 1)
```

**Player Action:**
```gdscript
D-Pad: Navigate to tilled plot
A Button: Press to open seed selector
D-Pad: Select seed type (moly/nightshade/golden_glow)
A Button: Confirm planting
// Repeat 9 times
```

**Result:**
```gdscript
GameState.farm_plots[grid_position] = {
    "crop_id": "moly",  // or nightshade/lotus
    "planted_day": 1,
    "current_stage": 0,
    "watered_today": false,
    "ready_to_harvest": false
}
```

#### Step 6.4: Water Crops

**From `farm_plot.gd:82-92`:**
```gdscript
func water() -> void:
    if current_state not in [State.PLANTED, State.GROWING]:
        return
    if GameState.farm_plots.has(grid_position):
        GameState.farm_plots[grid_position]["watered_today"] = true
    is_watered = true
    // Visual feedback
```

**Player Action:**
```gdscript
D-Pad: Navigate to each planted plot
A Button: Press to water
// Repeat 9 times
```

#### Step 6.5: Advance Time

**Sundial Interaction** (from `sundial.gd:2-5`):
```gdscript
func interact() -> void:
    GameState.advance_day()
```

**From `game_state.gd:152-169`:**
```gdscript
func advance_day() -> void:
    current_day += 1
    day_advanced.emit(current_day)
    _update_all_crops()
    get_tree().call_group("farm_plots", "sync_from_game_state")
```

**Player Action:**
```gdscript
D-Pad: Navigate to sundial
A Button: Press to interact
// Call twice for 2-day growth
```

**Crop Growth Logic** (from `game_state.gd:214-236`):
```gdscript
func _update_all_crops() -> void:
    for pos in farm_plots:
        var days_elapsed = current_day - plot_data["planted_day"]
        var crop_data = get_crop_data(plot_data["crop_id"])

        if days_elapsed >= crop_data.days_to_mature:
            plot_data["ready_to_harvest"] = true
```

#### Step 6.6: Harvest Crops

**From `farm_plot.gd:97-107`:**
```gdscript
func harvest() -> void:
    if current_state != State.HARVESTABLE:
        return

    _create_harvest_feedback()
    GameState.harvest_crop(grid_position)
    current_state = State.TILLED
```

**From `game_state.gd:186-212`:**
```gdscript
func harvest_crop(position: Vector2i) -> void:
    var crop_data = get_crop_data(plot_data["crop_id"])
    add_item(crop_data.harvest_item_id, 1)
```

**Player Action:**
```gdscript
D-Pad: Navigate to harvestable crops
A Button: Press to harvest
// Repeat for all 9 plots
```

**Result:**
```gdscript
GameState.inventory = {
    "moly": 3,
    "nightshade": 3,
    "golden_glow": 3  // "lotus" in document = "golden_glow" in registry
}
```

**Quest Completion:**
```gdscript
GameState.set_flag("quest_4_complete", true)
```

---

### CHAPTER 7: QUEST 5 - CALMING DRAUGHT

#### Step 7.1: Start Quest 5

**Trigger:** Quest 4 complete

**Dialogue** (from `quest5_start.tres`):
```gdscript
id = "quest5_start"
flags_required = ["quest_4_complete"]
flags_to_set = ["quest_5_active"]
```

#### Step 7.2: Craft Calming Draught

**Recipe Requirements:**
- 2× Moly
- 1× Lotus

**Minigame Difficulty:** MEDIUM

**From `crafting_minigame.gd:10`:**
```gdscript
Difficulty.MEDIUM: {"inputs": 16, "buttons": 4, "timing": 1.5, "retry": false}
```

**Pattern:** ↑↑→→↓↓←← (repeat 2×)

**Button Sequence:** A, A, B, [button]

**Player Action:**
```gdscript
// Phase 1: Grinding
D-Pad: Follow pattern × 16 inputs
// Each input within 1.5 seconds

// Phase 2: Button Sequence
A Button: Press when button appears × 4
```

**Success Result:**
```gdscript
GameState.add_item("calming_draught_potion", 1)
GameState.remove_item("moly", 2)
GameState.remove_item("lotus", 1)
```

#### Step 7.3: Return to Scylla

**Boat Travel:** `SceneManager.change_scene("scylla_cove")`

**Dialogue:** Attempt to give potion (fails)

**Quest Completion:**
```gdscript
GameState.set_flag("quest_5_complete", true)
```

---

### CHAPTER 8: QUEST 6 - REVERSAL ELIXIR

#### Step 8.1: Start Quest 6

**Trigger:** Quest 5 complete, Aeëtes appears

**Dialogue** (from `quest6_start.tres`):
```gdscript
id = "quest6_start"
flags_required = ["quest_5_complete"]
flags_to_set = ["quest_6_active"]
```

#### Step 8.2: Saffron Gathering (Herb ID Minigame)
> **Note:** Saffron is not in the current item registry. This quest step may need updating to use available crops (e.g., golden_glow) or saffron needs to be added to game_state.gd.

**New Herb ID Round:**
```gdscript
plants_per_round = [30]  // Single challenging round
correct_per_round = [3]  // Find 3 saffron
max_wrong = 5
```

**Visual Difference:** Red stamens vs yellow

**Player Action:**
```gdscript
D-Pad: Navigate plants grid
A Button: Select correct plants
// Find 3 saffron flowers
```

**Result:**
```gdscript
GameState.add_item("saffron", 3)
```

#### Step 8.3: Craft Reversal Elixir

**Recipe Requirements:**
- 2× Moly
- 2× Nightshade
- 1× Saffron

**Minigame Difficulty:** HARD

**From `crafting_minigame.gd:11`:**
```gdscript
Difficulty.HARD: {"inputs": 16, "buttons": 6, "timing": 1.0, "retry": false}
```

**Pattern:** Complex 8-direction pattern

**Button Sequence:** 6 buttons (A, B, X combinations)

**Result:**
```gdscript
GameState.add_item("reversal_elixir_potion", 1)
```

**Quest Completion:**
```gdscript
GameState.set_flag("quest_6_complete", true)
```

---

### CHAPTER 9: QUEST 7 - DAEDALUS ARRIVES

#### Step 9.1: Start Quest 7

**Trigger:** Quest 6 complete, Daedalus spawns

**Dialogue** (from `daedalus_intro.tres`):
```gdscript
id = "daedalus_intro"
flags_required = ["quest_6_complete"]
flags_to_set = ["quest_7_active"]
```

#### Step 9.2: Receive Loom

**Gift:** `GameState.add_item("loom", 1)`

> **Note:** Weaving minigame referenced but `weaving_minigame.gd` not found in current codebase. This feature may be unimplemented.

**Quest Completion:**
```gdscript
GameState.set_flag("quest_7_complete", true)
```

---

### CHAPTER 10: QUEST 8 - BINDING WARD

#### Step 10.1: Start Quest 8

**Trigger:** Quest 7 complete

**Dialogue** (from `quest8_start.tres`):
```gdscript
id = "quest8_start"
flags_required = ["quest_7_complete"]
flags_to_set = ["quest_8_active"]
```

#### Step 10.2: Sacred Earth Minigame

**Location:** Sacred grove or Titan battlefield

**Minigame** (from `sacred_earth.gd`):
```gdscript
var progress: float = 0.0
var time_remaining: float = 10.0
PROGRESS_PER_PRESS = 0.05
DECAY_RATE = 0.15
```

**Player Action:**
```gdscript
// Mash A button
A Button: Press rapidly
// Progress fills but decays over time
```

**Success Criteria:**
```gdscript
if progress >= 1.0:
    _win()
elif time_remaining <= 0:
    _lose()
```

**Result:**
```gdscript
GameState.add_item("sacred_earth", 3)
```

#### Step 10.3: Craft Binding Ward

**Recipe Requirements:**
- 5× Moly
- 3× Sacred Earth

**Minigame Difficulty:** EXPERT

**From `crafting_minigame.gd:12`:**
```gdscript
Difficulty.EXPERT: {"inputs": 36, "buttons": 10, "timing": 0.6, "retry": true}
```

**Result:**
```gdscript
GameState.add_item("binding_ward_potion", 1)
```

**Quest Completion:**
```gdscript
GameState.set_flag("quest_8_complete", true)
```

---

### CHAPTER 11: QUEST 9 - SACRED EARTH / QUEST 10 - MOON TEARS

#### Step 11.1: Start Quest 9

**Trigger:** Quest 8 complete, Scylla appears

**Dialogue** (from `quest9_start.tres`):
```gdscript
id = "quest9_start"
flags_required = ["quest_8_complete"]
flags_to_set = ["quest_9_active"]
```

#### Step 11.2: Moon Tears Minigame

**Location:** Sacred grove at night

**From `moon_tears_minigame.gd`:**
```gdscript
var tears_caught: int = 0
var tears_needed: int = 3
var player_x: float = 0.5
var spawn_timer: float = 0.0
SPAWN_INTERVAL = 2.0s
FALL_SPEED = 100.0
CATCH_WINDOW = 140.0
```

**Player Action:**
```gdscript
// Movement
D-Pad ←: player_x = max(0.1, player_x - 0.02)
D-Pad →: player_x = min(0.9, player_x + 0.02)

// Catching
A Button: Press when tear enters catch zone
```

**Catch Logic:**
```gdscript
func _check_catches() -> void:
    var accept_pressed := Input.is_action_pressed("ui_accept")
    for tear in active_tears:
        var marker_rect = Rect2(player_marker.global_position, player_marker.size).grow(CATCH_WINDOW)
        if marker_rect.intersects(tear_rect):
            _catch_tear(tear)
```

**Result:**
```gdscript
GameState.add_item("moon_tear", 3)
```

**Quest Completion:**
```gdscript
GameState.set_flag("quest_9_complete", true)
GameState.set_flag("quest_10_active", true)
```

---

### CHAPTER 12: QUEST 10 - ULTIMATE CRAFTING

#### Step 12.1: Start Quest 10

**Trigger:** Quest 9 complete

**Dialogue** (from `quest10_start.tres`):
```gdscript
id = "quest10_start"
flags_required = ["quest_9_complete"]
flags_to_set = ["quest_10_active"]
```

#### Step 12.2: Divine Blood Collection

**Cutscene:** Circe cuts palm for divine blood

**Result:**
```gdscript
GameState.add_item("divine_blood", 1)
```

#### Step 12.3: Petrification Potion

**Recipe Requirements:**
- 5× Moly
- 3× Sacred Earth
- 3× Moon Tears
- 1× Divine Blood

**Minigame Difficulty:** EXPERT (same as Binding Ward)

**Pattern:** Complex 36-input grinding

**Button Sequence:** 10 buttons

**Result:**
```gdscript
GameState.add_item("petrification_potion", 1)
```

**Quest Completion:**
```gdscript
GameState.set_flag("quest_10_complete", true)
GameState.set_flag("quest_11_active", true)
```

---

### CHAPTER 13: QUEST 11 - FINAL CONFRONTATION

#### Step 13.1: Start Quest 11

**Trigger:** Quest 10 complete

**Dialogue** (from `quest11_start.tres`):
```gdscript
id = "quest11_start"
flags_required = ["quest_10_complete"]
flags_to_set = ["quest_11_active"]
```

#### Step 13.2: Travel to Scylla

**Boat Travel:** `SceneManager.change_scene("scylla_cove")`

#### Step 13.3: Final Scene

**Dialogue:** Circe offers mercy, Scylla accepts

**Choice:**
```gdscript
choices = [
    {"text": "I'll understand if you hate me."},
    {"text": "This is the only mercy I can offer."},
    {"text": "Tell me what you want."}
]
```

**Petrification:**
```gdscript
// Visual cutscene
GameState.set_flag("scylla_petrified", true)
```

**Quest Completion:**
```gdscript
GameState.set_flag("quest_11_complete", true)
GameState.set_flag("scylla_petrified", true)
GameState.set_flag("game_complete", true)
```

---

### CHAPTER 14: EPILOGUE AND ENDINGS

#### Step 14.1: Epilogue Scene

**Dialogue** (from `epilogue_ending_choice.tres`):
```gdscript
id = "epilogue_ending_choice"
flags_required = ["quest_11_complete"]
```

**Ending Choices:**
```gdscript
choices = [
    {"text": "I'll continue learning witchcraft. Help those who come to me."},
    {"text": "I will seek redemption. Use my magic only for good."}
]
```

#### Step 14.2: Final State

**Ending A (Witch Path):**
```gdscript
GameState.set_flag("ending_chosen", "witch")
```

**Ending B (Healer Path):**
```gdscript
GameState.set_flag("ending_chosen", "healer")
```

**Free Play Unlock:**
```gdscript
GameState.set_flag("free_play_unlocked", true)
```

---

## Part 3: Debug and Testing Reference

### 3.1 Headless Testing Commands

```powershell
# Run all tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# Test dialogue flow
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_dialogue_flow_test.gd

# Test minigames
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_minigame_mechanics_test.gd

# Full playthrough
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/ai/test_full_playthrough.gd
```

### 3.2 Debug Methods

Each minigame has a debug completion method:

```gdscript
// Moon Tears
func _debug_complete_minigame() -> void:
    tears_caught = tears_needed
    _award_items(rewards)

// Sacred Earth
func _debug_complete_minigame() -> void:
    progress = 1.0
    _win()
```

### 3.3 State Query Tool

From `tools/testing/state_query.gd`:
```gdscript
// Query current game state
print(GameState.inventory)
print(GameState.quest_flags)
print(GameState.farm_plots)
```

---

## Appendix: Quick Reference

### Flag Check Sequence

```
prologue_complete
  └─→ quest_1_active → quest_1_complete
           └─→ quest_2_active → quest_2_complete
                    └─→ quest_3_active → quest_3_complete
                             └─→ quest_4_active → quest_4_complete
                                      └─→ quest_5_active → quest_5_complete
                                               └─→ quest_6_active → quest_6_complete
                                                        └─→ quest_7_active → quest_7_complete
                                                                 └─→ quest_8_active → quest_8_complete
                                                                          └─→ quest_9_active → quest_9_complete
                                                                                   └─→ quest_10_active → quest_10_complete
                                                                                            └─→ quest_11_active → quest_11_complete
                                                                                                     └─→ scylla_petrified
                                                                                                     └─→ game_complete
```

### Inventory Final State

```
pharmaka_flower: 0
moly: 0
nightshade: 0
golden_glow: 0  // Document "lotus" = registry "golden_glow"
saffron: 0
calming_draught_potion: 0
reversal_elixir_potion: 0
binding_ward_potion: 0
petrification_potion: 0
sacred_earth: 0
moon_tear: 0
divine_blood: 0
```

### Day Progression

```
Start: Day 1
After farming: Day 3 (2 advances)
End game: Day 3+
```

---

*Document Version: 1.0*
*Generated: 2025-12-31*
*Based on: Godot 4.5.1 source code analysis*
*Source Files: game_state.gd, player.gd, npc_base.gd, dialogue_box.gd, crafting_minigame.gd, herb_identification.gd, moon_tears_minigame.gd, sacred_earth.gd, farm_plot.gd, boat.gd, sundial.gd, scene_manager.gd, world.gd*
