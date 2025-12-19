# HERA'S GARDEN V2 - DATA SCHEMA

**Version:** 2.0
**Last Updated:** December 15, 2025
**Purpose:** Single source of truth for all data structures and property names

---

## CRITICAL: Property Name Enforcement

**ALWAYS check this document before accessing any property.** V1 failed because AI hallucinated property names (`sprites` vs `stages_textures`). Use EXACTLY the names defined here.

---

## 1. RESOURCE CLASSES

### CropData (`src/resources/crop_data.gd`)

```gdscript
class_name CropData
extends Resource

@export var id: String = ""                        # Unique identifier (snake_case: "wheat", "tomato")
@export var display_name: String = ""              # Human-readable name ("Wheat", "Tomato")
@export var growth_stages: Array[Texture2D] = []   # Textures for each growth stage
@export var days_to_mature: int = 3                # Days until harvestable
@export var harvest_item_id: String = ""           # ItemData.id for harvest result
@export var seed_item_id: String = ""              # ItemData.id for seed
@export var sell_price: int = 0                    # Gold value when sold
@export var regrows: bool = false                  # If true, doesn't need replanting
@export var seasons: Array[String] = []            # ["spring", "summer"] - empty = all seasons
```

**Property Enforcement:**
- ✅ `growth_stages` (NOT "sprites", "textures", "stages_textures")
- ✅ `days_to_mature` (NOT "growth_time", "days", "maturity_days")
- ✅ `id` in snake_case (NOT "name", "crop_id")

**Example Data File:** `resources/crops/wheat.tres`

---

### ItemData (`src/resources/item_data.gd`)

```gdscript
class_name ItemData
extends Resource

@export var id: String = ""              # Unique identifier (snake_case: "wheat_seed")
@export var display_name: String = ""    # Human-readable name ("Wheat Seed")
@export var description: String = ""     # Flavor text
@export var icon: Texture2D              # Inventory icon (32x32)
@export var stack_size: int = 99         # Max stack in inventory
@export var sell_price: int = 0          # Gold value when sold
@export var category: String = "misc"    # "seed", "crop", "tool", "gift", "misc"
```

**Property Enforcement:**
- ✅ `id` in snake_case (NOT "item_id", "name")
- ✅ `display_name` (NOT "name", "item_name")
- ✅ `category` (NOT "type", "item_type")

**Example Data File:** `resources/items/wheat_seed.tres`

---

### DialogueData (`src/resources/dialogue_data.gd`)

```gdscript
class_name DialogueData
extends Resource

@export var id: String = ""                           # Unique dialogue ID
@export var lines: Array[Dictionary] = []             # [{"speaker": "Hera", "text": "Hello!"}]
@export var choices: Array[Dictionary] = []           # [{"text": "Yes", "next_id": "accept"}]
@export var flags_required: Array[String] = []        # Quest flags needed to trigger
@export var flags_to_set: Array[String] = []          # Quest flags to set when complete
@export var next_dialogue_id: String = ""             # Auto-continue to this dialogue
```

**Line Dictionary Structure:**
```gdscript
{
    "speaker": "Hera",           # Character name (or "" for narrator)
    "text": "Welcome, friend.",  # Dialogue text
    "emotion": "happy"           # Optional: sprite emotion
}
```

**Choice Dictionary Structure:**
```gdscript
{
    "text": "I'll help you.",    # Choice text shown to player
    "next_id": "accept_quest",   # DialogueData.id to jump to
    "flag_required": ""          # Optional: flag needed to show this choice
}
```

**Example Data File:** `resources/dialogues/medusa_intro.tres`

---

### NPCData (`src/resources/npc_data.gd`)

```gdscript
class_name NPCData
extends Resource

@export var id: String = ""                      # Unique NPC ID (snake_case)
@export var display_name: String = ""            # Human-readable name
@export var sprite_frames: SpriteFrames         # Animated sprite
@export var default_dialogue_id: String = ""     # DialogueData.id for first interaction
@export var gift_preferences: Dictionary = {}    # {"item_id": affection_bonus}
@export var schedule: Array[Dictionary] = []     # [{"time": "0800", "location": "garden"}]
```

**Example Data File:** `resources/npcs/medusa.tres`

---

## 2. AUTOLOAD SINGLETONS

### GameState (`src/autoloads/game_state.gd`)

**Signals:**
```gdscript
signal inventory_changed(item_id: String, new_quantity: int)
signal gold_changed(new_amount: int)
signal day_advanced(new_day: int)
signal flag_changed(flag: String, value: bool)
signal crop_planted(plot_id: Vector2i, crop_id: String)
signal crop_harvested(plot_id: Vector2i, item_id: String, quantity: int)
```

**State Properties:**
```gdscript
var current_day: int = 1                    # Game day counter
var current_season: String = "spring"       # "spring", "summer", "fall", "winter"
var gold: int = 100                         # Player's money
var inventory: Dictionary = {}              # { "item_id": quantity }
var quest_flags: Dictionary = {}            # { "flag_name": bool }
var farm_plots: Dictionary = {}             # { Vector2i: PlotData }
```

**PlotData Structure:**
```gdscript
{
    "crop_id": "wheat",           # CropData.id
    "planted_day": 1,             # Day planted
    "current_stage": 0,           # Current growth stage index
    "watered_today": false,       # Watered status
    "ready_to_harvest": false     # Harvestable flag
}
```

**Methods:**
```gdscript
func add_item(item_id: String, quantity: int = 1) -> void
func remove_item(item_id: String, quantity: int = 1) -> bool
func has_item(item_id: String, quantity: int = 1) -> bool
func get_item_count(item_id: String) -> int

func add_gold(amount: int) -> void
func remove_gold(amount: int) -> bool

func set_flag(flag: String, value: bool = true) -> void
func get_flag(flag: String) -> bool

func advance_day() -> void
func plant_crop(position: Vector2i, crop_id: String) -> void
func harvest_crop(position: Vector2i) -> void
```

