extends GutTest

class_name TestInterfaces

func test_communication_behavior_contract():
    var behavior = ICommunicationBehavior.new()
    
    # Test that base interface exists and has required methods
    assert_true(behavior.has_method("handle_terminal_interaction"))
    assert_true(behavior.has_method("notify_alert_state"))
    assert_true(behavior.has_method("get_mission_context"))

func test_mock_communication_behavior():
    var mock = MockCommunicationBehavior.new()
    var test_context = {"test": "data"}
    
    # Test terminal interaction tracking
    mock.handle_terminal_interaction("tower_placement", test_context)
    assert_eq(mock.get_interaction_count(), 1)
    
    var last_interaction = mock.get_last_interaction()
    assert_eq(last_interaction["type"], "tower_placement")
    assert_eq(last_interaction["context"], test_context)

func test_player_input_behavior():
    var mock = MockPlayerInputBehavior.new()
    
    # Test initial state
    assert_false(mock.is_moving())
    assert_eq(mock.get_current_input(), Vector2.ZERO)
    
    # Test simulation
    mock.simulate_movement(Vector2.RIGHT)
    assert_true(mock.is_moving())
    assert_eq(mock.get_current_input(), Vector2.RIGHT)

func test_terminal_behavior():
    var mock = MockTerminalBehavior.new()
    mock.set_terminal_type("test_terminal")
    
    # Test interface methods
    assert_true(mock.is_accessible())
    assert_eq(mock.get_terminal_type(), "test_terminal")
    
    # Test interaction
    var result = mock.process_interaction(null)
    assert_true(result["success"])
    assert_eq(mock.get_interaction_count(), 1)

func test_di_container():
    var container = DIContainer.new()
    var mock_comm = MockCommunicationBehavior.new()
    
    # Test binding and retrieval
    container.bind_interface("ICommunicationBehavior", mock_comm)
    
    var retrieved = container.get_implementation("ICommunicationBehavior")
    assert_eq(retrieved, mock_comm)
    
    # Test safe behavior retrieval
    var behavior = container.get_behavior("ICommunicationBehavior")
    assert_eq(behavior, mock_comm)
    
    # Test unknown interface
    var unknown = container.get_implementation("UnknownInterface")
    assert_null(unknown)