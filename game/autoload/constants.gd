extends Node
## Global Constants
## DO NOT INSTANTIATE - Use as Constants.TILE_SIZE
## Readonly values used throughout the project

# ============================================
# GAME SETTINGS
# ============================================

## Core tile size (immutable - see docs/design/CONSTITUTION.md)
const TILE_SIZE: int = 32

## Target viewport size (Retroid Pocket Classic)
const VIEWPORT_WIDTH: int = 1080
const VIEWPORT_HEIGHT: int = 1240

## Target framerate
const TARGET_FPS: int = 60

# ============================================
# GAMEPLAY CONSTANTS
# ============================================

## Player movement speed (pixels per second)
const PLAYER_SPEED: float = 100.0

## Interaction range (pixels)
const INTERACTION_RANGE: int = 32

## Starting gold amount
const STARTING_GOLD: int = 100

## Days per season
const DAYS_PER_SEASON: int = 28

## Maximum inventory stack size
const MAX_STACK_SIZE: int = 99

# ============================================
# UI CONSTANTS
# ============================================

## Text scroll speed (seconds per character)
const TEXT_SCROLL_SPEED: float = 0.03

## Dialogue box height
const DIALOGUE_BOX_HEIGHT: int = 300

## Button size
const BUTTON_WIDTH: int = 200
const BUTTON_HEIGHT: int = 50

# ============================================
# AUDIO CONSTANTS
# ============================================

## Audio bus names
const BUS_MASTER: String = "Master"
const BUS_MUSIC: String = "Music"
const BUS_SFX: String = "SFX"

## Fade durations
const MUSIC_FADE_DURATION: float = 1.0
const SCENE_FADE_DURATION: float = 0.3

# ============================================
# COLORS (Theme)
# ============================================

## UI Colors
const COLOR_PRIMARY: Color = Color(0.4, 0.6, 0.3)  # Green
const COLOR_SECONDARY: Color = Color(0.415, 0.051, 0.678)  # Purple (Circe's color)
const COLOR_ACCENT: Color = Color(0.8, 0.7, 0.2)  # Gold
const COLOR_DANGER: Color = Color(0.8, 0.2, 0.2)  # Red
const COLOR_SUCCESS: Color = Color(0.2, 0.8, 0.2)  # Bright green
const COLOR_NEUTRAL: Color = Color(0.5, 0.5, 0.5)  # Gray

## Crop stage colors (for placeholder visualization)
const COLOR_TILLED: Color = Color(0.4, 0.3, 0.2)  # Brown
const COLOR_PLANTED: Color = Color(0.3, 0.5, 0.3)  # Dark green
const COLOR_GROWING: Color = Color(0.4, 0.6, 0.4)  # Medium green
const COLOR_HARVESTABLE: Color = Color(0.6, 0.8, 0.3)  # Bright green-yellow

# ============================================
# LAYER CONSTANTS
# ============================================

## Z-index layers for rendering order
const LAYER_BACKGROUND: int = -100
const LAYER_GROUND: int = 0
const LAYER_OBJECTS: int = 10
const LAYER_PLAYER: int = 20
const LAYER_UI: int = 100
const LAYER_DEBUG: int = 1000

# ============================================
# INPUT ACTION NAMES
# ============================================

## Input action identifiers (match project.godot)
const INPUT_INTERACT: String = "interact"
const INPUT_MENU: String = "ui_cancel"
const INPUT_CONFIRM: String = "ui_accept"
const INPUT_CANCEL: String = "ui_cancel"

# ============================================
# SCENE PATHS
# ============================================

## Main scene paths for SceneManager
const SCENE_MAIN_MENU: String = "res://game/features/ui/main_menu.tscn"
const SCENE_WORLD: String = "res://game/features/world/world.tscn"
const SCENE_TEST: String = "res://tests/test_scene.tscn"

# ============================================
# SAVE/LOAD
# ============================================

## Save file path (JSON format)
const SAVE_FILE_PATH: String = "user://savegame.json"

## Save file version (for compatibility checks)
const SAVE_VERSION: int = 2
