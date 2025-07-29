extends GutTest

class_name TestInterfaceIntegration

var container: DIContainer
var mock_comm: MockCommunicationInterface
var mock_input: MockPlayerInput

func before_each():
    container = DIContainer.new()
    mock_comm = MockCommunicationInterface.new()
    mock_input = MockPlayerInput.new()
    
    container.bind_interface("ICommunicationInterface", mock_comm)
    container.bind_interface("IPlayerInput", mock_input)

func test_dependency_injection_flow():
    # Test that we can retrieve and use injected dependencies
    var comm_interface = container.get_implementation("ICommunicationInterface")
    var input_interface = container.get_implementation("IPlayerInput")
    
    assert_not_null(comm_interface)
    assert_not_null(input_interface)
    
    # Test communication flow
    comm_interface.handle_terminal_interaction("test_terminal", {"player": "test"})
    assert_eq(mock_comm.get_interaction_count(), 1)
    
    # Test input simulation
    input_interface.simulate_movement(Vector2.RIGHT)
    assert_eq(input_interface.get_current_input(), Vector2.RIGHT)