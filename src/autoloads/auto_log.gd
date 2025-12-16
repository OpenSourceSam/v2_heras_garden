extends Node
## AutoLog - Writes game logs to user://agent_log.txt for AI agent debugging
## See DEVELOPMENT_ROADMAP.md for testing infrastructure

const LOG_PATH = "user://agent_log.txt"

var _log_file: FileAccess = null
var _last_position_log: float = 0.0
const POSITION_LOG_INTERVAL: float = 2.0 # Log player position every 2 seconds

func _ready() -> void:
	# Clear old log and start fresh
	_log_file = FileAccess.open(LOG_PATH, FileAccess.WRITE)
	if _log_file:
		_log_file.store_string("=== GAME SESSION START ===\n")
		_log_file.store_string("Timestamp: %s\n" % Time.get_datetime_string_from_system())
		_log_file.store_string("Godot Version: %s\n\n" % Engine.get_version_info().string)
		_log_file.close()
	
	# Connect to tree signals for crash detection
	get_tree().node_added.connect(_on_node_added)
	
	log_info("AutoLog initialized")

func _process(delta: float) -> void:
	# Log player position periodically for movement tracking
	_last_position_log += delta
	if _last_position_log >= POSITION_LOG_INTERVAL:
		_last_position_log = 0.0
		_log_player_position()

func _log_player_position() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player is Node2D:
		log_debug("Player position: %s" % str(player.global_position))

func _on_node_added(node: Node) -> void:
	# Log when key nodes are added (helps track scene loading)
	if node.name in ["World", "Player", "DialogueBox", "CraftingMinigame"]:
		log_info("Node added: %s (%s)" % [node.name, node.get_class()])

# ============================================
# PUBLIC LOGGING METHODS
# ============================================

func log_info(message: String) -> void:
	_write_log("INFO", message)
	print("[AutoLog] " + message)

func log_error(message: String) -> void:
	_write_log("ERROR", message)
	push_error("[AutoLog] " + message)

func log_warning(message: String) -> void:
	_write_log("WARN", message)
	push_warning("[AutoLog] " + message)

func log_debug(message: String) -> void:
	_write_log("DEBUG", message)

func log_event(event_name: String, data: Dictionary = {}) -> void:
	var event_str = event_name
	if data.size() > 0:
		event_str += " | " + str(data)
	_write_log("EVENT", event_str)

# ============================================
# INTERNAL
# ============================================

func _write_log(level: String, message: String) -> void:
	var file = FileAccess.open(LOG_PATH, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		var timestamp = Time.get_time_string_from_system()
		file.store_string("[%s] [%s] %s\n" % [timestamp, level, message])
		file.close()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		log_info("Game closing normally")
	elif what == NOTIFICATION_CRASH:
		log_error("CRASH DETECTED!")

func _exit_tree() -> void:
	log_info("=== GAME SESSION END ===")
