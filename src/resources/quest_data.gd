extends Resource
class_name QuestData
## Quest definition - see SCHEMA.md

## Objective Dictionary Structure:
## {
##     "id": "collect_moly",
##     "description": "Collect 3 Moly flowers",
##     "type": "collect",  # collect, dialogue, cutscene, craft
##     "required": true,
##     "target_id": "moly",  # item_id or npc_id
##     "target_quantity": 3
## }

## Reward Dictionary Structure:
## {
##     "type": "gold",  # gold, item, flag
##     "value": 100  # amount or item_id or flag_name
## }

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var objectives: Array[Dictionary] = []
@export var rewards: Array[Dictionary] = []
@export var prerequisite_flags: Array[String] = []
@export var next_quest_id: String = ""
