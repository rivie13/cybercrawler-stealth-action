class_name Terminal2D
extends StaticBody3D

@onready var terminal_sprite = $Visuals/TerminalSprite
@onready var shadow = $Visuals/Shadow
@onready var terminal_details = $Visuals/TerminalDetails

var terminal_type: String = "default"
var is_active: bool = true

func _ready():
	# Add to terminal group for identification
	add_to_group("terminals")

func _process(delta):
	_update_true_2_5d_effects()

func _update_true_2_5d_effects():
	# TRUE 2.5D: Calculate depth based on Z position
	var z_pos = global_position.z
	var depth = clamp(z_pos / 10.0, 0.0, 1.0)
	
	# Apply dramatic depth scaling - objects further back are much smaller
	var depth_scale = 1.0 - (depth * 0.6)
	
	# Apply depth-based positioning effect
	var depth_offset = depth * 2.0
	
	if terminal_sprite:
		terminal_sprite.scale = Vector3(depth_scale, depth_scale, depth_scale)
		terminal_sprite.position.y = depth_offset
		# Make terminals more visible
		terminal_sprite.modulate = Color(0.1, 0.3, 0.5, 1)
	
	if shadow:
		shadow.scale = Vector3(depth_scale, depth_scale, depth_scale)
		shadow.modulate.a = 0.3 - (depth * 0.5)
		shadow.position.y = depth_offset + 0.1
	
	if terminal_details:
		terminal_details.scale = Vector3(depth_scale, depth_scale, depth_scale)
		terminal_details.position.y = depth_offset
		# Make screen glow more visible
		var screen = terminal_details.get_node_or_null("Screen")
		if screen:
			screen.modulate = Color(0, 0.8, 1, 1)  # Bright cyan
		var screen_glow = terminal_details.get_node_or_null("ScreenGlow")
		if screen_glow:
			screen_glow.modulate = Color(0, 0.6, 0.8, 0.8)  # Bright glow

func interact_with_player(player):
	if is_active:
		print("Terminal ", terminal_type, " interacted with player at position: ", player.get_player_position())
		# Add visual feedback
		if terminal_sprite:
			terminal_sprite.modulate = Color(1, 1, 0, 1)  # Yellow flash
			await get_tree().create_timer(0.2).timeout
			terminal_sprite.modulate = Color(0.1, 0.3, 0.5, 1)  # Back to normal

func get_terminal_type() -> String:
	return terminal_type 