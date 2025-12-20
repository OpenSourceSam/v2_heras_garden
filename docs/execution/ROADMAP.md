# CIRCE'S GARDEN - DEVELOPMENT ROADMAP

**Version:** 2.1
**Last Updated:** December 19, 2025
**Status:** CANONICAL - Consolidated from DEVELOPMENT_ROADMAP.md, PHASE_2_ROADMAP.md, PHASES_3_TO_5_OUTLINE.md
**Purpose:** Explicit, step-by-step implementation guide for AI agents

Note: Phase-specific roadmaps have been archived to _docs/archive/. This is now the single source of truth.

---

## CRITICAL: READ FIRST

Before implementing ANY feature:
1. âœ… Read `docs/design/CONSTITUTION.md` (immutable rules)
2. âœ… Read `docs/design/SCHEMA.md` (data structures)
3. âœ… Read `docs/design/Storyline.md` (narrative context)
4. âœ… Check this roadmap for dependencies
5. âœ… Verify autoloads are registered
6. âœ… Test in isolation before integrating

**Golden Rule:** Complete â†’ Test â†’ Verify â†’ Commit â†’ Move to Next

---

## PROJECT OVERVIEW

### Game Summary
- **Title:** Circe's Garden
- **Genre:** Narrative Farming Game / Greek Tragedy
- **Platform:** Retroid Pocket Classic (1080Ã—1240 Android)
- **Engine:** Godot 4.5.1
- **Playtime:** 65-90 minutes (story) + endless free-play
- **Theme:** Jealousy â†’ Guilt â†’ Redemption through Mercy

### Core Mechanics
1. **Farming System:** Plant â†’ Water â†’ Wait â†’ Harvest pharmaka herbs
2. **Crafting System:** Grind herbs with directional patterns + button prompts
3. **Narrative System:** Linear story with dialogue choices
4. **Minigames:** Herb identification, moon tear catching, weaving
5. **Progression:** 11 main quests across 3 acts + prologue + epilogue

---

## DEVELOPMENT PHASES

### Phase 0: Foundation âœ… COMPLETE
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
â–¡ Create scenes/entities/player.tscn
â–¡ Add CharacterBody2D as root node
â–¡ Add Sprite2D child node (name: "Sprite")
â–¡ Add CollisionShape2D child (name: "Collision")
  - Shape: CapsuleShape2D (radius: 14, height: 28)
â–¡ Add Camera2D child (name: "Camera")
  - Enabled: true
  - Zoom: (2.0, 2.0) for pixel art
â–¡ Save scene
```

**Verification:**
- Scene loads without errors
- Node hierarchy matches spec
- Can view scene in editor

#### 1.1.2 - Player Movement Script
```
â–¡ Create src/entities/player.gd
â–¡ Extend CharacterBody2D
â–¡ Implement movement with d-pad input
â–¡ Implement physics using move_and_slide()
â–¡ Add animation state (idle vs walking)
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
â–¡ Add Area2D child to player (name: "InteractionZone")
â–¡ Add CollisionShape2D to InteractionZone (CircleShape2D, radius: 32)
â–¡ Implement interaction detection
â–¡ Add "interact" input action (E key)
â–¡ Emit signal when interacting with objects
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
â–¡ Create scenes/world.tscn
â–¡ Add Node2D as root
â–¡ Add TileMapLayer (name: "Ground")
  - Tile size: 32x32
  - Create basic tileset from placeholder sprite
â–¡ Paint tiles in editor (minimum 20x20 area)
â–¡ Add Node2D container (name: "Interactables")
â–¡ Instance player.tscn as child
```

**Critical:** TileMapLayer MUST have painted tiles. Do not leave empty.

**Test:**
1. Set world.tscn as main scene in project.godot
2. Run game
3. Verify: Player spawns, can move, camera follows, tiles visible

---

#### 1.2.2 - Scene Transition System
```
â–¡ Create src/autoloads/scene_manager.gd
â–¡ Register in project.godot as SceneManager
â–¡ Implement scene loading with fade transition
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
SceneManager="*res://game/autoload/scene_manager.gd"
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
â–¡ Create scenes/entities/farm_plot.tscn
â–¡ Add Node2D as root
â–¡ Add Sprite2D for tilled soil
â–¡ Add Sprite2D for crop growth stages
â–¡ Add Area2D for interaction detection
```

#### 1.3.2 - Farm Plot Script
```
â–¡ Create src/entities/farm_plot.gd
â–¡ Implement states: EMPTY, TILLED, PLANTED, GROWING, HARVESTABLE
â–¡ Implement methods: till(), plant(), water(), advance_growth(), harvest()
â–¡ Connect to GameState for crop data
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

