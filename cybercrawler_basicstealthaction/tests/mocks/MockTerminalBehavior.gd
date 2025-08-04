class_name MockTerminalBehavior
extends ITerminalBehavior

var can_interact_calls: int = 0
var get_terminal_type_calls: int = 0
var get_interaction_data_calls: int = 0
var process_interaction_calls: int = 0
var is_accessible_calls: int = 0

var mock_can_interact: bool = true
var mock_terminal_type: String = "mock_terminal"
var mock_interaction_data: Dictionary = {"mock": "data"}
var mock_process_result: Dictionary = {"success": true, "message": "Mock interaction"}
var mock_is_accessible: bool = true

func can_interact(player: Node) -> bool:
	can_interact_calls += 1
	return mock_can_interact

func get_terminal_type() -> String:
	get_terminal_type_calls += 1
	return mock_terminal_type

func get_interaction_data() -> Dictionary:
	get_interaction_data_calls += 1
	return mock_interaction_data

func process_interaction(player: Node) -> Dictionary:
	process_interaction_calls += 1
	return mock_process_result

func is_accessible() -> bool:
	is_accessible_calls += 1
	return mock_is_accessible

# Test helper methods
func get_can_interact_calls() -> int:
	return can_interact_calls

func get_terminal_type_call_count() -> int:
	return get_terminal_type_calls

func get_interaction_data_call_count() -> int:
	return get_interaction_data_calls

func get_process_interaction_calls() -> int:
	return process_interaction_calls

func get_is_accessible_calls() -> int:
	return is_accessible_calls

func reset():
	can_interact_calls = 0
	get_terminal_type_calls = 0
	get_interaction_data_calls = 0
	process_interaction_calls = 0
	is_accessible_calls = 0 