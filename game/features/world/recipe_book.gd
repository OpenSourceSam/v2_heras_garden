extends StaticBody2D

signal interacted

@export var recipes_unlocked: Array = []

func _ready():
	pass

func interact():
	# Show available recipes when player interacts with book
	print("[RecipeBook] Player interacted - showing recipes")
	emit_signal("interacted")
