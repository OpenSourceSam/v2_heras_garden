# CIRCE'S GARDEN - PROJECT SUMMARY

**Quick reference for AI agents joining this project**

---

## THE GAME IN 60 SECONDS

**What:** Narrative farming game based on Greek mythology
**Who:** Circe transforms Scylla into a monster, then seeks redemption
**How:** Farm pharmaka herbs → Craft potions → Progress tragic story
**Why:** Explore themes of jealousy, guilt, and mercy through gameplay

**Platform:** Retroid Pocket Classic (1080×1240 Android, d-pad only)
**Engine:** Godot 4.5.1
**Playtime:** 65-90 minutes + endless mode

---

## STORY ARC (3 ACTS)

### Prologue: Heartbreak
- Circe sees Glaucos (her creation) with Scylla
- Gets permission to visit island Aiaia
- Discovers pharmaka magic herbs

### Act 1: Jealousy & Transformation (15-20 min)
1. Learn herb identification
2. Craft transformation sap
3. Transform Scylla into 6-headed monster
4. Get exiled by Zeus

### Act 2: Guilt & Failed Redemption (30-40 min)
5. Build garden on Aiaia
6. Craft calming draught → Scylla rejects it
7. Craft reversal elixir → Doesn't work
8. Meet Daedalus (gives loom)
9. Craft binding ward → Scylla breaks free
10. Scylla begs: "Just let me die"

### Act 3: The Stone Solution (15-20 min)
11. Gather final ingredients (Moon Tears, Divine Blood)
12. Craft petrification potion (hardest)
13. Turn Scylla to stone as mercy kill
14. Epilogue: Choose path forward

---

## CORE MECHANICS

### 1. Farming System
```
EMPTY → (till) → TILLED → (plant) → PLANTED → (water + time) → GROWING → HARVESTABLE → (harvest) → TILLED
```
- **Crops:** Moly, Nightshade, Lotus, Saffron
- **Growth:** 2-3 in-game days
- **Water:** Daily requirement
- **Harvest:** Adds to inventory

### 2. Crafting System
**Minigame:** Directional pattern + Button prompts
```
Grinding Phase: ↑ → ↓ ← (repeat)
Binding Phase:  A B A X (timed)
```

**Difficulty Progression:**
| Potion | Pattern | Buttons | Timing |
|--------|---------|---------|--------|
| Transformation Sap | 12 inputs | 0 | 2.0s |
| Calming Draught | 16 inputs | 4 | 1.5s |
| Reversal Elixir | 16 inputs | 6 | 1.0s |
| Binding Ward | 30 inputs | 8 | 0.8s |
| Petrification | 36 inputs | 10 | 0.6s |

### 3. Dialogue System
- Linear story with branching choices
- Flag-gated content
- Text scrolling animation
- 300+ dialogue lines

### 4. Minigames
- **Herb Identification:** Find glowing pharmaka among decoys
- **Moon Tears:** Catch falling droplets
- **Weaving:** Rhythm-based (optional)
- **Sacred Earth:** Button mashing

---

## TECHNICAL ARCHITECTURE

### Autoloads (Singletons)
```gdscript
GameState         # Inventory, flags, farm plots, day counter
AudioController   # Music & SFX management
SaveController    # JSON save/load
SceneManager      # Scene transitions (add in Phase 1)
```

### Resource Classes
```gdscript
CropData         # growth_stages, days_to_mature, harvest_item_id
ItemData         # id, display_name, icon, category
DialogueData     # lines, choices, flags_required, flags_to_set
NPCData          # sprite_frames, default_dialogue_id
RecipeData       # ingredients, grinding_pattern, button_sequence
```

### Key Entities
```gdscript
Player           # Movement, interaction, inventory access
FarmPlot         # States: EMPTY→TILLED→PLANTED→GROWING→HARVESTABLE
NPC              # Dialogue trigger, schedule, gifts
Interactable     # Base class for objects (sundial, mortar, loom)
```

---

## DATA SCHEMA QUICK REF

### Quest Flags
```gdscript
"found_pharmaka"              # Prologue complete
"transformed_scylla"          # Act 1 complete
"met_hermes"                  # Hermes introduced
"met_aeetes"                  # Brother visited
"calming_draught_failed"      # First attempt failed
"reversal_elixir_failed"      # Second attempt failed
"binding_ward_failed"         # Third attempt failed
"met_daedalus"                # Craftsman arrived
"scylla_petrified"            # Final confrontation complete
"chose_witch_path"            # Ending A
"chose_redemption_path"       # Ending B
```

### Crop IDs
```
"moly"        # White flowers, 2 days, calming
"nightshade"  # Purple berries, 2 days, transformation
"lotus"       # Pink blooms, 2 days, peace
"saffron"     # Red stamens, 3 days, rare
```

### Item IDs
```
Seeds: "moly_seed", "nightshade_seed", "lotus_seed", "saffron_seed"
Herbs: "moly", "nightshade", "lotus", "saffron"
Special: "sacred_earth", "moon_tear", "divine_blood"
Potions: "transformation_sap", "calming_draught", "reversal_elixir",
         "binding_ward", "petrification_potion"
```

---

## DEVELOPMENT PHASES

### ✅ Phase 0: Foundation (COMPLETE)
- Governance docs
- Autoloads
- Resource classes
- Folder structure

