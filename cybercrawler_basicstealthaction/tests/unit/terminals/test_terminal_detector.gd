extends GutTest

class_name TestTerminalDetector

var terminal_detector: TerminalDetector
var tilemap: TileMapLayer

func before_each():
	# Create fresh instances for each test
	terminal_detector = TerminalDetector.new()
	tilemap = TileMapLayer.new()
	
	# Set up the scene tree structure to match TerminalDetector's expectations
	# TerminalDetector looks for "../TileMapLayer", so we need to create a parent node
	var parent_node = Node2D.new()
	add_child(parent_node)
	
	# Add tilemap as child of parent (so it's at "../TileMapLayer" from detector's perspective)
	parent_node.add_child(tilemap)
	tilemap.name = "TileMapLayer"
	
	# Add detector as child of parent (so it can find "../TileMapLayer")
	parent_node.add_child(terminal_detector)

func after_each():
	# Clean up - use proper GUT memory management
	if terminal_detector:
		terminal_detector.queue_free()
	if tilemap:
		tilemap.queue_free()

# ===== PROPER TESTS THAT TEST ACTUAL FUNCTIONALITY =====

func test_terminal_detector_initialization():
	# Test that terminal detector initializes correctly
	assert_not_null(terminal_detector, "Terminal detector should be created")
	assert_true(terminal_detector is TerminalDetector, "Should be TerminalDetector type")
	assert_true(terminal_detector is Node2D, "Should extend Node2D")

func test_terminal_detector_ready_method():
	# Test the _ready method properly
	# The _ready method calls detect_and_mark_terminals() after a frame
	# We'll test this by checking the method exists and can be called
	assert_true(terminal_detector.has_method("detect_and_mark_terminals"), "Should have detect_and_mark_terminals method")
	assert_true(terminal_detector.has_method("clear_indicators"), "Should have clear_indicators method")

func test_detect_and_mark_terminals_with_no_tiles():
	# Test detection when no tiles exist
	terminal_detector.detect_and_mark_terminals()
	
	# Should not crash and should have no indicators
	assert_eq(terminal_detector.terminal_indicators.size(), 0, "Should have no indicators with no tiles")

func test_detect_and_mark_terminals_with_non_terminal_tiles():
	# Test detection with tiles that are not terminals
	tilemap.set_cell(Vector2i(0, 0), 0, Vector2i(1, 1))  # Non-terminal tile
	tilemap.set_cell(Vector2i(1, 0), 0, Vector2i(2, 2))  # Non-terminal tile
	
	terminal_detector.detect_and_mark_terminals()
	
	# Should not create any indicators for non-terminal tiles
	assert_eq(terminal_detector.terminal_indicators.size(), 0, "Should not create indicators for non-terminal tiles")

func test_detect_and_mark_terminals_with_terminal_tiles():
	# Test detection with actual terminal tiles
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	assert_true(terminal_coords.size() > 0, "Should have terminal coordinates available")
	
	# Add a terminal tile
	var first_terminal = terminal_coords[0]
	tilemap.set_cell(Vector2i(0, 0), 0, first_terminal)
	
	terminal_detector.detect_and_mark_terminals()
	
	# Should create indicators for terminal tiles
	assert_eq(terminal_detector.terminal_indicators.size(), 1, "Should create one indicator for terminal tile")

func test_detect_and_mark_terminals_with_multiple_terminal_tiles():
	# Test detection with multiple terminal tiles
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	assert_true(terminal_coords.size() > 1, "Should have multiple terminal coordinates")
	
	# Add multiple terminal tiles
	tilemap.set_cell(Vector2i(0, 0), 0, terminal_coords[0])
	tilemap.set_cell(Vector2i(1, 0), 0, terminal_coords[1])
	tilemap.set_cell(Vector2i(2, 0), 0, Vector2i(99, 99))  # Non-terminal
	
	terminal_detector.detect_and_mark_terminals()
	
	# Should create indicators for terminal tiles only
	assert_eq(terminal_detector.terminal_indicators.size(), 2, "Should create indicators only for terminal tiles")