- State machine: EMPTY â†’ TILLED â†’ PLANTED â†’ GROWING â†’ HARVESTABLE
- Methods: till, plant, water, advance_growth, harvest
- Connects to GameState for crop data and inventory
- Supports regrowing crops

Tested: Full crop lifecycle works
```

---

#### 1.3.3 - Day/Night System
```
â–¡ Add day counter to GameState
â–¡ Create sundial interactable object
â–¡ Implement advance_day() method
â–¡ Update all farm plots when day advances
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
â–¡ Create scenes/ui/crafting_minigame.tscn
â–¡ Implement directional input pattern matching
â–¡ Implement button prompt sequence
â–¡ Add visual/audio feedback
â–¡ Difficulty scaling (timing windows)
```

**Scene Structure:**
```
CraftingMinigame (Control)
â”œâ”€ Background (ColorRect)
â”œâ”€ MortarSprite (Sprite2D)
â”œâ”€ IngredientsContainer (Control)
â”œâ”€ PatternDisplay (Label)
â”œâ”€ ProgressBar (ProgressBar)
â””â”€ ResultDisplay (Label)
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
2. Start with simple pattern: â†‘ â†’ â†“ â† (4 inputs)
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
â–¡ Create RecipeData resource class
â–¡ Define recipes in docs/design/SCHEMA.md
â–¡ Implement crafting UI integration
â–¡ Connect to inventory system
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
â–¡ Create scenes/ui/dialogue_box.tscn
â–¡ Add background panel
â–¡ Add speaker name label
â–¡ Add text label (scrolling)
â–¡ Add choice buttons container
â–¡ Add continue prompt
```

#### 1.5.2 - Dialogue Manager
```
â–¡ Implement dialogue tree traversal
â–¡ Text scrolling animation
â–¡ Choice handling
â–¡ Flag checking/setting
â–¡ Signal emission for game events
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
	var dialogue_data = load("res://game/shared/resources/dialogues/%s.tres" % dialogue_id) as DialogueData
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

## PHASE 2: STORYLINE IMPLEMENTATION (DETAILED)

### 2.1 - Cutscene System

#### 2.1.1 - Cutscene Base Scene
```
□ Create game/features/cutscenes/cutscene_base.tscn
□ Root: Control (full_rect anchors)
□ Add: Background (TextureRect)
□ Add: Overlay (ColorRect) - modulate for fades
□ Add: NarrationLabel (RichTextLabel)
□ Add: AnimationPlayer
□ Create game/features/cutscenes/cutscene_base.gd
```

**Scene Structure:**
```
CutsceneBase (Control)
├─ Background (TextureRect)
├─ Overlay (ColorRect)
├─ NarrationLabel (RichTextLabel)
└─ AnimationPlayer
```

**Key Code:**
```gdscript
extends Control
class_name CutsceneBase

signal cutscene_finished

@onready var background: TextureRect = $Background
@onready var overlay: ColorRect = $Overlay
@onready var narration: RichTextLabel = $NarrationLabel
@onready var anim: AnimationPlayer = $AnimationPlayer

func play_cutscene(name: String) -> void:
	anim.play(name)
	await anim.animation_finished
	cutscene_finished.emit()

func fade_in(duration: float = 1.0) -> void:
	var tween = create_tween()
	overlay.modulate.a = 1.0
	tween.tween_property(overlay, "modulate:a", 0.0, duration)

func fade_out(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, duration)

func show_text(text: String, duration: float = 3.0) -> void:
	narration.text = text
	narration.visible = true
	await get_tree().create_timer(duration).timeout
	narration.visible = false
```

