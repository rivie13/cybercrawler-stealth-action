extends GutTest

var terminal_object: TerminalObject
var mock_behavior: MockTerminalBehavior
var mock_player: MockPlayer

func before_each():
	terminal_object = TerminalObject.new()
	mock_behavior = MockTerminalBehavior.new()
	mock_player = MockPlayer.new()
	mock_player.set_mock_name("MockPlayer")

func after_each():
	if terminal_object:
		terminal_object.queue_free()
	if mock_behavior:
		# MockTerminalBehavior extends RefCounted, not Node
		mock_behavior = null
	if mock_player:
		mock_player.queue_free()

func test_terminal_object_initialization():
	assert_not_null(terminal_object)
	assert_eq(terminal_object.terminal_type, "basic_terminal")
	assert_eq(terminal_object.terminal_name, "Terminal")
	assert_null(terminal_object.terminal_behavior)

func test_set_terminal_behavior():
	terminal_object.set_terminal_behavior(mock_behavior)
	assert_eq(terminal_object.terminal_behavior, mock_behavior)

func test_get_terminal_type():
	assert_eq(terminal_object.get_terminal_type(), "basic_terminal")
	
	# Test with custom type
	terminal_object.terminal_type = "security_terminal"
	assert_eq(terminal_object.get_terminal_type(), "security_terminal")

func test_can_interact_with_behavior():
	terminal_object.set_terminal_behavior(mock_behavior)
	
	# Test when behavior allows interaction
	mock_behavior.mock_can_interact = true
	assert_true(terminal_object.can_interact())
	assert_eq(mock_behavior.get_can_interact_calls(), 1)
	
	# Test when behavior denies interaction
	mock_behavior.mock_can_interact = false
	assert_false(terminal_object.can_interact())
	assert_eq(mock_behavior.get_can_interact_calls(), 2)

func test_terminal_object_ready_method():
	# Test that _ready method works correctly
	# This tests the visual representation creation
	var test_terminal = TerminalObject.new()
	test_terminal.terminal_type = "test_terminal"
	test_terminal.terminal_name = "TestTerminal"
	
	# Add to scene tree to trigger _ready
	add_child(test_terminal)
	
	# Check that it was added to terminals group
	assert_true(test_terminal.is_in_group("terminals"))
	
	# Check that it has children (visual representation)
	assert_true(test_terminal.get_child_count() > 0)
	
	# Clean up
	test_terminal.queue_free()
	remove_child(test_terminal)

func test_terminal_object_with_sprite_texture_ready():
	# Test _ready method with sprite texture
	var test_terminal = TerminalObject.new()
	test_terminal.sprite_texture = Texture2D.new()
	test_terminal.terminal_type = "sprite_terminal"
	
	# Add to scene tree to trigger _ready
	add_child(test_terminal)
	
	# Check that it was added to terminals group
	assert_true(test_terminal.is_in_group("terminals"))
	
	# Check that it has children (sprite and collision)
	assert_true(test_terminal.get_child_count() > 0)
	
	# Clean up
	test_terminal.queue_free()
	remove_child(test_terminal)

func test_terminal_object_without_sprite_texture_ready():
	# Test _ready method without sprite texture (fallback visual)
	var test_terminal = TerminalObject.new()
	test_terminal.terminal_type = "fallback_terminal"
	
	# Add to scene tree to trigger _ready
	add_child(test_terminal)
	
	# Check that it was added to terminals group
	assert_true(test_terminal.is_in_group("terminals"))
	
	# Check that it has children (fallback visual and collision)
	assert_true(test_terminal.get_child_count() > 0)
	
	# Clean up
	test_terminal.queue_free()
	remove_child(test_terminal)

func test_terminal_object_export_properties():
	# Test that export properties work correctly
	var test_terminal = TerminalObject.new()
	
	# Test default values
	assert_eq(test_terminal.terminal_type, "basic_terminal")
	assert_eq(test_terminal.terminal_name, "Terminal")
	assert_null(test_terminal.sprite_texture)
	
	# Test setting values
	test_terminal.terminal_type = "custom_terminal"
	test_terminal.terminal_name = "CustomTerminal"
	var texture = Texture2D.new()
	test_terminal.sprite_texture = texture
	
	assert_eq(test_terminal.terminal_type, "custom_terminal")
	assert_eq(test_terminal.terminal_name, "CustomTerminal")
	assert_eq(test_terminal.sprite_texture, texture)
	
	test_terminal.queue_free()

func test_terminal_object_interaction_with_null_player():
	# Test interaction with null player (edge case)
	terminal_object.set_terminal_behavior(mock_behavior)
	
	# Should not crash with null player
	terminal_object.interact_with_player(null)
	
	# Should still call behavior
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_object_behavior_integration_complete():
	# Test complete integration with behavior
	terminal_object.set_terminal_behavior(mock_behavior)
	terminal_object.terminal_type = "integration_terminal"
	terminal_object.terminal_name = "IntegrationTerminal"
	
	# Set up mock behavior
	mock_behavior.mock_can_interact = true
	mock_behavior.mock_process_result = {"success": true, "message": "Integration test"}
	
	# Test can_interact
	assert_true(terminal_object.can_interact())
	
	# Test interaction
	terminal_object.interact_with_player(mock_player)
	
	# Verify behavior was called
	assert_eq(mock_behavior.get_can_interact_calls(), 1)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)
	
	# Verify terminal properties
	assert_eq(terminal_object.get_terminal_type(), "integration_terminal")
	assert_eq(terminal_object.terminal_name, "IntegrationTerminal")

