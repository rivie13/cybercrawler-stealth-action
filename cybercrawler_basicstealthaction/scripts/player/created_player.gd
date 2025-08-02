class_name CreatedPlayer
extends CharacterBody2D

# Injected dependencies
var input_behavior: IPlayerInputBehavior
var communication_behavior: ICommunicationBehavior  

# Components (composition)
var movement_component: PlayerMovementComponent
var interaction_component: PlayerInteractionComponent

# Visual feedback
@onready var debug_label: Label = $"../../UI/DebugInfo"
@onready var player_sprite: Sprite2D = $BasicPlayer
@onready var player_details: Node2D = $Visuals/PlayerDetails
@onready var interaction_indicator: ColorRect = $Visuals/InteractionIndicator
@onready var shadow: ColorRect = $Visuals/Shadow

# Isometric movement system
var isometric_offset: Vector2 = Vector2(8, 4)  # Half tile size for isometric positioning (16x8 tiles)

func initialize(container: DIContainer) -> void:
	# Dependency injection
	input_behavior = container.get_implementation("IPlayerInputBehavior")
	communication_behavior = container.get_implementation("ICommunicationBehavior")
	
	# Create components
	movement_component = PlayerMovementComponent.new()
	interaction_component = PlayerInteractionComponent.new()
	
	# Validate dependencies
	if not input_behavior:
		push_error("CreatedPlayer: IPlayerInputBehavior not found in DI container")
	if not communication_behavior:
		push_error("CreatedPlayer: ICommunicationBehavior not found in DI container")

func _ready() -> void:
	# Add to player group for identification
	add_to_group("players")

func _physics_process(delta: float) -> void:
	if not input_behavior:
		return
		
	# Update input (for real input implementations)
	if input_behavior.has_method("update_input"):
		input_behavior.update_input()
	
	# Handle movement
	_handle_movement(delta)
	
	# Handle interactions
	_handle_interactions()
	
	# Update isometric effects
	_update_isometric_effects()
	
	# Update visual effects
	_update_visual_effects()
	
	# Update debug info
	_update_debug_info()

func _handle_movement(_delta: float) -> void:
	var input_direction = input_behavior.get_current_input()
	# Use 2D movement for isometric world
	velocity = input_direction * movement_component.speed
	move_and_slide()

func _handle_interactions() -> void:
	# Find nearby terminals using 2D position
	var target = interaction_component.find_interaction_target(global_position)
	input_behavior.set_interaction_target(target)
	
	# Handle interaction input
	if Input.is_action_just_pressed("interact") and interaction_component.can_interact():
		_perform_interaction()

func _perform_interaction() -> void:
	var target = interaction_component.get_interaction_target()
	if target and target.has_method("interact_with_player"):
		# Notify external systems through DI
		if communication_behavior:
			communication_behavior.handle_terminal_interaction(
				target.terminal_type if target.has_method("get_terminal_type") else "unknown",
				{"player_position": global_position, "timestamp": Time.get_time_dict_from_system()}
			)
		
		# Perform actual interaction
		target.interact_with_player(self)

func _update_isometric_effects() -> void:
	# Isometric: Update visual effects based on position
	# This can include depth sorting, shadows, etc.
	pass

func _update_visual_effects() -> void:
	# Update stealth visual effects
	if input_behavior and input_behavior.is_stealth_action_active():
		# Stealth effect - make player smaller and more transparent
		if player_sprite:
			player_sprite.scale = Vector2(0.8, 0.8)
			player_sprite.modulate = Color(1, 1, 1, 0.6)
		
		if player_details:
			player_details.scale = Vector2(0.8, 0.8)
			for child in player_details.get_children():
				if child is ColorRect:
					child.modulate = Color(1, 1, 1, 0.6)
	else:
		# Normal visibility
		if player_sprite:
			player_sprite.scale = Vector2(1, 1)
			player_sprite.modulate = Color(1, 1, 1, 1)
		
		if player_details:
			player_details.scale = Vector2(1, 1)
			for child in player_details.get_children():
				if child is ColorRect:
					child.modulate = Color(1, 1, 1, 1)
	
	# Show interaction indicator when near terminals
	if interaction_component and interaction_component.can_interact():
		if interaction_indicator:
			interaction_indicator.visible = true
	else:
		if interaction_indicator:
			interaction_indicator.visible = false

func _update_debug_info() -> void:
	if debug_label:
		var debug_text = "Player Status:\n"
		debug_text += "Position: %.1f, %.1f\n" % [global_position.x, global_position.y]
		debug_text += "Moving: %s\n" % input_behavior.is_moving()
		debug_text += "Stealth: %s\n" % input_behavior.is_stealth_action_active()
		
		var target = interaction_component.get_interaction_target()
		debug_text += "Can Interact: %s" % (target != null)
		
		debug_label.text = debug_text

# Public API for external systems
func get_player_position() -> Vector2:
	return global_position

func is_moving() -> bool:
	return movement_component.is_moving() if movement_component else false

func is_in_stealth_mode() -> bool:
	return input_behavior.is_stealth_action_active() if input_behavior else false

# Method for external collision system to control velocity
func force_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity
