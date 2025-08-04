class_name CreatedPlayer
extends CharacterBody2D

# Injected dependencies
var input_behavior: IPlayerInputBehavior
var communication_behavior: ICommunicationBehavior  

# Components (composition)
var movement_component: PlayerMovementComponent
var interaction_component: PlayerInteractionComponent

# Visual feedback
@onready var debug_label: Label
@onready var player_sprite: Sprite2D = $BasicPlayer
@onready var player_details: Node2D = $Visuals/PlayerDetails
@onready var interaction_indicator: ColorRect = $Visuals/InteractionIndicator
@onready var shadow: ColorRect = $Visuals/Shadow
# Remove @onready for cyberpunk_ui to avoid null reference issues
var cyberpunk_ui: Control

# Isometric movement system
var isometric_offset: Vector2 = Vector2(8, 4)  # Half tile size for isometric positioning (16x8 tiles)

# Interaction optimization
var last_player_position: Vector2 = Vector2.ZERO
# Removed cooldown system for immediate range checking

func initialize(container: DIContainer) -> void:
	# Dependency injection
	input_behavior = container.get_implementation("IPlayerInputBehavior")
	communication_behavior = container.get_implementation("ICommunicationBehavior")
	
	# Create components
	movement_component = PlayerMovementComponent.new()
	interaction_component = PlayerInteractionComponent.new()
	
	# Get tilemap reference for interaction component
	var tilemap = get_parent().get_node_or_null("TileMapLayer")
	if tilemap and interaction_component:
		interaction_component.set_tilemap(tilemap)
	
	# Validate dependencies
	if not input_behavior:
		push_error("CreatedPlayer: IPlayerInputBehavior not found in DI container")
	if not communication_behavior:
		push_error("CreatedPlayer: ICommunicationBehavior not found in DI container")

func _ready() -> void:
	# Add to player group for identification
	add_to_group("players")
	# Initialize last position
	last_player_position = global_position
	
	# Initialize cyberpunk_ui properly
	cyberpunk_ui = get_node_or_null("CyberpunkUI")

func _physics_process(delta: float) -> void:
	if not input_behavior:
		return
		
	# Update input (for real input implementations)
	if input_behavior.has_method("update_input"):
		input_behavior.update_input()
	
	# Handle movement
	_handle_movement(delta)
	
	# Handle interactions (optimized to prevent infinite loops)
	_handle_interactions(delta)
	
	# Update isometric effects
	_update_isometric_effects()
	
	# Update visual effects
	_update_visual_effects()
	
	# Update debug info
	_update_debug_info()

func _handle_movement(delta: float) -> void:
	if not input_behavior:
		return
		
	var input_direction = input_behavior.get_current_input()
	# Use the movement component to calculate velocity with smooth acceleration
	if movement_component:
		velocity = movement_component.update_movement(delta, input_direction)
	else:
		# Fallback when movement component is not available
		velocity = input_direction * 100.0  # Basic movement without acceleration
	move_and_slide()

func _handle_interactions(_delta: float) -> void:
	# Only do terminal searching if we have the required components
	if not input_behavior or not interaction_component:
		return
		
	# Check if player moved significantly
	var should_search = false
	if global_position.distance_to(last_player_position) > 1.0:
		should_search = true
		last_player_position = global_position
	
	# IMMEDIATE search - no cooldown for range checking
	if should_search or not interaction_component.can_interact():
		# Find nearby terminals using 2D position
		var target = interaction_component.find_interaction_target(global_position)
		input_behavior.set_interaction_target(target)
	
	# Handle interaction input - IMMEDIATE range check
	if Input.is_action_just_pressed("interact"):
		# CRITICAL: Check distance every time, not just rely on cached target
		if interaction_component and _can_interact_with_current_target():
			_perform_interaction()
	elif Input.is_action_just_pressed("ui_accept"):
		# CRITICAL: Check distance every time, not just rely on cached target
		if interaction_component and _can_interact_with_current_target():
			_perform_interaction()

func _can_interact_with_current_target() -> bool:
	# Check if we have a target AND it's within range
	var target = interaction_component.get_interaction_target()
	if not target:
		return false
	
	# Check distance to target
	var distance = global_position.distance_to(target.global_position)
	var max_range = interaction_component.interaction_range
	
	# Only allow interaction if within range
	return distance <= max_range