### 🔨 Phase 1: Core Systems (CURRENT)
- Player movement & interaction
- Farming system
- Crafting minigame
- Dialogue system
- Scene management

### 📅 Phase 2: Story Implementation
- Prologue cutscene
- Act 1 quests (3 quests)
- Act 2 quests (5 quests)
- Act 3 quests (3 quests)
- Epilogue & endings

### 📅 Phase 3: Minigames & Polish
- Herb identification refinement
- Moon tear catching
- Weaving system
- UI/UX polish

### 📅 Phase 4: Content & Balance
- All dialogue implementation
- Difficulty tuning
- Audio integration
- Playtesting

### 📅 Phase 5: Deployment
- Android build
- Retroid Pocket optimization
- Final QA

---

## FILE ORGANIZATION

```
v2_heras_garden/
├── CONSTITUTION.md           ⚠️  Immutable rules (READ FIRST)
├── SCHEMA.md                 ⚠️  Data structures (READ SECOND)
├── Storyline.md              📖 Complete narrative
├── DEVELOPMENT_ROADMAP.md    🗺️  Step-by-step implementation
├── PROJECT_SUMMARY.md        📄 This file
│
├── src/
│   ├── autoloads/           ✅ GameState, AudioController, SaveController
│   ├── resources/           ✅ CropData, ItemData, DialogueData, NPCData
│   ├── entities/            🔨 Player, FarmPlot, NPC
│   └── ui/                  🔨 DialogueBox, CraftingMinigame, InventoryPanel
│
├── scenes/
│   ├── ui/                  🔨 Main menu, HUD, dialogue_box
│   ├── entities/            🔨 player, farm_plot, npc
│   └── world.tscn           🔨 Main game world
│
├── resources/
│   ├── crops/               📅 moly.tres, nightshade.tres, etc.
│   ├── items/               📅 Item definitions
│   ├── dialogues/           📅 All dialogue trees
│   └── npcs/                📅 Hermes, Aeëtes, Daedalus
│
├── assets/
│   ├── sprites/             📅 Characters, crops, tiles, UI
│   └── audio/               📅 Music, SFX
│
└── tests/
    └── run_tests.gd         ✅ Automated validation
```

**Legend:**
✅ Complete | 🔨 In Progress | 📅 Planned | ⚠️ Critical Reference

---

## CRITICAL RULES (FROM CONSTITUTION.MD)

### DO:
✅ Use `TILE_SIZE = 32` constant
✅ Check SCHEMA.md for exact property names
✅ Register autoloads in project.godot
✅ Paint tiles in TileMapLayer before runtime
✅ Test each feature in isolation
✅ Commit after each completed subsection

### DON'T:
❌ Hardcode tile sizes (16, 32, etc.)
❌ Guess property names (check SCHEMA.md)
❌ Leave TileMapLayer empty
❌ Create duplicate systems
❌ Skip testing before integration
❌ Work on multiple phases at once

---

## QUICK START FOR NEW AI AGENT

1. **Read these files in order:**
   ```
   1. CONSTITUTION.md      (5 min - immutable rules)
   2. SCHEMA.md            (5 min - data structures)
   3. PROJECT_SUMMARY.md   (3 min - this file)
   4. DEVELOPMENT_ROADMAP.md (10 min - current tasks)
   5. Storyline.md         (20 min - full narrative)
   ```

2. **Check current status:**
   ```bash
   cat PROJECT_STATUS.md
   git log --oneline -10
   ```

3. **Verify environment:**
   ```bash
   godot --version  # Should be 4.5.1
   grep "\[autoload\]" project.godot  # Check autoloads
   ```

4. **Pick up where left off:**
   - Check DEVELOPMENT_ROADMAP.md for next task
   - Read task dependencies
   - Implement following code templates
   - Test per verification steps
   - Commit with provided message template

---

## SUCCESS METRICS

### Phase 1 Complete When:
- [ ] Player can move and interact
- [ ] Can till, plant, water, harvest crops
- [ ] Crafting minigame works (simple pattern)
- [ ] Dialogue system displays text and choices
- [ ] All systems tested in isolation
- [ ] No console errors on startup

### Game Complete When:
- [ ] Can play from start to finish (65-90 min)
- [ ] All 11 quests completable
- [ ] Both endings reachable
- [ ] Free-play mode unlocked
- [ ] Runs smoothly on Retroid Pocket
- [ ] No game-breaking bugs

---

## GETTING HELP

**If stuck:**
1. Check CONSTITUTION.md for the rule you might be violating
2. Check SCHEMA.md for correct property names
3. Check DEVELOPMENT_ROADMAP.md for code templates
4. Search Storyline.md for narrative context
5. Ask user for clarification on ambiguous requirements

**If encountering V1 issues:**
- Autoload not found → Check project.godot registration
- Property not found → Check exact name in SCHEMA.md
- Empty TileMap → Paint tiles in editor
- Magic numbers → Replace with TILE_SIZE constant

---

## PROJECT GOALS

**Primary:** Create a complete, playable, emotionally resonant farming game
**Secondary:** Demonstrate proper Godot architecture for future projects
**Tertiary:** Build reusable systems (farming, crafting, dialogue)

**Success = Player feels the weight of Circe's choices through gameplay**

---

**Last Updated:** December 16, 2025
**Current Phase:** Phase 1 (Core Systems)
**Next Milestone:** Playable core loop (plant → craft → dialogue)
