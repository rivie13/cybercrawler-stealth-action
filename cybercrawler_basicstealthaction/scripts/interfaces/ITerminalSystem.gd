# Pure behavior contract for terminal interaction logic
# Actual terminal signals handled by Node-based terminal implementations (Area2D, etc.)
class_name ITerminalBehavior
extends RefCounted

# Terminal interaction methods
func can_interact(player: Node) -> bool:
    # Override in implementations
    return false

func get_terminal_type() -> String:
    # Override in implementations
    return ""

func get_interaction_data() -> Dictionary:
    # Override in implementations
    return {}

func process_interaction(player: Node) -> Dictionary:
    # Override in implementations - returns result data
    return {"success": false, "message": "Not implemented"}

func is_accessible() -> bool:
    # Override in implementations
    return true