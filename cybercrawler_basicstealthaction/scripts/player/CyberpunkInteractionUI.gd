class_name CyberpunkInteractionUI
extends Control

# Cyberpunk UI elements
var interaction_label: Label
var status_label: Label
var progress_bar: ProgressBar
var glitch_timer: Timer

# Animation properties
var ui_visible: bool = false
var alpha: float = 0.0
var target_alpha: float = 0.0

func _ready():
	setup_ui()
	setup_timers()
	hide_ui()
	# Make sure we're on top of other UI elements
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func setup_ui():
	# Create main container - position it properly on screen
	var container = VBoxContainer.new()
	# DON'T use PRESET_CENTER - it makes it huge!
	container.custom_minimum_size = Vector2(7, 2)  # MICROSCOPIC container - 2 pixels wide, 2 pixels tall
	container.add_theme_constant_override("separation", 0)  # NO SPACING
	add_child(container)
	
	# Create MICROSCOPIC labels for 16x16 pixel world
	interaction_label = Label.new()
	interaction_label.text = "TERMINAL ACCESS"
	interaction_label.add_theme_font_size_override("font_size", 7)  # MICROSCOPIC font - 7 pixels
	interaction_label.add_theme_color_override("font_color", Color(0, 255, 255))  # Cyan
	interaction_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(interaction_label)
	
	# Create status label
	status_label = Label.new()
	status_label.text = "JACKING IN..."
	status_label.add_theme_font_size_override("font_size", 7)  # MICROSCOPIC font - 7 pixels
	status_label.add_theme_color_override("font_color", Color(255, 255, 0))  # Yellow
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(status_label)
	
	# Create MICROSCOPIC progress bar for 16x16 pixel world
	progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(7, 1)  # MICROSCOPIC progress bar - 7 pixels wide, 1 pixels tall
	progress_bar.max_value = 100
	progress_bar.value = 0
	progress_bar.add_theme_stylebox_override("fill", create_cyberpunk_stylebox())
	progress_bar.add_theme_constant_override("h_separation", 0)  # No spacing
	progress_bar.add_theme_constant_override("v_separation", 0)  # No spacing
	container.add_child(progress_bar)
	
	# Set up container styling
	container.add_theme_constant_override("separation", 10)

func position_ui_above_terminal():
	# Get the current interaction target from the player
	var player = get_parent()
	if player and player.has_method("get_interaction_target"):
		var terminal = player.get_interaction_target()
		if terminal:
			print("🎯 PROOF: Terminal found!")
			print("🎯 PROOF: Terminal name: ", terminal.name)
			print("🎯 PROOF: Terminal global_position: ", terminal.global_position)
			print("🎯 PROOF: Terminal has get_global_position method: ", terminal.has_method("get_global_position"))
			
			# Convert world position to screen position
			var camera = get_viewport().get_camera_2d()
			if camera:
				print("🎯 PROOF: Camera found!")
				print("🎯 PROOF: Camera zoom: ", camera.zoom)
				print("🎯 PROOF: Camera global_position: ", camera.global_position)
				
				# Convert world coordinates to screen coordinates
				var screen_pos = camera.to_screen(terminal.global_position)
				print("🎯 PROOF: Terminal screen position: ", screen_pos)
				
				# Position UI above the terminal - use the actual screen coordinates
				position = screen_pos + Vector2(-10, -20)  # Center horizontally, 20 pixels above terminal
				print("📱 PROOF: UI positioned at screen coordinates: ", position)
				print("📱 PROOF: UI global_position: ", global_position)
			else:
				print("❌ No camera found for coordinate conversion")
		else:
			print("❌ No terminal found for UI positioning")
	else:
		print("❌ Player not found or doesn't have get_interaction_target method")

func create_cyberpunk_stylebox() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 255, 255, 0.8)  # Cyan with alpha
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color(255, 255, 0)  # Yellow border
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	return style

func setup_timers():
	glitch_timer = Timer.new()
	glitch_timer.wait_time = 0.1
	glitch_timer.timeout.connect(_on_glitch_timer_timeout)
	add_child(glitch_timer)