**Test:**
1. Instance cutscene_base in a test scene
2. Call play_cutscene("test") with a simple animation
3. Verify: animation plays, signal emits

**Commit:**
```
feat: add cutscene base scene and script
```

#### 2.1.2 - CutsceneManager Autoload
```
□ Create game/autoload/cutscene_manager.gd
□ Register in project.godot (autoload section)
□ Methods: play_cutscene(path), is_playing()
```

**Key Code:**
```gdscript
extends Node

var current_cutscene: CutsceneBase = null

func play_cutscene(scene_path: String) -> void:
	var scene = load(scene_path).instantiate()
	get_tree().root.add_child(scene)
	current_cutscene = scene
	await scene.cutscene_finished
	scene.queue_free()
	current_cutscene = null

func is_playing() -> bool:
	return current_cutscene != null
```

**Test:**
1. Register autoload in project.godot
2. Call CutsceneManager.play_cutscene() from any script
3. Verify: scene loads, plays, cleans up

**Commit:**
```
feat: add CutsceneManager autoload
```

---

### 2.2 - NPC System

#### 2.2.1 - NPC Base Scene
```
□ Create game/features/npcs/npc_base.tscn
□ Root: CharacterBody2D
□ Add: Sprite2D
□ Add: CollisionShape2D
□ Add: InteractionZone (Area2D + CollisionShape2D)
□ Add node to group "interactable"
□ Create game/features/npcs/npc_base.gd
```

**Scene Structure:**
```
NPCBase (CharacterBody2D) [group: interactable]
├─ Sprite (Sprite2D)
├─ Collision (CollisionShape2D)
└─ InteractionZone (Area2D)
   └─ CollisionShape2D
```

**Key Code:**
```gdscript
extends CharacterBody2D
class_name NPCBase

@export var npc_id: String = ""
@export var dialogue_id: String = ""
@export var portrait: Texture2D = null

@onready var sprite: Sprite2D = $Sprite

func interact() -> void:
	var dialogue_path = "res://game/shared/resources/dialogues/%s.tres" % dialogue_id
	var dialogue = load(dialogue_path)
	if dialogue:
		var dialogue_box = get_tree().get_first_node_in_group("dialogue_ui")
		if dialogue_box and dialogue_box.has_method("start_dialogue"):
			dialogue_box.start_dialogue(dialogue)

func set_facing(direction: Vector2) -> void:
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
```

**Test:**
1. Place NPC in world scene
2. Walk player to NPC, press interact
3. Verify: Dialogue starts

**Commit:**
```
feat: add NPC base scene with interaction
```

#### 2.2.2 - NPC Spawner
```
□ Add Marker2D spawn points to world.tscn
□ Create game/features/npcs/npc_spawner.gd
□ Spawn/despawn NPCs based on GameState flags
```

**Key Code:**
```gdscript
extends Node

@export var npc_scenes: Dictionary = {
	"hermes": preload("res://game/features/npcs/hermes.tscn"),
	"aeetes": preload("res://game/features/npcs/aeetes.tscn"),
	"daedalus": preload("res://game/features/npcs/daedalus.tscn")
}

var spawned_npcs: Dictionary = {}

func _ready() -> void:
	GameState.flag_changed.connect(_on_flag_changed)
	_update_npcs()

func _on_flag_changed(_flag: String, _value: bool) -> void:
	_update_npcs()

func _update_npcs() -> void:
	# Hermes: appears after prologue, before quest 3 complete
	_set_npc_visible("hermes",
		GameState.get_flag("prologue_complete") and
		not GameState.get_flag("quest_3_complete"))

	# Aeetes: appears during quest 6
	_set_npc_visible("aeetes",
		GameState.get_flag("quest_6_active"))

	# Daedalus: appears during quest 7
	_set_npc_visible("daedalus",
		GameState.get_flag("quest_7_active"))

func _set_npc_visible(npc_id: String, visible: bool) -> void:
	if visible and npc_id not in spawned_npcs:
		_spawn_npc(npc_id)
	elif not visible and npc_id in spawned_npcs:
		_despawn_npc(npc_id)

func _spawn_npc(npc_id: String) -> void:
	var spawn_point = get_node_or_null("SpawnPoints/" + npc_id.capitalize())
	if spawn_point and npc_id in npc_scenes:
		var npc = npc_scenes[npc_id].instantiate()
		npc.global_position = spawn_point.global_position
		add_child(npc)
		spawned_npcs[npc_id] = npc

func _despawn_npc(npc_id: String) -> void:
	if npc_id in spawned_npcs:
		spawned_npcs[npc_id].queue_free()
		spawned_npcs.erase(npc_id)
```

