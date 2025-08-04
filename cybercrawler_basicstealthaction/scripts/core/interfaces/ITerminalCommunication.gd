class_name ITerminalCommunication
extends RefCounted

# Interface for communicating terminal interactions to parent repo
# This handles the bridge between stealth action and tower defense

# Terminal interaction data structure
class TerminalInteractionData:
	var terminal_type: String
	var terminal_position: Vector2
	var player_position: Vector2
	var interaction_timestamp: Dictionary
	var terminal_id: String
	var interaction_type: String  # "activate", "deactivate", "interact"
	
	func _init(type: String, term_pos: Vector2, player_pos: Vector2, term_id: String = "", interact_type: String = "interact"):
		terminal_type = type
		terminal_position = term_pos
		player_position = player_pos
		terminal_id = term_id
		interaction_type = interact_type
		interaction_timestamp = Time.get_time_dict_from_system()

# Send terminal interaction to parent repo
func send_terminal_interaction(data: TerminalInteractionData) -> bool:
	push_error("ITerminalCommunication.send_terminal_interaction() must be implemented")
	return false

# Check if terminal communication is available
func is_communication_available() -> bool:
	push_error("ITerminalCommunication.is_communication_available() must be implemented")
	return false

# Get communication status
func get_communication_status() -> String:
	push_error("ITerminalCommunication.get_communication_status() must be implemented")
	return "unknown" 