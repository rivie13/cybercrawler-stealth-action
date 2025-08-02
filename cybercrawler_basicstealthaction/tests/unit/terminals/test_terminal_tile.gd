extends GutTest

var terminal_tile: TerminalTile
var mock_behavior: MockTerminalBehavior
var mock_player: MockPlayer

func before_each():
	terminal_tile = TerminalTile.new()
	mock_behavior = MockTerminalBehavior.new()
	mock_player = MockPlayer.new()
	mock_player.set_mock_name("MockPlayer")

func after_each():
	if terminal_tile:
		terminal_tile.queue_free()
	if mock_behavior:
		# MockTerminalBehavior extends RefCounted, not Node
		mock_behavior = null
	if mock_player:
		mock_player.queue_free()

func test_terminal_tile_initialization():
	assert_not_null(terminal_tile)
	assert_eq(terminal_tile.terminal_type, "basic_terminal")
	assert_eq(terminal_tile.terminal_name, "Terminal")
	assert_null(terminal_tile.terminal_behavior)

func test_set_terminal_behavior():
	terminal_tile.set_terminal_behavior(mock_behavior)
	assert_eq(terminal_tile.terminal_behavior, mock_behavior)

func test_get_terminal_type():
	assert_eq(terminal_tile.get_terminal_type(), "basic_terminal")
	
	# Test with custom type
	terminal_tile.terminal_type = "security_terminal"
	assert_eq(terminal_tile.get_terminal_type(), "security_terminal")

func test_is_interactable():
	# Should always return true for TerminalTile
	assert_true(terminal_tile.is_interactable())

func test_terminal_tile_ready_method():
	# Test that _ready method works correctly
	# This tests the collision setup and group assignment
	var test_terminal = TerminalTile.new()
	test_terminal.terminal_type = "test_terminal"
	test_terminal.terminal_name = "TestTerminal"
	
	# Add to scene tree to trigger _ready
	add_child(test_terminal)
	
	# Check that it was added to terminals group
	assert_true(test_terminal.is_in_group("terminals"))
	
	# Check collision layer/mask setup
	assert_eq(test_terminal.collision_layer, 2)  # Layer for terminals
	assert_eq(test_terminal.collision_mask, 1)   # Mask for player
	
	# Clean up
	test_terminal.queue_free()
	remove_child(test_terminal)

func test_terminal_tile_interact_with_player_without_behavior():
	# Should not crash and should print interaction message
	terminal_tile.interact_with_player(mock_player)
	# Verify that the terminal still exists and hasn't crashed
	assert_not_null(terminal_tile)
	assert_eq(terminal_tile.terminal_type, "basic_terminal")
	# Verify that the terminal can still interact (no side effects)
	assert_true(terminal_tile.is_interactable())

func test_terminal_tile_interact_with_player_with_behavior():
	terminal_tile.set_terminal_behavior(mock_behavior)
	
	# Test interaction with behavior
	terminal_tile.interact_with_player(mock_player)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_tile_properties():
	# Test setting and getting properties
	terminal_tile.terminal_type = "hacking_terminal"
	terminal_tile.terminal_name = "MainFrame"
	
	assert_eq(terminal_tile.terminal_type, "hacking_terminal")
	assert_eq(terminal_tile.terminal_name, "MainFrame")

func test_terminal_tile_multiple_interactions():
	terminal_tile.set_terminal_behavior(mock_behavior)
	
	# Perform multiple interactions
	terminal_tile.interact_with_player(mock_player)
	terminal_tile.interact_with_player(mock_player)
	terminal_tile.interact_with_player(mock_player)
	
	assert_eq(mock_behavior.get_process_interaction_calls(), 3)

func test_terminal_tile_behavior_integration():
	terminal_tile.set_terminal_behavior(mock_behavior)
	
	# Test full integration
	mock_behavior.mock_can_interact = true
	mock_behavior.mock_process_result = {"success": true, "message": "Test interaction"}
	
	# Test interaction
	terminal_tile.interact_with_player(mock_player)
	
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_tile_cleanup():
	# Test that terminal tile can be properly cleaned up
	terminal_tile.set_terminal_behavior(mock_behavior)
	
	# Verify terminal exists before cleanup
	assert_not_null(terminal_tile)
	assert_eq(terminal_tile.terminal_behavior, mock_behavior)
	
	# Perform cleanup
	terminal_tile.queue_free()
	
	# Verify that the terminal was properly queued for deletion
	assert_true(terminal_tile.is_queued_for_deletion())

