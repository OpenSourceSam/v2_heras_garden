extends Resource
class_name QuestData

@export var id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""
@export var next_quest_id: String = ""

# Hooks to run when quest starts/ends (e.g. "unlock_area_beach", "give_item_pharmaka")
@export var start_hooks: Array[String] = []
@export var end_hooks: Array[String] = []

# Requirements to start this quest (optional extra check beyond linear progression)
@export var prerequisites: Array[String] = []
