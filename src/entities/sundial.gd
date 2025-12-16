extends StaticBody2D
## Sundial - Advances game day when interacted with
## See DEVELOPMENT_ROADMAP.md Task 1.3.3

func _ready() -> void:
	add_to_group("interactables")
	print("[Sundial] Ready")

func interact() -> void:
	print("[Sundial] Advancing day...")
	GameState.advance_day()
	# TODO: Show visual feedback (text, animation)
