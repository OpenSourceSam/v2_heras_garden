extends Node
## QuestManager - Tracks quest progression and completion
## See DEVELOPMENT_ROADMAP.md Phase 2

# ============================================
# SIGNALS
# ============================================

signal quest_started(quest_id: String)
signal quest_completed(quest_id: String)
signal quest_updated(quest_id: String, status: String)

# ============================================
# QUEST STATUS ENUM
# ============================================

enum QuestStatus {NOT_STARTED, ACTIVE, COMPLETED, FAILED}

# ============================================
# STATE
# ============================================

var _quests: Dictionary = {} # quest_id -> QuestStatus
var _quest_data: Dictionary = {} # quest_id -> metadata

# ============================================
# INITIALIZATION
# ============================================

func _ready() -> void:
	print("[QuestManager] Initialized")

# ============================================
# QUEST MANAGEMENT
# ============================================

func start_quest(quest_id: String, metadata: Dictionary = {}) -> bool:
	"""Start a new quest. Returns false if already started."""
	if _quests.has(quest_id) and _quests[quest_id] != QuestStatus.NOT_STARTED:
		print("[QuestManager] Quest already started: %s" % quest_id)
		return false
	
	_quests[quest_id] = QuestStatus.ACTIVE
	_quest_data[quest_id] = metadata
	quest_started.emit(quest_id)
	print("[QuestManager] Quest started: %s" % quest_id)
	return true

func complete_quest(quest_id: String) -> bool:
	"""Mark quest as completed. Returns false if not active."""
	if not _quests.has(quest_id) or _quests[quest_id] != QuestStatus.ACTIVE:
		print("[QuestManager] Cannot complete quest (not active): %s" % quest_id)
		return false
	
	_quests[quest_id] = QuestStatus.COMPLETED
	quest_completed.emit(quest_id)
	
	# Set GameState flag for quest completion
	GameState.set_flag("quest_%s_complete" % quest_id, true)
	
	print("[QuestManager] Quest completed: %s" % quest_id)
	return true

func fail_quest(quest_id: String) -> bool:
	"""Mark quest as failed."""
	if not _quests.has(quest_id) or _quests[quest_id] != QuestStatus.ACTIVE:
		return false
	
	_quests[quest_id] = QuestStatus.FAILED
	quest_updated.emit(quest_id, "failed")
	print("[QuestManager] Quest failed: %s" % quest_id)
	return true

func update_quest(quest_id: String, update_key: String, update_value: Variant) -> void:
	"""Update quest metadata."""
	if _quest_data.has(quest_id):
		_quest_data[quest_id][update_key] = update_value
		quest_updated.emit(quest_id, update_key)

# ============================================
# QUERY METHODS
# ============================================

func get_quest_status(quest_id: String) -> QuestStatus:
	"""Get current status of a quest."""
	if _quests.has(quest_id):
		return _quests[quest_id]
	return QuestStatus.NOT_STARTED

func is_quest_active(quest_id: String) -> bool:
	return get_quest_status(quest_id) == QuestStatus.ACTIVE

func is_quest_completed(quest_id: String) -> bool:
	return get_quest_status(quest_id) == QuestStatus.COMPLETED

func get_quest_data(quest_id: String) -> Dictionary:
	if _quest_data.has(quest_id):
		return _quest_data[quest_id]
	return {}

func get_active_quests() -> Array[String]:
	"""Return list of all active quest IDs."""
	var active: Array[String] = []
	for quest_id in _quests:
		if _quests[quest_id] == QuestStatus.ACTIVE:
			active.append(quest_id)
	return active

func get_completed_quests() -> Array[String]:
	"""Return list of all completed quest IDs."""
	var completed: Array[String] = []
	for quest_id in _quests:
		if _quests[quest_id] == QuestStatus.COMPLETED:
			completed.append(quest_id)
	return completed

# ============================================
# SAVE/LOAD SUPPORT
# ============================================

func get_save_data() -> Dictionary:
	return {
		"quests": _quests.duplicate(),
		"quest_data": _quest_data.duplicate(true)
	}

func load_save_data(data: Dictionary) -> void:
	if data.has("quests"):
		_quests = data["quests"].duplicate()
	if data.has("quest_data"):
		_quest_data = data["quest_data"].duplicate(true)
	print("[QuestManager] Loaded save data")
