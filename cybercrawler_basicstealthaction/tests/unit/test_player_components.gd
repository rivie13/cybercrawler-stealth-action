extends GutTest

class_name TestPlayerComponents

func test_movement_component_initialization():
    var movement = PlayerMovementComponent.new()
    
    # Test default values
    assert_eq(movement.speed, 200.0)
    assert_eq(movement.acceleration, 10.0)
    assert_eq(movement.get_current_direction(), Vector2.ZERO)
    assert_false(movement.is_moving())

func test_movement_component_direction_updates():
    var movement = PlayerMovementComponent.new()
    
    # Test movement in different directions
    var velocity = movement.update_movement(0.016, Vector2.UP)
    assert_eq(movement.get_current_direction(), Vector2.UP)
    
    velocity = movement.update_movement(0.016, Vector2.DOWN)
    assert_eq(movement.get_current_direction(), Vector2.DOWN)
    
    velocity = movement.update_movement(0.016, Vector2.LEFT)
    assert_eq(movement.get_current_direction(), Vector2.LEFT)

func test_movement_component_diagonal_movement():
    var movement = PlayerMovementComponent.new()
    
    # Test diagonal movement
    var diagonal = Vector2(1, 1).normalized()
    var velocity = movement.update_movement(0.016, diagonal)
    
    assert_eq(movement.get_current_direction(), diagonal)
    assert_true(movement.is_moving())

func test_interaction_component_initialization():
    var interaction = PlayerInteractionComponent.new()
    
    # Test default values
    assert_eq(interaction.interaction_range, 50.0)
    assert_null(interaction.get_interaction_target())
    assert_false(interaction.can_interact())

func test_interaction_component_no_targets():
    var interaction = PlayerInteractionComponent.new()
    
    # Test without any terminals in the scene
    var target = interaction.find_interaction_target(Vector2.ZERO)
    assert_null(target)
    assert_false(interaction.can_interact())

func test_keyboard_input_initialization():
    var keyboard_input = KeyboardPlayerInput.new()
    
    # Test initial state
    assert_false(keyboard_input.is_moving())
    assert_eq(keyboard_input.get_current_input(), Vector2.ZERO)
    assert_null(keyboard_input.get_interaction_target())
    assert_false(keyboard_input.is_stealth_action_active())

func test_keyboard_input_constants():
    var keyboard_input = KeyboardPlayerInput.new()
    
    # Test that constants are defined
    assert_eq(keyboard_input.INPUT_MOVE_LEFT, "move_left")
    assert_eq(keyboard_input.INPUT_MOVE_RIGHT, "move_right")
    assert_eq(keyboard_input.INPUT_MOVE_UP, "move_up")
    assert_eq(keyboard_input.INPUT_MOVE_DOWN, "move_down")
    assert_eq(keyboard_input.INPUT_INTERACT, "interact")
    assert_eq(keyboard_input.INPUT_STEALTH, "stealth")