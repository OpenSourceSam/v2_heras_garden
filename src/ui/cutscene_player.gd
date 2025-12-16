extends Control
## CutscenePlayer - Plays story cutscenes with text, fades, and scene transitions
## See Storyline.md for cutscene content

# ============================================
# SIGNALS
# ============================================

signal cutscene_started(cutscene_id: String)
signal cutscene_ended(cutscene_id: String)
signal line_displayed(line_index: int)

# ============================================
# NODE REFERENCES
# ============================================

@onready var background: ColorRect = $Background
@onready var text_container: Control = $TextContainer
@onready var text_label: Label = $TextContainer/TextLabel
@onready var speaker_label: Label = $TextContainer/SpeakerLabel

# ============================================
# STATE
# ============================================

var current_cutscene_id: String = ""
var current_lines: Array = []
var current_line_index: int = 0
var is_playing: bool = false
var is_text_scrolling: bool = false
var text_scroll_speed: float = 40.0

# ============================================
# CUTSCENE DATA STRUCTURE
# ============================================
# Each line is a Dictionary:
# {
#   "speaker": "Circe",  # Empty for narrator/internal
#   "text": "Dialogue text here",
#   "duration": 0,  # Auto-advance after seconds (0 = wait for input)
#   "fade_in": false,
#   "fade_out": false
# }

# ============================================
# PUBLIC METHODS
# ============================================

func play_cutscene(cutscene_id: String, lines: Array) -> void:
	"""Start playing a cutscene with the given lines."""
	current_cutscene_id = cutscene_id
	current_lines = lines
	current_line_index = 0
	is_playing = true
	
	visible = true
	cutscene_started.emit(cutscene_id)
	print("[Cutscene] Started: %s with %d lines" % [cutscene_id, lines.size()])
	
	_show_current_line()

func play_transformation_scene() -> void:
	is_playing = true
	visible = true
	
	# Visual setup - dark purple background
	background.modulate = Color(0.2, 0, 0.4, 1)
	
	# Scene sequence
	speaker_label.text = ""
	text_label.text = "*The sap burns as it touches the water...*"
	await get_tree().create_timer(3.0).timeout
	
	text_label.text = "*Scylla screams as her form twists and breaks...*"
	await get_tree().create_timer(3.0).timeout
	
	speaker_label.text = "Scylla"
	text_label.text = "WHAT HAVE YOU DONE?!"
	await get_tree().create_timer(3.0).timeout
	
	# Cleanup
	background.modulate = Color.WHITE
	_end_cutscene()

func skip_cutscene() -> void:
	"""Skip to end of cutscene."""
	if is_playing:
		_end_cutscene()

# ============================================
# LINE DISPLAY
# ============================================

func _show_current_line() -> void:
	if current_line_index >= current_lines.size():
		_end_cutscene()
		return
	
	var line = current_lines[current_line_index]
	
	# Handle fade in
	if line.get("fade_in", false):
		await _fade_in()
	
	# Set speaker
	var speaker = line.get("speaker", "")
	if speaker.is_empty():
		speaker_label.visible = false
	else:
		speaker_label.visible = true
		speaker_label.text = speaker
	
	# Scroll text
	is_text_scrolling = true
	await _scroll_text(line.get("text", ""))
	is_text_scrolling = false
	
	line_displayed.emit(current_line_index)
	
	# Handle auto-advance
	var duration = line.get("duration", 0)
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		_advance_line()

func _scroll_text(full_text: String) -> void:
	text_label.text = full_text
	text_label.visible_ratio = 0.0
	
	var char_count = full_text.length()
	var duration = float(char_count) / text_scroll_speed
	
	var tween = create_tween()
	tween.tween_property(text_label, "visible_ratio", 1.0, duration)
	await tween.finished

func _advance_line() -> void:
	var line = current_lines[current_line_index]
	
	# Handle fade out before advancing
	if line.get("fade_out", false):
		await _fade_out()
	
	current_line_index += 1
	_show_current_line()

# ============================================
# INPUT
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	if not visible or not is_playing:
		return
	
	if event.is_action_pressed("ui_accept"):
		if is_text_scrolling:
			# Skip text scroll
			text_label.visible_ratio = 1.0
			is_text_scrolling = false
		else:
			# Advance to next line
			_advance_line()

# ============================================
# FADE EFFECTS
# ============================================

func _fade_in() -> void:
	background.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(background, "modulate:a", 0.0, 0.5)
	await tween.finished

func _fade_out() -> void:
	var tween = create_tween()
	tween.tween_property(background, "modulate:a", 1.0, 0.5)
	await tween.finished

# ============================================
# COMPLETION
# ============================================

func _end_cutscene() -> void:
	is_playing = false
	visible = false
	cutscene_ended.emit(current_cutscene_id)
	print("[Cutscene] Ended: %s" % current_cutscene_id)
	current_cutscene_id = ""
	current_lines = []