func _perform_interaction() -> void:
	if not interaction_component:
		print("❌ ERROR: No interaction component available")
		return
		
	var target = interaction_component.get_interaction_target()
	print("🔍 DEBUG: Attempting interaction with target: ", target)
	
	if target and target.has_method("interact_with_player"):
		# Log successful interaction
		print("🎯 SUCCESSFUL INTERACTION: Player interacted with terminal '%s'" % target.name)
		
		# Show cyberpunk UI
		if cyberpunk_ui:
			if cyberpunk_ui.has_method("show_interaction_ui"):
				var terminal_type = target.terminal_type if target.has_method("get_terminal_type") else "unknown"
				cyberpunk_ui.show_interaction_ui(terminal_type)
		
		# Notify external systems through DI
		if communication_behavior:
			communication_behavior.handle_terminal_interaction(
				target.terminal_type if target.has_method("get_terminal_type") else "unknown",
				{"player_position": global_position, "timestamp": Time.get_time_dict_from_system()}
			)
		
		# Perform actual interaction
		target.interact_with_player(self)
		
		# Update debug label with interaction success
		if debug_label:
			var current_text = debug_label.text
			debug_label.text = current_text + "\n✅ INTERACTION SUCCESS!"
			
			# Clear the success message after 2 seconds
			var timer = get_tree().create_timer(2.0)
			await timer.timeout
			if debug_label and is_instance_valid(debug_label):
				debug_label.text = current_text
	else:
		print("❌ ERROR: No valid interaction target found")

func show_fallback_interaction_ui(target: Node) -> void:
	# Create a simple popup message as fallback
	var popup = AcceptDialog.new()
	popup.title = "TERMINAL ACCESS"
	popup.dialog_text = "JACKING INTO " + (target.terminal_type if target.has_method("get_terminal_type") else "UNKNOWN") + "...\n\nACCESS GRANTED"
	popup.add_theme_color_override("font_color", Color(0, 255, 255))  # Cyan
	popup.add_theme_font_size_override("font_size", 16)
	
	# Add to scene safely
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.add_child(popup)
		popup.popup_centered()
		
		# Auto-close after 3 seconds
		var timer = get_tree().create_timer(3.0)
		await timer.timeout
		if is_instance_valid(popup):
			popup.queue_free()
	else:
		# Fallback for test environment
		print("❌ WARNING: No current scene available for popup")

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
			# Pulse the indicator
			var time_dict = Time.get_time_dict_from_system()
			var seconds = time_dict.get("second", 0)  # Use "second" key from time dict
			var alpha = 0.3 + 0.7 * sin(seconds * 3.0)  # Pulse every 3 seconds
			interaction_indicator.modulate = Color(1, 1, 0, alpha)
	else:
		if interaction_indicator:
			interaction_indicator.visible = false

func _update_debug_info() -> void:
	# Try to find debug label if not found
	if not debug_label:
		debug_label = get_node_or_null("../UI/DebugInfo")
		if not debug_label:
			debug_label = get_node_or_null("../../UI/DebugInfo")
		if not debug_label:
			debug_label = get_node_or_null("../../../UI/DebugInfo")
		if not debug_label:
			debug_label = get_node_or_null("/root/Main/UI/DebugInfo")
		if not debug_label:
			return  # Skip if no debug label found
	
	if debug_label:
		var debug_text = "Player Status:\n"
		debug_text += "Position: %.1f, %.1f\n" % [global_position.x, global_position.y]
		debug_text += "Moving: %s\n" % input_behavior.is_moving()
		debug_text += "Stealth: %s\n" % input_behavior.is_stealth_action_active()
		
		var target = interaction_component.get_interaction_target()
		debug_text += "Can Interact: %s\n" % (target != null)
		
		if target:
			debug_text += "Target: %s\n" % target.name
			if target.has_method("get_terminal_type"):
				debug_text += "Type: %s" % target.get_terminal_type()
		
		debug_label.text = debug_text
	else:
		# Fallback: print to console
		print("Player Status - Position: %.1f, %.1f, Moving: %s, Stealth: %s" % [
			global_position.x, global_position.y, 
			input_behavior.is_moving(), 
			input_behavior.is_stealth_action_active()
		])

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
