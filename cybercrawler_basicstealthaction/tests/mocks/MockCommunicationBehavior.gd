class_name MockCommunicationBehavior
extends ICommunicationBehavior

var interaction_calls: Array = []
var alert_calls: Array = []
var mission_context_calls: int = 0

func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
	interaction_calls.append({"terminal_type": terminal_type, "context": context})

func notify_alert_state(alert_level: int, context: Dictionary) -> void:
	alert_calls.append({"alert_level": alert_level, "context": context})

func get_mission_context() -> Dictionary:
	mission_context_calls += 1
	return {"mock_mission": "test_mission", "calls": mission_context_calls}

# Test helper methods
func get_interaction_calls() -> Array:
	return interaction_calls

func get_alert_calls() -> Array:
	return alert_calls

func get_mission_context_calls() -> int:
	return mission_context_calls

func reset():
	interaction_calls.clear()
	alert_calls.clear()
	mission_context_calls = 0 