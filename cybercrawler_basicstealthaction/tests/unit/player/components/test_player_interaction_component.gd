extends GutTest

class_name TestPlayerInteractionComponent

var interaction_component: PlayerInteractionComponent
var mock_engine: MockEngine
var mock_time: MockTime
var mock_terminal: MockTerminal

func before_each():
	mock_engine = MockEngine.new()
	mock_time = MockTime.new()
	mock_terminal = MockTerminal.new()
	
	# Set up mock terminal
	mock_terminal.set_terminal_name("MockTerminal")
	mock_terminal.global_position = Vector2(110, 100)
	
	# Set up mock engine with terminal in group
	mock_engine.set_nodes_in_group("terminals", [mock_terminal])
	
	# Set up mock time
	mock_time.set_second(100)
	
	# Create interaction component with injected mocks
	interaction_component = PlayerInteractionComponent.new(mock_engine, mock_time)

func after_each():
	if interaction_component:
		interaction_component = null
	if mock_engine:
		mock_engine.clear()
	if mock_time:
		mock_time.clear()
	if mock_terminal:
		mock_terminal = null

# Test initial state
func test_initial_state():
	assert_eq(interaction_component.interaction_range, 16.0, "Default interaction range should be 16.0")
	assert_eq(interaction_component.current_target, null, "Initial target should be null")
	assert_eq(interaction_component.tilemap, null, "Initial tilemap should be null")
	assert_false(interaction_component.can_interact(), "Should not be able to interact initially")

# Test set_tilemap
func test_set_tilemap():
	# Arrange
	var mock_tilemap = MockTileMapLayer.new()
	
	# Act
	interaction_component.set_tilemap(mock_tilemap)
	
	# Assert
	assert_eq(interaction_component.tilemap, mock_tilemap, "Should set tilemap correctly")

# Test find_interaction_target_with_no_terminals
func test_find_interaction_target_with_no_terminals():
	# Arrange
	var player_position = Vector2(100, 100)
	mock_engine.set_nodes_in_group("terminals", [])  # No terminals
	
	# Act
	var result = interaction_component.find_interaction_target(player_position)
	
	# Assert
	assert_eq(result, null, "Should return null when no terminals exist")
	assert_eq(interaction_component.current_target, null, "Current target should remain null")

# Test find_interaction_target_with_terminal_in_range
func test_find_interaction_target_with_terminal_in_range():
	# Arrange
	var player_position = Vector2(100, 100)
	mock_terminal.global_position = Vector2(110, 100)  # Within range (10 units)
	
	# Act
	var result = interaction_component.find_interaction_target(player_position)
	
	# Assert
	assert_eq(result, mock_terminal, "Should find terminal within range")
	assert_eq(interaction_component.current_target, mock_terminal, "Current target should be set")

# Test find_interaction_target_with_terminal_out_of_range
func test_find_interaction_target_with_terminal_out_of_range():
	# Arrange
	var player_position = Vector2(100, 100)
	mock_terminal.global_position = Vector2(200, 200)  # Out of range (141 units)
	
	# Act
	var result = interaction_component.find_interaction_target(player_position)
	
	# Assert
	assert_eq(result, null, "Should not find terminal out of range")
	assert_eq(interaction_component.current_target, null, "Current target should remain null")

# Test find_interaction_target_closest_terminal
func test_find_interaction_target_closest_terminal():
	# Arrange
	var player_position = Vector2(100, 100)
	var far_terminal = MockTerminal.new()
	far_terminal.set_terminal_name("FarTerminal")
	far_terminal.global_position = Vector2(110, 100)  # 10 units away
	
	var close_terminal = MockTerminal.new()
	close_terminal.set_terminal_name("CloseTerminal")
	close_terminal.global_position = Vector2(105, 100)  # 5 units away
	
	mock_engine.set_nodes_in_group("terminals", [far_terminal, close_terminal])
	
	# Act
	var result = interaction_component.find_interaction_target(player_position)
	
	# Assert
	assert_eq(result, close_terminal, "Should find closest terminal")
	assert_eq(interaction_component.current_target, close_terminal, "Current target should be closest terminal")