func show_interaction_ui(terminal_type: String):
	print("🎮 Showing interaction UI for: ", terminal_type)
	ui_visible = true
	target_alpha = 1.0
	
	# Update labels with cyberpunk text
	interaction_label.text = "TERMINAL ACCESS"
	status_label.text = "JACKING INTO " + terminal_type.to_upper()
	
	# Start progress animation
	progress_bar.value = 0
	progress_bar.max_value = 100
	
	# Position UI above the terminal
	position_ui_above_terminal()
	
	# Start glitch effect
	glitch_timer.start()
	
	# Animate in
	modulate.a = 0.0
	show()
	
	# Animate progress bar
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", 100, 2.0)
	tween.tween_callback(_on_hacking_complete)

func hide_ui():
	ui_visible = false
	target_alpha = 0.0
	glitch_timer.stop()
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(hide)

func _on_glitch_timer_timeout():
	if ui_visible:
		# Add cyberpunk glitch effect
		var glitch_offset = Vector2(randf_range(-3, 3), randf_range(-3, 3))
		interaction_label.position += glitch_offset
		status_label.position += glitch_offset
		
		# Add color glitch effect
		var glitch_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 0.8)
		interaction_label.add_theme_color_override("font_color", glitch_color)
		status_label.add_theme_color_override("font_color", glitch_color)
		
		# Reset position and color after a short delay
		await get_tree().create_timer(0.03).timeout
		interaction_label.position -= glitch_offset
		status_label.position -= glitch_offset
		
		# Reset colors
		interaction_label.add_theme_color_override("font_color", Color(0, 255, 255))
		status_label.add_theme_color_override("font_color", Color(255, 255, 0))

func _on_hacking_complete():
	status_label.text = "ACCESS GRANTED"
	status_label.add_theme_color_override("font_color", Color(0, 255, 0))  # Green
	
	# Start cyberpunk glitch animation
	start_cyberpunk_glitch_animation()
	
	# Hide after showing completion
	await get_tree().create_timer(2.0).timeout
	hide_ui()

func start_cyberpunk_glitch_animation():
	# Create a camera zoom effect that looks like glitching into cyberspace
	var camera = get_viewport().get_camera_2d()
	if camera:
		# Store original camera properties
		var original_zoom = camera.zoom
		var original_position = camera.global_position
		
		# Get TERMINAL position instead of player position
		var player = get_parent()
		var terminal = player.get_interaction_target() if player and player.has_method("get_interaction_target") else null
		var target_position = terminal.global_position if terminal else (player.global_position if player else original_position)
		
		# Create intense glitch effect
		var glitch_tween = create_tween()
		glitch_tween.set_parallel(true)
		
		# Zoom INTO the terminal (LARGER zoom values = zoom in)
		# THIS IS WHERE THE ZOOM IN IS SET!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		var zoom_in_value = Vector2(25.0, 25.0)  # This will zoom IN INTENSELY 3 = NO ZOOM IN SO NEED HIGHER THAN 3 ALWAYS!!!!!!!!!!!!!!!!!!!!!!
		print("🔍 Zooming IN to: ", zoom_in_value)
		glitch_tween.tween_property(camera, "zoom", zoom_in_value, 0.8)
		
		# Move camera to player/terminal position
		glitch_tween.tween_property(camera, "global_position", target_position, 0.8)
		
		# Add screen shake for glitch effect
		for i in range(20):
			var shake_offset = Vector2(randf_range(-3, 3), randf_range(-3, 3))
			glitch_tween.tween_property(camera, "global_position", 
				target_position + shake_offset, 0.05)
			glitch_tween.tween_property(camera, "global_position", 
				target_position, 0.05)
		
		# Add color distortion effect
		var color_rect = ColorRect.new()
		color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		color_rect.color = Color(0, 255, 255, 0.3)  # Cyan overlay
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		get_tree().current_scene.add_child(color_rect)
		
		# Animate the color overlay
		var color_tween = create_tween()
		color_tween.tween_property(color_rect, "modulate:a", 0.0, 0.8)
		color_tween.tween_callback(color_rect.queue_free)
		
		# Reset camera after animation
		await get_tree().create_timer(1.0).timeout
		var reset_tween = create_tween()
		reset_tween.tween_property(camera, "zoom", original_zoom, 0.5)
		reset_tween.tween_property(camera, "global_position", original_position, 0.5)

func _process(delta):
	# Smooth alpha transition
	if modulate.a != target_alpha:
		modulate.a = lerp(modulate.a, target_alpha, delta * 5.0) 