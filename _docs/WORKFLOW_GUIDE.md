# CIRCE'S GARDEN V2 - WORKFLOW GUIDE

**Purpose:** Comprehensive guide for AI agents and developers working on this project.
**Last Updated:** 2025-12-19
**Status:** CANONICAL - This is the authoritative workflow reference.

Note: This document consolidates content from the former DEVELOPMENT_WORKFLOW.md and
ANTIGRAVITY_FEEDBACK.md files, which have been archived to _docs/archive/.

---

## Discrepancy Log (For Senior PM Review)

1) File existence claims in ANTIGRAVITY_FEEDBACK.md are outdated:
   - It states src/entities/player.gd and src/entities/farm_plot.gd do not exist, but both files are present.
2) Branch and working tree status in ANTIGRAVITY_FEEDBACK.md are outdated:
   - It references a specific branch and a clean tree that no longer reflect current state.
3) Phase readiness statements differ from current reality:
   - Both docs assume Phase 1 has not started; current repo includes partial Phase 1 scaffolding and wiring.
4) Roadmap authority conflict:
   - DEVELOPMENT_WORKFLOW.md treats docs/execution/ROADMAP.md as authoritative; the senior PM has paused it for overhaul.
5) Tooling availability statements may be outdated:
   - ANTIGRAVITY_FEEDBACK.md states MCP is unavailable for testing; this should be reconfirmed.

---

## Source A: DEVELOPMENT_WORKFLOW.md (Verbatim)

# CIRCE'S GARDEN V2 - DEVELOPMENT WORKFLOW

**Purpose:** Guide for AI agents and developers working on this project.

---

## FOR NEW AI AGENTS: START HERE

When you join a conversation about this project, **follow this protocol:**

### 1. Read Foundation Documents (5 minutes)

```
â–¡ Read docs/design/CONSTITUTION.md (immutable rules)
â–¡ Read docs/design/SCHEMA.md (data structures)
â–¡ Read PROJECT_STRUCTURE.md (file organization)
â–¡ Read docs/execution/PROJECT_STATUS.md (current phase)
â–¡ Read this file (DEVELOPMENT_WORKFLOW.md)
```

### 2. Verify Current State

```bash
# Check which phase we're in
cat docs/execution/PROJECT_STATUS.md

# Verify autoloads are registered
grep -A 5 "\[autoload\]" project.godot

# Check git status
git status
git log --oneline -5
```

### 3. Ask Clarifying Questions

Before writing ANY code:

```
â–¡ "What phase are we currently in?"
â–¡ "What specific task am I implementing?"
â–¡ "Has the foundation been tested?"
â–¡ "Are there any known blockers?"
```

### 4. Verify Before Assuming

```gdscript
# âŒ DON'T assume this exists:
var crop = CropRegistry.get_crop("wheat")

# âœ… DO check docs/design/SCHEMA.md first:
var crop = GameState.get_crop_data("wheat")  # If this method exists
```

---

## DEVELOPMENT PHASES

### Phase 0: Foundation âœ…

**Acceptance Criteria:**
- [ ] All folders created
- [ ] docs/design/CONSTITUTION.md, docs/design/SCHEMA.md, PROJECT_STRUCTURE.md exist
- [ ] project.godot has autoloads registered
- [ ] All autoload scripts exist and compile
- [ ] All resource class definitions exist
- [ ] Tests pass: `godot --headless --script tests/run_tests.gd`

Note: If `godot` isn't on PATH, use the bundled executable:
`.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64_console.exe --headless --script tests/run_tests.gd`

**Deliverables:**
```
âœ… docs/design/CONSTITUTION.md
âœ… docs/design/SCHEMA.md
âœ… PROJECT_STRUCTURE.md
âœ… DEVELOPMENT_WORKFLOW.md
âœ… docs/execution/PROJECT_STATUS.md
âœ… project.godot
âœ… src/autoloads/game_state.gd
âœ… src/autoloads/audio_controller.gd
âœ… src/autoloads/save_controller.gd
âœ… src/resources/crop_data.gd
âœ… src/resources/item_data.gd
âœ… src/resources/dialogue_data.gd
âœ… src/resources/npc_data.gd
âœ… tests/run_tests.gd
âœ… .gitignore
```

**How to Complete:**
1. Create all files listed above
2. Run tests to verify compilation
3. Commit: `git commit -m "feat: Phase 0 foundation complete"`
4. Update docs/execution/PROJECT_STATUS.md to Phase 1

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
â–¡ Create src/entities/player.gd
â–¡ Create scenes/entities/player.tscn
â–¡ Implement basic movement (CharacterBody2D)
â–¡ Test: Player moves smoothly with WASD
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
â–¡ Create scenes/world.tscn
â–¡ Add TileMapLayer node (name: "Ground")
â–¡ Create simple tileset (32x32 grass tiles)
â–¡ Paint tiles in editor
â–¡ Add Player instance to world
â–¡ Test: Player moves on grass
```

**Critical:** TileMapLayer MUST have painted tiles. Don't leave it empty.

#### Step 1.3: Farm Plot System
```
â–¡ Create src/entities/farm_plot.gd
â–¡ Create scenes/entities/farm_plot.tscn
â–¡ Implement plant/grow/harvest logic
â–¡ Add farm_plot instances to world
â–¡ Test: Farm plots visible and interactable
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
â–¡ Add Area2D to farm_plot.tscn for detection
â–¡ Add interaction input (E key)
â–¡ Wire up plant/harvest actions
â–¡ Test: Press E near plot â†’ plants seed or harvests
```

#### Step 1.5: Growth System
```
â–¡ Implement day advance in GameState
â–¡ Connect day advance to farm plot updates
â–¡ Test: Advance day â†’ crops grow
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
â–¡ Create simple HUD with inventory display
â–¡ Wire up inventory_changed signal
â–¡ Test: Harvest crop â†’ inventory count increases
```

**Test:** Plant wheat â†’ advance 3 days â†’ harvest â†’ inventory shows "Wheat: 1"

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
â–¡ Enhance save_controller.gd with save logic
â–¡ Serialize GameState data to JSON
â–¡ Test: Save game â†’ check user://savegame.json exists
```

