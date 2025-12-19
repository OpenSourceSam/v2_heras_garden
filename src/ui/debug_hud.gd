extends CanvasLayer
## Debug HUD - Shows game state for testing
## Press F3 to toggle, F4 to advance day
## Automatically updates every frame

# ============================================
# NODE REFERENCES
# ============================================
@onready var panel: Panel = $Panel
@onready var day_label: Label = $Panel/MarginContainer/VBoxContainer/DayLabel
@onready var gold_label: Label = $Panel/MarginContainer/VBoxContainer/GoldLabel
@onready var inventory_label: Label = $Panel/MarginContainer/VBoxContainer/InventoryLabel
@onready var flags_label: Label = $Panel/MarginContainer/VBoxContainer/FlagsLabel
@onready var position_label: Label = $Panel/MarginContainer/VBoxContainer/PositionLabel
@onready var fps_label: Label = $Panel/MarginContainer/VBoxContainer/FPSLabel

# ============================================
# STATE
# ============================================
var is_visible: bool = true
var player: CharacterBody2D = null

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# Try to find player node
	_find_player()

	# Connect to GameState signals for live updates
	if GameState:
		GameState.day_advanced.connect(_on_day_advanced)
		GameState.gold_changed.connect(_on_gold_changed)
		GameState.inventory_changed.connect(_on_inventory_changed)
		GameState.flag_changed.connect(_on_flag_changed)

	print("[DebugHUD] Ready - Press F3 to toggle, F4 to advance day")

func _process(_delta: float) -> void:
	if not is_visible:
		return

	_update_labels()

# ============================================
# INPUT
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # F3 or ESC
		toggle_visibility()

	# F4 to advance day (for testing)
	if event is InputEventKey and event.pressed and event.keycode == KEY_F4:
		if GameState:
			GameState.advance_day()
			print("[DebugHUD] Advanced day to %d" % GameState.current_day)

# ============================================
# UPDATES
# ============================================

func _update_labels() -> void:
	# Update GameState info
	if GameState:
		day_label.text = "Day: %d | Season: %s" % [GameState.current_day, GameState.current_season]
		gold_label.text = "Gold: %d" % GameState.gold

		# Inventory (show first 3 items)
		if GameState.inventory.is_empty():
			inventory_label.text = "Inventory: (empty)"
		else:
			var items_text = ""
			var count = 0
			for item_id in GameState.inventory:
				if count >= 3:
					items_text += "..."
					break
				var qty = GameState.inventory[item_id]
				items_text += "%s:%d " % [item_id, qty]
				count += 1
			inventory_label.text = "Inventory: " + items_text

		# Quest flags (show first 3)
		if GameState.quest_flags.is_empty():
			flags_label.text = "Flags: (none)"
		else:
			var flags_text = ""
			var count = 0
			for flag in GameState.quest_flags:
				if count >= 3:
					flags_text += "..."
					break
				flags_text += flag + " "
				count += 1
			flags_label.text = "Flags: " + flags_text

	# Update player position
	if player:
		position_label.text = "Player Pos: (%d, %d)" % [int(player.position.x), int(player.position.y)]
	else:
		_find_player()
		position_label.text = "Player Pos: (not found)"

	# Update FPS
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

# ============================================
# SIGNAL HANDLERS
# ============================================

func _on_day_advanced(new_day: int) -> void:
	day_label.text = "Day: %d | Season: %s" % [new_day, GameState.current_season]

func _on_gold_changed(new_amount: int) -> void:
	gold_label.text = "Gold: %d" % new_amount

func _on_inventory_changed(_item_id: String, _new_quantity: int) -> void:
	# Will be updated in _process
	pass

func _on_flag_changed(_flag: String, _value: bool) -> void:
	# Will be updated in _process
	pass

# ============================================
# UTILITY
# ============================================

func toggle_visibility() -> void:
	is_visible = !is_visible
	panel.visible = is_visible
	print("[DebugHUD] Visibility: %s" % is_visible)

func _find_player() -> void:
	# Try to find player node in scene tree
	var root = get_tree().root
	player = _find_player_node(root)

func _find_player_node(node: Node) -> Node:
	if node is CharacterBody2D and node.name == "Player":
		return node
	for child in node.get_children():
		var result = _find_player_node(child)
		if result:
			return result
	return null
