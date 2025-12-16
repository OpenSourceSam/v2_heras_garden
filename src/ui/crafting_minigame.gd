extends Control
## Crafting Minigame - Mortar & Pestle pattern matching
## See DEVELOPMENT_ROADMAP.md Task 1.4.1

# ============================================
# SIGNALS
# ============================================

signal crafting_complete(success: bool)

# ============================================
# NODE REFERENCES
# ============================================

@onready var pattern_display: Label = $PatternDisplay
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var result_display: Label = $ResultDisplay

# ============================================
# STATE
# ============================================

var pattern: Array[String] = [] # ["ui_up", "ui_right", "ui_down", "ui_left"]
var button_sequence: Array[String] = [] # ["ui_accept", "ui_accept"]
var current_pattern_index: int = 0
var current_button_index: int = 0
var timing_window: float = 1.5 # seconds
var last_input_time: float = 0.0
var is_grinding_phase: bool = true

# ============================================
# PUBLIC METHODS
# ============================================

func start_crafting(grinding_pattern: Array[String], buttons: Array[String], timing: float = 1.5) -> void:
	pattern = grinding_pattern
	button_sequence = buttons
	timing_window = timing
	current_pattern_index = 0
	current_button_index = 0
	is_grinding_phase = true
	last_input_time = Time.get_ticks_msec() / 1000.0
	
	visible = true
	result_display.text = ""
	_update_display()
	print("[CraftingMinigame] Started - Pattern: %d inputs, Buttons: %d, Timing: %.1fs" % [pattern.size(), button_sequence.size(), timing])

# ============================================
# INPUT HANDLING
# ============================================

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0
	
	# Check timing window
	if current_time - last_input_time > timing_window:
		_fail_crafting()
		return
	
	if is_grinding_phase:
		_handle_grinding_input(event)
	else:
		_handle_button_input(event)

func _handle_grinding_input(event: InputEvent) -> void:
	var expected = pattern[current_pattern_index]
	
	if event.is_action_pressed(expected):
		# Correct input
		current_pattern_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)
		
		if current_pattern_index >= pattern.size():
			# Grinding complete, move to button sequence
			is_grinding_phase = false
			current_button_index = 0
			last_input_time = Time.get_ticks_msec() / 1000.0
			_update_display()
	
	# Check for wrong input
	for action in ["ui_up", "ui_right", "ui_down", "ui_left"]:
		if action != expected and event.is_action_pressed(action):
			_play_feedback(false)
			# Don't fail immediately, just give negative feedback

func _handle_button_input(event: InputEvent) -> void:
	var expected = button_sequence[current_button_index]
	
	if event.is_action_pressed(expected):
		# Correct input
		current_button_index += 1
		last_input_time = Time.get_ticks_msec() / 1000.0
		_update_display()
		_play_feedback(true)
		
		if current_button_index >= button_sequence.size():
			# All inputs correct - success!
			_complete_crafting(true)
	
	# Check for wrong input
	for action in ["ui_accept", "ui_cancel", "ui_select"]:
		if action != expected and event.is_action_pressed(action):
			_fail_crafting()

# ============================================
# COMPLETION
# ============================================

func _complete_crafting(success: bool) -> void:
	if success:
		result_display.text = "SUCCESS!"
		result_display.modulate = Color.GREEN
		print("[CraftingMinigame] SUCCESS")
	else:
		result_display.text = "FAILED"
		result_display.modulate = Color.RED
		print("[CraftingMinigame] FAILED")
	
	await get_tree().create_timer(1.0).timeout
	crafting_complete.emit(success)
	visible = false

func _fail_crafting() -> void:
	_complete_crafting(false)

# ============================================
# UI UPDATES
# ============================================

func _update_display() -> void:
	if is_grinding_phase:
		pattern_display.text = "Grind: %d/%d\nPress: %s" % [current_pattern_index, pattern.size(), _format_action(pattern[current_pattern_index] if current_pattern_index < pattern.size() else "")]
		progress_bar.value = float(current_pattern_index) / float(pattern.size()) * 100.0
	else:
		pattern_display.text = "Finish: %d/%d\nPress: %s" % [current_button_index, button_sequence.size(), _format_action(button_sequence[current_button_index] if current_button_index < button_sequence.size() else "")]
		progress_bar.value = 100.0 + (float(current_button_index) / float(button_sequence.size())) * 100.0

func _format_action(action: String) -> String:
	match action:
		"ui_up": return "↑"
		"ui_down": return "↓"
		"ui_left": return "←"
		"ui_right": return "→"
		"ui_accept": return "ENTER"
		"ui_cancel": return "ESC"
		"ui_select": return "SPACE"
		_: return action

func _play_feedback(correct: bool) -> void:
	# TODO: Play sound, show visual effect
	if correct:
		print("[CraftingMinigame] ✓ Correct input")
	else:
		print("[CraftingMinigame] ✗ Wrong input")
