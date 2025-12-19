# HERA'S GARDEN - DEVELOPMENT ROADMAP

**Version:** 2.1
**Last Updated:** December 19, 2025
**Status:** CANONICAL - Consolidated from DEVELOPMENT_ROADMAP.md, PHASE_2_ROADMAP.md, PHASES_3_TO_5_OUTLINE.md
**Purpose:** Explicit, step-by-step implementation guide for AI agents

Note: Phase-specific roadmaps have been archived to _docs/archive/. This is now the single source of truth.

---

## CRITICAL: READ FIRST

Before implementing ANY feature:
1. ✅ Read `CONSTITUTION.md` (immutable rules)
2. ✅ Read `SCHEMA.md` (data structures)
3. ✅ Read `Storyline.md` (narrative context)
4. ✅ Check this roadmap for dependencies
5. ✅ Verify autoloads are registered
6. ✅ Test in isolation before integrating

**Golden Rule:** Complete → Test → Verify → Commit → Move to Next

---

## PROJECT OVERVIEW

### Game Summary
- **Title:** Hera's Garden
- **Genre:** Narrative Farming Game / Greek Tragedy
- **Platform:** Retroid Pocket Classic (1080×1240 Android)
- **Engine:** Godot 4.5.1
- **Playtime:** 65-90 minutes (story) + endless free-play
- **Theme:** Jealousy → Guilt → Redemption through Mercy

### Core Mechanics
1. **Farming System:** Plant → Water → Wait → Harvest pharmaka herbs
2. **Crafting System:** Grind herbs with directional patterns + button prompts
3. **Narrative System:** Linear story with dialogue choices
4. **Minigames:** Herb identification, moon tear catching, weaving
5. **Progression:** 11 main quests across 3 acts + prologue + epilogue

---

## DEVELOPMENT PHASES

### Phase 0: Foundation ✅ COMPLETE
- [x] Governance documents
- [x] Project structure
- [x] Autoloads registered
- [x] Resource classes defined
- [x] Test runner created

### Phase 1: Core Systems (Estimated: 2-3 weeks)
- [ ] Player movement and interaction
- [ ] Farming system (till, plant, water, grow, harvest)
- [ ] Basic crafting system (mortar & pestle)
- [ ] Dialogue system
- [ ] Scene management

### Phase 2: Storyline Implementation (Estimated: 3-4 weeks)
- [ ] Prologue sequence
- [ ] Act 1: Jealousy & Transformation
- [ ] Act 2: Guilt & Failed Redemption
- [ ] Act 3: The Stone Solution
- [ ] Epilogue & endings

### Phase 3: Minigames & Polish (Estimated: 1-2 weeks)
- [ ] Herb identification game
- [ ] Moon tear catching
- [ ] Weaving minigame
- [ ] Sacred earth digging
- [ ] UI/UX polish

### Phase 4: Content & Balance (Estimated: 1 week)
- [ ] All dialogue implementation
- [ ] Difficulty balancing
- [ ] Audio integration
- [ ] Testing & QA

### Phase 5: Deployment (Estimated: 3-5 days)
- [ ] Android build configuration
- [ ] Retroid Pocket optimization
- [ ] Final testing on device

---

## PHASE 1: CORE SYSTEMS

### **1.1 - Player System**

**Goal:** Create functional player character with movement and interaction

**Dependencies:** None (fresh start)

**Tasks:**

#### 1.1.1 - Player Scene Creation
```
□ Create scenes/entities/player.tscn
□ Add CharacterBody2D as root node
□ Add Sprite2D child node (name: "Sprite")
□ Add CollisionShape2D child (name: "Collision")
  - Shape: CapsuleShape2D (radius: 14, height: 28)
□ Add Camera2D child (name: "Camera")
  - Enabled: true
  - Zoom: (2.0, 2.0) for pixel art
□ Save scene
```