**Test:**
1. Set prologue_complete flag
2. Verify: Hermes spawns at spawn point
3. Set quest_3_complete
4. Verify: Hermes despawns

**Commit:**
```
feat: add NPC spawner with flag-based visibility
```

---

### 2.3 - Quest Tracking

#### 2.3.1 - Quest Flags in GameState
```
□ Add quest flag convention to SCHEMA.md
□ No new code needed - use existing set_flag/get_flag
```

**Add to SCHEMA.md:**

## Quest Flags
| Flag | Type | Description |
|------|------|-------------|
| quest_X_active | bool | Quest X is available |
| quest_X_complete | bool | Quest X finished |
| prologue_complete | bool | Opening sequence done |
| transformed_scylla | bool | Scylla transformed |
| exiled_to_aiaia | bool | Zeus declared exile |
| garden_built | bool | Farming tutorial done |
| met_daedalus | bool | Daedalus visited |
| scylla_wants_death | bool | Scylla asked to die |
| scylla_petrified | bool | Final quest complete |
| ending_chosen | String | "witch" or "healer" |
| free_play_unlocked | bool | Post-game mode |

**Commit:**
```
docs: add quest flag convention to SCHEMA.md
```

#### 2.3.2 - Quest Trigger Areas
```
□ Create game/features/world/quest_trigger.gd
□ Area2D that checks flags and triggers events
```

**Key Code:**
```gdscript
extends Area2D
class_name QuestTrigger

@export var required_flag: String = ""
@export var set_flag_on_enter: String = ""
@export var trigger_dialogue: String = ""
@export var one_shot: bool = true

var triggered: bool = false

func _on_body_entered(body: Node2D) -> void:
	if triggered and one_shot:
		return
	if not body.is_in_group("player"):
		return
	if required_flag != "" and not GameState.get_flag(required_flag):
		return

	triggered = true

	if set_flag_on_enter != "":
		GameState.set_flag(set_flag_on_enter, true)

	if trigger_dialogue != "":
		# Start dialogue
		pass
```

**Commit:**
```
feat: add quest trigger area component
```

---

### 2.4 - Location Scenes

#### 2.4.1 - Scylla's Cove
```
□ Create game/features/locations/scylla_cove.tscn
□ TileMapLayer for cave environment
□ PlayerSpawn (Marker2D)
□ ScyllaPosition (Marker2D)
□ ReturnTrigger (Area2D) - returns to Aiaia
```

**Scene Structure:**
```
ScyllaCove (Node2D)
├─ TileMapLayer
├─ PlayerSpawn (Marker2D)
├─ ScyllaPosition (Marker2D)
├─ ReturnTrigger (Area2D)
│  └─ CollisionShape2D
└─ ScyllaNPC (instance of scylla.tscn)
```

**ReturnTrigger Code:**
```gdscript
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.change_scene("res://game/features/world/world.tscn")
```

**Test:**
1. Transition to scylla_cove
2. Verify: Player spawns at PlayerSpawn
3. Walk to ReturnTrigger
4. Verify: Returns to world

**Commit:**
```
feat: add Scylla's Cove location scene
```

#### 2.4.2 - Boat Travel
```
□ Create game/features/world/boat.tscn
□ StaticBody2D with interaction
□ Shows destination choice or auto-travels based on quest
```

**Key Code:**
```gdscript
extends StaticBody2D

func interact() -> void:
	# Determine destination based on quest state
	if GameState.get_flag("quest_3_active") or GameState.get_flag("quest_5_active") \
		or GameState.get_flag("quest_6_active") or GameState.get_flag("quest_8_active") \
		or GameState.get_flag("quest_11_active"):
		SceneManager.change_scene("res://game/features/locations/scylla_cove.tscn")
	elif GameState.get_flag("quest_9_active"):
		SceneManager.change_scene("res://game/features/locations/sacred_grove.tscn")
	else:
		# Show "nowhere to go" message
		print("No destination available")
```

