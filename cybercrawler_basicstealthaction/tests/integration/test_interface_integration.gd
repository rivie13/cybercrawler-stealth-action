extends GutTest

class_name TestInterfaceIntegration

var container: DIContainer
var mock_comm: MockCommunicationBehavior
var mock_input: MockPlayerInputBehavior
var mock_terminal: MockTerminalBehavior

func before_each():
    container = DIContainer.new()
    mock_comm = MockCommunicationBehavior.new()
    mock_input = MockPlayerInputBehavior.new()
    mock_terminal = MockTerminalBehavior.new()
    
    container.bind_interface("ICommunicationBehavior", mock_comm)
    container.bind_interface("IPlayerInputBehavior", mock_input)
    container.bind_interface("ITerminalBehavior", mock_terminal)

func test_dependency_injection_flow():
    # Test that we can retrieve and use injected dependencies
    var comm_behavior = container.get_behavior("ICommunicationBehavior")
    var input_behavior = container.get_behavior("IPlayerInputBehavior")
    var terminal_behavior = container.get_behavior("ITerminalBehavior")
    
    assert_not_null(comm_behavior)
    assert_not_null(input_behavior)
    assert_not_null(terminal_behavior)
    
    # Test communication flow
    comm_behavior.handle_terminal_interaction("test_terminal", {"player": "test"})
    assert_eq(mock_comm.get_interaction_count(), 1)
    
    # Test input simulation
    input_behavior.simulate_movement(Vector2.RIGHT)
    assert_eq(input_behavior.get_current_input(), Vector2.RIGHT)
    
    # Test terminal interaction
    var result = terminal_behavior.process_interaction(null)
    assert_true(result["success"])

func test_complete_interaction_flow():
    # Simulate a complete player-terminal interaction using DI
    var input_behavior = container.get_behavior("IPlayerInputBehavior") as MockPlayerInputBehavior
    var terminal_behavior = container.get_behavior("ITerminalBehavior") as MockTerminalBehavior
    var comm_behavior = container.get_behavior("ICommunicationBehavior") as MockCommunicationBehavior
    
    # Step 1: Player approaches terminal
    input_behavior.simulate_movement(Vector2.UP)
    assert_true(input_behavior.is_moving())
    
    # Step 2: Check if terminal allows interaction
    terminal_behavior.set_terminal_type("tower_placement")
    assert_true(terminal_behavior.can_interact(null))
    
    # Step 3: Process terminal interaction
    var interaction_result = terminal_behavior.process_interaction(null)
    assert_true(interaction_result["success"])
    
    # Step 4: Communicate result to external system
    comm_behavior.handle_terminal_interaction(
        terminal_behavior.get_terminal_type(),
        {"result": interaction_result}
    )
    
    # Verify the complete flow worked
    assert_eq(mock_terminal.get_interaction_count(), 1)
    assert_eq(mock_comm.get_interaction_count(), 1)
    
    var comm_interaction = mock_comm.get_last_interaction()
    assert_eq(comm_interaction["type"], "tower_placement")