# Implementation Plan: Game Playability - Phase 6

## Overview

Complete the game build-out by wiring in the 37 HQ sprites generated in Phase 5, replacing placeholder art, making quest markers visible, and ensuring the full storyline dialogue system is properly connected.

## Context

**Current State:**
- Phase 5 complete: 37 HQ sprites generated (`tools/sprite_generator/generate_sprites_hq.py`)
- All sprites saved to `assets/sprites/placeholders/`
- World scene uses `placeholder_grass_tileset.tres` for tiles
- NPCBase uses `npc_world_placeholder.png` for all NPCs
- Quest triggers exist in world.tscn but use placeholder sprites for markers
- 26 dialogue files exist covering full 3-act story with 11 quests

**Storyline Reference:** `docs/design/Storyline.md` (12,500 words, 300+ dialogue lines, 65-90 min gameplay)

**Target:** Personal gift build for Retroid Pocket Classic

## Best Practices Applied

Based on CLAUDE.md, godot-dev, and godot-gdscript-patterns skills:

1. **Node Groups for Quest Markers** - Register markers to "quest_markers" group, toggle via signal
2. **Signal-based Visibility** - Use `quest_activated` and `quest_completed` signals instead of polling
3. **Debug Methods for Minigames** - Add `_debug_complete_minigame()` for headless testing
4. **Incremental Testing** - Run headless tests after each batch of sprite wiring
5. **MCP Tool Usage** - Use `mcp__godot__load_sprite` and `mcp__godot__save_scene` for automation
6. **Resource Data Pattern** - Keep sprites as data (Texture2D), separate from logic scripts

## Implementation Phases

### Phase 6A: Wire In HQ Item Sprites

**Objective:** Replace all placeholder item icons with HQ sprites generated in Phase 5.

**Approach:** Use MCP tools for efficient sprite loading

**Tasks:**
- [ ] Use MCP to load sprites into item resources:
  ```bash
  mcp__godot__load_sprite path="res://assets/sprites/placeholders/wheat.png" sprite_path="game/shared/resources/items/wheat.tres::icon"
  ```
- [ ] Wire these items (14 total):
  | Resource | Sprite Path |
  |----------|-------------|
  | wheat.tres | wheat.png |
  | wheat_seed.tres | wheat_seed.png |
  | moly.tres | moly.png |
  | moly_seed.tres | moly_seed.png |
  | nightshade.tres | nightshade.png |
  | nightshade_seed.tres | nightshade_seed.png |
  | calming_draught_potion.tres | calming_draught_potion.png |
  | binding_ward_potion.tres | binding_ward_potion.png |
  | reversal_elixir_potion.tres | reversal_elixir_potion.png |
  | petrification_potion.tres | petrification_potion.png |
  | moon_tear.tres | moon_tear.png |
  | sacred_earth.tres | sacred_earth.png |
  | woven_cloth.tres | woven_cloth.png |
  | pharmaka_flower.tres | pharmaka_flower.png |

**Testing:**
```powershell
mcp__godot__get_debug_output  # Check for texture warnings
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd
```

**Success Criteria:**
- [ ] All item .tres files load without texture warnings
- [ ] Tests pass 5/5
- [ ] Inventory shows HQ item icons


### Phase 6B: Wire In HQ NPC Sprites

**Objective:** Replace placeholder NPC SpriteFrames with animated character sprites.

**Pattern:** Use AnimatedSprite2D with idle animation (4 frames for subtle movement)

**Tasks:**
- [ ] Create SpriteFrames resources for each NPC:
  ```
  npc_hermes_frames.tres (idle: 4 frames, speed 4.0)
  npc_aeetes_frames.tres (idle: 4 frames, speed 4.0)
  npc_daedalus_frames.tres (idle: 4 frames, speed 4.0)
  npc_scylla_frames.tres (idle: 4 frames, speed 4.0)
  npc_circe_frames.tres (idle: 4 frames, speed 4.0)
  ```
- [ ] Assign HQ sprites to frames:
  - `npc_hermes.png` (64x64) - winged sandals, caduceus staff, green/gold robes
  - `npc_aeetes.png` (64x64) - regal purple robe, crown, staff with fire
  - `npc_daedalus.png` (64x64) - leather apron, wings motif, toolbox
  - `npc_scylla.png` (64x64) - dark blue/green, tentacle details
  - `npc_circe.png` (64x64) - flowing purple gown, pig wand, mystical aura