**Commit:**
```
feat: add boat travel interactable
```

---

### 2.5 - Minigames

#### 2.5.1 - Herb Identification
```
□ Create game/features/minigames/herb_identification.tscn
□ Grid of plant sprites
□ D-pad navigation, A to select
□ Correct plants have subtle visual difference
□ 3 rounds with increasing difficulty
```

**Scene Structure:**
```
HerbIdentification (Control)
├─ Background (ColorRect)
├─ PlantGrid (GridContainer)
│  └─ [PlantSlot x 20-30]
├─ InstructionLabel (Label)
├─ AttemptsLabel (Label)
└─ RoundLabel (Label)
```

**Key Code:**
```gdscript
extends Control

signal minigame_complete(success: bool, items: Array)

@export var plants_per_round: Array[int] = [20, 25, 30]
@export var correct_per_round: Array[int] = [3, 3, 3]
@export var max_wrong: int = 5

var current_round: int = 0
var correct_found: int = 0
var wrong_count: int = 0
var selected_index: int = 0
var plant_slots: Array[Control] = []

func _ready() -> void:
	_setup_round(0)

func _setup_round(round_num: int) -> void:
	current_round = round_num
	correct_found = 0
	# Generate plants - correct ones have subtle glow/different stamen color
	_generate_plants(plants_per_round[round_num], correct_per_round[round_num])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_select_current()
	# D-pad navigation
	elif event.is_action_pressed("ui_right"):
		_move_selection(1)
	elif event.is_action_pressed("ui_left"):
		_move_selection(-1)
	elif event.is_action_pressed("ui_down"):
		_move_selection(5)  # Move down row
	elif event.is_action_pressed("ui_up"):
		_move_selection(-5)

func _select_current() -> void:
	var plant = plant_slots[selected_index]
	if plant.get_meta("is_correct", false):
		correct_found += 1
		plant.modulate = Color.GREEN
		if correct_found >= correct_per_round[current_round]:
			_advance_round()
	else:
		wrong_count += 1
		plant.modulate = Color.RED
		if wrong_count >= max_wrong:
			minigame_complete.emit(false, [])

func _advance_round() -> void:
	current_round += 1
	if current_round >= plants_per_round.size():
		# All rounds complete
		var items = ["pharmaka_flower", "pharmaka_flower", "pharmaka_flower"]
		minigame_complete.emit(true, items)
	else:
		_setup_round(current_round)
```

**Test:**
1. Start minigame
2. Select correct plants (glowing ones)
3. Verify: advances round after 3 correct
4. Verify: fails after 5 wrong

**Commit:**
```
feat: add herb identification minigame
```

#### 2.5.2 - Moon Tear Catching
```
□ Create game/features/minigames/moon_tears.tscn
□ Tears fall from top, player moves to catch
□ Press A when tear reaches player
□ Collect 3 to complete
```

**Key Code:**
```gdscript
extends Control

signal minigame_complete(success: bool, items: Array)

var tears_caught: int = 0
var player_x: float = 0.5  # 0-1 screen position
const MOVE_SPEED: float = 0.02

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		player_x = max(0.1, player_x - MOVE_SPEED)
	if Input.is_action_pressed("ui_right"):
		player_x = min(0.9, player_x + MOVE_SPEED)
	$PlayerMarker.position.x = size.x * player_x

func _on_tear_reached_player(tear: Node2D) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		tears_caught += 1
		tear.queue_free()
		if tears_caught >= 3:
			minigame_complete.emit(true, ["moon_tear", "moon_tear", "moon_tear"])
```

**Commit:**
```
feat: add moon tear catching minigame
```

#### 2.5.3 - Sacred Earth Digging
```
□ Create game/features/minigames/sacred_earth.tscn
□ Button mash A to fill progress bar
□ 10 second timer
```

