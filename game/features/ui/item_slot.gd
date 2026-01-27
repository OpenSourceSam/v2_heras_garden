extends Control

var item_id: String = ""
var quantity: int = 0

@onready var icon: TextureRect = $Icon
@onready var qty_label: Label = $QuantityLabel
@onready var highlight: ColorRect = $Highlight

func _ready() -> void:
	assert(icon != null, "Icon missing")
	assert(qty_label != null, "QuantityLabel missing")
	assert(highlight != null, "Highlight missing")

func set_item(id: String, qty: int) -> void:
	var is_new_item = item_id != id and id != ""
	var qty_changed = quantity != qty and item_id == id

	item_id = id
	quantity = qty

	var item_data = _load_item_data(id)
	if item_data:
		icon.texture = item_data.icon
		icon.visible = true
		qty_label.text = str(qty) if qty > 1 else ""
		qty_label.visible = qty > 1

		# Play animations based on what changed
		if is_new_item:
			_play_item_added_animation()
		elif qty_changed:
			_play_quantity_changed_animation()
	else:
		clear()

func clear() -> void:
	item_id = ""
	quantity = 0
	icon.texture = null
	icon.visible = false
	qty_label.visible = false

func set_selected(selected: bool) -> void:
	highlight.visible = selected
	if selected:
		_play_selected_animation()

func has_item() -> bool:
	return item_id != ""

func _load_item_data(id: String) -> ItemData:
	var path = "res://game/shared/resources/items/%s.tres" % id
	if ResourceLoader.exists(path):
		return load(path)
	return null

# ============================================
# ANIMATIONS
# ============================================

func _play_item_added_animation() -> void:
	# Bounce animation for new item
	var tween = create_tween()
	tween.set_parallel(true)

	# Start small
	icon.scale = Vector2.ZERO

	# Bounce in
	tween.tween_property(icon, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK)
	tween.tween_property(icon, "scale", Vector2.ONE, 0.1).set_delay(0.15)

	# Flash highlight briefly
	highlight.modulate.a = 0.5
	tween.tween_property(highlight, "modulate:a", 0.0, 0.3).set_delay(0.1)

func _play_selected_animation() -> void:
	# Pulse animation for selection
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)

	# Scale up slightly
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func _play_quantity_changed_animation() -> void:
	# Pulse the quantity label
	var tween = create_tween()

	# Scale up the label
	var original_scale = qty_label.scale
	tween.tween_property(qty_label, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(qty_label, "scale", original_scale, 0.1)
