# Pure behavior contract for input systems
# Actual input signals handled by Node-based input handlers
class_name IPlayerInputBehavior
extends RefCounted

# Input query methods
func is_moving() -> bool:
    # Override in implementations
    return false

func get_current_input() -> Vector2:
    # Override in implementations
    return Vector2.ZERO

func get_interaction_target() -> Node:
    # Override in implementations
    return null

func is_stealth_action_active() -> bool:
    # Override in implementations
    return false