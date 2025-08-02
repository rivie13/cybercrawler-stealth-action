class_name MockPlayerInputBehavior
extends RefCounted

# Mock input state
var mock_current_input: Vector2 = Vector2.ZERO
var mock_is_moving: bool = false
var mock_is_stealth_active: bool = false
var mock_interaction_target: Node = null

# Test tracking
var get_current_input_calls: int = 0
var is_moving_calls: int = 0
var is_stealth_action_active_calls: int = 0
var set_interaction_target_calls: int = 0
var update_input_calls: int = 0

func get_current_input() -> Vector2:
	get_current_input_calls += 1
	return mock_current_input

func set_current_input(input: Vector2):
	mock_current_input = input

func is_moving() -> bool:
	is_moving_calls += 1
	return mock_is_moving

func set_is_moving(moving: bool):
	mock_is_moving = moving

func is_stealth_action_active() -> bool:
	is_stealth_action_active_calls += 1
	return mock_is_stealth_active

func set_stealth_active(active: bool):
	mock_is_stealth_active = active

func set_interaction_target(target: Node):
	set_interaction_target_calls += 1
	mock_interaction_target = target

func get_interaction_target() -> Node:
	return mock_interaction_target

func update_input():
	update_input_calls += 1

# Test helper methods
func get_current_input_call_count() -> int:
	return get_current_input_calls

func get_is_moving_call_count() -> int:
	return is_moving_calls

func get_stealth_action_active_call_count() -> int:
	return is_stealth_action_active_calls

func get_set_interaction_target_call_count() -> int:
	return set_interaction_target_calls

func get_update_input_call_count() -> int:
	return update_input_calls

func reset_call_counts():
	get_current_input_calls = 0
	is_moving_calls = 0
	is_stealth_action_active_calls = 0
	set_interaction_target_calls = 0
	update_input_calls = 0

# Mock input simulation
func simulate_input_direction(direction: Vector2):
	mock_current_input = direction
	if direction != Vector2.ZERO:
		mock_is_moving = true
	else:
		mock_is_moving = false

func simulate_stealth_toggle():
	mock_is_stealth_active = !mock_is_stealth_active

func simulate_interaction_target(target: Node):
	mock_interaction_target = target 