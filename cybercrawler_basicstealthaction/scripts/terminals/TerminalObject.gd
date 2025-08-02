class_name TerminalObject
extends StaticBody2D

@export var terminal_type: String = "basic_terminal"
@export var terminal_name: String = "Terminal"
@export var sprite_texture: Texture2D

# DI Integration
var terminal_behavior: ITerminalBehavior

func _ready():
	# Add to terminals group for easy finding
	add_to_group("terminals")
	
	# Create visual representation using your sprite
	if sprite_texture:
		var sprite = Sprite2D.new()
		sprite.texture = sprite_texture
		sprite.position = Vector2.ZERO
		add_child(sprite)
	else:
		# Fallback visual
		var visual = ColorRect.new()
		visual.size = Vector2(16, 16)
		visual.position = Vector2(-8, -8)
		visual.color = Color(0.8, 0.4, 0.2)  # Brown color
		add_child(visual)
	
	# Create collision shape
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16, 16)
	collision.shape = shape
	add_child(collision)

func interact_with_player(player: Node) -> void:
	print("🎯 SUCCESSFUL INTERACTION: Player interacted with terminal '%s' at position %s" % [terminal_name, global_position])
	
	# Use DI behavior if available
	if terminal_behavior:
		var result = terminal_behavior.process_interaction(player)
		print("Terminal behavior result: ", result)
	
	# You can add more interaction logic here
	# For example, opening a UI, triggering events, etc.

func get_terminal_type() -> String:
	return terminal_type

func can_interact() -> bool:
	if terminal_behavior:
		return terminal_behavior.can_interact(self)
	return true

# DI Integration
func set_terminal_behavior(behavior: ITerminalBehavior) -> void:
	terminal_behavior = behavior 