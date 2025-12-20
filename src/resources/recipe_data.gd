extends Resource
class_name RecipeData
## Defines a crafting recipe - see docs/design/SCHEMA.md for property documentation
##
## CRITICAL: Use exact property names defined in docs/design/SCHEMA.md
## - ingredients (NOT "items", "inputs")
## - grinding_pattern (NOT "grind_pattern")
## - button_sequence (NOT "button_inputs")

@export var id: String = ""                         ## Unique identifier (snake_case: "moly_grind")
@export var display_name: String = ""               ## Human-readable name ("Ground Moly")
@export var description: String = ""                ## Flavor text
@export var ingredients: Array[Dictionary] = []     ## [{"item_id": "moly", "quantity": 2}]
@export var grinding_pattern: Array[String] = []    ## ["ui_up", "ui_right", ...]
@export var button_sequence: Array[String] = []     ## ["ui_accept", "ui_cancel", ...]
@export var timing_window: float = 1.5              ## Input timing window (seconds)
@export var result_item_id: String = ""             ## ItemData.id for crafting result
@export var result_quantity: int = 1                ## Amount produced
