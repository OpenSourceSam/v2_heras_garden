extends CanvasLayer
## Day/Season Indicator UI
## Shows current day, season, and time of day
## Auto-updates when GameState.day_advanced signal fires

# ============================================
# NODE REFERENCES
# ============================================
@onready var day_label: Label = $Panel/MarginContainer/VBoxContainer/DayLabel
@onready var season_label: Label = $Panel/MarginContainer/VBoxContainer/SeasonLabel
@onready var time_label: Label = $Panel/MarginContainer/VBoxContainer/TimeLabel

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	if GameState:
		GameState.day_advanced.connect(_on_day_advanced)
		_update_display()

# ============================================
# UPDATES
# ============================================

func _update_display() -> void:
	if not GameState:
		return

	day_label.text = "Day %d" % GameState.current_day
	season_label.text = GameState.current_season.capitalize()

	# TODO (Phase 3): Add time of day system
	# For now, just show static "Morning"
	time_label.text = "Morning"

func _on_day_advanced(new_day: int) -> void:
	_update_display()
