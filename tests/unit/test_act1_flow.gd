extends SceneTree

func _init() -> void:
	print("TEST: Act 1 Flow Verification")
	var passed = true
	
	# 1. Test QuestData Loading
	var quest_id = "act1_q1_pharmaka"
	var quest_path = "res://resources/quests/%s.tres" % quest_id
	if ResourceLoader.exists(quest_path):
		var quest = load(quest_path)
		if quest and quest.id == quest_id:
			print("  ✓ QuestData loaded: %s" % quest.title)
		else:
			print("  ✗ Failed to load QuestData: %s" % quest_id)
			passed = false
	else:
		print("  ✗ Quest file not found: %s" % quest_path)
		passed = false

	# 2. Test RecipeData Loading
	var recipe_id = "r_transformation_sap"
	var recipe_path = "res://resources/recipes/%s.tres" % recipe_id
	if ResourceLoader.exists(recipe_path):
		var recipe = load(recipe_path)
		if recipe and recipe.id == "r_transformation_sap" and recipe.ingredients.has("pharmaka_flower"):
			print("  ✓ RecipeData loaded: %s" % recipe.display_name)
		else:
			print("  ✗ Failed to verify RecipeData content")
			passed = false
	else:
		print("  ✗ Recipe file not found: %s" % recipe_path)
		passed = false

	# 3. Test Dialogue Loading
	var dialogue_id = "d_act1_hermes_intro"
	var dialogue_path = "res://resources/dialogues/%s.tres" % dialogue_id
	if ResourceLoader.exists(dialogue_path):
		print("  ✓ DialogueData file exists")
	else:
		print("  ✗ Dialogue file not found: %s" % dialogue_path)
		passed = false

	if passed:
		print("✅ ACT 1 RESOURCES VERIFIED")
		quit(0)
	else:
		print("❌ ACT 1 VERIFICATION FAILED")
		quit(1)
