extends Resource
class_name ItemData
## Defines an item type - see docs/design/SCHEMA.md for property documentation
##
## CRITICAL: Use exact property names defined in docs/design/SCHEMA.md
## - id (NOT "item_id", "name")
## - display_name (NOT "name", "item_name")
## - category (NOT "type", "item_type")

@export var id: String = ""              ## Unique identifier (snake_case: "wheat_seed")
@export var display_name: String = ""    ## Human-readable name ("Wheat Seed")
@export var description: String = ""     ## Flavor text
@export var icon: Texture2D              ## Inventory icon (32x32 recommended)
@export var stack_size: int = 99         ## Max stack in inventory
@export var sell_price: int = 0          ## Gold value when sold
@export var category: String = "misc"    ## "seed", "crop", "tool", "gift", "misc"
