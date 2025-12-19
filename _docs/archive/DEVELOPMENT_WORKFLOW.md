# HERA'S GARDEN V2 - DEVELOPMENT WORKFLOW

**Purpose:** Guide for AI agents and developers working on this project.

---

## FOR NEW AI AGENTS: START HERE

When you join a conversation about this project, **follow this protocol:**

### 1. Read Foundation Documents (5 minutes)

```
□ Read CONSTITUTION.md (immutable rules)
□ Read SCHEMA.md (data structures)
□ Read PROJECT_STRUCTURE.md (file organization)
□ Read PROJECT_STATUS.md (current phase)
□ Read this file (DEVELOPMENT_WORKFLOW.md)
```

### 2. Verify Current State

```bash
# Check which phase we're in
cat PROJECT_STATUS.md

# Verify autoloads are registered
grep -A 5 "\[autoload\]" project.godot

# Check git status
git status
git log --oneline -5
```

### 3. Ask Clarifying Questions

Before writing ANY code:

```
□ "What phase are we currently in?"
□ "What specific task am I implementing?"
□ "Has the foundation been tested?"
□ "Are there any known blockers?"
```

### 4. Verify Before Assuming

```gdscript
# ❌ DON'T assume this exists:
var crop = CropRegistry.get_crop("wheat")

# ✅ DO check SCHEMA.md first:
var crop = GameState.get_crop_data("wheat")  # If this method exists
```

---

## DEVELOPMENT PHASES

### Phase 0: Foundation ✅

**Acceptance Criteria:**
- [ ] All folders created
- [ ] CONSTITUTION.md, SCHEMA.md, PROJECT_STRUCTURE.md exist
- [ ] project.godot has autoloads registered
- [ ] All autoload scripts exist and compile
- [ ] All resource class definitions exist
- [ ] Tests pass: `godot --headless --script tests/run_tests.gd`

**Deliverables:**
```
✅ CONSTITUTION.md
✅ SCHEMA.md
✅ PROJECT_STRUCTURE.md
✅ DEVELOPMENT_WORKFLOW.md
✅ PROJECT_STATUS.md
✅ project.godot
✅ src/autoloads/game_state.gd
✅ src/autoloads/audio_controller.gd
✅ src/autoloads/save_controller.gd
✅ src/resources/crop_data.gd
✅ src/resources/item_data.gd
✅ src/resources/dialogue_data.gd
✅ src/resources/npc_data.gd
✅ tests/run_tests.gd
✅ .gitignore
```

**How to Complete:**
1. Create all files listed above
2. Run tests to verify compilation
3. Commit: `git commit -m "feat: Phase 0 foundation complete"`
4. Update PROJECT_STATUS.md to Phase 1

---

### Phase 1: Core Loop (Vertical Slice)

**Goal:** Player can plant, grow, and harvest ONE crop (wheat).

**Acceptance Criteria:**
- [ ] Player can move with WASD/arrow keys
- [ ] Player can interact with farm plots (press E)
- [ ] Player can plant wheat seed
- [ ] Wheat grows over 3 days
- [ ] Player can harvest wheat
- [ ] Wheat goes into inventory
- [ ] Inventory displays on HUD

**Workflow (Step-by-Step):**

#### Step 1.1: Player Movement
```
□ Create src/entities/player.gd
□ Create scenes/entities/player.tscn
□ Implement basic movement (CharacterBody2D)
□ Test: Player moves smoothly with WASD
```

**Implementation:**
```gdscript
# src/entities/player.gd
extends CharacterBody2D

const SPEED: float = 100.0

func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_dir * SPEED
    move_and_slide()
```

**Test:** Load scene, press WASD, player moves.

#### Step 1.2: World Setup
```
□ Create scenes/world.tscn
□ Add TileMapLayer node (name: "Ground")
□ Create simple tileset (32x32 grass tiles)
□ Paint tiles in editor
□ Add Player instance to world
□ Test: Player moves on grass
```

**Critical:** TileMapLayer MUST have painted tiles. Don't leave it empty.

