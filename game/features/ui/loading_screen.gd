extends Control
## LoadingScreen - Simple loading screen with progress indicator

signal loading_complete

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var progress_label: Label = $VBoxContainer/ProgressLabel
@onready var loading_label: Label = $VBoxContainer/LoadingLabel

var current_progress: float = 0.0
var target_progress: float = 0.0

func _ready() -> void:
	assert(progress_bar != null, "ProgressBar missing")
	assert(progress_label != null, "ProgressLabel missing")
	assert(loading_label != null, "LoadingLabel missing")

func set_progress(value: float) -> void:
	target_progress = clamp(value, 0.0, 100.0)
	_update_display()

func set_loading_text(text: String) -> void:
	if loading_label:
		loading_label.text = text

func _update_display() -> void:
	if progress_bar:
		progress_bar.value = target_progress
	if progress_label:
		progress_label.text = "%d%%" % int(target_progress)

func show_screen() -> void:
	visible = true

func hide_screen() -> void:
	visible = false
	loading_complete.emit()
