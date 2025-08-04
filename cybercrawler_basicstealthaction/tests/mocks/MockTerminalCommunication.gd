class_name MockTerminalCommunication
extends ITerminalCommunication

# Mock implementation for testing terminal communication
var sent_interactions: Array[TerminalInteractionData] = []
var communication_available: bool = true
var communication_status: String = "connected"

func send_terminal_interaction(data: TerminalInteractionData) -> bool:
	if not communication_available:
		return false
	
	sent_interactions.append(data)
	print("🎯 MOCK: Terminal interaction sent to parent repo:")
	print("  - Terminal Type: ", data.terminal_type)
	print("  - Terminal Position: ", data.terminal_position)
	print("  - Player Position: ", data.player_position)
	print("  - Interaction Type: ", data.interaction_type)
	print("  - Terminal ID: ", data.terminal_id)
	
	return true

func is_communication_available() -> bool:
	return communication_available

func get_communication_status() -> String:
	return communication_status

# Mock control methods for testing
func set_communication_available(available: bool) -> void:
	communication_available = available

func set_communication_status(status: String) -> void:
	communication_status = status

func get_sent_interactions() -> Array[TerminalInteractionData]:
	return sent_interactions

func clear_sent_interactions() -> void:
	sent_interactions.clear()

# Helper method to simulate communication failure
func simulate_communication_failure() -> void:
	communication_available = false
	communication_status = "disconnected"

# Helper method to simulate communication success
func simulate_communication_success() -> void:
	communication_available = true
	communication_status = "connected" 