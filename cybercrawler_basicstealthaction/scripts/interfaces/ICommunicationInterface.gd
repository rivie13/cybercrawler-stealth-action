class_name ICommunicationInterface
extends RefCounted

# Signals for external system communication
signal terminal_accessed(terminal_type: String, context: Dictionary)
signal alert_triggered(alert_level: int, location: Vector2)
signal mission_status_changed(status: String, data: Dictionary)

# Methods external systems implement
func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
    # Override in implementations
    pass

func notify_alert_state(alert_level: int, context: Dictionary) -> void:
    # Override in implementations  
    pass

func get_mission_context() -> Dictionary:
    # Override in implementations
    return {}