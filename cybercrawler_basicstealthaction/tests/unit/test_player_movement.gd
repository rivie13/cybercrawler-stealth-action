extends GutTest

class_name TestPlayerMovement

var player_controller: PlayerController
var mock_input: MockPlayerInputBehavior
var mock_communication: MockCommunicationBehavior
var container: DIContainer

func before_each():
    # Setup DI container with mocks
    container = DIContainer.new()
    mock_input = MockPlayerInputBehavior.new()
    mock_communication = MockCommunicationBehavior.new()
    
    container.bind_interface("IPlayerInputBehavior", mock_input)
    container.bind_interface("ICommunicationBehavior", mock_communication)
    
    # Create player controller
    player_controller = PlayerController.new()
    player_controller.initialize(container)

func test_player_movement_right():
    # Simulate right movement
    mock_input.simulate_movement(Vector2.RIGHT)
    
    # Process one physics frame
    player_controller._handle_movement(0.016)  # 60 FPS
    
    # Assert movement occurred
    assert_true(mock_input.is_moving())
    assert_eq(mock_input.get_current_input(), Vector2.RIGHT)

func test_player_stops_when_no_input():
    # Start moving
    mock_input.simulate_movement(Vector2.RIGHT)
    player_controller._handle_movement(0.016)
    
    # Stop input
    mock_input.simulate_movement(Vector2.ZERO)
    
    # Process several frames to decelerate
    for i in range(10):
        player_controller._handle_movement(0.016)
    
    # Assert player stopped
    assert_false(mock_input.is_moving())

func test_stealth_mode_toggle():
    # Test stealth activation
    mock_input.simulate_stealth_action(true)
    assert_true(mock_input.is_stealth_action_active())
    
    # Test stealth deactivation  
    mock_input.simulate_stealth_action(false)
    assert_false(mock_input.is_stealth_action_active())

func test_movement_component():
    var movement = PlayerMovementComponent.new()
    
    # Test movement calculation
    var velocity = movement.update_movement(0.016, Vector2.RIGHT)
    
    assert_true(velocity.x > 0)
    assert_true(movement.is_moving())
    assert_eq(movement.get_current_direction(), Vector2.RIGHT)

func test_interaction_component():
    var interaction = PlayerInteractionComponent.new()
    
    # Test without any terminals (should return null)
    var target = interaction.find_interaction_target(Vector2.ZERO)
    assert_null(target)
    assert_false(interaction.can_interact())