**Property Enforcement:**
- ✅ `inventory` (NOT "player_inventory", "items")
- ✅ `quest_flags` (NOT "flags", "questFlags")
- ✅ `farm_plots` (NOT "plots", "planted_crops")

---

### AudioController (`src/autoloads/audio_controller.gd`)

```gdscript
func play_sfx(sfx_name: String) -> void
func play_music(track_name: String, loop: bool = true) -> void
func stop_music() -> void
func set_master_volume(volume: float) -> void  # 0.0 to 1.0
func set_sfx_volume(volume: float) -> void
func set_music_volume(volume: float) -> void
```

---

### SaveController (`src/autoloads/save_controller.gd`)

```gdscript
const SAVE_PATH: String = "user://savegame.json"
const SAVE_VERSION: int = 2

func save_game() -> bool
func load_game() -> bool
func save_exists() -> bool
func delete_save() -> void
```

**Save File Structure:**
```json
{
    "version": 2,
    "timestamp": "2025-12-15T10:30:00Z",
    "current_day": 15,
    "current_season": "spring",
    "gold": 500,
    "inventory": {
        "wheat": 10,
        "tomato_seed": 5
    },
    "quest_flags": {
        "met_medusa": true,
        "unlocked_greenhouse": false
    },
    "farm_plots": {
        "(0, 0)": {
            "crop_id": "wheat",
            "planted_day": 10,
            "current_stage": 2,
            "watered_today": true,
            "ready_to_harvest": false
        }
    }
}
```

---

## 3. SCENE NODE STRUCTURES

### Player (`scenes/entities/player.tscn`)

**Required Nodes:**
```
Player (CharacterBody2D)
├─ Sprite2D (name: "Sprite")
├─ CollisionShape2D (name: "Collision")
└─ Camera2D (name: "Camera")
```

**Script Properties:**
```gdscript
const SPEED: float = 100.0
var velocity: Vector2 = Vector2.ZERO
```

---

### FarmPlot (`scenes/entities/farm_plot.tscn`)

**Required Nodes:**
```
FarmPlot (Node2D)
├─ Sprite2D (name: "TilledSprite")      # Shows tilled dirt
└─ Sprite2D (name: "CropSprite")        # Shows growing crop
```

**Script Properties:**
```gdscript
var grid_position: Vector2i = Vector2i.ZERO
var crop_id: String = ""
var current_stage: int = 0
var is_watered: bool = false
```

---

### World (`scenes/world.tscn`)

**Required Nodes:**
```
World (Node2D)
├─ TileMapLayer (name: "Ground")         # Grass, paths, etc.
├─ TileMapLayer (name: "FarmArea")       # Tillable soil
├─ Node2D (name: "FarmPlots")            # Container for farm_plot instances
├─ Node2D (name: "NPCs")                 # Container for NPC instances
└─ Player (instance)
```

---

## 4. CONSTANTS

**From CONSTITUTION.md:**

```gdscript
const TILE_SIZE: int = 32               # Base tile size in pixels
const VIEWPORT_WIDTH: int = 1080        # Target display width
const VIEWPORT_HEIGHT: int = 1240       # Target display height (Retroid Pocket)
```

---

## 5. QUEST FLAGS

**Naming Convention:** `snake_case_descriptive`

**Core Flags:**
```gdscript
"met_medusa"              # Triggered after first Medusa dialogue
"unlocked_watering_can"   # Player received watering can
"first_harvest_complete"  # Completed first crop harvest
"unlocked_greenhouse"     # Greenhouse area accessible
"medusa_friendship_1"     # Reached friendship level 1
"game_complete"           # Finished main storyline
```

**Flag Usage:**
```gdscript
# Setting flags
GameState.set_flag("met_medusa", true)

# Checking flags
if GameState.get_flag("met_medusa"):
    # Show advanced dialogue
```

---

## 6. ITEM ID REGISTRY

**Naming Convention:** `category_name` (snake_case)

**Seeds:**
- `wheat_seed`
- `tomato_seed`
- `carrot_seed`

**Crops:**
- `wheat`
- `tomato`
- `carrot`

**Tools:**
- `watering_can`
- `hoe`
- `sickle`

**Gifts:**
- `ambrosia`
- `golden_apple`

---

## 7. CROP ID REGISTRY

**Naming Convention:** `snake_case`

**Implemented:**
- `wheat` (3 days, 4 stages, no regrow)
- `tomato` (5 days, 5 stages, regrows)
- `carrot` (4 days, 4 stages, no regrow)

---

## 8. DIALOGUE ID REGISTRY

**Naming Convention:** `character_context`

**Medusa Dialogues:**
- `medusa_intro`              # First meeting
- `medusa_daily`              # Standard greeting
- `medusa_gift_response`      # After receiving gift
- `medusa_friendship_1`       # Friendship level 1 unlock

**Hera Internal Monologues:**
- `hera_first_day`
- `hera_first_harvest`
- `hera_season_change`

---

## QUICK REFERENCE: COMMON ACCESS PATTERNS

**Add item to inventory:**
```gdscript
GameState.add_item("wheat", 5)
```

**Check if player has item:**
```gdscript
if GameState.has_item("watering_can"):
    # Can water crops
```

**Plant crop:**
```gdscript
GameState.plant_crop(Vector2i(0, 0), "wheat")
```

**Check quest flag:**
```gdscript
if GameState.get_flag("met_medusa"):
    # Show advanced content
```

**Play sound:**
```gdscript
AudioController.play_sfx("plant_seed")
```

---

**End of SCHEMA.md**
