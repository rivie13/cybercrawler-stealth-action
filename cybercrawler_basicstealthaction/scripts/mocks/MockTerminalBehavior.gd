class_name MockTerminalBehavior
extends ITerminalBehavior

var _terminal_type: String = "test_terminal"
var _is_accessible: bool = true
var _can_interact: bool = true
var _interaction_data: Dictionary = {}
var _interaction_results: Array[Dictionary] = []

func can_interact(player: Node) -> bool:
    return _can_interact and _is_accessible

func get_terminal_type() -> String:
    return _terminal_type

func get_interaction_data() -> Dictionary:
    return _interaction_data

func process_interaction(player: Node) -> Dictionary:
    var result = {
        "success": _can_interact,
        "message": "Mock interaction processed",
        "terminal_type": _terminal_type,
        "timestamp": Time.get_time_dict_from_system()
    }
    _interaction_results.append(result)
    return result

func is_accessible() -> bool:
    return _is_accessible

# Testing helper methods
func set_terminal_type(type: String) -> void:
    _terminal_type = type

func set_accessible(accessible: bool) -> void:
    _is_accessible = accessible

func set_can_interact(can_interact: bool) -> void:
    _can_interact = can_interact

func set_interaction_data(data: Dictionary) -> void:
    _interaction_data = data

func get_interaction_count() -> int:
    return _interaction_results.size()

func get_last_interaction_result() -> Dictionary:
    if _interaction_results.size() > 0:
        return _interaction_results[-1]
    return {}

func clear_interaction_history() -> void:
    _interaction_results.clear()