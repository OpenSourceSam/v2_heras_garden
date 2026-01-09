extends Control

signal minigame_complete(success: bool, items: Array)

@export var plants_per_round: Array[int] = [20, 25, 30]
@export var correct_per_round: Array[int] = [3, 3, 3]
@export var max_wrong: int = 5

const GLOW_LOOP_COUNT: int = 999999

@onready var plant_grid: GridContainer = $PlantGrid
@onready var instruction_label: Label = $InstructionLabel
@onready var attempts_label: Label = $AttemptsLabel
@onready var round_label: Label = $RoundLabel

var current_round: int = 0
var correct_found: int = 0
var wrong_count: int = 0
var selected_index: int = 0
var plant_slots: Array[Control] = []

func _ready() -> void:
	assert(plant_grid != null, "PlantGrid missing")
	assert(instruction_label != null, "InstructionLabel missing")
	assert(attempts_label != null, "AttemptsLabel missing")
	assert(round_label != null, "RoundLabel missing")
	if not GameState.get_flag("herb_minigame_tutorial_done"):
		_show_tutorial()
	else:
		_setup_round(0)

func _setup_round(round_num: int) -> void:
	current_round = round_num
	correct_found = 0
	wrong_count = 0
	selected_index = 0
	# Generate plants - correct ones have subtle glow/different stamen color
	_generate_plants(plants_per_round[round_num], correct_per_round[round_num])
	_update_labels()
	_update_selection()

func _unhandled_input(event: InputEvent) -> void:
	var accept_pressed := event.is_action_pressed("ui_accept") or event.is_action_pressed("interact")
	if $TutorialOverlay.visible:
		if accept_pressed:
			_on_tutorial_continue()
		return

	if accept_pressed:
		_select_current()
	# D-pad navigation
	elif event.is_action_pressed("ui_right"):
		_move_selection(1)
	elif event.is_action_pressed("ui_left"):
		_move_selection(-1)
	elif event.is_action_pressed("ui_down"):
		_move_selection(5)  # Move down row
	elif event.is_action_pressed("ui_up"):
		_move_selection(-5)
	elif event.is_action_pressed("ui_cancel"):
		# Allow ESC to close minigame (but not during tutorial)
		queue_free()

func _show_tutorial() -> void:
	$TutorialOverlay.visible = true

func _on_tutorial_continue() -> void:
	$TutorialOverlay.visible = false
	GameState.set_flag("herb_minigame_tutorial_done", true)
	_setup_round(0)

func _select_current() -> void:
	if plant_slots.is_empty():
		return
	if current_round >= correct_per_round.size():
		return
	var plant = plant_slots[selected_index]
	if plant.get_meta("is_correct", false):
		_on_correct_selection(plant)
		if correct_found >= correct_per_round[current_round]:
			_advance_round()
			if current_round >= plants_per_round.size():
				return
	else:
		_on_wrong_selection(plant)
		if wrong_count >= max_wrong:
			minigame_complete.emit(false, [])
	_update_labels()

func _advance_round() -> void:
	current_round += 1
	if current_round >= plants_per_round.size():
		# All rounds complete
		var items = ["pharmaka_flower", "pharmaka_flower", "pharmaka_flower"]
		_award_items(items)
		minigame_complete.emit(true, items)
		# Auto-close minigame after a short delay to show completion
		await get_tree().create_timer(1.5).timeout
		queue_free()
	else:
		_setup_round(current_round)

func _generate_plants(total_plants: int, correct_plants: int) -> void:
	for child in plant_grid.get_children():
		child.queue_free()
	plant_slots.clear()

	var correct_indices: Array[int] = []
	while correct_indices.size() < correct_plants:
		var idx = randi_range(0, total_plants - 1)
		if not correct_indices.has(idx):
			correct_indices.append(idx)

	for i in range(total_plants):
		var slot := ColorRect.new()
		slot.custom_minimum_size = Vector2(32, 32)
		slot.modulate = Color(0.5, 0.5, 0.55, 1.0)  # Gray flowers
		var is_correct = correct_indices.has(i)
		if is_correct:
			slot.modulate = Color(1.0, 0.85, 0.3, 1.0)  # Bright gold for correct
			_add_glow_effect(slot)
		slot.set_meta("is_correct", is_correct)
		plant_grid.add_child(slot)
		plant_slots.append(slot)

func _move_selection(delta: int) -> void:
	if plant_slots.is_empty():
		return
	selected_index = clamp(selected_index + delta, 0, plant_slots.size() - 1)
	_update_selection()

func _update_selection() -> void:
	for i in range(plant_slots.size()):
		var slot = plant_slots[i]
		if i == selected_index:
			slot.scale = Vector2(1.1, 1.1)
		else:
			slot.scale = Vector2.ONE

func _update_labels() -> void:
	round_label.text = "Round %d/%d" % [current_round + 1, plants_per_round.size()]
	attempts_label.text = "Wrong: %d/%d" % [wrong_count, max_wrong]
	instruction_label.text = "Find the glowing plants"
	_update_status()

func _update_status() -> void:
	if current_round >= correct_per_round.size():
		return
	$StatusBar/WrongCount.text = "Wrong: %d/%d" % [wrong_count, max_wrong]
	$StatusBar/RemainingCount.text = "Find: %d" % (correct_per_round[current_round] - correct_found)

func _add_glow_effect(plant: Control) -> void:
	var tween = create_tween().set_loops(GLOW_LOOP_COUNT)
	tween.tween_property(plant, "modulate", Color(1.1, 1.05, 0.9), 1.0)
	tween.tween_property(plant, "modulate", Color(1.0, 1.0, 1.0), 1.0)

func _on_correct_selection(plant: Control) -> void:
	if AudioController.has_sfx("correct_ding"):
		AudioController.play_sfx("correct_ding")
	_spawn_particles(plant.global_position)
	var tween = create_tween()
	tween.tween_property(plant, "modulate", Color.GREEN, 0.2)
	correct_found += 1
	_update_status()

func _on_wrong_selection(plant: Control) -> void:
	if AudioController.has_sfx("wrong_buzz"):
		AudioController.play_sfx("wrong_buzz")
	var original_x = plant.position.x
	var tween = create_tween()
	tween.tween_property(plant, "position:x", original_x + 5, 0.05)
	tween.tween_property(plant, "position:x", original_x - 10, 0.05)
	tween.tween_property(plant, "position:x", original_x + 5, 0.05)
	tween.tween_property(plant, "position:x", original_x, 0.05)
	wrong_count += 1
	_update_status()

func _spawn_particles(pos: Vector2) -> void:
	var particles = $ParticleContainer/CorrectParticles
	particles.global_position = pos
	particles.restart()

func _award_items(items: Array) -> void:
	for item_id in items:
		GameState.add_item(item_id, 1)