- [ ] Update NPC .tres files to use new SpriteFrames:
  - hermes.tres → hermes_frames.tres
  - aeetes.tres → aeetes_frames.tres
  - daedalus.tres → daedalus_frames.tres
  - scylla.tres → scylla_frames.tres
  - circe.tres → circe_frames.tres

**NPCBase Update:**
```gdscript
# In npc_base.tscn, update AnimatedSprite2D:
[node name="Sprite" type="AnimatedSprite2D"]
sprite_frames = ExtResource("hermes_frames")  # Per NPC
animation = "idle"
autoplay = "idle"
```

**Testing:**
```powershell
mcp__godot__get_debug_output  # Check for sprite errors
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_dialogue_flow_test.gd
```

**Success Criteria:**
- [ ] NPCs display animated idle sprites
- [ ] Characters are visually distinct
- [ ] Dialogue flow test passes


### Phase 6C: Wire In Crop Growth Sprites

**Objective:** Assign stage-specific sprites to crop resources.

**Pattern:** Each growth stage has unique sprite (seedling → growing → mature → harvestable)

**Tasks:**
- [ ] wheat.tres:
  - stage_1: wheat_stage_1.png (seedling - small green shoot)
  - stage_2: wheat_stage_2.png (growing - taller, golden tips)
  - stage_3: wheat_stage_3.png (maturing - full height, yellowing)
  - stage_4: wheat_stage_4.png (ready - golden wheat bundle)
- [ ] moly.tres:
  - Assign moly_stage_1.png through moly_stage_4.png
- [ ] nightshade.tres:
  - Assign nightshade_stage_1.png through nightshade_stage_4.png

**FarmPlot Validation:**
```gdscript
# Verify in farm_plot.gd that growth_stage sprites are assigned:
@export var growth_stage_sprites: Array[Texture2D] = [
    load("res://assets/sprites/placeholders/wheat_stage_1.png"),
    # ... all 4 stages
]
```

**Testing:**
```powershell
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_minigame_mechanics_test.gd
```

**Success Criteria:**
- [ ] Farm plot lifecycle test passes
- [ ] Crops show progression through all 4 stages


### Phase 6D: Build Out World Map Tiles

**Objective:** Replace placeholder grass tileset with proper tile art.

**Pattern:** TileMap with multiple terrain types (grass, dirt path, water edge)

**Tasks:**
- [ ] Create grass tileset resource:
  - `game/shared/resources/tiles/grass_tileset.tres`
  - Include: full tile, 4 edges, 4 corners, 1-pixel variations
- [ ] Update world.tscn TileMapLayer:
  ```gdscript
  # Replace:
  tile_set = ExtResource("placeholder_grass_tileset")
  # With:
  tile_set = ExtResource("grass_tileset")
  ```
- [ ] Add dirt path tile for walking areas
- [ ] Add water edge tiles for Scylla Cove area

**Tile Configuration (grass_tileset.tres):**
```
| ID     | Texture                  | Walkable |
|--------|--------------------------|----------|
| 0      | grass_full.png           | Yes      |
| 1      | grass_top_edge.png       | Yes      |
| 2      | grass_bottom_edge.png    | Yes      |
| 3      | grass_left_edge.png      | Yes      |
| 4      | grass_right_edge.png     | Yes      |
| 5      | dirt_path.png            | Yes      |
| 6      | water_edge.png           | No       |
```

**Testing:**
```powershell
mcp__godot__get_debug_output  # Check for tile errors
mcp__godot__run_project --timeout 30  # Quick visual check
```

**Success Criteria:**
- [ ] No tile-related warnings
- [ ] Player can walk on intended tiles
- [ ] Visual distinction between walkable/non-walkable


### Phase 6E: Make Quest Triggers Visible

**Objective:** Replace placeholder quest marker sprites with visible, animated indicators.

**Pattern:** Node Groups + Signals (NOT polling in _process)

