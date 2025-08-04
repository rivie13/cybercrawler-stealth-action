class_name TerminalTile
extends StaticBody2D

var terminal_type: String = "basic_terminal"
var terminal_name: String = "Terminal"
var terminal_id: String = ""
var terminal_behavior: ITerminalBehavior

func _ready():
	# Generate unique terminal ID if not set
	if terminal_id.is_empty():
		terminal_id = "terminal_tile_" + str(get_instance_id())
	
	# Set up collision layer/mask for interaction
	collision_layer = 2  # Layer for terminals
	collision_mask = 1    # Mask for player
	
	# Add to terminals group for interaction detection
	add_to_group("terminals")

func interact_with_player(player: Node) -> void:
	print("🎯 SUCCESSFUL INTERACTION: Player interacted with terminal tile '%s' at position %s" % [terminal_type, global_position])
	
	# Use terminal behavior if available
	if terminal_behavior:
		terminal_behavior.process_interaction(player)
	
	# You can add more interaction logic here
	# For example, opening a UI, triggering events, etc.

func get_terminal_type() -> String:
	return terminal_type

func is_interactable() -> bool:
	return true

func set_terminal_behavior(behavior: ITerminalBehavior) -> void:
	terminal_behavior = behavior 