func test_interact_with_player_without_behavior():
	# Should not crash and should print interaction message
	terminal_object.interact_with_player(mock_player)
	# Verify that the terminal still exists and hasn't crashed
	assert_not_null(terminal_object)
	assert_eq(terminal_object.terminal_type, "basic_terminal")
	# Verify that the terminal can still interact (no side effects)
	assert_true(terminal_object.can_interact())

func test_interact_with_player_with_behavior():
	terminal_object.set_terminal_behavior(mock_behavior)
	
	# Test interaction with behavior
	terminal_object.interact_with_player(mock_player)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_object_properties():
	# Test setting and getting properties
	terminal_object.terminal_type = "hacking_terminal"
	terminal_object.terminal_name = "MainFrame"
	
	assert_eq(terminal_object.terminal_type, "hacking_terminal")
	assert_eq(terminal_object.terminal_name, "MainFrame")

func test_terminal_object_with_sprite_texture():
	# Test that terminal can be created with sprite texture
	var texture = Texture2D.new()
	terminal_object.sprite_texture = texture
	terminal_object.terminal_type = "visual_terminal"
	
	assert_eq(terminal_object.sprite_texture, texture)
	assert_eq(terminal_object.terminal_type, "visual_terminal")

func test_multiple_interactions():
	terminal_object.set_terminal_behavior(mock_behavior)
	
	# Perform multiple interactions
	terminal_object.interact_with_player(mock_player)
	terminal_object.interact_with_player(mock_player)
	terminal_object.interact_with_player(mock_player)
	
	assert_eq(mock_behavior.get_process_interaction_calls(), 3)

func test_behavior_integration():
	terminal_object.set_terminal_behavior(mock_behavior)
	
	# Test full integration
	mock_behavior.mock_can_interact = true
	mock_behavior.mock_process_result = {"success": true, "message": "Test interaction"}
	
	assert_true(terminal_object.can_interact())
	terminal_object.interact_with_player(mock_player)
	
	assert_eq(mock_behavior.get_can_interact_calls(), 1)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_object_cleanup():
	# Test that terminal object can be properly cleaned up
	terminal_object.set_terminal_behavior(mock_behavior)
	
	# Verify terminal exists before cleanup
	assert_not_null(terminal_object)
	assert_eq(terminal_object.terminal_behavior, mock_behavior)
	
	# Perform cleanup
	terminal_object.queue_free()
	
	# Verify that the terminal was properly queued for deletion
	# Note: In Godot, queue_free() doesn't immediately delete the object
	# but marks it for deletion at the end of the frame
	assert_true(terminal_object.is_queued_for_deletion())

func test_terminal_object_group_assignment():
	# Test that terminal is added to terminals group
	# Note: This would require the _ready method to be called
	# In a real test, we'd need to add the node to a scene tree
	# For now, we'll test the group assignment logic
	var test_terminal = TerminalObject.new()
	test_terminal.add_to_group("terminals")
	assert_true(test_terminal.is_in_group("terminals"))
	test_terminal.queue_free()

func test_terminal_object_with_mock_player():
	# Test interaction with proper mock player
	terminal_object.set_terminal_behavior(mock_behavior)
	mock_player.set_mock_global_position(Vector2(100, 100))
	
	# Test interaction
	terminal_object.interact_with_player(mock_player)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)
	assert_eq(mock_player.get_interaction_calls(), 0)  # Player doesn't track this call

func test_terminal_object_player_position_tracking():
	# Test that terminal can work with player position
	mock_player.set_mock_global_position(Vector2(50, 75))
	terminal_object.set_terminal_behavior(mock_behavior)
	
	# Verify player position is accessible
	assert_eq(mock_player.get_mock_global_position(), Vector2(50, 75))
	
	# Test interaction
	terminal_object.interact_with_player(mock_player)
	assert_eq(mock_behavior.get_process_interaction_calls(), 1)

func test_terminal_object_with_different_types():
	var test_cases = [
		{"type": "basic_terminal", "name": "Basic Terminal"},
		{"type": "security_terminal", "name": "Security Terminal"},
		{"type": "hacking_terminal", "name": "Hacking Terminal"},
		{"type": "mainframe", "name": "Mainframe"}
	]
	
	for test_case in test_cases:
		var terminal = TerminalObject.new()
		terminal.terminal_type = test_case.type
		terminal.terminal_name = test_case.name
		
		assert_eq(terminal.get_terminal_type(), test_case.type)
		assert_eq(terminal.terminal_name, test_case.name)
		
		terminal.queue_free()

func test_terminal_object_behavior_switching():
	terminal_object.set_terminal_behavior(mock_behavior)
	assert_eq(terminal_object.terminal_behavior, mock_behavior)
	
	# Switch to different behavior
	var new_behavior = MockTerminalBehavior.new()
	new_behavior.mock_can_interact = false
	terminal_object.set_terminal_behavior(new_behavior)
	
	assert_eq(terminal_object.terminal_behavior, new_behavior)
	assert_false(terminal_object.can_interact())
	
	# MockTerminalBehavior extends RefCounted, not Node
	new_behavior = null 