**Key Code:**
```gdscript
extends Control

signal minigame_complete(success: bool, items: Array)

var progress: float = 0.0
var time_remaining: float = 10.0
const PROGRESS_PER_PRESS: float = 0.03
const DECAY_RATE: float = 0.01

func _process(delta: float) -> void:
	time_remaining -= delta
	progress = max(0, progress - DECAY_RATE * delta)

	if progress >= 1.0:
		minigame_complete.emit(true, ["sacred_earth", "sacred_earth", "sacred_earth"])
	elif time_remaining <= 0:
		minigame_complete.emit(false, [])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		progress += PROGRESS_PER_PRESS
```

**Commit:**
```
feat: add sacred earth digging minigame
```

---

### 2.6 - Advanced Crafting

#### 2.6.1 - Difficulty Tiers
```
□ Extend crafting_minigame.gd with difficulty enum
□ Add retry logic for Petrification Potion
```

**Key Code (add to existing crafting_minigame.gd):**
```gdscript
enum Difficulty { TUTORIAL, EASY, MEDIUM, HARD, EXPERT }

const DIFFICULTY_SETTINGS = {
	Difficulty.TUTORIAL: {"inputs": 12, "buttons": 0, "timing": 2.0, "retry": false},
	Difficulty.EASY: {"inputs": 12, "buttons": 0, "timing": 2.0, "retry": false},
	Difficulty.MEDIUM: {"inputs": 16, "buttons": 4, "timing": 1.5, "retry": false},
	Difficulty.HARD: {"inputs": 16, "buttons": 6, "timing": 1.0, "retry": false},
	Difficulty.EXPERT: {"inputs": 36, "buttons": 10, "timing": 0.6, "retry": true}
}

var allow_retry: bool = false

func start_with_difficulty(diff: Difficulty, recipe: RecipeData) -> void:
	var settings = DIFFICULTY_SETTINGS[diff]
	allow_retry = settings.retry
	timing_window = settings.timing
	_generate_pattern(settings.inputs)
	_generate_buttons(settings.buttons)

func _on_crafting_failed() -> void:
	if allow_retry:
		# Don't consume ingredients, let player retry
		_reset_minigame()
	else:
		crafting_complete.emit(false)
```

**Commit:**
```
feat: add crafting difficulty tiers
```

---

### 2.7 - 2.11 Content Implementation (Quest-Driven)

Each content quest follows the same pattern:
```
□ DialogueData resources in game/shared/resources/dialogues/
□ Quest trigger placement in world
□ Flag checks and sets (GameState)
□ Any special cutscenes or minigame calls
```

#### 2.7.1 - Prologue Opening
```
□ Create game/features/cutscenes/prologue_opening.tscn
□ Inherit cutscene_base.tscn
□ Create AnimationPlayer keyframes:
   - 0.0s: Black screen, quote text
   - 3.0s: Fade in Helios palace background
   - 5.0s: Narration text 1
   - 8.0s: Narration text 2
   - 12.0s: Fade out
   - 13.0s: Load world scene, set prologue_complete flag
□ Create dialogues: prologue_opening.tres, aiaia_arrival.tres
```

**Commit:**
```
feat: implement prologue opening cutscene
```

#### 2.8 - Act 1 Quests
```
□ Herb identification quest (minigame)
□ Crafting tutorial quest (easy difficulty)
□ Scylla transformation cutscene + flag set
```

#### 2.9 - Act 2 Quests
```
□ Farming tutorial quest
□ Calming draught crafting
□ Reversal elixir crafting
□ Daedalus arrival + loom gift
□ Binding ward crafting
```

#### 2.10 - Act 3 Quests
```
□ Moon tears minigame
□ Sacred earth digging minigame
□ Ultimate crafting (expert difficulty)
□ Final confrontation cutscene
```

#### 2.11 - Epilogue & Endings
```
□ Ending choice dialogue
□ Set ending_chosen flag
□ Unlock free play
```

---

### 2.12 - Integration Testing
```
□ Full playthrough: Prologue -> Epilogue
□ Verify both endings reachable
□ Save/load at each quest
□ 65-90 min total
```

**Commit:**
```
test: add Phase 2 integration test checklist
```

**End of Phase 2 Roadmap**
