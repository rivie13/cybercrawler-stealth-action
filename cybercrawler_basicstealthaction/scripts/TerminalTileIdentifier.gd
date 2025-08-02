class_name TerminalTileIdentifier
extends RefCounted

# Terminal tile atlas coordinates (from your tileset)
# These are the coordinates of terminal sprites in your tileset
static var TERMINAL_ATLAS_COORDS = [
	Vector2i(9, 1),   # Terminal sprite at (9,1)
	Vector2i(11, 1),  # Terminal sprite at (11,1) 
	Vector2i(9, 3),   # Terminal sprite at (9,3)
	Vector2i(11, 3),  # Terminal sprite at (11,3)
]

# Convert atlas coordinates to tile coordinates for TileMap
static func get_tile_coords_from_atlas(atlas_coords: Vector2i) -> Vector2i:
	return atlas_coords

# Check if a tile at given coordinates is a terminal
static func is_terminal_tile(atlas_coords: Vector2i) -> bool:
	return atlas_coords in TERMINAL_ATLAS_COORDS

# Get terminal type based on atlas coordinates
static func get_terminal_type_from_atlas(atlas_coords: Vector2i) -> String:
	match atlas_coords:
		Vector2i(9, 1):
			return "terminal_desk_1"
		Vector2i(11, 1):
			return "terminal_desk_2"
		Vector2i(9, 3):
			return "terminal_console_1"
		Vector2i(11, 3):
			return "terminal_console_2"
		_:
			return "unknown_terminal"

# Get all terminal atlas coordinates
static func get_all_terminal_coords() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for coord in TERMINAL_ATLAS_COORDS:
		result.append(coord)
	return result

# Debug function to print all terminal tiles
static func debug_print_terminals() -> void:
	print("🔍 Terminal tiles in tileset:")
	for coords in TERMINAL_ATLAS_COORDS:
		var terminal_type = get_terminal_type_from_atlas(coords)
		print("  - Atlas coords: ", coords, " -> Type: ", terminal_type) 