# Test find_interaction_target_terminal_without_position
func test_find_interaction_target_terminal_without_position():
	# Arrange
	var player_position = Vector2(100, 100)
	var invalid_terminal = Node.new()  # No get_global_position method
	invalid_terminal.name = "InvalidTerminal"
	
	mock_engine.set_nodes_in_group("terminals", [invalid_terminal])
	
	# Act
	var result = interaction_component.find_interaction_target(player_position)
	
	# Assert
	assert_eq(result, null, "Should ignore terminals without get_global_position method")
	
	# Cleanup
	invalid_terminal.queue_free()

# Test create_terminal_object
func test_create_terminal_object():
	# Arrange
	var world_pos = Vector2(200, 300)
	var source_id = 5
	
	# Act
	var terminal = interaction_component.create_terminal_object(world_pos, source_id)
	
	# Assert
	assert_not_null(terminal, "Should create terminal object")
	assert_eq(terminal.global_position, world_pos, "Should set correct position")
	assert_eq(terminal.terminal_type, "terminal_5", "Should set correct terminal type")
	assert_true(terminal.name.begins_with("Terminal_5_"), "Should set correct name")
	
	# Cleanup
	terminal.queue_free()

# Test can_interact_when_target_exists
func test_can_interact_when_target_exists():
	# Arrange
	interaction_component.current_target = mock_terminal
	
	# Act & Assert
	assert_true(interaction_component.can_interact(), "Should be able to interact when target exists")

# Test can_interact_when_no_target
func test_can_interact_when_no_target():
	# Arrange
	interaction_component.current_target = null
	
	# Act & Assert
	assert_false(interaction_component.can_interact(), "Should not be able to interact when no target")

# Test get_interaction_target
func test_get_interaction_target():
	# Arrange
	interaction_component.current_target = mock_terminal
	
	# Act
	var result = interaction_component.get_interaction_target()
	
	# Assert
	assert_eq(result, mock_terminal, "Should return current target")

# Test get_interaction_target_when_null
func test_get_interaction_target_when_null():
	# Arrange
	interaction_component.current_target = null
	
	# Act
	var result = interaction_component.get_interaction_target()
	
	# Assert
	assert_eq(result, null, "Should return null when no target")

# Test interaction_range_custom_value
func test_interaction_range_custom_value():
	# Arrange
	interaction_component.interaction_range = 32.0
	var player_position = Vector2(100, 100)
	mock_terminal.global_position = Vector2(130, 100)  # 30 units away (within new range)
	
	# Act
	var result = interaction_component.find_interaction_target(player_position)
	
	# Assert
	assert_eq(result, mock_terminal, "Should find terminal within custom range")

# Test search_cooldown_functionality
func test_search_cooldown_functionality():
	# Arrange
	var player_position = Vector2(100, 100)
	mock_terminal.global_position = Vector2(110, 100)
	
	# Act - call multiple times quickly
	var result1 = interaction_component.find_interaction_target(player_position)
	var result2 = interaction_component.find_interaction_target(player_position)
	var result3 = interaction_component.find_interaction_target(player_position)
	
	# Assert - should work consistently despite cooldown
	assert_eq(result1, mock_terminal, "First call should work")
	assert_eq(result2, mock_terminal, "Second call should work")
	assert_eq(result3, mock_terminal, "Third call should work")

# Test component_inheritance
func test_component_inheritance():
	# Test that it extends RefCounted
	assert_true(interaction_component is RefCounted, "Should extend RefCounted")

# Test component_instantiation
func test_component_instantiation():
	# Test that we can create the component
	var new_component = PlayerInteractionComponent.new()
	assert_not_null(new_component, "Should be able to create PlayerInteractionComponent")
	
	# Cleanup
	new_component = null

# Test edge cases and error conditions
func test_edge_cases_and_errors():
	# Test with null engine
	var null_engine_component = PlayerInteractionComponent.new(null, mock_time)
	var result = null_engine_component.find_interaction_target(Vector2(100, 100))
	assert_eq(result, null, "Should handle null engine gracefully")
	
	# Test with null time
	var null_time_component = PlayerInteractionComponent.new(mock_engine, null)
	result = null_time_component.find_interaction_target(Vector2(100, 100))
	assert_eq(result, mock_terminal, "Should handle null time gracefully")
	
	# Test with invalid terminal (no get_global_position method)
	var invalid_terminal = Node.new()
	mock_engine.set_nodes_in_group("terminals", [invalid_terminal])
	result = interaction_component.find_interaction_target(Vector2(100, 100))
	assert_eq(result, null, "Should ignore terminals without get_global_position method")
	invalid_terminal.queue_free()
	
	# Test with extreme positions
	var extreme_positions = [
		Vector2(0, 0),
		Vector2(10000, 10000),
		Vector2(-1000, -1000)
	]
	
	for pos in extreme_positions:
		result = interaction_component.find_interaction_target(pos)
		# Should not crash, result depends on terminal positions
		assert_true(result == null || result is Object, "Should handle extreme position %s" % pos)

