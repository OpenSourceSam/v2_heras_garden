extends Resource
class_name RecipeData
## Recipe for crafting system - see SCHEMA.md

## Ingredient Dictionary Structure:
## {
##     "item_id": "nightshade",
##     "quantity": 3
## }

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var ingredients: Array[Dictionary] = []
@export var result_item_id: String = ""
@export var crafting_time: float = 5.0
@export var difficulty: String = "medium"  # easy, medium, hard
@export var required_tool: String = ""  # mortar_pestle, loom, etc.
