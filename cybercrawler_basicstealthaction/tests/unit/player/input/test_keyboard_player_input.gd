extends GutTest

class_name TestKeyboardPlayerInput

var keyboard_input: KeyboardPlayerInput
var mock_input: MockInput

func before_each():
	mock_input = MockInput.new()
	keyboard_input = KeyboardPlayerInput.new(mock_input)

func after_each():
	if keyboard_input:
		# Don't call queue_free() on RefCounted objects
		keyboard_input = null

# Test initial state
func test_initial_state():
	assert_eq(keyboard_input.get_current_input(), Vector2.ZERO, "Initial input should be zero")
	assert_false(keyboard_input.is_moving(), "Should not be moving initially")
	assert_eq(keyboard_input.get_interaction_target(), null, "Initial interaction target should be null")
	assert_false(keyboard_input.is_stealth_action_active(), "Stealth should not be active initially")

# Test interface methods
func test_interface_methods():
	# Test that all interface methods exist and work
	assert_not_null(keyboard_input.get_current_input(), "get_current_input should return a value")
	assert_not_null(keyboard_input.is_moving(), "is_moving should return a boolean")
	# get_interaction_target can return null, so we just test it doesn't crash
	assert_true(keyboard_input.get_interaction_target() == null, "get_interaction_target should return null initially")
	assert_not_null(keyboard_input.is_stealth_action_active(), "is_stealth_action_active should return a boolean")

# Test interaction target management
func test_interaction_target_management():
	# Arrange
	var mock_target = Node2D.new()
	
	# Act
	keyboard_input.set_interaction_target(mock_target)
	
	# Assert
	assert_eq(keyboard_input.get_interaction_target(), mock_target, "Should set interaction target")
	
	# Cleanup
	mock_target.queue_free()

# Test stealth state management
func test_stealth_state_management():
	# Arrange - set up mock input
	mock_input.set_action_just_pressed("stealth", true)
	
	# Act - update input with stealth pressed
	keyboard_input.update_input()
	
	# Assert - stealth should be toggled to true
	assert_true(keyboard_input.is_stealth_action_active(), "Stealth should be active after toggle")

# Test stealth toggle multiple times
func test_stealth_toggle_multiple_times():
	# Arrange - set up mock input for multiple toggles
	mock_input.set_action_just_pressed("stealth", true)
	
	# Act - toggle stealth on
	keyboard_input.update_input()
	assert_true(keyboard_input.is_stealth_action_active(), "Stealth should be active after first toggle")
	
	# Toggle stealth off
	mock_input.set_action_just_pressed("stealth", false)
	mock_input.set_action_just_pressed("stealth", true)
	keyboard_input.update_input()
	assert_false(keyboard_input.is_stealth_action_active(), "Stealth should be inactive after second toggle")
	
	# Toggle stealth on again
	mock_input.set_action_just_pressed("stealth", false)
	mock_input.set_action_just_pressed("stealth", true)
	keyboard_input.update_input()
	assert_true(keyboard_input.is_stealth_action_active(), "Stealth should be active after third toggle")

# Test movement state management
func test_movement_state_management():
	# Arrange - set up mock input for movement
	mock_input.set_action_pressed("move_right", true)
	
	# Act - update input with movement pressed
	keyboard_input.update_input()
	
	# Assert - should be moving with input
	assert_true(keyboard_input.is_moving(), "Should be moving with input")
	assert_eq(keyboard_input.get_current_input(), Vector2.RIGHT, "Should move right")

# Test input direction management
func test_input_direction_management():
	# Arrange - set up mock input for diagonal movement
	mock_input.set_action_pressed("move_right", true)
	mock_input.set_action_pressed("move_up", true)
	
	# Act - update input with diagonal movement
	keyboard_input.update_input()
	
	# Assert - should return normalized diagonal direction
	var expected_direction = Vector2(1, -1).normalized()
	assert_eq(keyboard_input.get_current_input(), expected_direction, "Should return normalized diagonal direction")
	assert_true(keyboard_input.is_moving(), "Should be moving with diagonal input")

# Test all movement directions
func test_all_movement_directions():
	# Test each direction individually
	var directions = [
		{"input": "move_left", "expected": Vector2.LEFT},
		{"input": "move_right", "expected": Vector2.RIGHT},
		{"input": "move_up", "expected": Vector2.UP},
		{"input": "move_down", "expected": Vector2.DOWN}
	]
	
	for direction_test in directions:
		# Reset input
		mock_input.clear_all()
		mock_input.set_action_pressed(direction_test.input, true)
		
		# Act
		keyboard_input.update_input()
		
		# Assert
		assert_eq(keyboard_input.get_current_input(), direction_test.expected, "Should move %s" % direction_test.input)
		assert_true(keyboard_input.is_moving(), "Should be moving in %s direction" % direction_test.input)

# Test opposite directions cancel out
func test_opposite_directions_cancel():
	# Test left + right = no movement
	mock_input.clear_all()
	mock_input.set_action_pressed("move_left", true)
	mock_input.set_action_pressed("move_right", true)
	keyboard_input.update_input()
	assert_eq(keyboard_input.get_current_input(), Vector2.ZERO, "Opposite horizontal directions should cancel")
	assert_false(keyboard_input.is_moving(), "Should not be moving with opposite horizontal directions")
	
	# Test up + down = no movement
	mock_input.clear_all()
	mock_input.set_action_pressed("move_up", true)
	mock_input.set_action_pressed("move_down", true)
	keyboard_input.update_input()
	assert_eq(keyboard_input.get_current_input(), Vector2.ZERO, "Opposite vertical directions should cancel")
	assert_false(keyboard_input.is_moving(), "Should not be moving with opposite vertical directions")

