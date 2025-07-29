class_name MockPlayerInputBehavior
extends IPlayerInputBehavior

var _current_direction: Vector2 = Vector2.ZERO
var _is_moving: bool = false
var _interaction_target: Node = null
var _stealth_action_active: bool = false

func is_moving() -> bool:
    return _is_moving

func get_current_input() -> Vector2:
    return _current_direction

func get_interaction_target() -> Node:
    return _interaction_target

func is_stealth_action_active() -> bool:
    return _stealth_action_active

# Testing helper methods - simulate input state changes
func simulate_movement(direction: Vector2) -> void:
    _current_direction = direction
    _is_moving = direction != Vector2.ZERO

func simulate_interaction_target(target: Node) -> void:
    _interaction_target = target

func simulate_stealth_action(active: bool) -> void:
    _stealth_action_active = active

func reset_input_state() -> void:
    _current_direction = Vector2.ZERO
    _is_moving = false
    _interaction_target = null
    _stealth_action_active = false