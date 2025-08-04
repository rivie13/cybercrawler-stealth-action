class_name TerminalObject
extends StaticBody2D

@export var terminal_type: String = "main_terminal"
@export var terminal_name: String = "Terminal"
@export var sprite_texture: Texture2D

# DI Integration
var terminal_behavior: ITerminalBehavior
var terminal_communication: ITerminalCommunication

# Terminal identification
var terminal_id: String = ""

func _ready():
	# Generate unique terminal ID if not set
	if terminal_id.is_empty():
		terminal_id = "terminal_" + str(get_instance_id())
	
	# Add to terminals group for easy finding
	add_to_group("terminals")
	
	# Create visual representation using your sprite
	if sprite_texture:
		var sprite = Sprite2D.new()
		sprite.texture = sprite_texture
		sprite.position = Vector2.ZERO
		add_child(sprite)
	else:
		# Fallback visual with terminal type indicator
		var visual = ColorRect.new()
		visual.size = Vector2(16, 16)
		visual.position = Vector2(-8, -8)
		
		# Color based on terminal type
		match terminal_type:
			"main_terminal":
				visual.color = Color(1.0, 0.2, 0.2)  # Red for main objective
			"tower_terminal":
				visual.color = Color(0.2, 0.8, 0.2)  # Green for tower placement
			"mine_terminal":
				visual.color = Color(0.8, 0.4, 0.0)  # Orange for mine deployment
			"upgrade_terminal":
				visual.color = Color(0.2, 0.2, 1.0)  # Blue for upgrades
			_:
				visual.color = Color(0.8, 0.4, 0.2)  # Brown for unknown
		
		add_child(visual)
	
	# Create collision shape
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16, 16)
	collision.shape = shape
	add_child(collision)
	
	# Add terminal type label for debugging
	var label = Label.new()
	label.text = TerminalTileIdentifier.get_terminal_icon(terminal_type) + " " + terminal_type
	label.position = Vector2(-20, -30)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_font_size_override("font_size", 8)
	add_child(label)

func interact_with_player(player: Node) -> void:
	print("🎯 SUCCESSFUL INTERACTION: Player interacted with terminal '%s' (%s) at position %s" % [terminal_name, terminal_type, global_position])
	
	# Send interaction data to parent repo
	if terminal_communication:
		var interaction_data = ITerminalCommunication.TerminalInteractionData.new(
			terminal_type,
			global_position,
			player.global_position if player else Vector2.ZERO,
			terminal_id,
			"interact"
		)
		
		var success = terminal_communication.send_terminal_interaction(interaction_data)
		if success:
			print("✅ Terminal interaction data sent to parent repo successfully")
		else:
			print("❌ Failed to send terminal interaction data to parent repo")
	
	# Use DI behavior if available
	if terminal_behavior:
		var result = terminal_behavior.process_interaction(player)
		print("Terminal behavior result: ", result)
	
	# You can add more interaction logic here
	# For example, opening a UI, triggering events, etc.

func get_terminal_type() -> String:
	return terminal_type

func get_terminal_description() -> String:
	return TerminalTileIdentifier.get_terminal_description(terminal_type)

func get_terminal_icon() -> String:
	return TerminalTileIdentifier.get_terminal_icon(terminal_type)

func can_interact() -> bool:
	# Check if terminal has behavior and behavior allows interaction
	if terminal_behavior:
		return terminal_behavior.can_interact(null)  # Pass null as player for now
	
	# Default to true if no behavior is set
	return true

# DI Integration
func set_terminal_behavior(behavior: ITerminalBehavior) -> void:
	terminal_behavior = behavior

func set_terminal_communication(communication: ITerminalCommunication) -> void:
	terminal_communication = communication 