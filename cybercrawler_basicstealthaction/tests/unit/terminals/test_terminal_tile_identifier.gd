extends GutTest

class_name TestTerminalTileIdentifier

# Test data - known terminal coordinates
var known_terminal_coords = [
	Vector2i(9, 1),
	Vector2i(11, 1),
	Vector2i(9, 3),
	Vector2i(11, 3)
]

var non_terminal_coords = [
	Vector2i(5, 5),
	Vector2i(0, 0),
	Vector2i(15, 15),
	Vector2i(8, 2)
]

# Test atlas coordinate conversion
func test_get_tile_coords_from_atlas():
	# Arrange
	var test_coords = Vector2i(9, 1)
	
	# Act
	var result = TerminalTileIdentifier.get_tile_coords_from_atlas(test_coords)
	
	# Assert
	assert_eq(result, test_coords, "Should return the same coordinates")

# Test terminal tile identification with known terminals
func test_is_terminal_tile_with_known_terminals():
	for coords in known_terminal_coords:
		# Act
		var result = TerminalTileIdentifier.is_terminal_tile(coords)
		
		# Assert
		assert_true(result, "Should identify %s as terminal" % coords)

# Test terminal tile identification with non-terminals
func test_is_terminal_tile_with_non_terminals():
	for coords in non_terminal_coords:
		# Act
		var result = TerminalTileIdentifier.is_terminal_tile(coords)
		
		# Assert
		assert_false(result, "Should not identify %s as terminal" % coords)

# Test terminal type mapping for each known terminal
func test_get_terminal_type_from_atlas_known_terminals():
	# Test each known terminal coordinate
	var expected_types = {
		Vector2i(9, 1): "terminal_desk_1",
		Vector2i(11, 1): "terminal_desk_2", 
		Vector2i(9, 3): "terminal_console_1",
		Vector2i(11, 3): "terminal_console_2"
	}
	
	for coords in known_terminal_coords:
		# Act
		var result = TerminalTileIdentifier.get_terminal_type_from_atlas(coords)
		var expected = expected_types[coords]
		
		# Assert
		assert_eq(result, expected, "Should return correct type for %s" % coords)

# Test terminal type mapping for unknown coordinates
func test_get_terminal_type_from_atlas_unknown_coordinates():
	# Test unknown coordinates
	for coords in non_terminal_coords:
		# Act
		var result = TerminalTileIdentifier.get_terminal_type_from_atlas(coords)
		
		# Assert
		assert_eq(result, "unknown_terminal", "Should return unknown_terminal for %s" % coords)

# Test getting all terminal coordinates
func test_get_all_terminal_coords():
	# Act
	var result = TerminalTileIdentifier.get_all_terminal_coords()
	
	# Assert
	assert_eq(result.size(), known_terminal_coords.size(), "Should return correct number of coordinates")
	
	# Check that all known coordinates are in the result
	for coords in known_terminal_coords:
		assert_has(result, coords, "Should contain %s" % coords)

# Test that returned coordinates are the same as known coordinates
func test_get_all_terminal_coords_content():
	# Act
	var result = TerminalTileIdentifier.get_all_terminal_coords()
	
	# Assert - should contain exactly the same coordinates
	for i in range(known_terminal_coords.size()):
		assert_eq(result[i], known_terminal_coords[i], "Coordinate at index %d should match" % i)

# Test edge cases with boundary coordinates
func test_is_terminal_tile_edge_cases():
	var edge_cases = [
		Vector2i(8, 1),   # Just before first terminal
		Vector2i(10, 1),  # Between terminals
		Vector2i(12, 1),  # Just after last terminal
		Vector2i(9, 0),   # Above terminal
		Vector2i(9, 2),   # Below terminal
		Vector2i(9, 4)    # Far below terminal
	]
	
	for coords in edge_cases:
		# Act
		var result = TerminalTileIdentifier.is_terminal_tile(coords)
		
		# Assert
		assert_false(result, "Edge case %s should not be identified as terminal" % coords)

# Test terminal type mapping edge cases
func test_get_terminal_type_from_atlas_edge_cases():
	var edge_cases = [
		Vector2i(8, 1),
		Vector2i(10, 1),
		Vector2i(12, 1),
		Vector2i(9, 0),
		Vector2i(9, 2),
		Vector2i(9, 4)
	]
	
	for coords in edge_cases:
		# Act
		var result = TerminalTileIdentifier.get_terminal_type_from_atlas(coords)
		
		# Assert
		assert_eq(result, "unknown_terminal", "Edge case %s should return unknown_terminal" % coords)

# Test that all terminal coordinates are valid
func test_all_known_coordinates_are_valid():
	for coords in known_terminal_coords:
		# Act
		var is_terminal = TerminalTileIdentifier.is_terminal_tile(coords)
		var terminal_type = TerminalTileIdentifier.get_terminal_type_from_atlas(coords)
		
		# Assert
		assert_true(is_terminal, "Known coordinate %s should be identified as terminal" % coords)
		assert_ne(terminal_type, "unknown_terminal", "Known coordinate %s should have valid type" % coords)

# Test coordinate conversion with various inputs
func test_get_tile_coords_from_atlas_various_inputs():
	var test_cases = [
		Vector2i(0, 0),
		Vector2i(15, 15),
		Vector2i(-1, -1),
		Vector2i(100, 100)
	]
	
	for coords in test_cases:
		# Act
		var result = TerminalTileIdentifier.get_tile_coords_from_atlas(coords)
		
		# Assert
		assert_eq(result, coords, "Should return input coordinates unchanged for %s" % coords) 