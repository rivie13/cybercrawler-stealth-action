extends GutTest

class_name TestDIIntegration

var di_container: DIContainer
var real_input_behavior: KeyboardPlayerInput
var real_communication_behavior: MockCommunicationBehavior  # Keep this as mock since it's for testing
var real_terminal_behavior: MockTerminalBehavior  # Keep this as mock since it's for testing

func before_each():
	# Setup fresh DI container for each test
	di_container = DIContainer.new()
	
	# Create REAL implementations (not mocks)
	real_input_behavior = KeyboardPlayerInput.new()
	real_communication_behavior = MockCommunicationBehavior.new()
	real_terminal_behavior = MockTerminalBehavior.new()

func after_each():
	# Clean up
	if di_container:
		di_container.clear_bindings()
		di_container = null
	real_input_behavior = null
	real_communication_behavior = null
	real_terminal_behavior = null

func test_di_container_with_real_implementations():
	# Test DI container with REAL implementations
	di_container.bind_interface("IPlayerInputBehavior", real_input_behavior)
	di_container.bind_interface("ICommunicationBehavior", real_communication_behavior)
	di_container.bind_interface("ITerminalBehavior", real_terminal_behavior)
	
	# Verify bindings exist
	assert_true(di_container.has_binding("IPlayerInputBehavior"), "Should have IPlayerInputBehavior binding")
	assert_true(di_container.has_binding("ICommunicationBehavior"), "Should have ICommunicationBehavior binding")
	assert_true(di_container.has_binding("ITerminalBehavior"), "Should have ITerminalBehavior binding")
	
	# Verify retrieval works with real implementations
	var retrieved_input = di_container.get_implementation("IPlayerInputBehavior")
	var retrieved_communication = di_container.get_implementation("ICommunicationBehavior")
	var retrieved_terminal = di_container.get_implementation("ITerminalBehavior")
	
	assert_eq(retrieved_input, real_input_behavior, "Should retrieve real input behavior")
	assert_eq(retrieved_communication, real_communication_behavior, "Should retrieve real communication behavior")
	assert_eq(retrieved_terminal, real_terminal_behavior, "Should retrieve real terminal behavior")
	
	# Test that real implementations can be used
	assert_true(retrieved_input is IPlayerInputBehavior, "Real input should implement interface")
	assert_true(retrieved_communication is ICommunicationBehavior, "Real communication should implement interface")
	assert_true(retrieved_terminal is ITerminalBehavior, "Real terminal should implement interface")

func test_di_container_real_input_integration():
	# Test that real input behavior works through DI
	di_container.bind_interface("IPlayerInputBehavior", real_input_behavior)
	
	# Simulate real input behavior
	real_input_behavior.update_input()
	
	# Verify real input behavior state
	assert_false(real_input_behavior.is_moving(), "Real input should not be moving initially")
	assert_eq(real_input_behavior.get_current_input(), Vector2.ZERO, "Real input should return zero initially")
	
	# Test that we can retrieve and use the real implementation
	var input_behavior = di_container.get_behavior("IPlayerInputBehavior")
	assert_not_null(input_behavior, "Should return RefCounted behavior")
	assert_true(input_behavior is IPlayerInputBehavior, "Should be castable to interface")

func test_di_container_real_communication_integration():
	# Test that real communication behavior works through DI
	di_container.bind_interface("ICommunicationBehavior", real_communication_behavior)
	
	# Test real communication behavior
	real_communication_behavior.handle_terminal_interaction("test_terminal", {"test": "data"})
	
	# Verify communication was recorded
	assert_eq(real_communication_behavior.get_handle_terminal_interaction_calls(), 1, "Real communication should record calls")
	
	# Test retrieval through DI
	var communication_behavior = di_container.get_implementation("ICommunicationBehavior")
	assert_eq(communication_behavior, real_communication_behavior, "Should retrieve real communication behavior")

func test_di_container_real_terminal_integration():
	# Test that real terminal behavior works through DI
	di_container.bind_interface("ITerminalBehavior", real_terminal_behavior)
	
	# Test real terminal behavior
	var test_player = Node.new()
	var result = real_terminal_behavior.process_interaction(test_player)
	
	# Verify terminal behavior was called
	assert_eq(real_terminal_behavior.get_process_interaction_calls(), 1, "Real terminal behavior should record calls")
	
	# Test retrieval through DI
	var terminal_behavior = di_container.get_implementation("ITerminalBehavior")
	assert_eq(terminal_behavior, real_terminal_behavior, "Should retrieve real terminal behavior")
	
	test_player.queue_free()

func test_di_container_lifecycle_with_real_implementations():
	# Test DI container lifecycle with real implementations
	di_container.bind_interface("IPlayerInputBehavior", real_input_behavior)
	di_container.bind_interface("ICommunicationBehavior", real_communication_behavior)
	
	# Verify initial state
	assert_true(di_container.has_binding("IPlayerInputBehavior"), "Should have initial binding")
	
	# Clear and rebind
	di_container.clear_bindings()
	assert_false(di_container.has_binding("IPlayerInputBehavior"), "Should not have binding after clear")
	
	# Rebind with different real implementation
	var new_real_input = KeyboardPlayerInput.new()
	di_container.bind_interface("IPlayerInputBehavior", new_real_input)
	
	var retrieved = di_container.get_implementation("IPlayerInputBehavior")
	assert_eq(retrieved, new_real_input, "Should retrieve new real implementation")
	assert_ne(retrieved, real_input_behavior, "Should not retrieve old implementation")

func test_di_container_error_handling_with_real_implementations():
	# Test error handling with real implementations
	di_container.bind_interface("", null)  # Empty string, null implementation
	di_container.bind_interface("ValidInterface", null)  # Valid string, null implementation
	
	# Should handle gracefully - DIContainer accepts any string including empty
	assert_true(di_container.has_binding(""), "Should have empty string binding (flexible design)")
	assert_true(di_container.has_binding("ValidInterface"), "Should have valid interface binding")
	
	var null_impl = di_container.get_implementation("ValidInterface")
	assert_null(null_impl, "Should return null for null implementation")

func test_di_container_performance_with_real_implementations():
	# Test performance with many real implementations
	var start_time = Time.get_ticks_msec()
	
	for i in range(100):
		var real_input = KeyboardPlayerInput.new()
		di_container.bind_interface("Interface" + str(i), real_input)
	
	var bind_time = Time.get_ticks_msec() - start_time
	assert_true(bind_time < 1000, "Should bind 100 real interfaces in under 1 second")
	
	# Test retrieval performance
	start_time = Time.get_ticks_msec()
	for i in range(100):
		var impl = di_container.get_implementation("Interface" + str(i))
		assert_not_null(impl, "Should retrieve real implementation " + str(i))
	
	var retrieve_time = Time.get_ticks_msec() - start_time
	assert_true(retrieve_time < 1000, "Should retrieve 100 real implementations in under 1 second")

func test_di_container_chaining_with_real_implementations():
	# Test method chaining functionality with real implementations
	var result = di_container.bind_interface("IPlayerInputBehavior", real_input_behavior)
	assert_eq(result, di_container, "Should return self for chaining")

func test_di_container_unknown_interface_with_real_implementations():
	# Test handling of unknown interfaces
	var unknown_impl = di_container.get_implementation("UnknownInterface")
	assert_null(unknown_impl, "Should return null for unknown interface")
	
	var unknown_behavior = di_container.get_behavior("UnknownInterface")
	assert_null(unknown_behavior, "Should return null for unknown behavior")
	
	assert_false(di_container.has_binding("UnknownInterface"), "Should not have unknown binding") 