**Verification:**
- Scene loads without errors
- Node hierarchy matches spec
- Can view scene in editor

#### 1.1.2 - Player Movement Script
```
□ Create src/entities/player.gd
□ Extend CharacterBody2D
□ Implement movement with d-pad input
□ Implement physics using move_and_slide()
□ Add animation state (idle vs walking)
```

**Code Template:**
```gdscript
extends CharacterBody2D

const SPEED: float = 100.0

@onready var sprite: Sprite2D = $Sprite

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * SPEED
	move_and_slide()

	# Flip sprite based on direction
	if input_dir.x != 0:
		sprite.flip_h = input_dir.x < 0
```

**Test:**
1. Attach script to player.tscn
2. Create test world scene
3. Instance player
4. Run scene
5. Verify: Player moves with WASD/arrows, sprite flips correctly

**Commit Message:**
```
feat: implement player movement system

- Add CharacterBody2D with collision
- Implement 8-directional movement at 100px/sec
- Add sprite flipping based on direction
- Camera follows player at 2x zoom

Tested: Player moves smoothly in all directions
```

---

#### 1.1.3 - Interaction System
```
□ Add Area2D child to player (name: "InteractionZone")
□ Add CollisionShape2D to InteractionZone (CircleShape2D, radius: 32)
□ Implement interaction detection
□ Add "interact" input action (E key)
□ Emit signal when interacting with objects
```

**Code Addition:**
```gdscript
signal interacted_with(target: Node)

@onready var interaction_zone: Area2D = $InteractionZone

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_try_interact()

func _try_interact() -> void:
	var bodies = interaction_zone.get_overlapping_bodies()
	if bodies.size() > 0:
		var target = bodies[0]
		if target.has_method("interact"):
			target.interact()
			interacted_with.emit(target)
```

**Test:**
1. Create test interactable object
2. Implement `interact()` method that prints message
3. Walk near object, press E
4. Verify: Message prints, signal emits

**Commit Message:**
```
feat: add player interaction system

- Add interaction zone (32px radius)
- E key triggers interaction
- Signal emitted when interacting
- Interactable objects must have interact() method

Tested: Can interact with test objects
```

---

### **1.2 - World & Scene Management**

#### 1.2.1 - World Scene Creation
```
□ Create scenes/world.tscn
□ Add Node2D as root
□ Add TileMapLayer (name: "Ground")
  - Tile size: 32x32
  - Create basic tileset from placeholder sprite
□ Paint tiles in editor (minimum 20x20 area)
□ Add Node2D container (name: "Interactables")
□ Instance player.tscn as child
```

**Critical:** TileMapLayer MUST have painted tiles. Do not leave empty.

**Test:**
1. Set world.tscn as main scene in project.godot
2. Run game
3. Verify: Player spawns, can move, camera follows, tiles visible

---

#### 1.2.2 - Scene Transition System
```
□ Create src/autoloads/scene_manager.gd
□ Register in project.godot as SceneManager
□ Implement scene loading with fade transition
```

**Code:**
```gdscript
extends Node

signal scene_changing
signal scene_changed

var current_scene: Node = null

func change_scene(scene_path: String) -> void:
	scene_changing.emit()
	# Fade out (use ColorRect + Tween)
	await _fade_out()

	if current_scene:
		current_scene.queue_free()

	var new_scene = load(scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene

	await _fade_in()
	scene_changed.emit()

func _fade_out() -> void:
	# TODO: Implement fade animation
	await get_tree().create_timer(0.3).timeout

func _fade_in() -> void:
	# TODO: Implement fade animation
	await get_tree().create_timer(0.3).timeout
```

**Register in project.godot:**
```ini
[autoload]
SceneManager="*res://src/autoloads/scene_manager.gd"
```

**Test:**
1. Create two test scenes
2. Add button to trigger `SceneManager.change_scene()`
3. Verify: Scene changes smoothly

