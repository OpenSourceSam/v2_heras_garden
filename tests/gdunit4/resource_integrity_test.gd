extends GdUnitTestSuite

func _collect_tres_paths(root_path: String) -> Array[String]:
	var results: Array[String] = []
	var dir = DirAccess.open(root_path)
	if dir == null:
		return results

	dir.list_dir_begin()
	var name = dir.get_next()
	while name != "":
		if name != "." and name != "..":
			var full_path = root_path + "/" + name
			if dir.current_is_dir():
				results.append_array(_collect_tres_paths(full_path))
			elif name.ends_with(".tres"):
				if name.to_upper().begins_with("TEMPLATE_"):
					name = dir.get_next()
					continue
				results.append(full_path)
		name = dir.get_next()
	dir.list_dir_end()

	return results

func test_strict_checks_skip_templates() -> void:
	var paths = _collect_tres_paths("res://game/shared/resources")
	assert_that(paths.size()).is_greater(0)
	for path in paths:
		assert_that(path.get_file().to_upper().begins_with("TEMPLATE_")).is_false()

func test_template_resources_use_template_ids() -> void:
	var templates: Array[String] = []
	var pending: Array[String] = ["res://game/shared/resources"]

	while not pending.is_empty():
		var root_path = pending.pop_back()
		var dir = DirAccess.open(root_path)
		if dir == null:
			continue
		dir.list_dir_begin()
		var name = dir.get_next()
		while name != "":
			if name != "." and name != "..":
				var full_path = root_path + "/" + name
				if dir.current_is_dir():
					pending.append(full_path)
				elif name.ends_with(".tres") and name.to_upper().begins_with("TEMPLATE_"):
					templates.append(full_path)
			name = dir.get_next()
		dir.list_dir_end()

	assert_that(templates.size()).is_greater(0)
	for path in templates:
		var res = load(path)
		assert_that(res).is_not_null()
		if res is CropData or res is ItemData or res is DialogueData:
			assert_that(res.id.to_lower().begins_with("template_")).is_true()

func test_all_resources_load() -> void:
	var paths = _collect_tres_paths("res://game/shared/resources")
	assert_that(paths.size()).is_greater(0)
	for path in paths:
		assert_that(ResourceLoader.exists(path)).is_true()
		var res = load(path)
		assert_that(res).is_not_null()

func test_crop_data_fields() -> void:
	var crops = _collect_tres_paths("res://game/shared/resources/crops")
	assert_that(crops.size()).is_greater(0)
	for path in crops:
		var crop = load(path) as CropData
		assert_that(crop).is_not_null()
		assert_that(crop.id).is_not_empty()
		assert_that(crop.seed_item_id).is_not_empty()
		assert_that(crop.harvest_item_id).is_not_empty()
		assert_that(crop.growth_stages.size()).is_greater(0)
		for stage in crop.growth_stages:
			assert_that(stage).is_not_null()

func test_item_data_fields() -> void:
	var items = _collect_tres_paths("res://game/shared/resources/items")
	assert_that(items.size()).is_greater(0)
	for path in items:
		var item = load(path) as ItemData
		assert_that(item).is_not_null()
		assert_that(item.id).is_not_empty()
		assert_that(item.display_name).is_not_empty()
		assert_that(item.icon).is_not_null()

func test_recipe_data_fields() -> void:
	var recipes = _collect_tres_paths("res://game/shared/resources/recipes")
	assert_that(recipes.size()).is_greater(0)
	for path in recipes:
		var recipe = load(path) as RecipeData
		assert_that(recipe).is_not_null()
		assert_that(recipe.id).is_not_empty()
		assert_that(recipe.ingredients.size()).is_greater(0)
		assert_that(recipe.grinding_pattern.size()).is_greater(0)
		assert_that(recipe.button_sequence.size()).is_greater(0)
		assert_that(recipe.result_item_id).is_not_empty()
		assert_that(recipe.timing_window).is_greater(0)

func test_dialogue_data_fields() -> void:
	var dialogues = _collect_tres_paths("res://game/shared/resources/dialogues")
	assert_that(dialogues.size()).is_greater(0)
	for path in dialogues:
		var dialogue = load(path) as DialogueData
		assert_that(dialogue).is_not_null()
		assert_that(dialogue.id).is_not_empty()
		assert_that(dialogue.lines.size()).is_greater(0)

func test_npc_data_fields() -> void:
	var npcs = _collect_tres_paths("res://game/shared/resources/npcs")
	assert_that(npcs.size()).is_greater(0)
	for path in npcs:
		var npc = load(path) as NPCData
		assert_that(npc).is_not_null()
		assert_that(npc.id).is_not_empty()
		assert_that(npc.display_name).is_not_empty()
		assert_that(npc.default_dialogue_id).is_not_empty()

func test_dialogue_min_lines() -> void:
	var dialogues = _collect_tres_paths("res://game/shared/resources/dialogues")
	assert_that(dialogues.size()).is_greater(0)
	for path in dialogues:
		var dialogue = load(path) as DialogueData
		assert_that(dialogue).is_not_null()
		assert_that(dialogue.lines.size()).is_greater_or_equal(5)

func test_npc_dialogue_references_exist() -> void:
	var dialogue_ids: Dictionary = {}
	var dialogues = _collect_tres_paths("res://game/shared/resources/dialogues")
	for path in dialogues:
		var dialogue = load(path) as DialogueData
		if dialogue:
			dialogue_ids[dialogue.id] = true

	var npcs = _collect_tres_paths("res://game/shared/resources/npcs")
	assert_that(npcs.size()).is_greater(0)
	for path in npcs:
		var npc = load(path) as NPCData
		assert_that(npc).is_not_null()
		assert_that(dialogue_ids.has(npc.default_dialogue_id)).is_true()