#### Step 2.2: Implement Load
```
â–¡ Enhance save_controller.gd with load logic
â–¡ Restore GameState from JSON
â–¡ Rebuild farm plots from save data
â–¡ Test: Load game â†’ state restored correctly
```

#### Step 2.3: UI Integration
```
â–¡ Add Save/Load buttons to main menu
â–¡ Test: Save â†’ quit â†’ load â†’ verify all state
```

---

### Phase 3: Content Expansion

**Goal:** Add more crops, NPCs, dialogue, quests.

**Workflow:**

#### Step 3.1: Additional Crops
```
â–¡ Create resources/crops/tomato.tres
â–¡ Create resources/crops/carrot.tres
â–¡ Add item data for seeds and harvests
â–¡ Test: Can plant/grow/harvest all crops
```

#### Step 3.2: NPC System
```
â–¡ Create src/entities/npc.gd
â–¡ Create scenes/entities/npc.tscn
â–¡ Implement basic movement/idle behavior
â–¡ Test: NPC visible and animated
```

#### Step 3.3: Dialogue System
```
â–¡ Create src/ui/dialogue_box.gd
â–¡ Create scenes/ui/dialogue_box.tscn
â–¡ Implement line-by-line text display
â–¡ Test: Dialogue displays correctly
```

#### Step 3.4: First NPC (Medusa)
```
â–¡ Create resources/npcs/medusa.tres
â–¡ Create resources/dialogues/medusa_intro.tres
â–¡ Add Medusa to world
â–¡ Wire up interaction
â–¡ Test: Talk to Medusa â†’ dialogue appears
```

#### Step 3.5: Quest Flags
```
â–¡ Implement flag setting in dialogue
â–¡ Test flag-gated content
â–¡ Test: Complete quest â†’ flag set â†’ new dialogue available
```

---

### Phase 4: Polish

**Goal:** UI/UX improvements, audio, balance.

**Workflow:**

#### Step 4.1: Audio Integration
```
â–¡ Add SFX for plant/harvest/walk
â–¡ Add background music
â–¡ Test: All sounds play correctly
```

#### Step 4.2: UI Polish
```
â–¡ Create proper inventory panel
â–¡ Add tooltips
â–¡ Add animations
â–¡ Test: UI feels responsive
```

#### Step 4.3: Balance Pass
```
â–¡ Adjust crop prices
â–¡ Adjust growth times
â–¡ Test: Gameplay feels balanced
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
â–¡ Does the game launch without errors?
â–¡ Can I complete the core loop? (plant â†’ harvest)
â–¡ Does save/load work?
â–¡ Are there any console errors?
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
âœ… Completed Step 1.1 (Player Movement)
   â†’ git commit -m "feat: add player movement"

âœ… Completed Step 1.2 (World Setup)
   â†’ git commit -m "feat: create world with tilemap"
```

### Push Frequency

**Push after each phase milestone:**
```
âœ… Phase 0 complete â†’ git push
âœ… Phase 1 Step 1-3 complete â†’ git push
```

---

## ERROR HANDLING PROTOCOL

### When You Encounter an Error:

1. **Read the Error Message Carefully**
   - Note the exact error text
   - Note the file and line number

2. **Check docs/design/CONSTITUTION.md**
   - Is this a known V1 failure mode?
   - What's the prescribed solution?

3. **Verify Autoload Registration**
   ```bash
   grep -A 5 "\[autoload\]" project.godot
   ```

4. **Verify Property Names**
   - Check docs/design/SCHEMA.md for exact property name
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

1. **Update docs/execution/PROJECT_STATUS.md**
   - What phase/step did you complete?
   - What's next?

2. **Commit All Work**
   ```bash
   git add -A
   git commit -m "chore: end of session - Phase X Step Y complete"
   git push
   ```

