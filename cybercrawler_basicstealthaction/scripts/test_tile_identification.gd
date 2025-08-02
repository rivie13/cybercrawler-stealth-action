extends Node

# Test script to verify tile identification system
func _ready():
	print("🧪 Testing Tile Identification System")
	
	# Test TerminalTileIdentifier
	test_terminal_identification()
	
	# Test with actual tilemap
	test_tilemap_scan()

func test_terminal_identification():
	print("\n🔍 Testing TerminalTileIdentifier...")
	
	# Test known terminal coordinates
	var test_coords = [
		Vector2i(9, 1),
		Vector2i(11, 1),
		Vector2i(9, 3),
		Vector2i(11, 3),
		Vector2i(5, 5),  # Non-terminal
	]
	
	for coords in test_coords:
		var is_terminal = TerminalTileIdentifier.is_terminal_tile(coords)
		var terminal_type = TerminalTileIdentifier.get_terminal_type_from_atlas(coords)
		print("  Coords ", coords, ": is_terminal=", is_terminal, ", type=", terminal_type)
	
	# Print all terminal coordinates
	TerminalTileIdentifier.debug_print_terminals()

func test_tilemap_scan():
	print("\n🔍 Testing TileMap Scan...")
	
	# Find the tilemap in the scene
	var tilemap = get_node_or_null("../TileMapLayer")
	if not tilemap:
		print("❌ TileMapLayer not found in scene")
		return
	
	print("✅ Found TileMapLayer")
	
	# Get all used cells
	var used_cells = tilemap.get_used_cells()
	print("📊 Found ", used_cells.size(), " used cells")
	
	# Scan for terminals
	var terminal_count = 0
	for cell_pos in used_cells:
		var atlas_coords = tilemap.get_cell_atlas_coords(cell_pos)
		var source_id = tilemap.get_cell_source_id(cell_pos)
		
		if TerminalTileIdentifier.is_terminal_tile(atlas_coords):
			terminal_count += 1
			var terminal_type = TerminalTileIdentifier.get_terminal_type_from_atlas(atlas_coords)
			print("🎯 Found terminal at ", cell_pos, " (atlas: ", atlas_coords, ") type: ", terminal_type)
	
	print("📊 Total terminals found: ", terminal_count) 