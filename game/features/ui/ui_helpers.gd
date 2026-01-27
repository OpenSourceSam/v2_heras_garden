class_name UIHelpers
extends Node

# ============================================
# PANEL TRANSITIONS
# ============================================

static func _get_base_y(panel: Control) -> float:
	if not panel.has_meta("ui_helpers_base_y"):
		panel.set_meta("ui_helpers_base_y", panel.position.y)
	return float(panel.get_meta("ui_helpers_base_y"))

static func open_panel(panel: Control) -> void:
	var base_y = _get_base_y(panel)
	panel.visible = true
	panel.modulate.a = 0.0
	var start_y = base_y + 50
	panel.position.y = start_y

	var tween = panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)
	tween.tween_property(panel, "position:y", base_y, 0.2).set_ease(Tween.EASE_OUT)

	if AudioController and AudioController.has_method("has_sfx") and AudioController.has_sfx("ui_open"):
		AudioController.play_sfx("ui_open")

static func close_panel(panel: Control) -> void:
	var base_y = _get_base_y(panel)
	var tween = panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 0.0, 0.15)
	tween.tween_property(panel, "position:y", base_y + 30, 0.15)
	tween.chain().tween_callback(func(): panel.visible = false)

	if AudioController and AudioController.has_method("has_sfx") and AudioController.has_sfx("ui_close"):
		AudioController.play_sfx("ui_close")

# ============================================
# BUTTON ANIMATIONS
# ============================================

## Setup button focus animations (keyboard/controller navigation)
static func setup_button_focus(button: Button) -> void:
	if not button or not is_instance_valid(button):
		return

	button.focus_entered.connect(func():
		var tween = button.create_tween()
		tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)
		if AudioController and AudioController.has_method("has_sfx") and AudioController.has_sfx("ui_move"):
			AudioController.play_sfx("ui_move")
	)
	button.focus_exited.connect(func():
		var tween = button.create_tween()
		tween.tween_property(button, "scale", Vector2.ONE, 0.1)
	)

## Setup button press animation (scale down + bounce back)
static func setup_button_press(button: Button) -> void:
	if not button or not is_instance_valid(button):
		return

	button.pressed.connect(func():
		_button_press_animation(button)
		if AudioController and AudioController.has_method("has_sfx") and AudioController.has_sfx("ui_confirm"):
			AudioController.play_sfx("ui_confirm")
	)

## Setup button hover animation (for mouse users)
static func setup_button_hover(button: Control) -> void:
	if not button or not is_instance_valid(button):
		return

	button.mouse_entered.connect(func():
		_button_hover_animation(button, true)
	)

	button.mouse_exited.connect(func():
		_button_hover_animation(button, false)
	)

## Complete button setup (focus + press + hover)
static func setup_button(button: Button) -> void:
	setup_button_focus(button)
	setup_button_press(button)
	setup_button_hover(button)

## Button press animation (scale down + bounce back)
static func _button_press_animation(button: Control) -> void:
	if not button or not is_instance_valid(button):
		return

	# Also use VisualFeedbackController if available
	var feedback = Engine.get_main_loop().root.get_node_or_null("VisualFeedbackController")
	if feedback and feedback.has_method("button_press_animation"):
		feedback.button_press_animation(button)
	else:
		# Fallback animation
		var tween = button.create_tween()
		tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.05)
		tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

## Button hover animation (scale up slightly)
static func _button_hover_animation(button: Control, is_hovering: bool) -> void:
	if not button or not is_instance_valid(button):
		return

	var feedback = Engine.get_main_loop().root.get_node_or_null("VisualFeedbackController")
	if feedback and feedback.has_method("button_hover_animation"):
		feedback.button_hover_animation(button, is_hovering)
	else:
		# Fallback animation
		var target_scale = Vector2(1.05, 1.05) if is_hovering else Vector2(1.0, 1.0)
		var tween = button.create_tween()
		tween.tween_property(button, "scale", target_scale, 0.1)

# ============================================
# SUCCESS/FAILURE FEEDBACK
# ============================================

## Show success indicator at position
static func show_success(position: Vector2) -> void:
	var feedback = Engine.get_main_loop().root.get_node_or_null("VisualFeedbackController")
	if feedback and feedback.has_method("show_indicator"):
		feedback.show_indicator(position, true)
		if AudioController and AudioController.has_method("play_sfx"):
			AudioController.play_sfx("correct_ding")

## Show failure indicator at position
static func show_failure(position: Vector2) -> void:
	var feedback = Engine.get_main_loop().root.get_node_or_null("VisualFeedbackController")
	if feedback and feedback.has_method("show_indicator"):
		feedback.show_indicator(position, false)
		if AudioController and AudioController.has_method("play_sfx"):
			AudioController.play_sfx("wrong_buzz")

## Show indicator with custom success state
static func show_indicator(position: Vector2, is_success: bool) -> void:
	var feedback = Engine.get_main_loop().root.get_node_or_null("VisualFeedbackController")
	if feedback and feedback.has_method("show_indicator"):
		feedback.show_indicator(position, is_success)
		if AudioController and AudioController.has_method("play_sfx"):
			var sfx = "correct_ding" if is_success else "wrong_buzz"
			AudioController.play_sfx(sfx)

# ============================================
# ITEM PICKUP EFFECTS
# ============================================

## Show item pickup effect at position
static func show_item_pickup(position: Vector2, item_texture: Texture2D = null) -> void:
	var feedback = Engine.get_main_loop().root.get_node_or_null("VisualFeedbackController")
	if feedback and feedback.has_method("item_pickup_effect"):
		feedback.item_pickup_effect(position, item_texture)
	if AudioController and AudioController.has_method("play_sfx"):
		AudioController.play_sfx("ui_confirm")

# ============================================
# UTILITY FUNCTIONS
# ============================================

## Fade in a control
static func fade_in(control: Control, duration: float = 0.3) -> void:
	if not control or not is_instance_valid(control):
		return
	control.visible = true
	control.modulate.a = 0.0
	var tween = control.create_tween()
	tween.tween_property(control, "modulate:a", 1.0, duration)

## Fade out a control
static func fade_out(control: Control, duration: float = 0.3) -> void:
	if not control or not is_instance_valid(control):
		return
	var tween = control.create_tween()
	tween.tween_property(control, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): control.visible = false)

## Pulse animation (scale up and down)
static func pulse(control: Control, scale: float = 1.1, duration: float = 0.3) -> void:
	if not control or not is_instance_valid(control):
		return
	var tween = control.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(control, "scale", Vector2(scale, scale), duration * 0.5)
	tween.tween_property(control, "scale", Vector2.ONE, duration * 0.5)

## Shake animation
static func shake(control: Control, intensity: float = 5.0, duration: float = 0.3) -> void:
	if not control or not is_instance_valid(control):
		return

	var feedback = Engine.get_main_loop().root.get_node_or_null("VisualFeedbackController")
	if feedback and feedback.has_method("screen_shake"):
		feedback.screen_shake(control, intensity, duration)
	else:
		# Fallback shake
		var tween = control.create_tween()
		var original_pos = control.position
		tween.tween_property(control, "position:x", original_pos.x + intensity, 0.05)
		tween.tween_property(control, "position:x", original_pos.x - intensity, 0.05)
		tween.tween_property(control, "position:x", original_pos.x, 0.05)
