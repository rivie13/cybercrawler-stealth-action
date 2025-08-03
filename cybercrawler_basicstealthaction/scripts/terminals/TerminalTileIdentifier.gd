class_name TerminalTileIdentifier
extends RefCounted

# Terminal tile atlas coordinates (from your tileset)
# These are the coordinates of terminal sprites in your tileset
static var TERMINAL_ATLAS_COORDS = [
	Vector2i(9, 1),   # Main Terminal - Data packet release
	Vector2i(11, 1),  # Tower Terminal - Tower placement
	Vector2i(9, 3),   # Mine Terminal - Mine deployment
	Vector2i(11, 3),  # Upgrade Terminal - Tower upgrades
]

# Terminal type constants for tower defense mechanics
enum TerminalType {
	MAIN_TERMINAL,      # Primary win condition - release data packet
	TOWER_TERMINAL,     # Deploy and manage defensive towers
	MINE_TERMINAL,      # Place freeze mines and tactical devices
	UPGRADE_TERMINAL,   # Enhance existing towers and systems
	UNKNOWN_TERMINAL    # Fallback for unidentified terminals
}

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
			return "main_terminal"      # Data packet release
		Vector2i(11, 1):
			return "tower_terminal"     # Tower placement
		Vector2i(9, 3):
			return "mine_terminal"      # Mine deployment
		Vector2i(11, 3):
			return "upgrade_terminal"   # Tower upgrades
		_:
			return "unknown_terminal"

# Get terminal type enum from string
static func get_terminal_enum_from_string(terminal_type: String) -> TerminalType:
	match terminal_type:
		"main_terminal":
			return TerminalType.MAIN_TERMINAL
		"tower_terminal":
			return TerminalType.TOWER_TERMINAL
		"mine_terminal":
			return TerminalType.MINE_TERMINAL
		"upgrade_terminal":
			return TerminalType.UPGRADE_TERMINAL
		_:
			return TerminalType.UNKNOWN_TERMINAL

# Get terminal description for UI/tooltips
static func get_terminal_description(terminal_type: String) -> String:
	match terminal_type:
		"main_terminal":
			return "Main Terminal - Release data packet into enemy network"
		"tower_terminal":
			return "Tower Terminal - Deploy defensive towers in cyberspace"
		"mine_terminal":
			return "Mine Terminal - Place tactical mines and devices"
		"upgrade_terminal":
			return "Upgrade Terminal - Enhance existing towers and systems"
		_:
			return "Unknown Terminal - Function unclear"

# Get terminal icon/visual identifier
static func get_terminal_icon(terminal_type: String) -> String:
	match terminal_type:
		"main_terminal":
			return "🎯"  # Target for main objective
		"tower_terminal":
			return "🏗️"  # Building for tower placement
		"mine_terminal":
			return "💣"  # Bomb for mine deployment
		"upgrade_terminal":
			return "⚡"  # Lightning for upgrades
		_:
			return "❓"  # Question mark for unknown

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
		var description = get_terminal_description(terminal_type)
		var icon = get_terminal_icon(terminal_type)
		print("  - Atlas coords: ", coords, " -> Type: ", terminal_type, " ", icon, " - ", description) 