func test_terminal_tile_group_assignment():
	# Test that terminal is added to terminals group
	var test_terminal = TerminalTile.new()
	test_terminal.add_to_group("terminals")
	assert_true(test_terminal.is_in_group("terminals"))
	test_terminal.queue_free()

func test_terminal_tile_with_mock_player():
	# Test interaction with proper mock player
	terminal_tile.set_terminal_behavior(mock_behavior)
	mock_player.set_mock_global_position(Vector2(100, 100))
	
	# Test interaction
	terminal_tile.interact_with_player(mock_player)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)
	assert_eq(mock_player.get_interaction_calls(), 0)  # Player doesn't track this call

func test_terminal_tile_player_position_tracking():
	# Test that terminal can work with player position
	mock_player.set_mock_global_position(Vector2(50, 75))
	terminal_tile.set_terminal_behavior(mock_behavior)
	
	# Verify player position is accessible
	assert_eq(mock_player.get_mock_global_position(), Vector2(50, 75))
	
	# Test interaction
	terminal_tile.interact_with_player(mock_player)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_tile_with_different_types():
	var test_cases = [
		{"type": "basic_terminal", "name": "Basic Terminal"},
		{"type": "security_terminal", "name": "Security Terminal"},
		{"type": "hacking_terminal", "name": "Hacking Terminal"},
		{"type": "mainframe", "name": "Mainframe"}
	]
	
	for test_case in test_cases:
		var terminal = TerminalTile.new()
		terminal.terminal_type = test_case.type
		terminal.terminal_name = test_case.name
		
		assert_eq(terminal.get_terminal_type(), test_case.type)
		assert_eq(terminal.terminal_name, test_case.name)
		
		terminal.queue_free()

func test_terminal_tile_behavior_switching():
	terminal_tile.set_terminal_behavior(mock_behavior)
	assert_eq(terminal_tile.terminal_behavior, mock_behavior)
	
	# Switch to different behavior
	var new_behavior = MockTerminalBehavior.new()
	new_behavior.mock_can_interact = false
	terminal_tile.set_terminal_behavior(new_behavior)
	
	assert_eq(terminal_tile.terminal_behavior, new_behavior)
	
	# MockTerminalBehavior extends RefCounted, not Node
	new_behavior = null

func test_terminal_tile_interaction_with_null_player():
	# Test interaction with null player (edge case)
	terminal_tile.set_terminal_behavior(mock_behavior)
	
	# Should not crash with null player
	terminal_tile.interact_with_player(null)
	
	# Should still call behavior
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_tile_behavior_integration_complete():
	# Test complete integration with behavior
	terminal_tile.set_terminal_behavior(mock_behavior)
	terminal_tile.terminal_type = "integration_terminal"
	terminal_tile.terminal_name = "IntegrationTerminal"
	
	# Set up mock behavior
	mock_behavior.mock_can_interact = true
	mock_behavior.mock_process_result = {"success": true, "message": "Integration test"}
	
	# Test interaction
	terminal_tile.interact_with_player(mock_player)
	
	# Verify behavior was called
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)
	
	# Verify terminal properties
	assert_eq(terminal_tile.get_terminal_type(), "integration_terminal")
	assert_eq(terminal_tile.terminal_name, "IntegrationTerminal")

func test_terminal_tile_collision_setup():
	# Test that collision layer/mask are set correctly in _ready
	var test_terminal = TerminalTile.new()
	
	# Add to scene tree to trigger _ready
	add_child(test_terminal)
	
	# Check collision setup
	assert_eq(test_terminal.collision_layer, 2)  # Layer for terminals
	assert_eq(test_terminal.collision_mask, 1)   # Mask for player
	
	# Clean up
	test_terminal.queue_free()
	remove_child(test_terminal)

func test_terminal_tile_export_properties():
	# Test that properties work correctly
	var test_terminal = TerminalTile.new()
	
	# Test default values
	assert_eq(test_terminal.terminal_type, "basic_terminal")
	assert_eq(test_terminal.terminal_name, "Terminal")
	
	# Test setting values
	test_terminal.terminal_type = "custom_terminal"
	test_terminal.terminal_name = "CustomTerminal"
	
	assert_eq(test_terminal.terminal_type, "custom_terminal")
	assert_eq(test_terminal.terminal_name, "CustomTerminal")
	
	test_terminal.queue_free() 