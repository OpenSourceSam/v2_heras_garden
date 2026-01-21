---
description: "Expert Godot Engine game development knowledge"
---

You are now using the godot skill from .claude/skills/godot/SKILL.md

## Core Concepts

### Scene Tree Architecture
- Scenes are collections of nodes arranged in a tree hierarchy
- Every scene has a root node
- Nodes inherit from parent nodes and can have multiple children
- Scene instances can be nested and reused
- The scene tree is traversed from root to leaves

### Node Types

*2D Nodes:*
- Node2D: Base for all 2D nodes, has position, rotation, scale
- Sprite2D: Displays 2D textures
- AnimatedSprite2D: Plays sprite animations
- CollisionShape2D: Defines collision areas (must be child of physics body)
- Area2D: Detects overlapping bodies/areas
- CharacterBody2D: Physics body with built-in movement functions
- RigidBody2D: Physics body affected by forces
- StaticBody2D: Imovable physics body
- TileMap: Grid-based tile system
- Camera2D: 2D camera with follow and zoom
- CanvasLayer: UI layer that stays fixed on screen
- Control: Base for UI elements (Button, Label, Panel, etc.)

### Common Nodes:
- Timer: Execute code after a delay
- AudioStreamPlayer: Play sounds
- AnimationPlayer: Control complex animations

## GDScript Patterns

**Node References:**
```gdscript
# Get child node
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

# Get node by path
var player = get_node("/root/Main/Player")

# Find node by type
var camera = get_tree().get_first_node_in_group("camera")
```

**Common Lifecycle Methods:**
```gdscript
func _ready():
    # Called when node enters scene tree
    pass

func _process(delta):
    # Called every frame
    pass

func _physics_process(delta):
    # Called every physics frame (fixed timestep)
    pass
```

## Input Handling
```gdscript
func _input(event):
    if event.is_action_pressed("jump"):
        jump()

func _process(delta):
    var direction = Input.get_axis("left", "right")
```

## Testing Commands

### Headless Verification
```powershell
# Unit tests
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --script tests/run_tests.gd

# Smoke scene wiring
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --scene res://tests/smoke_test.tscn --quit-after 30

# Scene load validation
.\Godot_v4.5.1-stable_win64.exe\Godot_v4.5.1-stable_win64.exe --headless --path . --script tests/phase3_scene_load_runner.gd
```

## Project Structure Best Practices
```
project/
├── project.godot           # Project configuration
├── scenes/                 # All scene files
├── scripts/                # GDScript files
├── assets/                 # Art, audio, etc.
└── resources/              # .tres resource files
```

## MCP Tools Available
- `mcp__godot__launch_editor`: Open Godot editor
- `mcp__godot__run_project`: Run the game
- `mcp__godot__get_debug_output`: Get console output
- `mcp__godot__create_scene`: Create new scenes
- `mcp__godot__add_node`: Add nodes to scenes
- `mcp__godot__load_sprite`: Load textures
