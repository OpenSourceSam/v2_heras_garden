# PLAYTESTER AI GUIDE

**For AI agents testing with Godot MCP server**

---

## SETUP

1. **Verify Godot MCP server is running**
   - Check that you can access Godot project
   - Confirm project opens without errors

2. **Open project:**
   ```
   Project location: /home/user/v2_heras_garden/project.godot
   Engine version: Godot 4.5.1
   ```

3. **Current state:**
   - Phase 0: Complete (documentation + structure)
   - Phase 1: Not started (implementation pending)
   - Testing: Placeholder scenes only

---

## WHAT TO TEST (PHASE 0 VALIDATION)

### Test 1: Project Loads
```
✅ Open project in Godot
✅ No errors in output console
✅ All autoloads registered (check Project Settings → Autoload)
```

**Expected:**
- GameState, AudioController, SaveController visible
- No missing script errors

### Test 2: Scene Structure
```
✅ Open scenes/ui/main_menu.tscn
✅ Verify node structure matches spec
✅ Run scene (F6) - should display menu
```

**Expected:**
- Purple background
- Title: "CIRCE'S GARDEN"
- 4 buttons (New Game, Continue, Settings, Quit)

### Test 3: Player Scene
```
✅ Open scenes/entities/player.tscn
✅ Verify CharacterBody2D → Sprite2D, CollisionShape2D, Camera2D
✅ Check no script attached yet (Phase 1 task)
```

**Expected:**
- Scene structure correct
- Yellow modulate on Sprite2D
- No runtime errors when instantiated

### Test 4: World Scene
```
✅ Open scenes/world.tscn
✅ Verify Player instance present
✅ Run scene (F6)
```

**Expected:**
- Blue background visible
- Player visible at center (yellow placeholder)
- No movement yet (no script)

### Test 5: Autoload Scripts
```
✅ Check src/autoloads/game_state.gd compiles
✅ Check src/autoloads/audio_controller.gd compiles
✅ Check src/autoloads/save_controller.gd compiles
✅ Run project - check output for initialization messages
```

**Expected Output:**
```
[GameState] Initialized
[GameState] Registries loaded (stub)
[AudioController] Initialized
```

### Test 6: Resource Classes
```
✅ Open src/resources/crop_data.gd
✅ Verify class_name CropData defined
✅ Check @export vars present
✅ Repeat for item_data.gd, dialogue_data.gd, npc_data.gd
```

**Expected:**
- All classes compile without errors
- Can create .tres files with these types

### Test 7: Resource Templates
```
✅ Open resources/crops/TEMPLATE_crop.tres
✅ Verify loads without errors
✅ Check script property points to crop_data.gd
```

**Expected:**
- Template loads
- Shows CropData properties in inspector
- Can duplicate to create new crops

---

## KNOWN LIMITATIONS (PHASE 0)

**What DOESN'T work yet:**
- ❌ Player movement (no script attached)
- ❌ Farming system (not implemented)
- ❌ Crafting system (not implemented)
- ❌ Dialogue system (not implemented)
- ❌ Actual sprites (using colored placeholders)
- ❌ Audio (no files yet)

**What SHOULD work:**
- ✅ Project opens
- ✅ Scenes load
- ✅ Autoloads initialize
- ✅ No compilation errors
- ✅ Resource classes defined

---

## TEST REPORTS

### Format:
```
Test: [Test Name]
Status: PASS / FAIL
Details: [What you observed]
Errors: [Any console errors]
```

### Example:
```
Test: Project Loads
Status: PASS
Details: Project opened successfully, all autoloads visible
Errors: None
```

---

## REGRESSION TESTS (After Phase 1)

Once Phase 1 is implemented, test:

1. **Player Movement**
   - Run world.tscn
   - Press WASD/arrows
   - Verify player moves at 100px/sec
   - Verify sprite flips when moving left

2. **Farm Plot Interaction**
   - Walk near farm plot
   - Press E key
   - Verify plot tills (color changes)

3. **Crafting Minigame**
   - Open crafting scene
   - Test directional input pattern
   - Verify success/fail states

4. **Dialogue System**
   - Trigger test dialogue
   - Verify text scrolls
   - Verify choices appear
   - Verify flags set correctly

---

## CONSOLE ERROR CHECKING

**Common errors to watch for:**

1. **Autoload not found:**
   ```
   ERROR: Autoload 'GameState' not found
   ```
   Fix: Check project.godot registration

2. **Script not found:**
   ```
   ERROR: Cannot load script at 'res://src/...'
   ```
   Fix: Verify file path matches exactly

3. **Class not found:**
   ```
   ERROR: Parse Error: Class 'CropData' not found
   ```
   Fix: Restart Godot editor (reload project)

4. **Null reference:**
   ```
   ERROR: Attempt to call method on null instance
   ```
   Fix: Check @onready node paths match scene structure

---

## PERFORMANCE BASELINE

**Target (Retroid Pocket Classic):**
- FPS: 60 (stable)
- Resolution: 1080×1240
- RAM: < 512MB
- Battery: > 2 hours gameplay

**Current (Empty Project):**
- Should be well under targets
- Use as baseline for future optimization

---

## BUG REPORTING

**If you find bugs, report:**

1. **Bug Title:** Short description
2. **Steps to Reproduce:** 1, 2, 3...
3. **Expected:** What should happen
4. **Actual:** What actually happens
5. **Console Errors:** Any error messages
6. **Files Affected:** Which scenes/scripts

**Example:**
```
Bug: Main menu button doesn't respond
Steps: 1) Run main_menu.tscn 2) Click New Game
Expected: Game starts
Actual: Nothing happens
Errors: None
Files: scenes/ui/main_menu.tscn (no script attached yet)
Note: This is expected - Phase 1 task to add functionality
```

---

## SUCCESS CRITERIA (PHASE 0)

Phase 0 is complete when:
- ✅ All 7 tests pass
- ✅ No compilation errors
- ✅ Scenes load without errors
- ✅ Autoloads initialize correctly
- ✅ Resource classes compile

**Current Status:** Ready for testing

---

## NEXT STEPS (PHASE 1)

After Phase 0 validation, next AI should:
1. Implement player movement script
2. Test player movement
3. Implement farm plot script
4. Test farming interaction
5. Continue through Phase 1 tasks sequentially

---

**Last Updated:** December 16, 2025
**Phase:** 0 (Foundation complete, awaiting implementation)
