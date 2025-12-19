extends Resource
class_name CropData
## Defines a crop type - see docs/design/SCHEMA.md for property documentation
##
## CRITICAL: Use exact property names defined in docs/design/SCHEMA.md
## - growth_stages (NOT "sprites", "textures", "stages_textures")
## - days_to_mature (NOT "growth_time", "days")

@export var id: String = ""                        ## Unique identifier (snake_case: "wheat", "tomato")
@export var display_name: String = ""              ## Human-readable name ("Wheat", "Tomato")
@export var growth_stages: Array[Texture2D] = []   ## Textures for each growth stage
@export var days_to_mature: int = 3                ## Days until harvestable
@export var harvest_item_id: String = ""           ## ItemData.id for harvest result
@export var seed_item_id: String = ""              ## ItemData.id for seed
@export var sell_price: int = 0                    ## Gold value when sold
@export var regrows: bool = false                  ## If true, doesn't need replanting
@export var seasons: Array[String] = []            ## ["spring", "summer"] - empty = all seasons
