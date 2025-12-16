extends Control
## HerbMinigame - Identify pharmaka flowers among regular flowers
## See Storyline.md Quest 1: "Learn to Identify Pharmaka"

# ============================================
# SIGNALS
# ============================================

signal minigame_complete(success: bool, pharmaka_collected: int)
signal round_complete(round_number: int)

# ============================================
# CONSTANTS
# ============================================

const PLANT_COLORS = [
	Color(0.2, 0.7, 0.2), # Green
	Color(0.7, 0.2, 0.7), # Purple
	Color(0.7, 0.2, 0.2), # Red
	Color(0.2, 0.2, 0.7), # Blue
	Color(0.7, 0.7, 0.2), # Yellow
]

const PHARMAKA_COLOR = Color(0.9, 0.8, 0.3) # Golden glow

# ============================================
# NODE REFERENCES
# ============================================

@onready var plant_container: Control = $PlantContainer
@onready var instruction_label: Label = $InstructionLabel
@onready var progress_label: Label = $ProgressLabel

# ============================================
# STATE
# ============================================

var current_round: int = 0
var total_rounds: int = 3
var attempts_remaining: int = 3
var pharmaka_collected: int = 0
var plants: Array[Control] = []
var pharmaka_index: int = -1

# Round configuration: [plant_count, identification_type]
# Types: "glow", "petals", "movement"
var round_configs = [
	{"count": 20, "type": "glow"},
	{"count": 25, "type": "petals"},
	{"count": 30, "type": "movement"}
]

# ============================================
# PUBLIC METHODS
# ============================================

func start_minigame() -> void:
	visible = true
	current_round = 0
	pharmaka_collected = 0
	_start_round()

# ============================================
# ROUND MANAGEMENT
# ============================================

func _start_round() -> void:
	attempts_remaining = 3
	_clear_plants()
	
	var config = round_configs[current_round]
	_generate_plants(config["count"], config["type"])
	
	instruction_label.text = _get_instruction_text(config["type"])
	_update_progress()
	
	print("[HerbMinigame] Round %d started: %d plants, type: %s" % [current_round + 1, config["count"], config["type"]])

func _get_instruction_text(identification_type: String) -> String:
	match identification_type:
		"glow":
			return "Find the pharmaka flower. It glows with golden light."
		"petals":
			return "Find the pharmaka. It has 6 petals, not 5."
		"movement":
			return "Find the pharmaka. It sways gently while others are still."
		_:
			return "Find the pharmaka flower."

func _generate_plants(count: int, identification_type: String) -> void:
	# Determine pharmaka position
	pharmaka_index = randi() % count
	
	# Create plant grid
	var cols = 5
	var spacing = 60
	var start_x = 100
	var start_y = 150
	
	for i in range(count):
		var plant = _create_plant(i == pharmaka_index, identification_type)
		var col = i % cols
		var row = i / cols
		plant.position = Vector2(start_x + col * spacing, start_y + row * spacing)
		plant_container.add_child(plant)
		plants.append(plant)
		
		# Add click handler
		plant.gui_input.connect(_on_plant_clicked.bind(i))

func _create_plant(is_pharmaka: bool, identification_type: String) -> Control:
	var plant = ColorRect.new()
	plant.custom_minimum_size = Vector2(40, 40)
	plant.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if is_pharmaka:
		plant.color = PHARMAKA_COLOR
		plant.set_meta("is_pharmaka", true)
		
		# Apply identification difference
		match identification_type:
			"glow":
				# Add subtle pulsing animation
				var tween = create_tween().set_loops()
				tween.tween_property(plant, "modulate:a", 0.7, 0.5)
				tween.tween_property(plant, "modulate:a", 1.0, 0.5)
			"petals":
				# Different size to indicate petal count
				plant.custom_minimum_size = Vector2(45, 45)
			"movement":
				# Gentle swaying
				var tween = create_tween().set_loops()
				tween.tween_property(plant, "position:x", plant.position.x + 3, 1.0)
				tween.tween_property(plant, "position:x", plant.position.x - 3, 1.0)
	else:
		plant.color = PLANT_COLORS[randi() % PLANT_COLORS.size()]
		plant.set_meta("is_pharmaka", false)
	
	return plant

func _clear_plants() -> void:
	for plant in plants:
		plant.queue_free()
	plants.clear()

# ============================================
# INPUT
# ============================================

func _on_plant_clicked(event: InputEvent, plant_index: int) -> void:
	if not event is InputEventMouseButton:
		return
	if not event.pressed or event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	var plant = plants[plant_index]
	var is_pharmaka = plant.get_meta("is_pharmaka", false)
	
	if is_pharmaka:
		_correct_selection(plant)
	else:
		_wrong_selection(plant)

func _correct_selection(plant: Control) -> void:
	print("[HerbMinigame] Correct! Pharmaka found!")
	plant.modulate = Color.WHITE
	pharmaka_collected += 1
	
	# Show feedback
	instruction_label.text = "Correct! The pharmaka glows with power."
	
	# Brief pause then advance
	await get_tree().create_timer(1.0).timeout
	
	round_complete.emit(current_round)
	current_round += 1
	
	if current_round >= total_rounds:
		_complete_minigame(true)
	else:
		_start_round()

func _wrong_selection(plant: Control) -> void:
	attempts_remaining -= 1
	plant.modulate = Color(0.5, 0.5, 0.5, 0.5) # Dim wrong selection
	
	print("[HerbMinigame] Wrong! Attempts remaining: %d" % attempts_remaining)
	instruction_label.text = "That's just a regular flower. %d attempts left." % attempts_remaining
	
	if attempts_remaining <= 0:
		_complete_minigame(false)

func _update_progress() -> void:
	progress_label.text = "Round %d/%d | Attempts: %d | Collected: %d" % [current_round + 1, total_rounds, attempts_remaining, pharmaka_collected]

# ============================================
# COMPLETION
# ============================================

func _complete_minigame(success: bool) -> void:
	_clear_plants()
	
	if success:
		instruction_label.text = "Excellent! You've collected %d pharmaka flowers." % pharmaka_collected
		# Add items to inventory
		GameState.add_item("pharmaka_flower", pharmaka_collected)
	else:
		instruction_label.text = "You failed to identify the pharmaka. Try again later."
	
	await get_tree().create_timer(2.0).timeout
	
	visible = false
	minigame_complete.emit(success, pharmaka_collected)
	print("[HerbMinigame] Complete: success=%s, collected=%d" % [success, pharmaka_collected])
