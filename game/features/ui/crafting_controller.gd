extends Control
## Crafting controller that loads recipes and runs the crafting minigame.

@export var recipe_paths: Array[String] = [
	"res://game/shared/resources/recipes/moly_grind.tres",
	"res://game/shared/resources/recipes/calming_draught.tres",
	"res://game/shared/resources/recipes/binding_ward.tres",
	"res://game/shared/resources/recipes/reversal_elixir.tres",
	"res://game/shared/resources/recipes/petrification_potion.tres"
]

@onready var crafting_minigame: Control = $CraftingMinigame

var _recipes: Dictionary = {} # { "recipe_id": RecipeData }
var current_recipe: RecipeData = null

func _ready() -> void:
	assert(crafting_minigame != null, "CraftingMinigame node missing")
	_load_recipes()
	if crafting_minigame:
		crafting_minigame.visible = false
		crafting_minigame.crafting_complete.connect(_on_crafting_complete)

func start_craft(recipe_id: String) -> void:
	if not crafting_minigame:
		push_error("CraftingMinigame node missing.")
		return

	var recipe = _get_recipe(recipe_id)
	if not recipe:
		push_error("Recipe not found: %s" % recipe_id)
		return

	if recipe.grinding_pattern.is_empty() or recipe.button_sequence.is_empty():
		push_error("Recipe inputs missing for: %s" % recipe_id)
		return

	current_recipe = recipe

	# Check ingredients
	if not _has_ingredients(recipe):
		print("Missing ingredients!")
		return

	# Start minigame
	crafting_minigame.start_crafting(
		recipe.grinding_pattern,
		recipe.button_sequence,
		recipe.timing_window
	)
	crafting_minigame.visible = true

func _on_crafting_complete(success: bool) -> void:
	if not current_recipe:
		return

	if success:
		# Remove ingredients
		_consume_ingredients(current_recipe)
		# Add result
		GameState.add_item(current_recipe.result_item_id, current_recipe.result_quantity)
		print("Crafted: %s" % current_recipe.display_name)

		# Mark quest complete based on recipe
		_update_quest_flags(current_recipe.id)
	else:
		print("Crafting failed!")

func _update_quest_flags(recipe_id: String) -> void:
	match recipe_id:
		"moly_grind":
			GameState.set_flag("quest_2_complete", true)
		"calming_draught":
			GameState.set_flag("quest_5_complete", true)
		"reversal_elixir":
			GameState.set_flag("quest_6_complete", true)
		"binding_ward":
			GameState.set_flag("quest_7_complete", true)
		"petrification_potion":
			GameState.set_flag("quest_11_complete", true)

func _load_recipes() -> void:
	_recipes.clear()
	for path in recipe_paths:
		var recipe = load(path) as RecipeData
		if recipe:
			_recipes[recipe.id] = recipe
		else:
			push_error("Failed to load recipe: %s" % path)

func _get_recipe(recipe_id: String) -> RecipeData:
	return _recipes.get(recipe_id, null)

func _has_ingredients(recipe: RecipeData) -> bool:
	for ingredient in recipe.ingredients:
		var item_id = ingredient.get("item_id", "")
		var quantity = ingredient.get("quantity", 0)
		if item_id == "" or quantity <= 0:
			return false
		if not GameState.has_item(item_id, quantity):
			return false
	return true

func _consume_ingredients(recipe: RecipeData) -> void:
	for ingredient in recipe.ingredients:
		var item_id = ingredient.get("item_id", "")
		var quantity = ingredient.get("quantity", 0)
		if item_id == "" or quantity <= 0:
			continue
		GameState.remove_item(item_id, quantity)
