extends GutTest
## Unit tests for QuestManager autoload

var quest_manager: Node

func before_each() -> void:
	quest_manager = preload("res://src/autoloads/quest_manager.gd").new()
	add_child_autofree(quest_manager)

# ============================================
# QUEST START TESTS
# ============================================

func test_start_quest_returns_true() -> void:
	var result = quest_manager.start_quest("test_quest")
	assert_true(result, "start_quest should return true for new quest")

func test_start_quest_emits_signal() -> void:
	watch_signals(quest_manager)
	quest_manager.start_quest("test_quest")
	assert_signal_emitted(quest_manager, "quest_started")

func test_start_quest_duplicate_returns_false() -> void:
	quest_manager.start_quest("test_quest")
	var result = quest_manager.start_quest("test_quest")
	assert_false(result, "start_quest should return false for duplicate")

# ============================================
# QUEST STATUS TESTS
# ============================================

func test_quest_status_not_started() -> void:
	var status = quest_manager.get_quest_status("nonexistent")
	assert_eq(status, quest_manager.QuestStatus.NOT_STARTED)

func test_quest_status_active() -> void:
	quest_manager.start_quest("test_quest")
	var status = quest_manager.get_quest_status("test_quest")
	assert_eq(status, quest_manager.QuestStatus.ACTIVE)

func test_is_quest_active_true() -> void:
	quest_manager.start_quest("test_quest")
	assert_true(quest_manager.is_quest_active("test_quest"))

func test_is_quest_active_false() -> void:
	assert_false(quest_manager.is_quest_active("nonexistent"))

# ============================================
# QUEST COMPLETION TESTS
# ============================================

func test_complete_quest_returns_true() -> void:
	quest_manager.start_quest("test_quest")
	var result = quest_manager.complete_quest("test_quest")
	assert_true(result, "complete_quest should return true for active quest")

func test_complete_quest_emits_signal() -> void:
	quest_manager.start_quest("test_quest")
	watch_signals(quest_manager)
	quest_manager.complete_quest("test_quest")
	assert_signal_emitted(quest_manager, "quest_completed")

func test_complete_quest_inactive_returns_false() -> void:
	var result = quest_manager.complete_quest("nonexistent")
	assert_false(result, "complete_quest should return false for inactive quest")

func test_is_quest_completed_true() -> void:
	quest_manager.start_quest("test_quest")
	quest_manager.complete_quest("test_quest")
	assert_true(quest_manager.is_quest_completed("test_quest"))

# ============================================
# QUEST DATA TESTS
# ============================================

func test_quest_metadata_stored() -> void:
	quest_manager.start_quest("test_quest", {"target": "collect_herbs"})
	var data = quest_manager.get_quest_data("test_quest")
	assert_eq(data["target"], "collect_herbs")

func test_update_quest_metadata() -> void:
	quest_manager.start_quest("test_quest", {"count": 0})
	quest_manager.update_quest("test_quest", "count", 5)
	var data = quest_manager.get_quest_data("test_quest")
	assert_eq(data["count"], 5)

# ============================================
# QUERY TESTS
# ============================================

func test_get_active_quests() -> void:
	quest_manager.start_quest("quest1")
	quest_manager.start_quest("quest2")
	quest_manager.complete_quest("quest1")
	var active = quest_manager.get_active_quests()
	assert_eq(active.size(), 1)
	assert_has(active, "quest2")

func test_get_completed_quests() -> void:
	quest_manager.start_quest("quest1")
	quest_manager.start_quest("quest2")
	quest_manager.complete_quest("quest1")
	var completed = quest_manager.get_completed_quests()
	assert_eq(completed.size(), 1)
	assert_has(completed, "quest1")