**Commit:**
```
feat: add scene transition system

- Implement SceneManager autoload
- Fade in/out transitions
- Signal emission on scene change

Tested: Smooth transitions between scenes
```

---

### **1.3 - Farming System**

#### 1.3.1 - Farm Plot Entity
```
□ Create scenes/entities/farm_plot.tscn
□ Add Node2D as root
□ Add Sprite2D for tilled soil
□ Add Sprite2D for crop growth stages
□ Add Area2D for interaction detection
```

#### 1.3.2 - Farm Plot Script
```
□ Create src/entities/farm_plot.gd
□ Implement states: EMPTY, TILLED, PLANTED, GROWING, HARVESTABLE
□ Implement methods: till(), plant(), water(), advance_growth(), harvest()
□ Connect to GameState for crop data
```

**State Machine:**
```gdscript
extends Node2D

enum State { EMPTY, TILLED, PLANTED, GROWING, HARVESTABLE }

@export var grid_position: Vector2i = Vector2i.ZERO
@onready var soil_sprite: Sprite2D = $SoilSprite
@onready var crop_sprite: Sprite2D = $CropSprite

var current_state: State = State.EMPTY
var crop_id: String = ""
var planted_day: int = 0
var current_growth_stage: int = 0
var is_watered: bool = false

func till() -> void:
	if current_state != State.EMPTY:
		return
	current_state = State.TILLED
	soil_sprite.visible = true
	print("Plot tilled at %s" % grid_position)

func plant(seed_id: String) -> void:
	if current_state != State.TILLED:
		return

	# Get crop data from GameState
	var crop_data = GameState.get_crop_data(seed_id)
	if not crop_data:
		push_error("Unknown crop: %s" % seed_id)
		return

	crop_id = crop_data.id
	planted_day = GameState.current_day
	current_state = State.PLANTED
	current_growth_stage = 0
	_update_crop_sprite()

	GameState.crop_planted.emit(grid_position, crop_id)
	print("Planted %s at %s" % [crop_id, grid_position])

func water() -> void:
	if current_state not in [State.PLANTED, State.GROWING]:
		return
	is_watered = true
	# Visual feedback (sparkles, color change, etc.)
	print("Watered crop at %s" % grid_position)

func advance_growth() -> void:
	if current_state not in [State.PLANTED, State.GROWING]:
		return

	var crop_data = GameState.get_crop_data(crop_id)
	if not crop_data:
		return

	var days_elapsed = GameState.current_day - planted_day
	var total_stages = crop_data.growth_stages.size()

	# Calculate stage based on days
	var stage_index = int(float(days_elapsed) / float(crop_data.days_to_mature) * float(total_stages))
	current_growth_stage = min(stage_index, total_stages - 1)

	if days_elapsed >= crop_data.days_to_mature:
		current_state = State.HARVESTABLE
	else:
		current_state = State.GROWING

	_update_crop_sprite()
	is_watered = false

func harvest() -> void:
	if current_state != State.HARVESTABLE:
		return

	var crop_data = GameState.get_crop_data(crop_id)
	if not crop_data:
		return

	GameState.add_item(crop_data.harvest_item_id, 1)
	GameState.crop_harvested.emit(grid_position, crop_data.harvest_item_id, 1)

	if crop_data.regrows:
		# Reset to growing stage
		planted_day = GameState.current_day
		current_growth_stage = 0
		current_state = State.GROWING
		_update_crop_sprite()
	else:
		# Reset to tilled
		crop_id = ""
		current_state = State.TILLED
		crop_sprite.visible = false

	print("Harvested at %s" % grid_position)

func _update_crop_sprite() -> void:
	var crop_data = GameState.get_crop_data(crop_id)
	if not crop_data or current_growth_stage >= crop_data.growth_stages.size():
		crop_sprite.visible = false
		return

	crop_sprite.texture = crop_data.growth_stages[current_growth_stage]
	crop_sprite.visible = true

func interact() -> void:
	# Called by player interaction system
	match current_state:
		State.EMPTY:
			till()
		State.TILLED:
			# Player needs to select seed from inventory
			# This will be handled by UI later
			pass
		State.PLANTED, State.GROWING:
			water()
		State.HARVESTABLE:
			harvest()
```

