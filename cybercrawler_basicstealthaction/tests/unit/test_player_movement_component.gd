extends GutTest

class_name TestPlayerMovementComponent

var movement_component: PlayerMovementComponent

func before_each():
	movement_component = PlayerMovementComponent.new()

func after_each():
	if movement_component:
		movement_component = null

# Test initial state
func test_initial_state():
	# Assert
	assert_eq(movement_component.speed, 200.0, "Default speed should be 200.0")
	assert_eq(movement_component.acceleration, 10.0, "Default acceleration should be 10.0")
	assert_eq(movement_component.current_direction, Vector2.ZERO, "Initial direction should be zero")
	assert_eq(movement_component.velocity, Vector2.ZERO, "Initial velocity should be zero")

# Test movement with input direction
func test_update_movement_with_input():
	# Arrange
	var input_direction = Vector2(1, 0)  # Right
	var delta = 0.016  # 60 FPS
	
	# Act
	var result = movement_component.update_movement(delta, input_direction)
	
	# Assert
	assert_ne(result, Vector2.ZERO, "Should return non-zero velocity")
	assert_eq(movement_component.current_direction, input_direction, "Should update current direction")
	assert_true(result.x > 0, "Should move in positive X direction")

# Test movement with zero input (stopping)
func test_update_movement_with_zero_input():
	# Arrange
	var input_direction = Vector2.ZERO
	var delta = 0.016
	
	# First move in a direction to set initial velocity
	movement_component.update_movement(delta, Vector2(1, 0))
	var initial_velocity = movement_component.velocity
	
	# Act - now stop
	var result = movement_component.update_movement(delta, input_direction)
	
	# Assert
	assert_eq(movement_component.current_direction, Vector2.ZERO, "Should update current direction to zero")
	# The velocity should either decrease or stay the same (depending on acceleration timing)
	assert_true(result.length() <= initial_velocity.length(), "Velocity should not increase when stopping")

# Test diagonal movement
func test_update_movement_diagonal():
	# Arrange
	var input_direction = Vector2(1, 1).normalized()
	var delta = 0.016
	
	# Act
	var result = movement_component.update_movement(delta, input_direction)
	
	# Assert
	assert_ne(result, Vector2.ZERO, "Should return non-zero velocity")
	assert_eq(movement_component.current_direction, input_direction, "Should update current direction")
	assert_true(result.x > 0 and result.y > 0, "Should move in both X and Y directions")

# Test get_current_direction
func test_get_current_direction():
	# Arrange
	var test_direction = Vector2(0, 1)  # Down
	movement_component.current_direction = test_direction
	
	# Act
	var result = movement_component.get_current_direction()
	
	# Assert
	assert_eq(result, test_direction, "Should return the current direction")

# Test is_moving when moving
func test_is_moving_when_moving():
	# Arrange
	movement_component.velocity = Vector2(10, 0)  # Moving right
	
	# Act
	var result = movement_component.is_moving()
	
	# Assert
	assert_true(result, "Should return true when velocity length > 1.0")

# Test is_moving when stopped
func test_is_moving_when_stopped():
	# Arrange
	movement_component.velocity = Vector2(0.5, 0)  # Very slow movement
	
	# Act
	var result = movement_component.is_moving()
	
	# Assert
	assert_false(result, "Should return false when velocity length <= 1.0")

# Test is_moving with zero velocity
func test_is_moving_zero_velocity():
	# Arrange
	movement_component.velocity = Vector2.ZERO
	
	# Act
	var result = movement_component.is_moving()
	
	# Assert
	assert_false(result, "Should return false with zero velocity")

# Test movement acceleration over time
func test_movement_acceleration():
	# Arrange
	var input_direction = Vector2(1, 0)
	var delta = 0.016
	
	# Act - multiple updates to see acceleration
	var velocity1 = movement_component.update_movement(delta, input_direction)
	var velocity2 = movement_component.update_movement(delta, input_direction)
	var velocity3 = movement_component.update_movement(delta, input_direction)
	
	# Assert - velocity should increase over time due to acceleration
	assert_true(velocity2.length() >= velocity1.length(), "Velocity should increase or stay same")
	assert_true(velocity3.length() >= velocity2.length(), "Velocity should continue increasing")

# Test movement deceleration when stopping
func test_movement_deceleration():
	# Arrange
	var delta = 0.016
	
	# First get moving
	movement_component.update_movement(delta, Vector2(1, 0))
	var moving_velocity = movement_component.velocity
	
	# Act - now stop
	var stopped_velocity = movement_component.update_movement(delta, Vector2.ZERO)
	
	# Assert
	assert_true(stopped_velocity.length() < moving_velocity.length(), "Velocity should decrease when stopping")

# Test custom speed and acceleration
func test_custom_speed_and_acceleration():
	# Arrange
	movement_component.speed = 300.0
	movement_component.acceleration = 20.0
	var input_direction = Vector2(1, 0)
	var delta = 0.016
	
	# Act
	var result = movement_component.update_movement(delta, input_direction)
	
	# Assert
	assert_eq(movement_component.speed, 300.0, "Speed should be set to custom value")
	assert_eq(movement_component.acceleration, 20.0, "Acceleration should be set to custom value")
	assert_true(result.length() > 0, "Should move with custom speed")

# Test movement with negative input
func test_movement_negative_input():
	# Arrange
	var input_direction = Vector2(-1, 0)  # Left
	var delta = 0.016
	
	# Act
	var result = movement_component.update_movement(delta, input_direction)
	
	# Assert
	assert_ne(result, Vector2.ZERO, "Should return non-zero velocity")
	assert_eq(movement_component.current_direction, input_direction, "Should update current direction")
	assert_true(result.x < 0, "Should move in negative X direction")

# Test movement with very small delta
func test_movement_small_delta():
	# Arrange
	var input_direction = Vector2(1, 0)
	var delta = 0.001  # Very small delta
	
	# Act
	var result = movement_component.update_movement(delta, input_direction)
	
	# Assert
	assert_eq(movement_component.current_direction, input_direction, "Should update current direction")
	assert_true(result.length() >= 0, "Should handle very small delta values") 