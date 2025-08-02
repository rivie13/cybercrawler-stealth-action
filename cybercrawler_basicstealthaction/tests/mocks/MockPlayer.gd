class_name MockPlayer
extends CharacterBody2D

# Mock properties
var mock_position: Vector2 = Vector2.ZERO
var mock_velocity: Vector2 = Vector2.ZERO
var mock_is_moving: bool = false
var mock_is_stealth_mode: bool = false
var mock_name: String = "MockPlayer"
var mock_global_position: Vector2 = Vector2.ZERO

# Mock components
var mock_movement_component: PlayerMovementComponent
var mock_interaction_component: PlayerInteractionComponent

# Mock behaviors
var mock_input_behavior: IPlayerInputBehavior
var mock_communication_behavior: ICommunicationBehavior

# Mock visual elements
var mock_player_sprite: Sprite2D
var mock_interaction_indicator: ColorRect
var mock_cyberpunk_ui: Control

# Test tracking
var interaction_calls: int = 0
var movement_calls: int = 0
var stealth_calls: int = 0

func _init():
	# Initialize mock components
	mock_movement_component = PlayerMovementComponent.new()
	mock_interaction_component = PlayerInteractionComponent.new()

func get_player_position() -> Vector2:
	return mock_position

func set_player_position(pos: Vector2):
	mock_position = pos
	mock_global_position = pos

func is_moving() -> bool:
	return mock_is_moving

func set_is_moving(moving: bool):
	mock_is_moving = moving

func is_in_stealth_mode() -> bool:
	return mock_is_stealth_mode

func set_stealth_mode(stealth: bool):
	mock_is_stealth_mode = stealth

func force_velocity(new_velocity: Vector2):
	mock_velocity = new_velocity

func get_mock_global_position() -> Vector2:
	return mock_global_position

func set_mock_global_position(pos: Vector2):
	mock_global_position = pos
	mock_position = pos

func get_mock_name() -> String:
	return mock_name

func set_mock_name(name: String):
	mock_name = name

# Mock component access
func get_movement_component() -> PlayerMovementComponent:
	return mock_movement_component

func get_interaction_component() -> PlayerInteractionComponent:
	return mock_interaction_component

# Mock behavior access
func get_input_behavior() -> IPlayerInputBehavior:
	return mock_input_behavior

func set_input_behavior(behavior: IPlayerInputBehavior):
	mock_input_behavior = behavior

func get_communication_behavior() -> ICommunicationBehavior:
	return mock_communication_behavior

func set_communication_behavior(behavior: ICommunicationBehavior):
	mock_communication_behavior = behavior

# Mock visual elements
func get_player_sprite() -> Sprite2D:
	return mock_player_sprite

func set_player_sprite(sprite: Sprite2D):
	mock_player_sprite = sprite

func get_interaction_indicator() -> ColorRect:
	return mock_interaction_indicator

func set_interaction_indicator(indicator: ColorRect):
	mock_interaction_indicator = indicator

func get_cyberpunk_ui() -> Control:
	return mock_cyberpunk_ui

func set_cyberpunk_ui(ui: Control):
	mock_cyberpunk_ui = ui

# Test tracking methods
func get_interaction_calls() -> int:
	return interaction_calls

func get_movement_calls() -> int:
	return movement_calls

func get_stealth_calls() -> int:
	return stealth_calls

func reset_call_counts():
	interaction_calls = 0
	movement_calls = 0
	stealth_calls = 0

# Mock interaction method that terminals can call
func interact_with_terminal(terminal: Node):
	interaction_calls += 1
	print("MockPlayer: Interacted with terminal ", terminal.name)

# Mock methods that match CreatedPlayer interface
func has_mock_method(method_name: String) -> bool:
	var valid_methods = [
		"get_player_position",
		"is_moving", 
		"is_in_stealth_mode",
		"force_velocity",
		"get_mock_global_position",
		"get_mock_name",
		"interact_with_terminal"
	]
	return valid_methods.has(method_name)

# Mock terminal type access (for testing terminal interactions)
var mock_terminal_type: String = "mock_terminal"

func get_terminal_type() -> String:
	return mock_terminal_type

func set_terminal_type(type: String):
	mock_terminal_type = type 