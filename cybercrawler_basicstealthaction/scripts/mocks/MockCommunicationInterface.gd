class_name MockCommunicationBehavior
extends ICommunicationBehavior

# Track interactions for testing
var terminal_interactions: Array[Dictionary] = []
var alerts_triggered: Array[Dictionary] = []
var mission_context: Dictionary = {}

func handle_terminal_interaction(_terminal_type: String, _context: Dictionary) -> void:
    terminal_interactions.append({
        "type": _terminal_type,
        "context": _context,
        "timestamp": Time.get_time_dict_from_system()
    })

func notify_alert_state(_alert_level: int, _context: Dictionary) -> void:
    alerts_triggered.append({
        "level": _alert_level,
        "context": _context,
        "timestamp": Time.get_time_dict_from_system()
    })

func get_mission_context() -> Dictionary:
    return mission_context

# Testing helper methods
func set_mission_context(context: Dictionary) -> void:
    mission_context = context

func get_interaction_count() -> int:
    return terminal_interactions.size()

func get_last_interaction() -> Dictionary:
    if terminal_interactions.size() > 0:
        return terminal_interactions[-1]
    return {}

func clear_interactions() -> void:
    terminal_interactions.clear()
    alerts_triggered.clear()