**Test:**
1. Create test crop data (wheat.tres)
2. Place farm plot in world
3. Interact to till
4. Call plant("wheat") manually
5. Advance GameState day
6. Call advance_growth()
7. Verify: Growth stages update correctly

**Commit:**
```
feat: implement farm plot system

- State machine: EMPTY → TILLED → PLANTED → GROWING → HARVESTABLE
- Methods: till, plant, water, advance_growth, harvest
- Connects to GameState for crop data and inventory
- Supports regrowing crops

Tested: Full crop lifecycle works
```

---

#### 1.3.3 - Day/Night System
```
□ Add day counter to GameState
□ Create sundial interactable object
□ Implement advance_day() method
□ Update all farm plots when day advances
```

**GameState Enhancement:**
```gdscript
# Add to GameState
func advance_day() -> void:
	current_day += 1
	day_advanced.emit(current_day)
	_update_all_farm_plots()
	print("Day advanced to %d" % current_day)

func _update_all_farm_plots() -> void:
	# Get all farm plots in current scene
	var plots = get_tree().get_nodes_in_group("farm_plots")
	for plot in plots:
		if plot.has_method("advance_growth"):
			plot.advance_growth()
```

**Sundial Object:**
```gdscript
extends StaticBody2D

func interact() -> void:
	GameState.advance_day()
	# Show visual feedback (text, animation)
	print("Time advanced!")
```

**Test:**
1. Plant crop
2. Interact with sundial
3. Verify: Crop advances growth stage
4. Repeat until harvestable

---

### **1.4 - Crafting System**

#### 1.4.1 - Mortar & Pestle Minigame
```
□ Create scenes/ui/crafting_minigame.tscn
□ Implement directional input pattern matching
□ Implement button prompt sequence
□ Add visual/audio feedback
□ Difficulty scaling (timing windows)
```

**Scene Structure:**
```
CraftingMinigame (Control)
├─ Background (ColorRect)
├─ MortarSprite (Sprite2D)
├─ IngredientsContainer (Control)
├─ PatternDisplay (Label)
├─ ProgressBar (ProgressBar)
└─ ResultDisplay (Label)
```

**Script:**
```gdscript
extends Control

signal crafting_complete(success: bool)

var pattern: Array[String] = []  # ["ui_up", "ui_right", "ui_down", "ui_left"]
var button_sequence: Array[String] = []  # ["ui_accept", "ui_accept", "ui_cancel"]
var current_pattern_index: int = 0
var current_button_index: int = 0
var timing_window: float = 1.5  # seconds
var last_input_time: float = 0.0
var is_grinding_phase: bool = true

func start_crafting(grinding_pattern: Array[String], buttons: Array[String], timing: float = 1.5) -> void:
	pattern = grinding_pattern
	button_sequence = buttons
	timing_window = timing
	current_pattern_index = 0
	current_button_index = 0
	is_grinding_phase = true
	last_input_time = Time.get_ticks_msec() / 1000.0

	_update_display()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	var current_time = Time.get_ticks_msec() / 1000.0

	# Check timing window
	if current_time - last_input_time > timing_window:
		_fail_crafting()
		return

	if is_grinding_phase:
		_handle_grinding_input(event)
	else:
		_handle_button_input(event)

func _handle_grinding_input(event: InputEvent) -> void:
	var expected = pattern[current_pattern_index]

	if event.is_action_pressed(expected):
		# Correct input
		current_pattern_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)

		if current_pattern_index >= pattern.size():
			# Grinding complete, move to button sequence
			is_grinding_phase = false
			current_button_index = 0
			last_input_time = Time.get_ticks_msec() / 1000.0
			_update_display()

	# Check for wrong input
	for action in ["ui_up", "ui_right", "ui_down", "ui_left"]:
		if action != expected and event.is_action_pressed(action):
			_play_feedback(false)
			# Don't fail immediately, just give negative feedback

func _handle_button_input(event: InputEvent) -> void:
	var expected = button_sequence[current_button_index]

	if event.is_action_pressed(expected):
		# Correct input
		current_button_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)

		if current_button_index >= button_sequence.size():
			# All inputs correct - success!
			_complete_crafting(true)

	# Check for wrong input
	for action in ["ui_accept", "ui_cancel", "ui_select"]:
		if action != expected and event.is_action_pressed(action):
			_fail_crafting()

func _complete_crafting(success: bool) -> void:
	crafting_complete.emit(success)
	visible = false

func _fail_crafting() -> void:
	_complete_crafting(false)

func _update_display() -> void:
	# Update UI to show current progress
	# Show next expected input
	pass

func _play_feedback(correct: bool) -> void:
	# Play sound, show visual effect
	pass
```

