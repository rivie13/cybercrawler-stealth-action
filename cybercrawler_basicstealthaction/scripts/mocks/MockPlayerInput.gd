class_name MockPlayerInput
extends IPlayerInput

var _current_direction: Vector2 = Vector2.ZERO
var _is_moving: bool = false

func is_moving() -> bool:
    return _is_moving

func get_current_input() -> Vector2:
    return _current_direction

# Testing helper methods
func simulate_movement(direction: Vector2) -> void:
    _current_direction = direction
    _is_moving = direction != Vector2.ZERO
    move_requested.emit(direction)

func simulate_interaction(target: Node) -> void:
    interaction_requested.emit(target)

func simulate_stealth_action(action_type: String) -> void:
    stealth_action_requested.emit(action_type)