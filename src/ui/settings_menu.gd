extends Control
## Settings Menu
## Volume controls, key remapping (Phase 3)
## See DEVELOPMENT_ROADMAP.md Phase 3

# ============================================
# NODE REFERENCES
# ============================================
@onready var master_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/MasterVolume/Slider
@onready var music_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/MusicVolume/Slider
@onready var sfx_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/SFXVolume/Slider
@onready var back_button: Button = $Panel/MarginContainer/VBoxContainer/BackButton

# ============================================
# LIFECYCLE
# ============================================

func _ready() -> void:
	# TODO (Phase 3): Initialize settings
	# - Load saved settings from SaveController
	# - Set slider values
	# - Connect signals
	back_button.pressed.connect(_on_back_pressed)
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)

# ============================================
# VOLUME CONTROLS
# ============================================

func _on_master_volume_changed(value: float) -> void:
	# TODO (Phase 3): Update master volume
	# AudioController.set_master_volume(value)
	pass

func _on_music_volume_changed(value: float) -> void:
	# TODO (Phase 3): Update music volume
	# AudioController.set_music_volume(value)
	pass

func _on_sfx_volume_changed(value: float) -> void:
	# TODO (Phase 3): Update SFX volume
	# AudioController.set_sfx_volume(value)
	pass

# ============================================
# NAVIGATION
# ============================================

func _on_back_pressed() -> void:
	# TODO (Phase 3): Return to previous menu
	# SceneManager.change_scene(Constants.SCENE_MAIN_MENU)
	queue_free()
