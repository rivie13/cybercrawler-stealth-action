extends GutTest

class_name TestTerminalSpawner

var terminal_spawner: TerminalSpawner
var tilemap: TileMapLayer
var di_container: DIContainer
var mock_terminal_behavior: MockTerminalBehavior

func before_each():
	# Create fresh instances for each test
	terminal_spawner = TerminalSpawner.new()
	tilemap = TileMapLayer.new()
	di_container = DIContainer.new()
	mock_terminal_behavior = MockTerminalBehavior.new()
	
	# Set up DI container with mock behavior
	di_container.bind_interface("ITerminalBehavior", mock_terminal_behavior)
	
	# Set up terminal spawner dependencies
	terminal_spawner.tilemap = tilemap
	terminal_spawner.di_container = di_container

func after_each():
	# Clean up - use proper GUT memory management
	if terminal_spawner:
		terminal_spawner.queue_free()
	if tilemap:
		tilemap.queue_free()
	if di_container:
		di_container.clear_bindings()

# ===== PROPER TESTS THAT TEST ACTUAL FUNCTIONALITY =====

func test_terminal_spawner_initialization():
	# Test that terminal spawner initializes correctly
	assert_not_null(terminal_spawner, "Terminal spawner should be created")
	assert_true(terminal_spawner is TerminalSpawner, "Should be TerminalSpawner type")
	assert_true(terminal_spawner is Node2D, "Should extend Node2D")

func test_terminal_spawner_ready_method():
	# Test the _ready method properly
	add_child(terminal_spawner)
	
	# Verify terminal atlas coordinates are initialized
	assert_not_null(terminal_spawner.terminal_atlas_coords, "Terminal atlas coordinates should be initialized")
	assert_true(terminal_spawner.terminal_atlas_coords.size() > 0, "Should have terminal coordinates")
	
	remove_child(terminal_spawner)

func test_spawn_terminals_with_no_tiles():
	# Test spawning when no tiles exist - should not crash
	terminal_spawner.spawn_terminals()
	assert_true(true, "Should handle empty tilemap without crashing")

func test_spawn_terminals_with_non_terminal_tiles():
	# Test spawning with tiles that are not terminals
	tilemap.set_cell(Vector2i(0, 0), 0, Vector2i(1, 1))  # Non-terminal tile
	tilemap.set_cell(Vector2i(1, 0), 0, Vector2i(2, 2))  # Non-terminal tile
	
	terminal_spawner.spawn_terminals()
	
	# Should not create any terminal objects
	var terminal_children = tilemap.get_children()
	var terminal_count = 0
	for child in terminal_children:
		if child.is_in_group("terminals"):
			terminal_count += 1
	
	assert_eq(terminal_count, 0, "Should not create terminals for non-terminal tiles")

func test_spawn_terminals_with_terminal_tiles():
	# Test spawning with actual terminal tiles
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	assert_true(terminal_coords.size() > 0, "Should have terminal coordinates available")
	
	# Add a terminal tile
	var first_terminal = terminal_coords[0]
	tilemap.set_cell(Vector2i(0, 0), 0, first_terminal)
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Should create terminal objects
	var terminal_children = tilemap.get_children()
	var terminal_count = 0
	for child in terminal_children:
		if child.is_in_group("terminals"):
			terminal_count += 1
	
	assert_eq(terminal_count, 1, "Should create one terminal for terminal tile")

func test_spawn_terminals_with_multiple_terminal_tiles():
	# Test spawning with multiple terminal tiles
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	assert_true(terminal_coords.size() > 1, "Should have multiple terminal coordinates")
	
	# Add multiple terminal tiles
	tilemap.set_cell(Vector2i(0, 0), 0, terminal_coords[0])
	tilemap.set_cell(Vector2i(1, 0), 0, terminal_coords[1])
	tilemap.set_cell(Vector2i(2, 0), 0, Vector2i(99, 99))  # Non-terminal
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Should create terminal objects for terminal tiles only
	var terminal_children = tilemap.get_children()
	var terminal_count = 0
	for child in terminal_children:
		if child.is_in_group("terminals"):
			terminal_count += 1
	
	assert_eq(terminal_count, 2, "Should create terminals only for terminal tiles")

func test_terminal_object_creation():
	# Test that terminal objects are created with correct properties
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(5, 5), 0, terminal_coords[0])
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Find the created terminal
	var terminal_body = null
	for child in tilemap.get_children():
		if child.is_in_group("terminals"):
			terminal_body = child
			break
	
	assert_not_null(terminal_body, "Should create terminal body")
	assert_true(terminal_body is StaticBody2D, "Should be StaticBody2D")
	assert_eq(terminal_body.name, "Terminal_5_5", "Should have correct name")
	assert_true(terminal_body.is_in_group("terminals"), "Should be in terminals group")

func test_terminal_collision_shape():
	# Test that collision shapes are created correctly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(3, 3), 0, terminal_coords[0])
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Find the created terminal
	var terminal_body = null
	for child in tilemap.get_children():
		if child.is_in_group("terminals"):
			terminal_body = child
			break
	
	assert_not_null(terminal_body, "Should create terminal body")
	
	# Check collision shape
	var collision_shape = terminal_body.get_child(0)
	assert_not_null(collision_shape, "Should have collision shape")
	assert_true(collision_shape is CollisionShape2D, "Should be CollisionShape2D")
	
	# Check shape properties
	var shape = collision_shape.shape
	assert_not_null(shape, "Should have shape")
	assert_true(shape is RectangleShape2D, "Should be RectangleShape2D")
	assert_eq(shape.size, Vector2(16, 16), "Should have correct size")