#### Step 1.3: Farm Plot System
```
□ Create src/entities/farm_plot.gd
□ Create scenes/entities/farm_plot.tscn
□ Implement plant/grow/harvest logic
□ Add farm_plot instances to world
□ Test: Farm plots visible and interactable
```

**Implementation:**
```gdscript
# src/entities/farm_plot.gd
extends Node2D

@export var grid_position: Vector2i = Vector2i.ZERO
@onready var crop_sprite: Sprite2D = $CropSprite

var crop_id: String = ""
var current_stage: int = 0

func plant(crop_data_id: String) -> void:
    crop_id = crop_data_id
    current_stage = 0
    GameState.plant_crop(grid_position, crop_id)
    _update_sprite()

func _update_sprite() -> void:
    var crop_data = GameState.get_crop_data(crop_id)
    if crop_data and current_stage < crop_data.growth_stages.size():
        crop_sprite.texture = crop_data.growth_stages[current_stage]
```

#### Step 1.4: Interaction System
```
□ Add Area2D to farm_plot.tscn for detection
□ Add interaction input (E key)
□ Wire up plant/harvest actions
□ Test: Press E near plot → plants seed or harvests
```

#### Step 1.5: Growth System
```
□ Implement day advance in GameState
□ Connect day advance to farm plot updates
□ Test: Advance day → crops grow
```

**Implementation:**
```gdscript
# src/autoloads/game_state.gd
func advance_day() -> void:
    current_day += 1
    day_advanced.emit(current_day)
    _update_all_crops()

func _update_all_crops() -> void:
    for pos in farm_plots:
        var plot_data = farm_plots[pos]
        var days_elapsed = current_day - plot_data["planted_day"]
        var crop_data = get_crop_data(plot_data["crop_id"])

        if days_elapsed >= crop_data.days_to_mature:
            plot_data["ready_to_harvest"] = true
            plot_data["current_stage"] = crop_data.growth_stages.size() - 1
```

#### Step 1.6: Inventory Integration
```
□ Create simple HUD with inventory display
□ Wire up inventory_changed signal
□ Test: Harvest crop → inventory count increases
```

**Test:** Plant wheat → advance 3 days → harvest → inventory shows "Wheat: 1"

---

### Phase 2: Persistence

**Goal:** Save and load game state.

**Acceptance Criteria:**
- [ ] Can save game to `user://savegame.json`
- [ ] Can load game and restore all state
- [ ] Farm plots persist
- [ ] Inventory persists
- [ ] Current day persists

**Workflow:**

#### Step 2.1: Implement Save
```
□ Enhance save_controller.gd with save logic
□ Serialize GameState data to JSON
□ Test: Save game → check user://savegame.json exists
```

#### Step 2.2: Implement Load
```
□ Enhance save_controller.gd with load logic
□ Restore GameState from JSON
□ Rebuild farm plots from save data
□ Test: Load game → state restored correctly
```

#### Step 2.3: UI Integration
```
□ Add Save/Load buttons to main menu
□ Test: Save → quit → load → verify all state
```

---

### Phase 3: Content Expansion

**Goal:** Add more crops, NPCs, dialogue, quests.

**Workflow:**

#### Step 3.1: Additional Crops
```
□ Create resources/crops/tomato.tres
□ Create resources/crops/carrot.tres
□ Add item data for seeds and harvests
□ Test: Can plant/grow/harvest all crops
```

#### Step 3.2: NPC System
```
□ Create src/entities/npc.gd
□ Create scenes/entities/npc.tscn
□ Implement basic movement/idle behavior
□ Test: NPC visible and animated
```

#### Step 3.3: Dialogue System
```
□ Create src/ui/dialogue_box.gd
□ Create scenes/ui/dialogue_box.tscn
□ Implement line-by-line text display
□ Test: Dialogue displays correctly
```

#### Step 3.4: First NPC (Medusa)
```
□ Create resources/npcs/medusa.tres
□ Create resources/dialogues/medusa_intro.tres
□ Add Medusa to world
□ Wire up interaction
□ Test: Talk to Medusa → dialogue appears
```

#### Step 3.5: Quest Flags
```
□ Implement flag setting in dialogue
□ Test flag-gated content
□ Test: Complete quest → flag set → new dialogue available
```

