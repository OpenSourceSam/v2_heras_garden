extends Resource
class_name DialogueData
## Defines a dialogue sequence - see docs/design/SCHEMA.md for property documentation
##
## Line Dictionary Structure:
## {
##     "speaker": "Hera",           # Character name (or "" for narrator)
##     "text": "Welcome, friend.",  # Dialogue text
##     "emotion": "happy"           # Optional: sprite emotion
## }
##
## Choice Dictionary Structure:
## {
##     "text": "I'll help you.",    # Choice text shown to player
##     "next_id": "accept_quest",   # DialogueData.id to jump to
##     "flag_required": ""          # Optional: flag needed to show this choice
## }

@export var id: String = ""                           ## Unique dialogue ID
@export var lines: Array[Dictionary] = []             ## [{"speaker": "Hera", "text": "Hello!"}]
@export var choices: Array[Dictionary] = []           ## [{"text": "Yes", "next_id": "accept"}]
@export var flags_required: Array[String] = []        ## Quest flags needed to trigger
@export var flags_to_set: Array[String] = []          ## Quest flags to set when complete
@export var next_dialogue_id: String = ""             ## Auto-continue to this dialogue