**Test:**
1. Create test scene with crafting minigame
2. Start with simple pattern: ↑ → ↓ ← (4 inputs)
3. Add button sequence: A A (2 inputs)
4. Timing: 2.0 seconds
5. Verify: Correct inputs succeed, wrong inputs fail

**Commit:**
```
feat: implement crafting minigame system

- Directional pattern matching
- Button prompt sequence
- Timing window validation
- Success/fail states
- Scalable difficulty

Tested: Simple patterns work correctly
```

---

#### 1.4.2 - Recipe System
```
□ Create RecipeData resource class
□ Define recipes in SCHEMA.md
□ Implement crafting UI integration
□ Connect to inventory system
```

**RecipeData Class:**
```gdscript
extends Resource
class_name RecipeData

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var ingredients: Array[Dictionary] = []  # [{"item_id": "moly", "quantity": 2}]
@export var grinding_pattern: Array[String] = []  # ["ui_up", "ui_right", ...]
@export var button_sequence: Array[String] = []   # ["ui_accept", "ui_cancel", ...]
@export var timing_window: float = 1.5
@export var result_item_id: String = ""
@export var result_quantity: int = 1
```

**Crafting Controller:**
```gdscript
func start_craft(recipe_id: String) -> void:
	var recipe = _get_recipe(recipe_id)
	if not recipe:
		return

	# Check ingredients
	if not _has_ingredients(recipe):
		print("Missing ingredients!")
		return

	# Start minigame
	crafting_minigame.start_crafting(
		recipe.grinding_pattern,
		recipe.button_sequence,
		recipe.timing_window
	)
	crafting_minigame.visible = true

func _on_crafting_complete(success: bool) -> void:
	if success:
		# Remove ingredients
		_consume_ingredients(current_recipe)
		# Add result
		GameState.add_item(current_recipe.result_item_id, current_recipe.result_quantity)
		print("Crafted: %s" % current_recipe.display_name)
	else:
		print("Crafting failed!")
```

---

### **1.5 - Dialogue System**

#### 1.5.1 - DialogueBox UI
```
□ Create scenes/ui/dialogue_box.tscn
□ Add background panel
□ Add speaker name label
□ Add text label (scrolling)
□ Add choice buttons container
□ Add continue prompt
```

#### 1.5.2 - Dialogue Manager
```
□ Implement dialogue tree traversal
□ Text scrolling animation
□ Choice handling
□ Flag checking/setting
□ Signal emission for game events
```