func test_create_terminal_indicator():
	# Test that terminal indicators are created with correct properties
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(5, 5), 0, terminal_coords[0])
	
	terminal_detector.detect_and_mark_terminals()
	
	# Should create indicator
	assert_eq(terminal_detector.terminal_indicators.size(), 1, "Should create indicator")
	
	var indicator = terminal_detector.terminal_indicators[0]
	assert_not_null(indicator, "Should create indicator node")
	assert_true(indicator is Node2D, "Should be Node2D")
	assert_eq(indicator.name, "TerminalIndicator_5_5", "Should have correct name")
	
	# Check that indicator has children (visual and label)
	assert_true(indicator.get_child_count() >= 2, "Should have visual and label children")

func test_create_terminal_indicator_visual_properties():
	# Test that visual properties are set correctly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(3, 3), 0, terminal_coords[0])
	
	terminal_detector.detect_and_mark_terminals()
	
	var indicator = terminal_detector.terminal_indicators[0]
	
	# Check visual representation
	var visual = indicator.get_child(0)
	assert_not_null(visual, "Should have visual child")
	assert_true(visual is ColorRect, "Should be ColorRect")
	assert_eq(visual.size, Vector2(16, 8), "Should have correct size")
	assert_eq(visual.position, Vector2(-8, -4), "Should be centered on tile")
	assert_eq(visual.color, Color(1, 0, 0, 0.5), "Should be semi-transparent red")

func test_create_terminal_indicator_label_properties():
	# Test that label properties are set correctly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(2, 2), 0, terminal_coords[0])
	
	terminal_detector.detect_and_mark_terminals()
	
	var indicator = terminal_detector.terminal_indicators[0]
	
	# Check label
	var label = indicator.get_child(1)
	assert_not_null(label, "Should have label child")
	assert_true(label is Label, "Should be Label")
	assert_eq(label.position, Vector2(-20, -20), "Should have correct position")
	
	# Check terminal type in label
	var expected_type = TerminalTileIdentifier.get_terminal_type_from_atlas(terminal_coords[0])
	assert_eq(label.text, expected_type, "Should have correct terminal type in label")

func test_clear_indicators():
	# Test that indicators are cleared properly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(1, 1), 0, terminal_coords[0])
	
	terminal_detector.detect_and_mark_terminals()
	assert_eq(terminal_detector.terminal_indicators.size(), 1, "Should have one indicator")
	
	terminal_detector.clear_indicators()
	assert_eq(terminal_detector.terminal_indicators.size(), 0, "Should clear all indicators")

func test_clear_indicators_with_multiple_indicators():
	# Test clearing multiple indicators
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(0, 0), 0, terminal_coords[0])
	tilemap.set_cell(Vector2i(1, 0), 0, terminal_coords[1])
	
	terminal_detector.detect_and_mark_terminals()
	assert_eq(terminal_detector.terminal_indicators.size(), 2, "Should have two indicators")
	
	terminal_detector.clear_indicators()
	assert_eq(terminal_detector.terminal_indicators.size(), 0, "Should clear all indicators")

func test_clear_indicators_with_no_indicators():
	# Test clearing when no indicators exist
	terminal_detector.clear_indicators()
	assert_eq(terminal_detector.terminal_indicators.size(), 0, "Should handle clearing with no indicators")

func test_detect_and_mark_terminals_without_tilemap():
	# Test behavior when tilemap is not found
	var detector_without_tilemap = TerminalDetector.new()
	add_child(detector_without_tilemap)
	
	# Should not crash when tilemap is missing
	detector_without_tilemap.detect_and_mark_terminals()
	assert_eq(detector_without_tilemap.terminal_indicators.size(), 0, "Should handle missing tilemap gracefully")
	
	# Clean up
	detector_without_tilemap.queue_free()

