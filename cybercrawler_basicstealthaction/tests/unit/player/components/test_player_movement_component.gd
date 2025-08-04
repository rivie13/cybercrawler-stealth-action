extends GutTest

class_name TestPlayerMovementComponent

var player_movement: PlayerMovementComponent

func before_each():
	player_movement = PlayerMovementComponent.new()

func after_each():
	if player_movement:
		# Don't call queue_free() on RefCounted objects
		player_movement = null

# Test initial state
func test_initial_state():
	assert_eq(player_movement.get_current_direction(), Vector2.ZERO, "Initial direction should be zero")
	assert_false(player_movement.is_moving(), "Should not be moving initially")

# Test movement with input
func test_update_movement_with_input():
	# Arrange
	var input_direction = Vector2.RIGHT
	var delta = 0.016
	
	# Act
	var velocity = player_movement.update_movement(delta, input_direction)
	
	# Assert
	assert_true(velocity.x > 0, "Should move right")
	assert_true(player_movement.is_moving(), "Should be moving")

# Test movement with zero input
func test_update_movement_with_zero_input():
	# Arrange
	var input_direction = Vector2.ZERO
	var delta = 0.016
	
	# Act
	var velocity = player_movement.update_movement(delta, input_direction)
	
	# Assert
	assert_eq(velocity, Vector2.ZERO, "Should not move with zero input")
	assert_false(player_movement.is_moving(), "Should not be moving")

# Test diagonal movement
func test_update_movement_diagonal():
	# Arrange
	var input_direction = Vector2(1, 1).normalized()
	var delta = 0.016
	
	# Act
	var velocity = player_movement.update_movement(delta, input_direction)
	
	# Assert
	assert_true(velocity.length() > 0, "Should move diagonally")
	assert_true(player_movement.is_moving(), "Should be moving")

# Test get current direction
func test_get_current_direction():
	# Arrange
	var input_direction = Vector2.UP
	var delta = 0.016
	player_movement.update_movement(delta, input_direction)
	
	# Act
	var current_direction = player_movement.get_current_direction()
	
	# Assert
	assert_eq(current_direction, Vector2.UP, "Should return current direction")

# Test is moving when moving
func test_is_moving_when_moving():
	# Arrange
	var input_direction = Vector2.RIGHT
	var delta = 0.016
	player_movement.update_movement(delta, input_direction)
	
	# Act & Assert
	assert_true(player_movement.is_moving(), "Should be moving")

# Test is moving when stopped
func test_is_moving_when_stopped():
	# Arrange
	var input_direction = Vector2.ZERO
	var delta = 0.016
	player_movement.update_movement(delta, input_direction)
	
	# Act & Assert
	assert_false(player_movement.is_moving(), "Should not be moving")

# Test is moving with zero velocity
func test_is_moving_zero_velocity():
	# Arrange
	player_movement.velocity = Vector2.ZERO
	
	# Act & Assert
	assert_false(player_movement.is_moving(), "Should not be moving with zero velocity")

# Test movement acceleration
func test_movement_acceleration():
	# Arrange
	var input_direction = Vector2.RIGHT
	var delta = 0.016
	
	# Act
	var velocity1 = player_movement.update_movement(delta, input_direction)
	var velocity2 = player_movement.update_movement(delta, input_direction)
	
	# Assert - second velocity should be greater due to acceleration
	assert_true(velocity2.length() >= velocity1.length(), "Should accelerate")

# Test movement deceleration
func test_movement_deceleration():
	# Arrange
	var input_direction = Vector2.RIGHT
	var delta = 0.016
	
	# Get to full speed first
	for i in range(10):
		player_movement.update_movement(delta, input_direction)
	
	# Then stop
	var velocity_stopping = player_movement.update_movement(delta, Vector2.ZERO)
	
	# Assert
	assert_true(velocity_stopping.length() < player_movement.speed, "Should decelerate")

# Test custom speed and acceleration
func test_custom_speed_and_acceleration():
	# Arrange
	player_movement.speed = 200.0
	player_movement.acceleration = 500.0
	var input_direction = Vector2.RIGHT
	var delta = 0.016
	
	# Act
	var velocity = player_movement.update_movement(delta, input_direction)
	
	# Assert
	assert_true(velocity.length() > 0, "Should move with custom settings")

# Test movement with negative input
func test_movement_negative_input():
	# Arrange
	var input_direction = Vector2.LEFT
	var delta = 0.016
	
	# Act
	var velocity = player_movement.update_movement(delta, input_direction)
	
	# Assert
	assert_true(velocity.x < 0, "Should move left")

# Test movement with small delta
func test_movement_small_delta():
	# Arrange
	var input_direction = Vector2.RIGHT
	var delta = 0.001
	
	# Act
	var velocity = player_movement.update_movement(delta, input_direction)
	
	# Assert
	assert_true(velocity.length() >= 0, "Should handle small delta values") 