class_name TerminalDetector
extends Node2D

# Visual indicator for terminal tiles
var terminal_indicators: Array[Node2D] = []

func _ready():
	# Wait a frame to ensure everything is loaded
	await get_tree().process_frame
	detect_and_mark_terminals()

func detect_and_mark_terminals():
	print("🔍 TerminalDetector: Scanning for terminal tiles...")
	
	# Find the tilemap
	var tilemap = get_node_or_null("../TileMapLayer")
	if not tilemap:
		print("❌ TerminalDetector: TileMapLayer not found")
		return
	
	# Clear existing indicators
	clear_indicators()
	
	# Scan all used cells
	var used_cells = tilemap.get_used_cells()
	var terminal_count = 0
	
	for cell_pos in used_cells:
		var atlas_coords = tilemap.get_cell_atlas_coords(cell_pos)
		var source_id = tilemap.get_cell_source_id(cell_pos)
		
		# Check if this is a terminal tile
		if TerminalTileIdentifier.is_terminal_tile(atlas_coords):
			terminal_count += 1
			var terminal_type = TerminalTileIdentifier.get_terminal_type_from_atlas(atlas_coords)
			
			# Create visual indicator
			create_terminal_indicator(cell_pos, tilemap, terminal_type)
			
			print("🎯 Found terminal at ", cell_pos, " (atlas: ", atlas_coords, ") type: ", terminal_type)
	
	print("📊 TerminalDetector: Found ", terminal_count, " terminal tiles")

func create_terminal_indicator(cell_pos: Vector2i, tilemap: TileMapLayer, terminal_type: String):
	# Get world position of the tile
	var world_pos = tilemap.map_to_local(cell_pos)
	
	# Create indicator node
	var indicator = Node2D.new()
	indicator.position = world_pos
	indicator.name = "TerminalIndicator_" + str(cell_pos.x) + "_" + str(cell_pos.y)
	
	# Create visual representation
	var visual = ColorRect.new()
	visual.size = Vector2(16, 8)  # Match tile size
	visual.position = Vector2(-8, -4)  # Center on tile
	visual.color = Color(1, 0, 0, 0.5)  # Semi-transparent red
	indicator.add_child(visual)
	
	# Add label
	var label = Label.new()
	label.text = terminal_type
	label.position = Vector2(-20, -20)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_font_size_override("font_size", 8)
	indicator.add_child(label)
	
	# Add to scene
	add_child(indicator)
	terminal_indicators.append(indicator)

func clear_indicators():
	for indicator in terminal_indicators:
		if is_instance_valid(indicator):
			indicator.queue_free()
	terminal_indicators.clear()

func _input(event):
	# Toggle indicators with T key
	if event.is_action_pressed("ui_accept"):  # Space bar
		if terminal_indicators.size() > 0:
			clear_indicators()
			print("🔍 TerminalDetector: Hidden terminal indicators")
		else:
			detect_and_mark_terminals()
			print("🔍 TerminalDetector: Showed terminal indicators") 