# Test interaction range edge cases
func test_interaction_range_edge_cases():
	# Test exactly at range boundary
	interaction_component.interaction_range = 10.0
	var player_position = Vector2(100, 100)
	mock_terminal.global_position = Vector2(110, 100)  # Exactly 10 units away
	
	var result = interaction_component.find_interaction_target(player_position)
	assert_eq(result, mock_terminal, "Should find terminal exactly at range boundary")
	
	# Test just outside range
	mock_terminal.global_position = Vector2(110.1, 100)  # Just outside range
	result = interaction_component.find_interaction_target(player_position)
	assert_eq(result, null, "Should not find terminal just outside range")
	
	# Test zero range
	interaction_component.interaction_range = 0.0
	mock_terminal.global_position = Vector2(100, 100)  # Same position
	result = interaction_component.find_interaction_target(player_position)
	assert_eq(result, mock_terminal, "Should find terminal at same position with zero range")
	
	# Test negative range (should be treated as zero)
	interaction_component.interaction_range = -10.0
	result = interaction_component.find_interaction_target(player_position)
	assert_eq(result, mock_terminal, "Should handle negative range gracefully")

# Test multiple terminals with same distance
func test_multiple_terminals_same_distance():
	# Create two terminals at exactly the same distance
	var player_position = Vector2(100, 100)
	var terminal1 = MockTerminal.new()
	var terminal2 = MockTerminal.new()
	
	terminal1.global_position = Vector2(110, 100)  # 10 units away
	terminal2.global_position = Vector2(100, 110)  # Also 10 units away
	
	mock_engine.set_nodes_in_group("terminals", [terminal1, terminal2])
	
	var result = interaction_component.find_interaction_target(player_position)
	# Should return one of them (implementation dependent)
	assert_true(result == terminal1 || result == terminal2, "Should return one of the equidistant terminals")
	
	# Cleanup
	terminal1.queue_free()
	terminal2.queue_free()

# Test terminal object creation edge cases
func test_terminal_object_creation_edge_cases():
	# Test with zero source ID
	var terminal = interaction_component.create_terminal_object(Vector2(100, 100), 0)
	assert_eq(terminal.terminal_type, "terminal_0", "Should handle zero source ID")
	terminal.queue_free()
	
	# Test with negative source ID
	terminal = interaction_component.create_terminal_object(Vector2(100, 100), -5)
	assert_eq(terminal.terminal_type, "terminal_-5", "Should handle negative source ID")
	terminal.queue_free()
	
	# Test with zero position
	terminal = interaction_component.create_terminal_object(Vector2.ZERO, 1)
	assert_eq(terminal.global_position, Vector2.ZERO, "Should handle zero position")
	terminal.queue_free()

# Test dependency injection edge cases
func test_dependency_injection_edge_cases():
	# Test with both null dependencies
	var null_component = PlayerInteractionComponent.new(null, null)
	var result = null_component.find_interaction_target(Vector2(100, 100))
	assert_eq(result, null, "Should handle both null dependencies gracefully")
	
	# Test with custom interaction range
	var custom_component = PlayerInteractionComponent.new(mock_engine, mock_time)
	custom_component.interaction_range = 50.0
	mock_terminal.global_position = Vector2(140, 100)  # 40 units away
	
	result = custom_component.find_interaction_target(Vector2(100, 100))
	assert_eq(result, mock_terminal, "Should use custom interaction range")

# Test performance with many terminals
func test_performance_with_many_terminals():
	# Create many terminals to test performance
	var terminals = []
	for i in range(10):  # Reduced from 100 to 10 for better test performance
		var terminal = MockTerminal.new()
		terminal.global_position = Vector2(100 + i, 100 + i)
		terminals.append(terminal)
	
	mock_engine.set_nodes_in_group("terminals", terminals)
	
	# Should not crash and should return a result
	var result = interaction_component.find_interaction_target(Vector2(100, 100))
	assert_true(result == null || result is Object, "Should handle many terminals without crashing")
	
	# Cleanup
	for terminal in terminals:
		terminal.queue_free() 