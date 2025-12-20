extends SceneTree

const WORLD_SCENE_PATH := "res://game/features/world/world.tscn"
const TILE_TEXTURE_PATH := "res://assets/sprites/tiles/placeholder_grass.png"
const TILESET_PATH := "res://game/shared/resources/tiles/placeholder_grass_tileset.tres"
const TILE_SIZE := Vector2i(32, 32)
const FILL_SIZE := Vector2i(20, 20)


func _initialize() -> void:
	_ensure_directories()
	if not FileAccess.file_exists(TILE_TEXTURE_PATH):
		push_error("Missing tile texture: %s" % TILE_TEXTURE_PATH)
		quit(1)
		return

	var tileset_data = _build_tileset()
	var tileset: TileSet = tileset_data["tileset"]
	var source_id: int = tileset_data["source_id"]
	if source_id < 0:
		quit(1)
		return

	var save_result := ResourceSaver.save(tileset, TILESET_PATH)
	if save_result != OK:
		push_error("Failed to save tileset: %s" % save_result)
		quit(1)
		return

	var world_scene := load(WORLD_SCENE_PATH) as PackedScene
	if world_scene == null:
		push_error("Failed to load world scene.")
		quit(1)
		return

	var world := world_scene.instantiate()
	var tilemap := world.get_node("Ground") as TileMapLayer
	if tilemap == null:
		push_error("Ground TileMapLayer not found in world scene.")
		quit(1)
		return

	tilemap.tile_set = load(TILESET_PATH)
	_fill_tiles(tilemap, source_id)

	var packed := PackedScene.new()
	if packed.pack(world) != OK:
		push_error("Failed to pack world scene.")
		quit(1)
		return

	if ResourceSaver.save(packed, WORLD_SCENE_PATH) != OK:
		push_error("Failed to save world scene.")
		quit(1)
		return

	print("World tiles setup complete.")
	quit()


func _ensure_directories() -> void:
	var tiles_dir := DirAccess.open("res://assets/sprites")
	if tiles_dir != null and not tiles_dir.dir_exists("tiles"):
		tiles_dir.make_dir("tiles")

	var resources_dir := DirAccess.open("res://game/shared/resources")
	if resources_dir != null and not resources_dir.dir_exists("tiles"):
		resources_dir.make_dir("tiles")


func _build_tileset() -> Dictionary:
	var tileset := TileSet.new()
	tileset.tile_size = TILE_SIZE

	var image := Image.new()
	var load_result := image.load(TILE_TEXTURE_PATH)
	if load_result != OK:
		push_error("Failed to load tile texture: %s" % load_result)
		return {"tileset": tileset, "source_id": -1}
	var texture := ImageTexture.create_from_image(image)
	var source := TileSetAtlasSource.new()
	source.texture = texture
	source.texture_region_size = TILE_SIZE
	source.create_tile(Vector2i.ZERO)

	var source_id := tileset.add_source(source)
	return {"tileset": tileset, "source_id": source_id}


func _fill_tiles(tilemap: TileMapLayer, source_id: int) -> void:
	for x in range(FILL_SIZE.x):
		for y in range(FILL_SIZE.y):
			tilemap.set_cell(Vector2i(x, y), source_id, Vector2i.ZERO, 0)
