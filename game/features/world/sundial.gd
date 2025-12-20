extends StaticBody2D

func interact() -> void:
	GameState.advance_day()
	print("Time advanced!")