# Test all diagonal combinations
func test_all_diagonal_combinations():
	var diagonal_tests = [
		{"inputs": ["move_up", "move_right"], "expected": Vector2(1, -1).normalized()},
		{"inputs": ["move_up", "move_left"], "expected": Vector2(-1, -1).normalized()},
		{"inputs": ["move_down", "move_right"], "expected": Vector2(1, 1).normalized()},
		{"inputs": ["move_down", "move_left"], "expected": Vector2(-1, 1).normalized()}
	]
	
	for test in diagonal_tests:
		mock_input.clear_all()
		for input_action in test.inputs:
			mock_input.set_action_pressed(input_action, true)
		
		keyboard_input.update_input()
		assert_eq(keyboard_input.get_current_input(), test.expected, "Diagonal should be normalized")
		assert_true(keyboard_input.is_moving(), "Should be moving with diagonal input")

# Test update input method
func test_update_input_method():
	# Arrange - ensure no input is pressed
	mock_input.clear_all()
	
	# Act
	keyboard_input.update_input()
	
	# Assert - should not crash and should process input
	assert_false(keyboard_input.is_moving(), "Should not be moving without input")
	assert_eq(keyboard_input.get_current_input(), Vector2.ZERO, "Should have zero input without any keys pressed")

# Test input constants
func test_input_constants():
	# Test that input action names are defined
	assert_not_null(keyboard_input.INPUT_MOVE_UP, "INPUT_MOVE_UP should be defined")
	assert_not_null(keyboard_input.INPUT_MOVE_DOWN, "INPUT_MOVE_DOWN should be defined")
	assert_not_null(keyboard_input.INPUT_MOVE_LEFT, "INPUT_MOVE_LEFT should be defined")
	assert_not_null(keyboard_input.INPUT_MOVE_RIGHT, "INPUT_MOVE_RIGHT should be defined")
	assert_not_null(keyboard_input.INPUT_INTERACT, "INPUT_INTERACT should be defined")
	assert_not_null(keyboard_input.INPUT_STEALTH, "INPUT_STEALTH should be defined")

# Test component inheritance
func test_component_inheritance():
	# Test that it extends the correct interface
	assert_true(keyboard_input is IPlayerInputBehavior, "Should implement IPlayerInputBehavior interface")

# Test component instantiation
func test_component_instantiation():
	# Test that we can create the component
	var new_input = KeyboardPlayerInput.new()
	assert_not_null(new_input, "Should be able to create KeyboardPlayerInput")
	
	# Don't call queue_free() on RefCounted objects
	# Just let it be garbage collected

# Test component behavior
func test_component_behavior():
	# Arrange
	var mock_target = Node2D.new()
	keyboard_input.set_interaction_target(mock_target)
	
	# Act
	var result = keyboard_input.get_interaction_target()
	
	# Assert - should return the object or null, not a different type
	assert_true(result == null || result is Object, "Interaction target should remain object or null")
	
	# Cleanup
	mock_target.queue_free()

# Test edge cases
func test_edge_cases():
	# Test setting null interaction target
	keyboard_input.set_interaction_target(null)
	assert_eq(keyboard_input.get_interaction_target(), null, "Should handle null interaction target")
	
	# Test multiple rapid input updates
	for i in range(10):
		mock_input.clear_all()
		mock_input.set_action_pressed("move_right", true)
		keyboard_input.update_input()
		assert_true(keyboard_input.is_moving(), "Should handle rapid input updates")
	
	# Test stealth toggle with no input
	mock_input.clear_all()
	keyboard_input.update_input()
	assert_false(keyboard_input.is_stealth_action_active(), "Stealth should remain false with no input")

# Test input system injection
func test_input_system_injection():
	# Test that we can inject a different input system
	var custom_mock_input = MockInput.new()
	var custom_keyboard_input = KeyboardPlayerInput.new(custom_mock_input)
	
	# Test that it uses the injected system
	custom_mock_input.set_action_pressed("move_right", true)
	custom_keyboard_input.update_input()
	assert_true(custom_keyboard_input.is_moving(), "Should use injected input system")
	
	# Test that it doesn't affect the original
	assert_false(keyboard_input.is_moving(), "Original should not be affected")

# Test input constants are correct
func test_input_constants_are_correct():
	assert_eq(keyboard_input.INPUT_MOVE_LEFT, "move_left", "INPUT_MOVE_LEFT should be correct")
	assert_eq(keyboard_input.INPUT_MOVE_RIGHT, "move_right", "INPUT_MOVE_RIGHT should be correct")
	assert_eq(keyboard_input.INPUT_MOVE_UP, "move_up", "INPUT_MOVE_UP should be correct")
	assert_eq(keyboard_input.INPUT_MOVE_DOWN, "move_down", "INPUT_MOVE_DOWN should be correct")
	assert_eq(keyboard_input.INPUT_INTERACT, "interact", "INPUT_INTERACT should be correct")
	assert_eq(keyboard_input.INPUT_STEALTH, "stealth", "INPUT_STEALTH should be correct") 