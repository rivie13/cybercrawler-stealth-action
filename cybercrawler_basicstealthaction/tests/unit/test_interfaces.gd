extends GutTest

class_name TestInterfaces

func test_communication_interface_contract():
    var interface = ICommunicationInterface.new()
    
    # Test that base interface exists and has required methods
    assert_true(interface.has_method("handle_terminal_interaction"))
    assert_true(interface.has_method("notify_alert_state"))
    assert_true(interface.has_method("get_mission_context"))

func test_mock_communication_interface():
    var mock = MockCommunicationInterface.new()
    var test_context = {"test": "data"}
    
    # Test terminal interaction tracking
    mock.handle_terminal_interaction("tower_placement", test_context)
    assert_eq(mock.get_interaction_count(), 1)
    
    var last_interaction = mock.get_last_interaction()
    assert_eq(last_interaction["type"], "tower_placement")
    assert_eq(last_interaction["context"], test_context)

func test_di_container():
    var container = DIContainer.new()
    var mock_comm = MockCommunicationInterface.new()
    
    # Test binding and retrieval
    container.bind_interface("ICommunicationInterface", mock_comm)
    
    var retrieved = container.get_implementation("ICommunicationInterface")
    assert_eq(retrieved, mock_comm)
    
    # Test unknown interface
    var unknown = container.get_implementation("UnknownInterface")
    assert_null(unknown)