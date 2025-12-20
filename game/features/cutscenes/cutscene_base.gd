extends Control
class_name CutsceneBase

signal cutscene_finished

@onready var background: TextureRect = $Background
@onready var overlay: ColorRect = $Overlay
@onready var narration: RichTextLabel = $NarrationLabel
@onready var anim: AnimationPlayer = $AnimationPlayer

func play_cutscene(name: String) -> void:
	anim.play(name)
	await anim.animation_finished
	cutscene_finished.emit()

func fade_in(duration: float = 1.0) -> void:
	var tween = create_tween()
	overlay.modulate.a = 1.0
	tween.tween_property(overlay, "modulate:a", 0.0, duration)

func fade_out(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, duration)

func show_text(text: String, duration: float = 3.0) -> void:
	narration.text = text
	narration.visible = true
	await get_tree().create_timer(duration).timeout
	narration.visible = false
