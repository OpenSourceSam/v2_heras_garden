extends CanvasLayer
## NotificationSystem - Popup notification system for quest updates, achievements, etc.

const NOTIFICATION_DURATION: float = 3.0  # seconds
const MAX_NOTIFICATIONS: int = 5

var notification_queue: Array[Dictionary] = []
var active_notifications: Array[Control] = []

@onready var notification_container: VBoxContainer = $NotificationContainer
@onready var notification_template: Panel = $NotificationTemplate

enum NotificationType {
	QUEST_UPDATE,
	ACHIEVEMENT,
	ITEM_COLLECTED,
	INFORMATION
}

func _ready() -> void:
	assert(notification_container != null, "NotificationContainer missing")
	assert(notification_template != null, "NotificationTemplate missing")

	# Hide template
	notification_template.visible = false
	notification_template.set_meta("notification_id", null)

func show_notification(title: String, message: String, type: NotificationType = NotificationType.INFORMATION, icon: Texture2D = null) -> void:
	var notification_data = {
		"title": title,
		"message": message,
		"type": type,
		"icon": icon,
		"timestamp": Time.get_unix_time_from_system()
	}

	notification_queue.append(notification_data)
	_process_queue()

func show_quest_update(quest_name: String, status: String) -> void:
	show_notification(
		"Quest Update",
		"%s: %s" % [quest_name, status],
		NotificationType.QUEST_UPDATE
	)

func show_achievement(title: String, description: String) -> void:
	show_notification(
		"Achievement",
		"%s: %s" % [title, description],
		NotificationType.ACHIEVEMENT
	)

func show_item_collected(item_name: String, quantity: int = 1) -> void:
	show_notification(
		"Item Collected",
		"%s x%d" % [item_name, quantity],
		NotificationType.ITEM_COLLECTED
	)

func _process_queue() -> void:
	if active_notifications.size() >= MAX_NOTIFICATIONS:
		return

	if notification_queue.is_empty():
		return

	var notification_data = notification_queue.pop_front()
	_create_notification(notification_data)

func _create_notification(data: Dictionary) -> void:
	var notification = notification_template.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_USE_INSTANTIATION)
	notification.visible = true

	# Set content
	var title_label = notification.get_node("HBoxContainer/VBoxContainer/TitleLabel")
	var message_label = notification.get_node("HBoxContainer/VBoxContainer/MessageLabel")
	var icon_rect = notification.get_node("HBoxContainer/Icon")

	if title_label:
		title_label.text = data.get("title", "Notification")

	if message_label:
		message_label.text = data.get("message", "")

	if icon_rect and data.has("icon") and data["icon"]:
		icon_rect.texture = data["icon"]

	# Add to container
	notification_container.add_child(notification)
	active_notifications.append(notification)

	# Play sound
	if AudioController and AudioController.has_method("play_sfx"):
		AudioController.play_sfx("ui_open")

	# Animate in
	var tween = notification.create_tween()
	notification.modulate = Color(1, 1, 1, 0)
	tween.tween_property(notification, "modulate:a", 1.0, 0.3)

	# Auto-remove after duration
	await get_tree().create_timer(NOTIFICATION_DURATION).timeout
	_remove_notification(notification)

func _remove_notification(notification: Control) -> void:
	if not is_instance_valid(notification):
		return

	if notification in active_notifications:
		active_notifications.erase(notification)

	# Animate out
	var tween = notification.create_tween()
	tween.tween_property(notification, "modulate:a", 0.0, 0.3)
	tween.tween_callback(notification.queue_free)

	# Process queue
	await get_tree().create_timer(0.4).timeout
	_process_queue()
