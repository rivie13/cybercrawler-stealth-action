class_name IPlayerInput
extends RefCounted

# Input event signals
signal move_requested(direction: Vector2)
signal interaction_requested(target: Node)
signal stealth_action_requested(action_type: String)

# Input query methods
func is_moving() -> bool:
    # Override in implementations
    return false

func get_current_input() -> Vector2:
    # Override in implementations
    return Vector2.ZERO