3. **Document Blockers**
   - Add any issues to docs/execution/PROJECT_STATUS.md
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
â–¡ Read docs/design/CONSTITUTION.md
â–¡ Read docs/design/SCHEMA.md
â–¡ Check project.godot for autoloads
â–¡ Verify TILE_SIZE = 32
â–¡ Check actual node paths in scenes
â–¡ Use exact property names from docs/design/SCHEMA.md
â–¡ Test in isolation before integrating
```

**When stuck:**
```
â–¡ Check error message carefully
â–¡ Check docs/design/CONSTITUTION.md for known issues
â–¡ Verify autoload registration
â–¡ Verify property names in docs/design/SCHEMA.md
â–¡ Test scene in isolation
â–¡ Ask for help
```

---

**End of DEVELOPMENT_WORKFLOW.md**


---

## Source B: ANTIGRAVITY_FEEDBACK.md (Verbatim)

# ANTIGRAVITY AI - AUDIT & OPERATIONAL GUIDELINES

**Created:** December 16, 2025
**Updated:** December 16, 2025 (Revised)
**Purpose:** Provide explicit guardrails, tool documentation, and workflow boundaries
**Status:** Phase 0 Complete â†’ Phase 1 Ready to Start

---

## ðŸ” PROJECT AUDIT - CURRENT STATE

### âœ… What Has Been Completed (Phase 0)

**Documentation Foundation:**
- âœ… docs/design/CONSTITUTION.md - Immutable technical rules (CORRECTED: Now says Circe's Garden)
- âœ… docs/design/SCHEMA.md - Data structure definitions (exact property names)
- âœ… docs/execution/ROADMAP.md - Step-by-step Phase 1 implementation guide with code templates
- âœ… PROJECT_SUMMARY.md - Quick reference
- âœ… docs/execution/PROJECT_STATUS.md - Current progress tracker
- âœ… PLAYTESTER_GUIDE.md - Testing instructions
- âœ… docs/design/Storyline.md - Complete narrative (CIRCE'S GARDEN - 4,687 lines)
- âœ… docs/execution/ROADMAP.md - Quest-by-quest story implementation plan
- âœ… ASSET_CHECKLIST.md - Complete asset inventory (~150 assets documented)

**Godot Project Structure:**
- âœ… project.godot - Autoloads pre-registered (GameState, AudioController, SaveController)
- âœ… src/autoloads/game_state.gd - Central state management with TILE_SIZE = 32
- âœ… src/autoloads/audio_controller.gd - Audio system stub
- âœ… src/autoloads/save_controller.gd - Save/load system stub
- âœ… src/resources/crop_data.gd - CropData resource class (class_name defined)
- âœ… src/resources/item_data.gd - ItemData resource class
- âœ… src/resources/dialogue_data.gd - DialogueData resource class
- âœ… src/resources/npc_data.gd - NPCData resource class
- âœ… resources/crops/TEMPLATE_crop.tres - Example crop data file
- âœ… scenes/ui/main_menu.tscn - Placeholder menu scene (purple background, title, buttons)
- âœ… scenes/entities/player.tscn - Placeholder player scene (**NO SCRIPT ATTACHED YET**)
- âœ… scenes/entities/farm_plot.tscn - Placeholder farm plot scene (**NO SCRIPT YET**)
- âœ… scenes/world.tscn - Placeholder world scene (blue background, player instance)
- âœ… TEST_SCRIPT.gd - Automated Phase 0 validation script

**Git Status:**
- âœ… All Phase 0 work committed and pushed
- âœ… Branch: claude/access-data-bnkZr
- âœ… Working tree: CLEAN
- âœ… Ready for Phase 1 implementation

### âŒ What Has NOT Been Implemented Yet

**Phase 1 Tasks (ALL PENDING - 0% Complete):**
- âŒ Player movement script (src/entities/player.gd) - **FILE DOES NOT EXIST**
- âŒ Farm plot script (src/entities/farm_plot.gd) - **FILE DOES NOT EXIST**
- âŒ Interaction system - **NOT IMPLEMENTED**
- âŒ Scene transition system (SceneManager autoload) - **NOT IMPLEMENTED**
- âŒ Farming state machine - **NOT IMPLEMENTED**
- âŒ Crafting system - **NOT IMPLEMENTED**
- âŒ Dialogue system - **NOT IMPLEMENTED**

**Critical Understanding:**
- The placeholder scenes exist but are **non-functional** without scripts
- This is **intentional** - Phase 1 starts with implementing these scripts
- Follow docs/execution/ROADMAP.md exactly - it has complete code templates

### ðŸ“Š Project Readiness Assessment

| Category | Status | Notes |
|----------|--------|-------|
| Documentation | âœ… Excellent | Comprehensive roadmap with code templates |
| Structure | âœ… Complete | All folders, autoloads, resource classes set up |
| Implementation | âšª Not Started | Phase 1 tasks are 0% complete - ready to begin |
| Code Quality | âœ… Clean | No implementation = no bugs yet |
| Clarity | âœ… Very High | Step-by-step instructions with exact code provided |

**Verdict:** Project is in **IDEAL** state to begin Phase 1 implementation.

---

## ðŸ› ï¸ AVAILABLE TOOLS & TESTING STRATEGY

### Standard Development Tools

**File Operations:**
- **Read** - Read any file in the codebase (use liberally to verify state)
- **Write** - Create new files (scripts, scenes, resources)
- **Edit** - Modify existing files with exact string replacement
- **Glob** - Find files by pattern (e.g., `**/*.gd`, `src/entities/*.gd`)
- **Grep** - Search for content in files (find property usage, function calls)

**Execution:**
- **Bash** - Run shell commands (git operations, file checks, etc.)

**IMPORTANT:** MCP Godot server is **NOT** currently available for Antigravity AI.
Testing must be done through **code review and validation** via standard tools.

### Testing Strategy WITHOUT MCP

Since you cannot run Godot directly, use these validation methods:

#### 1. **Static Code Validation**

**Before creating any script:**
```bash
# Check if file already exists
ls -la src/entities/player.gd

# Verify parent directory exists
ls -la src/entities/
```

**After creating a script:**
```bash
# Verify file was created
ls -la src/entities/player.gd

# Check file size (should be reasonable, not empty)
wc -l src/entities/player.gd

# Preview the content
head -30 src/entities/player.gd
```

#### 2. **Syntax Validation (GDScript)**

**Check for common syntax errors:**
```bash
# Look for unmatched parentheses/brackets (rough check)
grep -c "(" src/entities/player.gd
grep -c ")" src/entities/player.gd
# Counts should match

# Check for TODO/FIXME markers
grep -i "TODO\|FIXME" src/entities/player.gd
```

**Validate against template:**
- Read the code template from docs/execution/ROADMAP.md
- Compare line-by-line with your implementation
- Ensure no deviations unless documented

#### 3. **Dependency Verification**

**Check property names match docs/design/SCHEMA.md:**
```bash
# Example: Verify you're using correct CropData properties
grep "growth_stages" src/entities/farm_plot.gd
# Should find usage

grep "sprites" src/entities/farm_plot.gd
# Should NOT find (wrong property name)
```

**Check autoload references:**
```bash
# Verify autoloads are referenced correctly
grep "GameState\." src/entities/farm_plot.gd
# Should find calls like GameState.add_item()

# Verify spelling
grep "GameStat\." src/entities/farm_plot.gd
# Should be EMPTY (typo check)
```

#### 4. **Scene Structure Validation**

**Check .tscn files for script references:**
```bash
# Verify script is attached to scene
grep "script = " scenes/entities/player.tscn
# Should show: script = ExtResource("path_to_player.gd")

# Check node structure
grep "node name=" scenes/entities/player.tscn
# Should show all expected nodes
```

#### 5. **Cross-Reference Validation**

**Before implementing, read related files:**
```gdscript
# Example workflow for implementing farm_plot.gd:

1. Read docs/design/SCHEMA.md â†’ Check CropData properties
2. Read src/autoloads/game_state.gd â†’ Check available methods
3. Read docs/execution/ROADMAP.md â†’ Check code template
4. Write src/entities/farm_plot.gd using EXACT template
5. Read your own file back â†’ Verify it matches template
6. Grep for property names â†’ Ensure they match docs/design/SCHEMA.md
7. Commit only if all validations pass
```

#### 6. **Validation Checklist (Use After EVERY Implementation)**

**File Creation:**
- [ ] File created in correct location (src/entities/, src/ui/, etc.)
- [ ] File extension correct (.gd for scripts, .tres for resources, .tscn for scenes)
- [ ] File size reasonable (not empty, not suspiciously large)
- [ ] Can read file back successfully

**Code Quality:**
- [ ] Extends correct base class (CharacterBody2D, Node2D, etc.)
- [ ] All @onready vars reference nodes that exist in scene
- [ ] All property names match docs/design/SCHEMA.md exactly
- [ ] All constants use defined values (TILE_SIZE, not magic numbers)
- [ ] All autoload calls reference registered autoloads

**Template Adherence:**
- [ ] Code matches docs/execution/ROADMAP.md template
- [ ] No additions beyond template (unless explicitly instructed)
- [ ] No omissions from template
- [ ] Function signatures match exactly

**Integration:**
- [ ] Script attached to correct scene file
- [ ] Scene structure matches specification
- [ ] Node names match @onready references
- [ ] No circular dependencies

---

## âš ï¸ OVERZEALOUS BEHAVIOR PATTERNS (CRITICAL)

### Understanding "Overzealous"

**Overzealous does NOT mean:** Working too quickly or completing tasks efficiently

**Overzealous MEANS:**
- ðŸš¨ **Diverging from the plan** (implementing something not in docs/execution/ROADMAP.md)
- ðŸš¨ **Writing too much code** (adding features beyond the task scope)
- ðŸš¨ **Adding unnecessary things** (helper functions, optimizations, extras not requested)
- ðŸš¨ **Going beyond boundaries** (implementing Task 1.1.2 when only 1.1.1 was assigned)

### ðŸš¨ Pattern 1: Scope Creep - Adding Unnecessary Features

**Symptom:** Implementing features not in the roadmap

**Examples:**
- âŒ Task: "Implement player movement"
  Overzealous: Adds animation system, particle effects, footstep sounds

- âŒ Task: "Create farm plot entity"
  Overzealous: Adds fertilizer system, crop diseases, weather effects

- âŒ Task: "Implement dialogue box"
  Overzealous: Adds voice acting system, portrait animations, typewriter sound

**Why This Fails:**
- Adds complexity not in the design
- May conflict with actual plans in later phases
- Wastes time on non-essential features
- Makes debugging harder (more code = more bugs)
- Deviates from tested roadmap

**Correct Approach:**
- âœ… Read the task in docs/execution/ROADMAP.md
- âœ… Implement ONLY what's in the code template
- âœ… If template seems incomplete, **ask** before adding
- âœ… Trust the roadmap - features omitted now may be in later phases

**Red Flags:**
- "I also added..." (unless explicitly requested)
- "I improved..." (unless asked to optimize)
- "I thought it would be better if..." (opinion, not requirement)
- Creating helper functions not in template
- Adding configuration options not specified

---

### ðŸš¨ Pattern 2: Diverging from Code Templates

**Symptom:** Writing code that differs from docs/execution/ROADMAP.md templates

**Examples:**
- âŒ Template shows simple movement, you add acceleration/deceleration
- âŒ Template uses `Input.get_vector()`, you create custom input buffering
- âŒ Template has 50 lines, your version has 200 lines

**Why This Fails:**
- Templates are tested and designed to work together
- Your changes may break integration with future systems
- Makes handoff harder (next AI expects template code)
- May introduce bugs not present in template

**Correct Approach:**
- âœ… Copy template code EXACTLY from docs/execution/ROADMAP.md
- âœ… Only fill in obvious placeholders (like scene paths)
- âœ… If you think template has an error, **ask** before changing
- âœ… Use template as-is even if you think you can "improve" it

---

### ðŸš¨ Pattern 3: Writing Too Much Code in One Session

**Symptom:** Creating multiple files or implementing multiple subsections at once

**Examples:**
- âŒ Creating player.gd, farm_plot.gd, dialogue_manager.gd all at once
- âŒ Implementing tasks 1.1.1, 1.1.2, and 1.1.3 together
- âŒ "I finished all of Section 1.1 in one go"

**Why This Fails:**
- Cannot isolate which code caused bugs
- Validation becomes impossible (too many variables)
- One error cascades across multiple systems
- Commit becomes too large to review effectively
- If something fails, have to undo large amounts of work

**Correct Approach:**
- âœ… Implement ONE subsection per session (e.g., 1.1.1 only)
- âœ… Validate that ONE piece thoroughly
- âœ… Commit it
- âœ… Report completion and ask to proceed to next subsection
- âœ… Then (and only then) start next subsection

**Size Limits:**
| Work Type | Maximum Per Session |
|-----------|-------------------|
| Scripts | 1 file |
| Subsections | 1 subsection (e.g., 1.1.1) |
| Features | 1 feature implementation |
| Commits | 1 per subsection |

---

### ðŸš¨ Pattern 4: Hallucinating Property Names

**Symptom:** Guessing property names instead of checking docs/design/SCHEMA.md

**Examples:**
- âŒ `crop_data.sprites` (wrong - should be `growth_stages`)
- âŒ `crop_data.growth_time` (wrong - should be `days_to_mature`)
- âŒ `GameState.player_inventory` (wrong - should be `GameState.inventory`)
- âŒ `item.item_id` (wrong - should be `item.id`)

**Why This Fails:**
- Property doesn't exist â†’ runtime error
- Code won't work when actually run
- Breaks integration with other systems that use correct names

**Correct Approach:**
- âœ… **BEFORE** writing any code that uses a property:
  1. Read docs/design/SCHEMA.md
  2. Find the exact property name
  3. Copy-paste it into your code
- âœ… When uncertain, grep existing code: `grep "growth_stages" src/resources/crop_data.gd`
- âœ… Never guess - verify

**Mandatory Check:**
```bash
# After writing code, check property usage
grep "crop_data\." src/entities/farm_plot.gd

# For each property found, verify it exists in docs/design/SCHEMA.md
# Read docs/design/SCHEMA.md and confirm each property name is correct
```

---

### ðŸš¨ Pattern 5: Ignoring docs/design/CONSTITUTION.md Rules

**Symptom:** Not following immutable technical rules

**Examples:**
- âŒ Using hardcoded numbers: `position = Vector2(16, 16)` (should use TILE_SIZE)
- âŒ Referencing autoload before checking registration: `DialogueManager.start()` (not registered yet)
- âŒ Creating .tres files before class exists: `wheat.tres` created before `crop_data.gd`
- âŒ Not matching folder structure: Putting script in `scenes/` instead of `src/`

**Why This Fails:**
- Violates project standards (inconsistent codebase)
- Causes runtime crashes (missing autoloads)
- Makes code unmaintainable (magic numbers everywhere)
- Repeats V1 architectural failures

**Correct Approach:**
- âœ… Read docs/design/CONSTITUTION.md section relevant to your task
- âœ… Check project.godot for autoload registration before referencing
- âœ… Use constants: `GameState.TILE_SIZE` not `32`
- âœ… Follow folder structure strictly
- âœ… Verify resource class exists before creating .tres file

---

### ðŸš¨ Pattern 6: Jumping Into Fixes Without Debugging

**Symptom:** Finding a bug and immediately trying to fix it without understanding root cause

**Examples:**
- âŒ "Player movement doesn't work, let me rewrite the whole function"
- âŒ "Getting an error, I'll add a null check here"
- âŒ "Farm plot isn't tilling, let me add more debug prints randomly"

**Why This Fails:**
- May fix symptom but not root cause
- Introduces new bugs while fixing old ones
- Wastes time on wrong solution
- Makes code messier with band-aid fixes

**Correct Approach:** See "Debugging Workflow" section below â¬‡ï¸

---

## ðŸ› COMPREHENSIVE DEBUGGING WORKFLOW

### When You Encounter a Bug or Unexpected Behavior

**DO NOT immediately try to fix it.** Follow this workflow:

---

### Phase 1: STOP and DOCUMENT

**Step 1: Stop Coding**
- ðŸ›‘ **Pause** - Do not write any more code
- ðŸ›‘ **Do not attempt a quick fix**
- ðŸ›‘ **Step back from the problem**

**Step 2: Document the Bug**
```markdown
## Bug Report

**What I Was Doing:**
[Implementing Task X.X.X - describe the task]

**What I Expected:**
[Player should move when pressing WASD]

**What Actually Happened:**
[Player doesn't move, no console errors visible]

**Code Location:**
[src/entities/player.gd, lines 10-25]

**Error Messages:**
[Paste any error messages if visible, or "None visible"]
```

---

### Phase 2: GATHER INFORMATION

**Step 3: Read Related Files**
```bash
# Re-read the original specification
# Find the task in docs/execution/ROADMAP.md
grep -A 50 "1.1.2 - Player Movement" docs/execution/ROADMAP.md

# Read the code template again
# Compare your implementation line-by-line
```

**Step 4: Check Dependencies**
```bash
# Verify the scene structure
grep "node name=" scenes/entities/player.tscn

# Verify script attachment
grep "script = " scenes/entities/player.tscn

# Check if file exists
ls -la src/entities/player.gd

# Check autoload registration (if using autoloads)
grep "GameState" project.godot
```

**Step 5: Validate Property Names**
```bash
# Read docs/design/SCHEMA.md to verify property names
grep "velocity\|move_and_slide" docs/design/SCHEMA.md

# Check docs/design/CONSTITUTION.md for relevant rules
grep -A 10 "TILE_SIZE\|NODE PATH" docs/design/CONSTITUTION.md
```

**Step 6: Cross-Reference Template**
- Read docs/execution/ROADMAP.md code template for this task
- Open your implementation side-by-side (mentally)
- Note EVERY difference, even small ones:
  - Different variable names?
  - Different function order?
  - Added extra code?
  - Omitted something from template?

---

### Phase 3: ANALYZE ROOT CAUSE

**Step 7: Form Hypotheses**

Based on gathered information, list possible causes:
```markdown
## Possible Causes:

1. Script not attached to scene (verify with grep)
2. Node names don't match @onready references
3. Typo in function name (_physics_process vs _process)
4. Using wrong property name (velocity vs linear_velocity)
5. Scene structure doesn't match template
6. [Add more based on your findings]
```

**Step 8: Test Hypotheses (Most Likely First)**

**For each hypothesis, validate:**
```bash
# Hypothesis 1: Script not attached
grep "script = " scenes/entities/player.tscn
# Expected: Should show "script = ExtResource(...player.gd)"
# Result: [Document what you found]

# Hypothesis 2: Node names wrong
grep "@onready var sprite" src/entities/player.gd
# Shows: @onready var sprite: Sprite2D = $Sprite
grep "node name=\"Sprite\"" scenes/entities/player.tscn
# Expected: Should find node named "Sprite"
# Result: [Document what you found]
```

**Step 9: Identify Root Cause**
```markdown
## Root Cause Identified:

[Describe the actual problem found]
Example: "Script is attached, but node name in scene is 'Sprite2D', not 'Sprite'.
The @onready reference $Sprite fails to find the node."
```

---

### Phase 4: PLAN THE FIX

**Step 10: Determine Minimal Fix**

**Ask yourself:**
1. What is the SMALLEST change that fixes the root cause?
2. Does the fix align with docs/execution/ROADMAP.md template?
3. Does the fix violate any docs/design/CONSTITUTION.md rules?
4. Will the fix affect other systems?

**Document the planned fix:**
```markdown
## Planned Fix:

**Change:** Rename node from "Sprite2D" to "Sprite" in player.tscn
**Why:** Matches @onready reference in player.gd and template specification
**Risk:** None - isolated change
**Verification:** After fix, grep scene file to confirm node name changed
```

---

### Phase 5: IMPLEMENT THE FIX

**Step 11: Make the Minimal Change**
```bash
# Example: Fix the node name in scene file
# Use Edit tool to change node name from "Sprite2D" to "Sprite"
```

**Step 12: Verify the Fix**
```bash
# Check the change was applied
grep "node name=\"Sprite\"" scenes/entities/player.tscn
# Should now show correct node name

# Re-check cross-references
grep "@onready var sprite" src/entities/player.gd
grep "node name=\"Sprite\"" scenes/entities/player.tscn
# Both should align now
```

---

### Phase 6: VALIDATE SOLUTION

**Step 13: Run All Validation Checks Again**

Use the "Validation Checklist" from earlier:
- [ ] File structure correct
- [ ] Code matches template
- [ ] Property names match docs/design/SCHEMA.md
- [ ] Node references align with scene structure
- [ ] No new issues introduced

**Step 14: Document the Fix**
```markdown
## Bug Fixed:

**Root Cause:** Node named "Sprite2D" but @onready expected "Sprite"
**Fix Applied:** Renamed node to "Sprite" in player.tscn
**Validation:** Grep confirms node name now matches reference
**Commit Message:** "fix: correct Sprite node name in player scene to match script reference"
```

---

### Phase 7: REFLECT AND PREVENT

**Step 15: Update Process to Prevent Recurrence**
```markdown
## Prevention:

**Why did this happen?**
[I created the scene with default node name "Sprite2D" but template specified "Sprite"]

**How to prevent in future?**
[Always verify node names match template specification BEFORE attaching script]
[Add to personal checklist: Verify all @onready paths before testing]
```

---

### Debugging Decision Tree

```
Found unexpected behavior
â”‚
â”œâ”€â†’ Error message visible?
â”‚   â”œâ”€ Yes â†’ Read error message, identify line number, go to Phase 2
â”‚   â””â”€ No â†’ Go to Phase 2 (gather information)
â”‚
Phase 2: Gather Information
â”œâ”€ Re-read specification
â”œâ”€ Check dependencies
â”œâ”€ Validate property names
â””â”€ Cross-reference template
â”‚
Phase 3: Analyze
â”œâ”€ Form hypotheses (at least 3)
â”œâ”€ Test each hypothesis systematically
â””â”€ Identify root cause
â”‚
Phase 4: Plan Fix
â”œâ”€ Determine minimal change
â”œâ”€ Check against rules
â””â”€ Document plan
â”‚
Phase 5: Implement
â”œâ”€ Make change
â””â”€ Verify change applied
â”‚
Phase 6: Validate
â”œâ”€ Run all checks
â””â”€ Document fix
â”‚
Phase 7: Reflect
â””â”€ Update process
```

---

### Red Flags During Debugging

**ðŸš¨ Stop and reassess if you find yourself:**
- Adding random debug prints without hypothesis
- Rewriting large sections of code
- Adding try-catch or null checks without understanding why they're needed
- Copying code from internet/examples
- Making multiple changes at once
- "Let me just try this..." approaches

**âœ… You're debugging correctly when:**
- You can explain the root cause clearly
- Your fix is minimal and targeted
- You can predict the outcome of the fix
- The fix aligns with project standards
- You've documented the bug and fix

---

## ðŸ”’ STRICT WORKFLOW GUARDRAILS

### Mandatory Workflow for EVERY Task

```
STEP 1: Read Task Specification
â”œâ”€ Open docs/execution/ROADMAP.md
â”œâ”€ Find your current task (e.g., 1.1.1)
â”œâ”€ Read the ENTIRE section (goals, tasks, code template, test criteria)
â””â”€ Understand what success looks like

STEP 2: Verify Prerequisites
â”œâ”€ Check dependencies listed in task
â”œâ”€ Verify required files exist (use ls, Read)
â”œâ”€ Verify autoloads registered if needed (grep project.godot)
â””â”€ If dependencies missing â†’ STOP and report

STEP 3: Read Related Documentation
â”œâ”€ Check docs/design/SCHEMA.md for property names you'll use
â”œâ”€ Check docs/design/CONSTITUTION.md for relevant rules
â”œâ”€ Read related files (e.g., if modifying scene, read the .tscn file first)
â””â”€ Take notes on exact property names and constants

STEP 4: Implement (Following Template EXACTLY)
â”œâ”€ Copy code template from docs/execution/ROADMAP.md
â”œâ”€ Paste into appropriate file
â”œâ”€ Fill in any placeholders (file paths, etc.)
â”œâ”€ DO NOT add code beyond template
â””â”€ DO NOT "improve" or "optimize" unless explicitly asked

STEP 5: Self-Validate
â”œâ”€ Read your own code back (use Read tool)
â”œâ”€ Compare line-by-line with template
â”œâ”€ Run validation checks (grep for property names, check file structure)
â”œâ”€ Use validation checklist from "Testing Strategy" section
â””â”€ If validation fails â†’ Debug using debugging workflow

STEP 6: Commit
â”œâ”€ Stage changes: git add <files>
â”œâ”€ Commit with template message from docs/execution/ROADMAP.md
â”œâ”€ Check commit succeeded: git log -1
â””â”€ Verify working tree clean: git status

STEP 7: Update Status
â”œâ”€ Edit docs/execution/PROJECT_STATUS.md
â”œâ”€ Mark current task as complete
â”œâ”€ Update progress percentage if applicable
â””â”€ Commit status update

STEP 8: Report and Stop
â”œâ”€ Report: "Task X.X.X complete"
â”œâ”€ List what was implemented
â”œâ”€ List validation results (all checks passed)
â”œâ”€ Ask: "Ready to proceed to Task X.X.Y?"
â””â”€ WAIT for approval before continuing
```

---

### Hard Rules (NEVER Violate)

**Rule 1: ONE Subsection at a Time**
- âŒ NEVER implement 1.1.1 AND 1.1.2 together
- âœ… Implement 1.1.1 â†’ Validate â†’ Commit â†’ Report â†’ Wait â†’ Then 1.1.2

**Rule 2: EXACT Template Adherence**
- âŒ NEVER add code not in template (unless explicitly requested)
- âœ… Copy template exactly, fill obvious placeholders only

**Rule 3: Property Names from docs/design/SCHEMA.md**
- âŒ NEVER guess property names
- âœ… Read docs/design/SCHEMA.md, copy-paste exact names

**Rule 4: Validate Before Commit**
- âŒ NEVER commit without running validation checklist
- âœ… Check file structure, property names, template match

**Rule 5: Stop at Checkpoints**
- âŒ NEVER auto-continue to next section
- âœ… Report completion, wait for approval

**Rule 6: Debug Systematically**
- âŒ NEVER jump into random fixes
- âœ… Follow debugging workflow: Stop â†’ Document â†’ Analyze â†’ Plan â†’ Fix

**Rule 7: No Premature Optimization**
- âŒ NEVER add performance optimizations not requested
- âœ… Implement functionality first, optimize later if asked

---

### Acceptable Work Increments

**âœ… ONE Subsection Per Session:**
```
Session 1: Task 1.1.1 (Player scene creation)
â”œâ”€ Read spec â†’ Implement â†’ Validate â†’ Commit â†’ Report â†’ STOP

Session 2: Task 1.1.2 (Player movement script)
â”œâ”€ Read spec â†’ Implement â†’ Validate â†’ Commit â†’ Report â†’ STOP

Session 3: Task 1.1.3 (Interaction system)
â”œâ”€ Read spec â†’ Implement â†’ Validate â†’ Commit â†’ Report â†’ STOP
```

**âŒ NOT Acceptable:**
```
Session 1: Tasks 1.1.1 + 1.1.2 + 1.1.3 + 1.2.1 all at once
â”œâ”€ Too much at once â†’ Hard to validate â†’ Errors accumulate â†’ âŒ
```

---

### Progress Reporting Protocol

**After completing each subsection:**

```markdown
## Task X.X.X Complete

**Implemented:**
- [Bullet list of what was created/modified]
- Example: Created src/entities/player.gd with movement logic
- Example: Attached script to scenes/entities/player.tscn

**Validation Results:**
- [List of checks performed]
- âœ… File created in correct location
- âœ… Code matches docs/execution/ROADMAP.md template
- âœ… Property names verified against docs/design/SCHEMA.md
- âœ… No syntax errors (grep checks passed)
- âœ… Committed with message: "feat: implement player movement system"

**Files Changed:**
- src/entities/player.gd (new file, 45 lines)
- scenes/entities/player.tscn (modified, attached script)
- docs/execution/PROJECT_STATUS.md (marked 1.1.2 complete)

**Next Task:** X.X.Y (Describe next task)

**Ready to proceed to X.X.Y?**
```

**You will respond:** "Proceed" or "Fix [specific issue] first"

**Important:** You (the user) will NOT review code quality - that's the senior AI's job (me). You only approve progression to next tasks. If there are code issues, I (Claude) will catch them during the next session or through validation.

---

## ðŸŽ¯ GO / NO-GO CRITERIA

### âœ… You Are CLEAR to Proceed When:

**Task Level:**
- Current subsection fully implemented (file created, code written)
- All validation checks passed (see checklist)
- Code matches docs/execution/ROADMAP.md template
- Property names verified against docs/design/SCHEMA.md
- Commit completed successfully
- docs/execution/PROJECT_STATUS.md updated
- User approved: "Proceed" or "Continue"

**Section Level:**
- All subsections in section complete (e.g., 1.1.1, 1.1.2, 1.1.3 all done)
- No known bugs or errors
- Git working tree clean
- User approved: "Move to next section"

### ðŸ›‘ You Must STOP When:

**Immediately stop if:**
- Validation check fails (file in wrong place, property name wrong, etc.)
- Code doesn't match template (unexplained deviations)
- You can't find required information (property not in docs/design/SCHEMA.md)
- You've completed current subsection (don't auto-continue)
- You've completed full section (e.g., all of 1.1)
- You encounter unexpected behavior/bug
- Git operation fails

**When stopped, report:**
```markdown
## STOPPED - Issue Encountered

**Task:** X.X.X
**Issue:** [Describe problem]
**What I've Tried:** [Debugging steps taken]
**Hypothesis:** [What you think is wrong]
**Blocker:** [What's preventing progression]

**Need Guidance:** [What information/decision needed]
```

### â“ You Must ASK Senior AI (Me, Claude) When:

**Technical Questions:**
- Template seems to have an error or omission
- Property name not found in docs/design/SCHEMA.md
- docs/design/CONSTITUTION.md rule conflicts with task
- Unclear how to implement something
- Need clarification on spec

**Format for Questions:**
```markdown
## Question for Senior AI

**Task:** X.X.X
**Context:** [What you're trying to do]
**Issue:** [What's unclear]
**Options Considered:**
1. [Option A]
2. [Option B]

**Recommendation:** [Which option you think is best and why]

**Waiting for guidance before proceeding.**
```

**DO NOT ask user** - they are non-technical and learning to code. Technical questions go to senior AI (me).

---

## ðŸ“– REQUIRED READING ORDER

**Before Starting ANY Work:**

**Priority 1 (Read Fully):**
1. âœ… This file (ANTIGRAVITY_FEEDBACK.md) - Current document
2. docs/design/CONSTITUTION.md - Immutable technical rules
3. docs/design/SCHEMA.md - Data structure definitions

**Priority 2 (Read Task-Specific Section):**
4. docs/execution/ROADMAP.md (Read ONLY your current task section)
   - Example: If doing Task 1.1.1, read Task 1.1.1 section only
   - Don't read ahead (prevents confusion and scope creep)

**Priority 3 (Reference as Needed):**
5. docs/execution/PROJECT_STATUS.md - Verify current phase and dependencies
6. PROJECT_SUMMARY.md - Quick reference if need context

**Not Immediately Needed:**
7. docs/design/Storyline.md - (Read when implementing Phase 2 story quests)
8. docs/execution/ROADMAP.md - (Not needed until Phase 1 complete)
9. ASSET_CHECKLIST.md - (For asset creation, not code implementation)
10. PLAYTESTER_GUIDE.md - (For testing after features implemented)

---

## ðŸ§­ VIBE CODING PRINCIPLES (For Agentic Workflows)

### Based on Google and Claude's Agentic Coding Guidelines

**Principle 1: Explicit Over Implicit**
- Template code is provided â†’ Use it exactly
- Property names documented â†’ Copy them
- Folder structure defined â†’ Follow it
- DON'T rely on "common sense" or "best practices" - rely on documentation

**Principle 2: Verify Before Implement**
- Read files before modifying them
- Check dependencies before using them
- Validate assumptions with grep/ls
- "Trust but verify" everything

**Principle 3: Small, Validated Steps**
- One file at a time
- One feature at a time
- Validate immediately
- Commit granularly

**Principle 4: Document Your Reasoning**
- Why you made this choice
- What you verified
- What assumptions you're making
- Makes debugging easier later

**Principle 5: Fail Fast, Fail Clearly**
- If validation fails â†’ STOP immediately
- Report the failure clearly
- Don't try to work around it
- Get help rather than guess

**Principle 6: Templates Are Truth**
- If template says 50 lines, don't write 200
- If template omits a feature, don't add it
- Templates designed to work together
- Trust the system design

**Principle 7: Automate Validation**
- Use grep to verify property names
- Use ls to verify file locations
- Use git status to verify clean state
- Don't rely on memory - use tools

**Principle 8: Context Switching Costs**
- Don't jump between tasks
- Finish one thing completely before starting next
- Keep focus narrow
- Deep work > multitasking

**Principle 9: Progressive Enhancement**
- Get basic version working first
- Validate it
- Then (if requested) enhance
- Never optimize prematurely

**Principle 10: Communication Protocol**
- Report what you did
- Report what you validated
- Ask permission to continue
- Clear, structured updates

---

## ðŸŽ“ SUMMARY - KEY TAKEAWAYS

### Golden Rules:

1. **ONE task at a time** - Never implement multiple subsections simultaneously
2. **EXACT template adherence** - Copy templates from docs/execution/ROADMAP.md exactly
3. **VALIDATE immediately** - Use grep, ls, file reads to verify correctness
4. **CHECK docs/design/SCHEMA.md** - Never guess property names, always verify
5. **STOP at checkpoints** - Report completion, wait for approval to continue
6. **DEBUG systematically** - Follow debugging workflow, don't jump to fixes
7. **COMMIT granularly** - One subsection = one commit
8. **REPORT progress** - Clear structured updates after each task

### What "Overzealous" Means:

- âŒ Adding features not in roadmap
- âŒ Writing code beyond template scope
- âŒ "Improving" or "optimizing" without being asked
- âŒ Implementing multiple subsections at once
- âŒ Diverging from specifications

### What "Overzealous" Does NOT Mean:

- âœ… Working efficiently
- âœ… Completing tasks correctly
- âœ… Following instructions precisely
- âœ… Finishing assigned subsection quickly

### You Are Successful When:

- Code matches template exactly
- All validation checks pass
- Property names match docs/design/SCHEMA.md
- Commits are clean and well-documented
- You stay within subsection boundaries
- Senior AI can continue from your work seamlessly
- No rework needed

### Remember:

- **Small steps** = big success
- **Validate** before commit
- **One task** at a time
- **Trust the roadmap** - it's comprehensive
- **Ask when uncertain** - better to ask than guess
- **Stop at checkpoints** - let user approve progression
- **Debug systematically** - don't rush fixes

---

## ðŸš€ READY TO START?

### Next Immediate Actions:

**Step 1: Validate Understanding**
- [ ] I have read this entire document (ANTIGRAVITY_FEEDBACK.md)
- [ ] I understand "overzealous" means scope creep, not speed
- [ ] I understand I should NOT ask user to review code (they're non-technical)
- [ ] I understand I SHOULD ask to proceed to next task after completing current one
- [ ] I understand debugging workflow: Stop â†’ Document â†’ Analyze â†’ Plan â†’ Fix
- [ ] I understand template adherence is mandatory

**Step 2: Read Core Documentation**
- [ ] Read docs/design/CONSTITUTION.md (immutable rules)
- [ ] Read docs/design/SCHEMA.md (data structures)
- [ ] Read docs/execution/PROJECT_STATUS.md (current state)

**Step 3: Start First Task**
- [ ] Read docs/execution/ROADMAP.md Task 1.1.1 section ONLY
- [ ] Verify prerequisite files exist
- [ ] Implement Task 1.1.1 using exact template
- [ ] Validate using checklist
- [ ] Commit with template message
- [ ] Report completion and ask to proceed

**Remember:**
- Trust the roadmap
- Use templates exactly
- Validate everything
- Stop at checkpoints
- Ask senior AI for technical questions
- Ask user for permission to continue
- Debug systematically
- Stay within scope

**Good luck, Antigravity AI. Follow the guardrails and you'll succeed.** ðŸŽ¯

---

**End of ANTIGRAVITY_FEEDBACK.md**