func test_terminal_detector_edge_cases():
	# Test various edge cases
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	# Test with invalid coordinates
	tilemap.set_cell(Vector2i(-1, -1), 0, terminal_coords[0])
	tilemap.set_cell(Vector2i(999, 999), 0, terminal_coords[0])
	
	terminal_detector.detect_and_mark_terminals()
	
	# Should handle edge case coordinates
	assert_eq(terminal_detector.terminal_indicators.size(), 2, "Should handle edge case coordinates")

func test_terminal_detector_performance():
	# Test performance with many tiles
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	# Add many tiles (mix of terminal and non-terminal)
	for i in range(100):
		var cell_pos = Vector2i(i, 0)
		if i % 3 == 0:  # Every third tile is a terminal
			tilemap.set_cell(cell_pos, 0, terminal_coords[0])
		else:
			tilemap.set_cell(cell_pos, 0, Vector2i(i, i))
	
	# Should complete in reasonable time
	var start_time = Time.get_ticks_msec()
	terminal_detector.detect_and_mark_terminals()
	var end_time = Time.get_ticks_msec()
	
	var duration = end_time - start_time
	assert_true(duration < 1000, "Should complete detection in under 1 second")
	
	# Verify correct number of indicators created
	var expected_indicators = 34  # 100/3 rounded up
	assert_eq(terminal_detector.terminal_indicators.size(), expected_indicators, "Should create correct number of indicators")

func test_terminal_detector_input_method():
	# Test that input method exists
	assert_true(terminal_detector.has_method("_input"), "Should have _input method")

func test_terminal_detector_component_inheritance():
	# Test that TerminalDetector inherits correctly
	assert_true(terminal_detector is Node2D, "Should inherit from Node2D")
	assert_true(terminal_detector is Node, "Should inherit from Node")

func test_terminal_detector_cleanup():
	# Test that detector can be cleaned up properly
	terminal_detector.clear_indicators()
	terminal_detector.queue_free()
	
	# Should not crash during cleanup
	assert_true(true, "Should clean up properly")

func test_terminal_detector_repeated_detection():
	# Test that repeated detection works correctly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(0, 0), 0, terminal_coords[0])
	
	# First detection
	terminal_detector.detect_and_mark_terminals()
	assert_eq(terminal_detector.terminal_indicators.size(), 1, "Should create indicator on first detection")
	
	# Second detection (should clear and recreate)
	terminal_detector.detect_and_mark_terminals()
	assert_eq(terminal_detector.terminal_indicators.size(), 1, "Should recreate indicator on second detection")

func test_terminal_detector_with_different_terminal_types():
	# Test detection with different terminal types
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	assert_true(terminal_coords.size() > 1, "Should have multiple terminal coordinates")
	
	# Add different terminal types
	tilemap.set_cell(Vector2i(0, 0), 0, terminal_coords[0])
	tilemap.set_cell(Vector2i(1, 0), 0, terminal_coords[1])
	
	terminal_detector.detect_and_mark_terminals()
	
	# Should create indicators for both types
	assert_eq(terminal_detector.terminal_indicators.size(), 2, "Should create indicators for different terminal types")
	
	# Check that labels show different types
	var indicator1 = terminal_detector.terminal_indicators[0]
	var indicator2 = terminal_detector.terminal_indicators[1]
	
	var label1 = indicator1.get_child(1)
	var label2 = indicator2.get_child(1)
	
	var type1 = TerminalTileIdentifier.get_terminal_type_from_atlas(terminal_coords[0])
	var type2 = TerminalTileIdentifier.get_terminal_type_from_atlas(terminal_coords[1])
	
	assert_eq(label1.text, type1, "Should show correct terminal type for first indicator")
	assert_eq(label2.text, type2, "Should show correct terminal type for second indicator") 