**Tasks:**
- [ ] Create quest marker sprites:
  - `quest_marker.png` (16x16) - golden exclamation, pulse animation
  - `quest_complete.png` (16x16) - green checkmark, fade out
- [ ] Add markers to "quest_markers" group in world.tscn:
  ```gdscript
  # In world.gd _ready():
  for marker in $QuestMarkers.get_children():
      marker.add_to_group("quest_markers")
  ```
- [ ] Implement signal-based visibility:
  ```gdscript
  # In world.gd
  func _on_quest_activated(quest_id: String, position: Vector2):
      var marker = _get_marker_for_quest(quest_id)
      if marker:
          marker.visible = true
          marker.play("pulse")

  func _on_quest_completed(quest_id: String):
      var marker = _get_marker_for_quest(quest_id)
      if marker:
          marker.play("complete")
          await marker.animation_finished
          marker.visible = false
  ```
- [ ] Wire markers in world.tscn:
  - Quest1Marker → Quest1 trigger area
  - Quest2Marker → Quest2 trigger area
  - ... continue for all Quest1-Quest11 and Epilogue

**Quest Trigger Integration:**
```gdscript
# In quest_trigger.gd, emit signal when quest activates:
func _on_body_entered(body):
    if body.is_in_group("player"):
        GameState.set_flag(set_flag_on_enter)
        # Emit signal for marker visibility
        get_tree().call_group("world", "_on_quest_activated", set_flag_on_enter, global_position)
```

**Testing:**
```powershell
mcp__godot__get_debug_output  # Check for group errors
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_softlock_test.gd
```

**Success Criteria:**
- [ ] Golden markers appear when quests unlock
- [ ] Markers pulse to draw attention
- [ ] Markers disappear after quest completion


### Phase 6F: Populate Minigame Assets + Add Debug Methods

**Objective:** Assign HQ sprites and add debug completion methods for testing.

**Pattern:** Debug methods for headless testing (per godot-dev skill)

**Tasks:**
- [ ] Moon Tears minigame (`moon_tears.tscn`):
  - Assign moon_tears_moon.png (moon background)
  - Assign moon_tears_stars.png (stars overlay)
  - Assign moon_tears_player_marker.png
- [ ] Sacred Earth minigame (`sacred_earth.tscn`):
  - Assign sacred_earth_digging_area.png
  - Add debug method:
    ```gdscript
    func _debug_complete_minigame():
        progress = 100.0
        _on_minigame_complete(true)
    ```
- [ ] Crafting minigame (`crafting_minigame.tscn`):
  - Assign crafting_mortar.png
  - Add debug method:
    ```gdscript
    func _debug_complete_crafting():
        _on_crafting_complete(true)
    ```

**All Minigame Debug Methods:**
```gdscript
# In each minigame:
func _debug_complete_minigame():
    """Call this to complete minigame without timing dependency"""
    _on_success()
```

**Testing:**
```powershell
mcp__godot__get_debug_output
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_minigame_mechanics_test.gd
```

**Success Criteria:**
- [ ] Minigame backgrounds render correctly
- [ ] Debug methods allow headless completion
- [ ] All minigame tests pass


### Phase 6G: Dialogue System Integration

**Objective:** Ensure all storyline dialogue is properly connected to quest triggers.

**Pattern:** Validate dialogue chains, fix broken references

**Tasks:**
- [ ] Fix broken dialogue references:
  - circe_intro.tres → circe_accept_farming.tres
  - circe_intro.tres → circe_explain_pharmaka.tres
  - Verify these files exist and have proper `next_id` chains
- [ ] Validate full dialogue chain:
  ```
  prologue_opening → aiaia_arrival → circe_intro → [branch] → quest1_start
  quest1_start → act1_herb_identification → quest2_start
  quest2_start → act1_extract_sap → quest3_start
  quest3_start → act1_confront_scylla → (exile) → quest4_start
  ... continues through all 11 quests
  quest11_start → act3_final_confrontation → epilogue_ending_choice
  ```
- [ ] Ensure world.tscn dialogue references match:
  - Quest3 trigger: act1_confront_scylla ✓
  - Quest4 trigger: act2_farming_tutorial ✓
  - Quest5 trigger: act2_calming_draught ✓
  - Quest6 trigger: act2_reversal_elixir ✓
  - Quest7 trigger: act2_daedalus_arrives ✓
  - Quest8 trigger: act2_binding_ward ✓
  - Quest9 trigger: act3_sacred_earth ✓
  - Quest10 trigger: act3_moon_tears ✓
  - Quest11 trigger: act3_final_confrontation ✓

