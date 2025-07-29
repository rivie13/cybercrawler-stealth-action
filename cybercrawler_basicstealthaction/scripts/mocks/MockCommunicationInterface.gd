class_name MockCommunicationInterface
extends ICommunicationInterface

# Track interactions for testing
var terminal_interactions: Array[Dictionary] = []
var alerts_triggered: Array[Dictionary] = []
var mission_context: Dictionary = {}

func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
    terminal_interactions.append({
        "type": terminal_type,
        "context": context,
        "timestamp": Time.get_time_dict_from_system()
    })

func notify_alert_state(alert_level: int, context: Dictionary) -> void:
    alerts_triggered.append({
        "level": alert_level,
        "context": context,
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