**DialogueManager Code:**
```gdscript
extends Control

signal dialogue_started(dialogue_id: String)
signal dialogue_ended(dialogue_id: String)
signal choice_made(choice_index: int, choice_data: Dictionary)

@onready var speaker_label: Label = $Panel/SpeakerName
@onready var text_label: Label = $Panel/Text
@onready var choices_container: VBoxContainer = $Panel/Choices

var current_dialogue: DialogueData = null
var current_line_index: int = 0
var is_text_scrolling: bool = false
var text_scroll_speed: float = 30.0  # characters per second

func start_dialogue(dialogue_id: String) -> void:
	var dialogue_data = load("res://resources/dialogues/%s.tres" % dialogue_id) as DialogueData
	if not dialogue_data:
		push_error("Dialogue not found: %s" % dialogue_id)
		return

	# Check if flags required
	for flag in dialogue_data.flags_required:
		if not GameState.get_flag(flag):
			print("Missing required flag: %s" % flag)
			return

	current_dialogue = dialogue_data
	current_line_index = 0
	visible = true
	dialogue_started.emit(dialogue_id)

	_show_next_line()

func _show_next_line() -> void:
	if current_line_index >= current_dialogue.lines.size():
		_end_dialogue()
		return

	var line = current_dialogue.lines[current_line_index]
	speaker_label.text = line.get("speaker", "")

	# Start text scrolling
	is_text_scrolling = true
	_scroll_text(line.get("text", ""))

func _scroll_text(full_text: String) -> void:
	text_label.text = ""
	var chars_shown = 0

	while chars_shown < full_text.length():
		text_label.text = full_text.substr(0, chars_shown + 1)
		chars_shown += 1
		await get_tree().create_timer(1.0 / text_scroll_speed).timeout

	is_text_scrolling = false

	# Check if there are choices
	if current_line_index == current_dialogue.lines.size() - 1 and current_dialogue.choices.size() > 0:
		_show_choices()

func _show_choices() -> void:
	# Clear existing choices
	for child in choices_container.get_children():
		child.queue_free()

	# Create choice buttons
	for i in range(current_dialogue.choices.size()):
		var choice = current_dialogue.choices[i]

		# Check if choice requires flag
		if choice.has("flag_required") and choice["flag_required"] != "":
			if not GameState.get_flag(choice["flag_required"]):
				continue  # Skip this choice

		var button = Button.new()
		button.text = choice["text"]
		button.pressed.connect(_on_choice_selected.bind(i, choice))
		choices_container.add_child(button)

	choices_container.visible = true

func _on_choice_selected(index: int, choice: Dictionary) -> void:
	choice_made.emit(index, choice)
	choices_container.visible = false

	# Jump to next dialogue if specified
	if choice.has("next_id") and choice["next_id"] != "":
		_end_dialogue()
		start_dialogue(choice["next_id"])
	else:
		_end_dialogue()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_accept"):
		if is_text_scrolling:
			# Skip text scroll
			# TODO: Instant show full text
			pass
		else:
			# Next line
			current_line_index += 1
			_show_next_line()

func _end_dialogue() -> void:
	# Set flags if specified
	for flag in current_dialogue.flags_to_set:
		GameState.set_flag(flag, true)

	dialogue_ended.emit(current_dialogue.id)
	visible = false
	current_dialogue = null
```

**Test:**
1. Create test dialogue.tres
2. Add 3 lines
3. Add 2 choices
4. Start dialogue
5. Verify: Text scrolls, choices appear, flags set

---

## TESTING PROTOCOL

**For Every Feature:**

1. **Unit Test**
   - Test feature in isolation
   - Verify all states/transitions
   - Check edge cases

2. **Integration Test**
   - Test with dependencies
   - Verify signals/connections
   - Check data flow

3. **Regression Test**
   - Ensure previous features still work
   - Run automated test suite
   - Manual smoke test

4. **Commit**
   - Clear commit message
   - Link to task/quest
   - Push to branch

---

## NEXT: PHASE 2 ROADMAP

Once Phase 1 is complete and tested, the next document will detail:
- Prologue cutscene implementation
- Act 1 quest implementation
- NPC system
- Minigame refinements

**End of Phase 1 Roadmap**
