extends Resource
class_name NPCData
## Defines an NPC character - see docs/design/SCHEMA.md for property documentation
##
## Schedule Dictionary Structure:
## {
##     "time": "0800",              # Time in 24-hour format (HHMM)
##     "location": "garden",        # Location name or coordinates
##     "animation": "idle"          # Animation to play
## }

@export var id: String = ""                      ## Unique NPC ID (snake_case)
@export var display_name: String = ""            ## Human-readable name
@export var sprite_frames: SpriteFrames         ## Animated sprite
@export var default_dialogue_id: String = ""     ## DialogueData.id for first interaction
@export var gift_preferences: Dictionary = {}    ## {"item_id": affection_bonus}
@export var schedule: Array[Dictionary] = []     ## [{"time": "0800", "location": "garden"}]
