class_name KeyboardPlayerInput
extends IPlayerInputBehavior

var _current_direction: Vector2 = Vector2.ZERO
var _is_moving: bool = false
var _interaction_target: Node = null
var _stealth_action_active: bool = false
var _input_system: Object = Input  # Default to global Input, but can be injected for testing

# Input action names (defined in Input Map)
const INPUT_MOVE_LEFT = "move_left"
const INPUT_MOVE_RIGHT = "move_right" 
const INPUT_MOVE_UP = "move_up"
const INPUT_MOVE_DOWN = "move_down"
const INPUT_INTERACT = "interact"
const INPUT_STEALTH = "stealth"

func _init(input_system: Object = null):
	if input_system != null:
		_input_system = input_system

func update_input() -> void:
	# Gather input direction
	var input_dir = Vector2.ZERO
	
	if _input_system.is_action_pressed(INPUT_MOVE_LEFT):
		input_dir.x -= 1
	if _input_system.is_action_pressed(INPUT_MOVE_RIGHT):
		input_dir.x += 1
	if _input_system.is_action_pressed(INPUT_MOVE_UP):
		input_dir.y -= 1
	if _input_system.is_action_pressed(INPUT_MOVE_DOWN):
		input_dir.y += 1
	
	# Normalize diagonal movement
	input_dir = input_dir.normalized()
	
	_current_direction = input_dir
	_is_moving = input_dir != Vector2.ZERO
	
	# Handle stealth toggle
	if _input_system.is_action_just_pressed(INPUT_STEALTH):
		_stealth_action_active = !_stealth_action_active

# Interface implementation
func is_moving() -> bool:
	return _is_moving

func get_current_input() -> Vector2:
	return _current_direction

func get_interaction_target() -> Node:
	return _interaction_target

func is_stealth_action_active() -> bool:
	return _stealth_action_active

func set_interaction_target(target: Node) -> void:
	_interaction_target = target