**Dialogue Validation Script:**
```gdscript
# In dialogue_box.gd or test:
func validate_dialogue_chain(start_id: String) -> bool:
    var current = start_id
    var visited = {}
    while current and current != "":
        if visited.has(current):
            push_error("Circular dialogue reference: %s" % current)
            return false
        visited[current] = true
        var dialogue = load("res://game/shared/resources/dialogues/" + current + ".tres")
        if not dialogue:
            push_error("Missing dialogue: %s" % current)
            return false
        current = dialogue.next_id
    return true
```

**Testing:**
```powershell
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/phase3_dialogue_flow_test.gd
```

**Success Criteria:**
- [ ] Dialogue flow test passes 29/29
- [ ] No missing dialogue references
- [ ] All quest dialogues trigger correctly


### Phase 6H: Create Visible Landmarks

**Objective:** Add visual landmarks to make the world feel populated.

**Pattern:** Static world decorations (non-interactive)

**Tasks:**
- [ ] Create/replace landmark sprites:
  - Tree: tree.png (48x64) - green foliage, brown trunk
  - Rock: rock.png (32x24) - gray stone
  - Signpost: signpost.png (16x32) - wooden, points to farm
  - House: house.png (96x64) - cottage with purple roof (Circe's home)
  - Mortar: mortar.png (24x24) - crafting station
- [ ] Update world.tscn landmarks:
  ```gdscript
  # Current uses npc_world_placeholder.png, replace with:
  TreeA.texture = load("res://assets/sprites/placeholders/tree.png")
  RockA.texture = load("res://assets/sprites/placeholders/rock.png")
  SignA.texture = load("res://assets/sprites/placeholders/signpost.png")
  ```
- [ ] Add new landmarks:
  - House near farm plots (Circe's home)
  - Mortar near house (crafting area)
  - Boat landmark at beach area

**Success Criteria:**
- [ ] World looks like a garden island
- [ ] Player can identify key locations
- [ ] Visual landmarks guide navigation


### Phase 6I: Environment Polish

**Objective:** Add visual polish for cohesive game feel.

**Tasks:**
- [ ] App icon:
  - Verify `app_icon.png` (512x512) exists
  - Assign in project.godot → Application → Icon
- [ ] Background gradient:
  - Update world.tscn Background ColorRect:
    ```gdscript
    # Use gradient instead of solid color
    color = Color(0.53, 0.81, 0.92)  # Sky blue
    ```
- [ ] Particle effects (using BurstParticles2D):
  - Harvest completion particles
  - Quest marker pulse glow
  - Potion craft success sparkle
- [ ] UI polish:
  - Inventory slots have consistent border
  - Dialogue box has proper styling
  - Quest markers have shadow for visibility

**BurstParticles2D Example:**
```gdscript
# In farm_plot.gd _on_harvest():
if harvest_particles:
    harvest_particles.emitting = true
```

**Testing:**
```powershell
mcp__godot__run_project --timeout 15  # Quick visual verification
mcp__godot__get_debug_output  # Check for particle errors
```

**Success Criteria:**
- [ ] Game has cohesive visual style
- [ ] Background looks like outdoor scene
- [ ] Harvest/quest completion feels rewarding


### Phase 6J: Final Integration Test

**Objective:** Verify all systems work together end-to-end.

**Pattern:** Run full test suite + manual playthrough checklist

**Tasks:**
- [ ] Run all headless tests:
  ```powershell
  # Run tests in sequence
  "Godot_v4.5.1-stable_win64.exe/Godot_v4.5.1-stable_win64.exe" --headless --script tests/run_tests.gd
  "Godot_v4.5.1-stable_win64.exe/Godot_v4.5.1-stable_win64.exe" --headless --script tests/phase3_dialogue_flow_test.gd
  "Godot_v4.5.1-stable_win64.exe/Godot_v4.5.1-stable_win64.exe" --headless --script tests/phase3_minigame_mechanics_test.gd
  "Godot_v4.5.1-stable_win64.exe/Godot_v4.5.1-stable_win64.exe" --headless --script tests/phase3_save_load_test.gd
  "Godot_v4.5.1-stable_win64.exe/Godot_v4.5.1-stable_win64.exe" --headless --script tests/phase3_softlock_test.gd
  "Godot_v4.5.1-stable_win64.exe/Godot_v4.5.1-stable_win64.exe" --headless --script tests/phase4_balance_test.gd
  ```
- [ ] Manual playthrough checklist:
  - [ ] New Game → Prologue dialogue plays
  - [ ] Player gains control in Aiaia
  - [ ] Golden marker shows first quest location
  - [ ] Talk to Hermes → quest activates
  - [ ] Complete herb identification minigame
  - [ ] Farm plot works (till → plant → grow → harvest)
  - [ ] Crafting ritual works
  - [ ] Boat travel to Scylla Cove
  - [ ] All 11 quests completeable
  - [ ] Epilogue plays, ending choice works
  - [ ] Free play mode unlocks

**Success Criteria:**
- [ ] All 166+ tests pass
- [ ] Full playthrough completes without errors
- [ ] All HQ sprites render correctly
- [ ] Game feels complete and polished


## MCP Commands Reference

```powershell
# Sprite loading
mcp__godot__load_sprite path="res://assets/sprites/placeholders/wheat.png" sprite_path="game/shared/resources/items/wheat.tres::icon"

# Scene operations
mcp__godot__save_scene scene_path="game/features/world/world.tscn"

# Testing
mcp__godot__get_debug_output
mcp__godot__run_project --timeout 60

# Editor
mcp__godot__launch_editor --project_path="C:\Users\Sam\Documents\GitHub\v2_heras_garden"
```


## Dependencies

**Prerequisites:**
- Phase 5 complete (37 HQ sprites generated)
- All dialogue files exist
- Quest trigger system working
- Godot 4.5.1 with export templates installed

**External:**
- Python with PIL/Pillow for any additional sprite generation
- Godot editor for assigning resources to .tres files


## Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Sprite assignment errors | Test each batch with `mcp__godot__get_debug_output` |
| Dialogue chain broken | Run dialogue validation before integration |
| Performance with particles | Limit particle counts, use simple effects |
| Map tiles don't tile | Test tile transitions in editor first |
| Quest marker visibility | Use contrasting colors + pulse animation |


## Files to Modify

**Resources (assign textures):**
- `game/shared/resources/items/*.tres` (14 files)
- `game/shared/resources/npcs/*.tres` (5 files)
- `game/shared/resources/crops/*.tres` (3 files)
- `game/shared/resources/tiles/grass_tileset.tres` (new)

**Scenes (assign sprites):**
- `game/features/world/world.tscn`
- `game/features/npcs/npc_base.tscn`
- `game/features/minigames/moon_tears/moon_tears.tscn`
- `game/features/minigames/sacred_earth/sacred_earth.tscn`
- `game/features/crafting/crafting_minigame.tscn`

**Scripts (add functionality):**
- `game/features/world/world.gd` (quest marker signals, marker groups)
- `game/features/world/quest_trigger.gd` (signal emission)
- Minigame scripts (add `_debug_complete_minigame()`)

**New Files:**
- `game/shared/resources/npcs/*_frames.tres` (5 files)
- `game/shared/resources/tiles/grass_tileset.tres`
- `assets/sprites/placeholders/quest_marker.png`
- `assets/sprites/placeholders/quest_complete.png`


## Estimated Effort

| Phase | Tasks | Complexity |
|-------|-------|------------|
| 6A: Item Sprites | 14 | Low |
| 6B: NPC Sprites | 10 | Medium |
| 6C: Crop Sprites | 3 | Low |
| 6D: Map Tiles | 5 | Medium |
| 6E: Quest Markers | 8 | Medium |
| 6F: Minigame + Debug | 6 | Medium |
| 6G: Dialogue Integration | 5 | Medium |
| 6H: Landmarks | 6 | Low |
| 6I: Environment Polish | 4 | Low |
| 6J: Final Test | 10 | Medium |

**Total: ~71 tasks across 10 phases**
