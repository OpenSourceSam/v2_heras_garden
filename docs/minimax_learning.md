# MiniMax Learning Notes

## Real-Time Debug Monitoring

**CRITICAL LESSON:** Always monitor debug output in real-time while users play. Use:

```bash
tail -f /tmp/claude/C--Users-Sam-Documents-GitHub/v2_heras-garden/tasks/*/*.output | grep -E "quest|Quest|herb|pharmaka"
```

This gives immediate feedback on:
- Quest activation/deactivation
- Item counts
- Flag changes
- User actions and game state

## Game Navigation with MCP

### Getting Player Position
```gdscript
# Get exact player coordinates
get_tree().get_first_node_in_group("player").global_position
# Returns: Vector2(x, y)
```

### Getting NPC Position
```gdscript
# Get Hermes position
get_node("/root/World/NPCs/NPCSpawner/Hermes").global_position
```

### Smart Movement Strategy
1. Get both player and target positions
2. Calculate vector difference
3. Move in the direction needed:
   - If target.x > player.x: move right (ui_right)
   - If target.x < player.x: move left (ui_left)
   - If target.y > player.y: move down (ui_down)
   - If target.y < player.y: move up (ui_up)

**Example Navigation Logic:**
```python
# Pseudocode for smart movement
player_pos = evaluate("get_tree().get_first_node_in_group('player').global_position")
hermes_pos = evaluate("get_node('/root/World/NPCs/NPCSpawner/Hermes').global_position")

dx = hermes_pos.x - player_pos.x
dy = hermes_pos.y - player_pos.y

if abs(dx) > 50:  # Need horizontal movement
    if dx > 0:
        move_right()
    else:
        move_left()
elif abs(dy) > 50:  # Need vertical movement
    if dy > 0:
        move_down()
    else:
        move_up()
else:
    # Close enough to interact
    interact()
```

## Quest Flow Debugging

### Key Flags to Monitor
- `prologue_complete` - Game start
- `quest_1_active` - Quest 1 triggered
- `quest_1_complete` - Quest 1 finished
- `quest_2_active` - May be deleted, causing issues
- `quest_3_active` - Next quest after quest 1

### Common Bug Patterns
1. **Dialogue sets quest_complete without running minigame**
   - Symptom: quest_1_complete appears immediately after quest_1_active
   - Fix: Remove `flags_to_set = ["quest_1_complete"]` from dialogue
   - Connect `dialogue_ended` to start minigame instead

2. **Quest 2 deleted but referenced**
   - Symptom: "Missing required flag: quest_2_complete"
   - Fix: Update NPC dialogue flow to skip quest 2 or restore it

3. **Minigame doesn't close**
   - Add ESC key handler: `elif event.is_action_pressed("ui_cancel"): queue_free()`
   - Auto-close on completion: `await timer; queue_free()`

## Testing Workflow

### 1. Start Monitoring First
```bash
tail -f /tmp/claude/C--Users-Sam-Documents-GitHub/v2_heras-garden/tasks/*/*.output &
tail_pid=$!
```

### 2. Run Game
```bash
npx -y godot-mcp-cli run_project
```

### 3. Execute Test Sequence
```bash
# Start new game
simulate_input_sequence --sequence '[{"type":"tap","action":"ui_accept","duration_ms":100}]'

# Navigate to NPC (using position data)
# Use evaluate_runtime_expression to get positions
# Move in correct direction based on coordinates

# Interact and advance dialogue
simulate_input_sequence --sequence '[{"type":"tap","action":"interact","duration_ms":100}]'
simulate_input_sequence --sequence '[{"type":"tap","action":"ui_accept","duration_ms":100}]'
```

### 4. Monitor Quest Activation
Watch for:
```
[GameState] Flag set: quest_1_active = true
[GameState] Flag set: quest_1_complete = true  # Should NOT appear immediately!
```

### 5. Check Item Counts
```
[GameState] Added 3 x pharmaka_flower (total: 3)  # From minigame
[GameState] Added 1 x golden_glow (total: 1)      # From harvesting
```

## Code Patterns for Fixing Quests

### Pattern 1: Fix Dialogue Flow
**Before (BROKEN):**
```gdscript
# In dialogue.tres
flags_to_set = ["quest_1_complete"]  # ❌ Skips minigame!
```