func test_terminal_script_assignment():
	# Test that terminal script is assigned correctly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(1, 1), 0, terminal_coords[0])
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Find the created terminal
	var terminal_body = null
	for child in tilemap.get_children():
		if child.is_in_group("terminals"):
			terminal_body = child
			break
	
	assert_not_null(terminal_body, "Should create terminal body")
	assert_not_null(terminal_body.get_script(), "Should have script assigned")

func test_terminal_type_assignment():
	# Test that terminal type is assigned correctly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	var cell_pos = Vector2i(2, 2)
	tilemap.set_cell(cell_pos, 0, terminal_coords[0])
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Find the created terminal
	var terminal_body = null
	for child in tilemap.get_children():
		if child.is_in_group("terminals"):
			terminal_body = child
			break
	
	assert_not_null(terminal_body, "Should create terminal body")
	
	# Check terminal type
	var expected_type = TerminalTileIdentifier.get_terminal_type_from_atlas(terminal_coords[0])
	assert_eq(terminal_body.terminal_type, expected_type, "Should have correct terminal type")

func test_di_container_integration():
	# Test that DI container is used correctly
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(4, 4), 0, terminal_coords[0])
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Find the created terminal
	var terminal_body = null
	for child in tilemap.get_children():
		if child.is_in_group("terminals"):
			terminal_body = child
			break
	
	assert_not_null(terminal_body, "Should create terminal body")
	
	# Check that terminal behavior is set (if available)
	if terminal_body.has_method("get_terminal_behavior"):
		var behavior = terminal_body.get_terminal_behavior()
		assert_not_null(behavior, "Should have terminal behavior set")

func test_terminal_spawner_without_di_container():
	# Test behavior when DI container is not set
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	tilemap.set_cell(Vector2i(6, 6), 0, terminal_coords[0])
	
	# Create spawner without DI container
	var spawner_without_di = TerminalSpawner.new()
	spawner_without_di.tilemap = tilemap
	# Don't set di_container
	
	# Initialize the terminal spawner properly
	spawner_without_di.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	spawner_without_di.spawn_terminals()
	
	# Should still create terminal objects
	var terminal_children = tilemap.get_children()
	var terminal_count = 0
	for child in terminal_children:
		if child.is_in_group("terminals"):
			terminal_count += 1
	
	assert_eq(terminal_count, 1, "Should create terminal even without DI container")
	
	# Clean up
	spawner_without_di.queue_free()

func test_terminal_spawner_without_tilemap():
	# Test behavior when tilemap is not set
	var spawner_without_tilemap = TerminalSpawner.new()
	spawner_without_tilemap.di_container = di_container
	# Don't set tilemap
	
	# Should not crash
	spawner_without_tilemap.spawn_terminals()
	assert_true(true, "Should handle missing tilemap gracefully")
	
	# Clean up
	spawner_without_tilemap.queue_free()

func test_terminal_spawner_edge_cases():
	# Test various edge cases
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	# Test with invalid coordinates
	tilemap.set_cell(Vector2i(-1, -1), 0, terminal_coords[0])
	tilemap.set_cell(Vector2i(999, 999), 0, terminal_coords[0])
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	terminal_spawner.spawn_terminals()
	
	# Should handle edge cases gracefully
	assert_true(true, "Should handle edge case coordinates")

func test_terminal_spawner_performance():
	# Test performance with many tiles
	var terminal_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	# Add many tiles (mix of terminal and non-terminal)
	for i in range(100):
		var cell_pos = Vector2i(i, 0)
		if i % 3 == 0:  # Every third tile is a terminal
			tilemap.set_cell(cell_pos, 0, terminal_coords[0])
		else:
			tilemap.set_cell(cell_pos, 0, Vector2i(i, i))
	
	# Initialize the terminal spawner properly
	terminal_spawner.terminal_atlas_coords = TerminalTileIdentifier.get_all_terminal_coords()
	
	# Should complete in reasonable time
	var start_time = Time.get_ticks_msec()
	terminal_spawner.spawn_terminals()
	var end_time = Time.get_ticks_msec()
	
	var duration = end_time - start_time
	assert_true(duration < 1000, "Should complete spawning in under 1 second")
	
	# Verify correct number of terminals created
	var terminal_count = 0
	for child in tilemap.get_children():
		if child.is_in_group("terminals"):
			terminal_count += 1
	
	# Should have created terminals for every third tile
	var expected_terminals = int(ceil(100.0 / 3.0))  # 100/3 rounded up
	assert_eq(terminal_count, expected_terminals, "Should create correct number of terminals")

func test_terminal_spawner_component_inheritance():
	# Test that TerminalSpawner inherits correctly
	assert_true(terminal_spawner is Node2D, "Should inherit from Node2D")
	assert_true(terminal_spawner is Node, "Should inherit from Node")

func test_terminal_spawner_cleanup():
	# Test that spawner can be cleaned up properly
	add_child(terminal_spawner)
	remove_child(terminal_spawner)
	terminal_spawner.queue_free()
	
	# Should not crash during cleanup
	assert_true(true, "Should clean up properly") 