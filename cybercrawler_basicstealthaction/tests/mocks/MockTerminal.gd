class_name MockTerminal
extends StaticBody2D

var mock_terminal_type: String = "mock_terminal"
var mock_terminal_name: String = "MockTerminal"
var mock_terminal_behavior: ITerminalBehavior = null
var mock_can_interact: bool = true

func get_terminal_type() -> String:
	return mock_terminal_type

func set_terminal_type(type: String):
	mock_terminal_type = type

func get_terminal_name() -> String:
	return mock_terminal_name

func set_terminal_name(name: String):
	mock_terminal_name = name

func can_interact() -> bool:
	return mock_can_interact

func set_can_interact(can_interact: bool):
	mock_can_interact = can_interact

func interact_with_player(player: Node) -> void:
	print("Mock terminal interaction with player")

func set_terminal_behavior(behavior: ITerminalBehavior) -> void:
	mock_terminal_behavior = behavior 