extends StaticBody2D

signal interacted

@export var crafting_menu_path: String = "res://game/features/ui/crafting_minigame.tscn"

func _ready():
	pass

func interact():
	# Open crafting menu when player interacts with mortar
	print("[MortarPestle] Player interacted - opening crafting menu")
	# The actual menu opening would be handled by the interaction system
	emit_signal("interacted")
