class_name TerminalSpawner
extends Node2D

@export var terminal_scene: PackedScene
@export var tilemap: TileMapLayer
var di_container: DIContainer

# Terminal tile atlas coordinates to replace (from TerminalTileIdentifier)
var terminal_atlas_coords: Array[Vector2i] = []

func _ready():
	# Initialize terminal atlas coordinates
	terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	if tilemap and di_container:
		spawn_terminals()

func spawn_terminals():
	# Check if tilemap is available
	if not tilemap:
		print("❌ TerminalSpawner: Tilemap not set, cannot spawn terminals")
		return
	
	# Get all used cells from tilemap
	var used_cells = tilemap.get_used_cells()
	
	print("🔍 Checking ", used_cells.size(), " tiles for terminals...")
	
	for cell_pos in used_cells:
		var source_id = tilemap.get_cell_source_id(cell_pos)
		var atlas_coords = tilemap.get_cell_atlas_coords(cell_pos)
		
		# Debug: Print tile information
		print("🔍 Tile at ", cell_pos, " has source_id: ", source_id, " atlas_coords: ", atlas_coords)
		
		# Check if this is a terminal tile using atlas coordinates
		if atlas_coords in terminal_atlas_coords:
			# Get terminal type from atlas coordinates
			var terminal_type = TerminalTileIdentifier.get_terminal_type_from_atlas(atlas_coords)
			var terminal_description = TerminalTileIdentifier.get_terminal_description(terminal_type)
			var terminal_icon = TerminalTileIdentifier.get_terminal_icon(terminal_type)
			
			print("🎯 Found terminal tile at ", cell_pos, " - Type: ", terminal_type, " ", terminal_icon, " - ", terminal_description)
			
			# Instead of creating new objects, we'll add interaction behavior to the existing tiles
			# Create a StaticBody2D as a child of the tilemap for this position
			var terminal_body = StaticBody2D.new()
			terminal_body.name = "Terminal_" + str(cell_pos.x) + "_" + str(cell_pos.y)
			
			# Add collision shape (same size as tile)
			var collision_shape = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(16, 16)  # Assuming 16x16 tiles
			collision_shape.shape = shape
			terminal_body.add_child(collision_shape)
			
			# Position the body at the tile position
			terminal_body.global_position = tilemap.map_to_local(cell_pos)
			
			# Add terminal behavior script
			var terminal_script = load("res://scripts/terminals/TerminalTile.gd")
			terminal_body.set_script(terminal_script)
			terminal_body.terminal_type = terminal_type
			terminal_body.terminal_name = terminal_body.name
			terminal_body.terminal_id = "terminal_" + str(cell_pos.x) + "_" + str(cell_pos.y)
			
			# Set up DI behavior
			if di_container:
				var terminal_behavior = di_container.get_implementation("ITerminalBehavior")
				if terminal_behavior:
					terminal_body.set_terminal_behavior(terminal_behavior)
				
				# Set up terminal communication
				var terminal_communication = di_container.get_implementation("ITerminalCommunication")
				if terminal_communication:
					terminal_body.set_terminal_communication(terminal_communication)
			
			# Add to tilemap as child
			tilemap.add_child(terminal_body)
			
			# Add to terminals group for interaction detection
			terminal_body.add_to_group("terminals")
			
			print("✅ Terminal spawned successfully: ", terminal_type, " at ", cell_pos)
		else:
			print("❌ Tile at ", cell_pos, " is not a terminal (atlas_coords: ", atlas_coords, ")")

# Debug function to print all terminal types
func debug_print_terminal_types():
	print("🔍 Available terminal types:")
	TerminalTileIdentifier.debug_print_terminals() 