**After (FIXED):**
```gdscript
# In dialogue.tres
flags_to_set = []  # ✅ Don't set quest complete

# In world.gd
func _on_dialogue_ended(dialogue_id: String) -> void:
    if dialogue_id == "act1_herb_identification":
        _start_herb_identification_minigame()

func _start_herb_identification_minigame() -> void:
    var minigame = load("res://...herb_identification.tscn").instantiate()
    ui_layer.add_child(minigame)
    minigame.minigame_complete.connect(_on_minigame_complete)

func _on_minigame_complete(success: bool, items: Array) -> void:
    if success:
        GameState.set_flag("quest_1_complete", true)  # ✅ Set after minigame
```

### Pattern 2: Add Minigame Closing
**ESC to Close:**
```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        queue_free()  # Close minigame
```

**Auto-Close on Success:**
```gdscript
func _complete_minigame() -> void:
    minigame_complete.emit(true, items)
    await get_tree().create_timer(1.5).timeout
    queue_free()  # Auto-close after showing success
```

## MCP Server Capabilities

### Documentation Resources
- ✅ `docs/MCP_SETUP.md` - Complete MCP server documentation
- ✅ `docs/testing/GODOT_TOOLS_GUIDE.md` - VS Code + Godot integration guide
- ✅ `.vscode/mcp.json` - MCP configuration

### Input Simulation
- `simulate_action_tap` - Single button press
- `simulate_input_sequence` - Complex input sequences with timing
- Supports: `ui_accept`, `interact`, `ui_left`, `ui_right`, `ui_up`, `ui_down`, `ui_cancel`

### State Inspection
- `get_runtime_scene_structure` - Full scene tree
- `evaluate_runtime_expression` - Execute GDScript to get data
- `get_debug_output` - Console messages
- `get_node_properties` - Node details

### Navigation Aids (Position-Based Movement)
```bash
# Get player coordinates
npx -y godot-mcp-cli evaluate_runtime_expression --expression "get_tree().get_first_node_in_group('player').global_position"

# Get target (Hermes) coordinates
npx -y godot-mcp-cli evaluate_runtime_expression --expression "get_node('/root/World/NPCs/NPCSpawner/Hermes').global_position"

# Get any NPC position
npx -y godot-mcp-cli evaluate_runtime_expression --expression "get_node('/root/World/NPCs/NPCSpawner/{NPC_NAME}').global_position"
```

**Returns:** Vector2(x, y) - Use coordinates to calculate movement direction!

**Smart Navigation Algorithm:**
```python
# Step 1: Get positions
player_pos = evaluate("get_tree().get_first_node_in_group('player').global_position")
hermes_pos = evaluate("get_node('/root/World/NPCs/NPCSpawner/Hermes').global_position")

# Step 2: Calculate direction
dx = hermes_pos.x - player_pos.x
dy = hermes_pos.y - player_pos.y

# Step 3: Move in the right direction
if abs(dx) > 50:  # More than 50 pixels away horizontally
    if dx > 0:
        # Target is to the right - move right
        simulate("ui_right", 500ms)
    else:
        # Target is to the left - move left
        simulate("ui_left", 500ms)
elif abs(dy) > 50:  # More than 50 pixels away vertically
    if dy > 0:
        # Target is below - move down
        simulate("ui_down", 500ms)
    else:
        # Target is above - move up
        simulate("ui_up", 500ms)
else:
    # Close enough - interact!
    simulate("interact", 100ms)
```

### Other Useful Data Points
- **Quest Flags:** `GameState.get_flag("quest_1_active")`
- **Item Counts:** `GameState.get_item_count("pharmaka_flower")`
- **Scene Structure:** `get_runtime_scene_structure --max-depth 3`

## Common Mistakes to Avoid

1. **Don't assume positions** - Always get actual coordinates
2. **Don't skip monitoring** - Real-time output reveals issues immediately
3. **Don't hardcode movement** - Use position data to navigate intelligently
4. **Don't leave minigames open** - Always add close/escape functionality
5. **Don't set quest_complete in dialogue** - Use proper flow with minigames

## When to Use Each Tool

| Task | Best Tool |
|------|-----------|
| Navigate to NPC | Position evaluation + smart movement |
| Check quest state | `get_debug_output` or evaluate GameState flags |
| Verify item counts | Debug output or evaluate inventory |
| Test dialogue flow | MCP input + monitor flag changes |
| Inspect UI state | `get_runtime_scene_structure` |
| Debug errors | `get_debug_output` |

## Success Metrics

✅ **Quest 1 Working:** Dialogue → Minigame → 3 pharmaka_flower items → quest_1_complete
✅ **Navigation:** Can reach any NPC using position data
✅ **Monitoring:** Real-time debug output shows all quest events
✅ **UX:** Minigames close properly (ESC or auto-close)
