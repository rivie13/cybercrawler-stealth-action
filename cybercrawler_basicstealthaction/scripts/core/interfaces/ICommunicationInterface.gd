# Pure behavior contract for communication with external systems
# Signals handled by actual Node implementations, not interfaces
class_name ICommunicationBehavior
extends RefCounted

# Methods external systems implement
func handle_terminal_interaction(_terminal_type: String, _context: Dictionary) -> void:
    # Override in implementations
    pass

func notify_alert_state(_alert_level: int, _context: Dictionary) -> void:
    # Override in implementations  
    pass

func get_mission_context() -> Dictionary:
    # Override in implementations
    return {}