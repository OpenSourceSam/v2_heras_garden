extends Resource
class_name RecipeData

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

# Array of dictionaries, e.g. [{"item_id": "moly", "quantity": 2}]
# This is more editor-friendly than a raw Dictionary
@export var ingredients: Array[Dictionary] = []

@export var grinding_pattern: Array[String] = [] # ["ui_up", "ui_right", ...]
@export var button_sequence: Array[String] = [] # ["ui_accept", "ui_cancel", ...]
@export var timing_window: float = 1.5
@export var result_item_id: String = ""
@export var result_quantity: int = 1