---

### Phase 4: Polish

**Goal:** UI/UX improvements, audio, balance.

**Workflow:**

#### Step 4.1: Audio Integration
```
□ Add SFX for plant/harvest/walk
□ Add background music
□ Test: All sounds play correctly
```

#### Step 4.2: UI Polish
```
□ Create proper inventory panel
□ Add tooltips
□ Add animations
□ Test: UI feels responsive
```

#### Step 4.3: Balance Pass
```
□ Adjust crop prices
□ Adjust growth times
□ Test: Gameplay feels balanced
```

---

## TESTING WORKFLOW

### Automated Tests

**Run all tests:**
```bash
godot --headless --script tests/run_tests.gd
```

**Tests to maintain:**
- `test_autoloads.gd` - Verify autoloads exist
- `test_resources.gd` - Verify resource classes compile
- `test_game_state.gd` - Verify GameState logic

### Manual Testing Checklist

**After ANY change:**
```
□ Does the game launch without errors?
□ Can I complete the core loop? (plant → harvest)
□ Does save/load work?
□ Are there any console errors?
```

---

## GIT WORKFLOW

### Branch Naming

```
claude/<task-description>-<session-id>
```

Example: `claude/implement-player-movement-bnkZr`

### Commit Message Format

```
<type>: <summary>

<optional body>

<optional footer>
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code restructure (no behavior change)
- `docs` - Documentation only
- `test` - Test changes
- `chore` - Build/config changes

**Example:**
```
feat: implement player movement

- Add CharacterBody2D with WASD controls
- Set movement speed to 100 pixels/second
- Add collision shape for world interaction

Closes #1
```

### Commit Frequency

**Commit after each sub-step:**
```
✅ Completed Step 1.1 (Player Movement)
   → git commit -m "feat: add player movement"

✅ Completed Step 1.2 (World Setup)
   → git commit -m "feat: create world with tilemap"
```

### Push Frequency

**Push after each phase milestone:**
```
✅ Phase 0 complete → git push
✅ Phase 1 Step 1-3 complete → git push
```

---

## ERROR HANDLING PROTOCOL

### When You Encounter an Error:

1. **Read the Error Message Carefully**
   - Note the exact error text
   - Note the file and line number

2. **Check CONSTITUTION.md**
   - Is this a known V1 failure mode?
   - What's the prescribed solution?

3. **Verify Autoload Registration**
   ```bash
   grep -A 5 "\[autoload\]" project.godot
   ```

4. **Verify Property Names**
   - Check SCHEMA.md for exact property name
   - Don't guess or hallucinate

5. **Test in Isolation**
   - Load just the scene that's failing
   - Remove dependencies one by one

6. **Ask for Help**
   - Document the error
   - Share your debugging steps
   - Ask user for guidance

---

## HANDOFF PROTOCOL

### When Ending Your Session:

1. **Update PROJECT_STATUS.md**
   - What phase/step did you complete?
   - What's next?

2. **Commit All Work**
   ```bash
   git add -A
   git commit -m "chore: end of session - Phase X Step Y complete"
   git push
   ```

3. **Document Blockers**
   - Add any issues to PROJECT_STATUS.md
   - Flag incomplete work clearly

4. **Leave Clear Next Steps**
   ```
   ## Next Steps for Next Agent:
   - [ ] Complete Step 1.3 (Farm Plot System)
   - [ ] Test interaction with E key
   - [ ] Verify crop sprite updates
   ```

---

## QUICK REFERENCE CARD

**Before writing ANY code:**
```
□ Read CONSTITUTION.md
□ Read SCHEMA.md
□ Check project.godot for autoloads
□ Verify TILE_SIZE = 32
□ Check actual node paths in scenes
□ Use exact property names from SCHEMA.md
□ Test in isolation before integrating
```

**When stuck:**
```
□ Check error message carefully
□ Check CONSTITUTION.md for known issues
□ Verify autoload registration
□ Verify property names in SCHEMA.md
□ Test scene in isolation
□ Ask for help
```

---

**End of DEVELOPMENT_WORKFLOW.md**
