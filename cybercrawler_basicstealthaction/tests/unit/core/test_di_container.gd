extends GutTest

class_name TestDIContainer

var di_container: DIContainer

func before_each():
	di_container = DIContainer.new()

func after_each():
	if di_container:
		di_container.clear_bindings()
		di_container = null

# Test binding interfaces to implementations
func test_bind_interface():
	# Arrange
	var mock_implementation = RefCounted.new()
	
	# Act
	var result = di_container.bind_interface("ITestInterface", mock_implementation)
	
	# Assert
	assert_eq(result, di_container, "Should return self for chaining")
	assert_true(di_container.has_binding("ITestInterface"), "Should have binding after bind_interface")

# Test retrieving implementations
func test_get_implementation():
	# Arrange
	var mock_implementation = RefCounted.new()
	di_container.bind_interface("ITestInterface", mock_implementation)
	
	# Act
	var result = di_container.get_implementation("ITestInterface")
	
	# Assert
	assert_eq(result, mock_implementation, "Should return the bound implementation")

# Test getting unknown implementation
func test_get_implementation_unknown():
	# Act
	var result = di_container.get_implementation("UnknownInterface")
	
	# Assert
	assert_eq(result, null, "Should return null for unknown interface")

# Test checking if binding exists
func test_has_binding():
	# Arrange
	var mock_implementation = RefCounted.new()
	di_container.bind_interface("ITestInterface", mock_implementation)
	
	# Act & Assert
	assert_true(di_container.has_binding("ITestInterface"), "Should return true for existing binding")
	assert_false(di_container.has_binding("UnknownInterface"), "Should return false for non-existent binding")

# Test clearing all bindings
func test_clear_bindings():
	# Arrange
	var mock1 = RefCounted.new()
	var mock2 = RefCounted.new()
	di_container.bind_interface("IInterface1", mock1)
	di_container.bind_interface("IInterface2", mock2)
	
	# Act
	di_container.clear_bindings()
	
	# Assert
	assert_false(di_container.has_binding("IInterface1"), "Should not have binding after clear")
	assert_false(di_container.has_binding("IInterface2"), "Should not have binding after clear")

# Test safe casting with RefCounted
func test_get_behavior_with_refcounted():
	# Arrange
	var mock_implementation = RefCounted.new()
	di_container.bind_interface("ITestInterface", mock_implementation)
	
	# Act
	var result = di_container.get_behavior("ITestInterface")
	
	# Assert
	assert_eq(result, mock_implementation, "Should return RefCounted implementation")

# Test safe casting with non-RefCounted
func test_get_behavior_with_non_refcounted():
	# Arrange
	var mock_implementation = Node.new()
	di_container.bind_interface("ITestInterface", mock_implementation)
	
	# Act
	var result = di_container.get_behavior("ITestInterface")
	
	# Assert
	assert_eq(result, null, "Should return null for non-RefCounted implementation")
	
	# Cleanup
	mock_implementation.queue_free()

# Test chaining bind_interface calls
func test_bind_interface_chaining():
	# Arrange
	var mock1 = RefCounted.new()
	var mock2 = RefCounted.new()
	
	# Act
	var result = di_container.bind_interface("IInterface1", mock1).bind_interface("IInterface2", mock2)
	
	# Assert
	assert_eq(result, di_container, "Should return self for chaining")
	assert_true(di_container.has_binding("IInterface1"), "Should have first binding")
	assert_true(di_container.has_binding("IInterface2"), "Should have second binding")

# Test multiple bindings
func test_multiple_bindings():
	# Arrange
	var mock1 = RefCounted.new()
	var mock2 = RefCounted.new()
	var mock3 = RefCounted.new()
	
	# Act
	di_container.bind_interface("IInterface1", mock1)
	di_container.bind_interface("IInterface2", mock2)
	di_container.bind_interface("IInterface3", mock3)
	
	# Assert
	assert_eq(di_container.get_implementation("IInterface1"), mock1, "Should return first implementation")
	assert_eq(di_container.get_implementation("IInterface2"), mock2, "Should return second implementation")
	assert_eq(di_container.get_implementation("IInterface3"), mock3, "Should return third implementation")

# Test binding null implementation
func test_bind_null_implementation():
	# Act
	di_container.bind_interface("ITestInterface", null)
	
	# Assert
	assert_true(di_container.has_binding("ITestInterface"), "Should have binding even for null")
	assert_eq(di_container.get_implementation("ITestInterface"), null, "Should return null implementation")

# Test get_behavior with unknown interface
func test_get_behavior_unknown():
	# Act
	var result = di_container.get_behavior("UnknownInterface")
	
	# Assert
	assert_eq(result, null, "Should return null for unknown interface") 