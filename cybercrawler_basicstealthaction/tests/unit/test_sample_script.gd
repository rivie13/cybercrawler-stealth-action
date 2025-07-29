extends GutTest

# This test file demonstrates code coverage by testing SampleScript
# Some functions will be tested (covered) and others won't (uncovered)

class_name TestSampleScript

var sample_script: SampleScript

func before_each():
	# Create a new instance before each test
	sample_script = SampleScript.new(10, "test")

func after_each():
	# Clean up after each test
	sample_script = null

func test_initialization():
	assert_eq(sample_script.get_value(), 10, "Initial value should be set correctly")
	assert_eq(sample_script.get_name(), "test", "Initial name should be set correctly")

func test_add_value():
	var result = sample_script.add_value(5)
	assert_eq(result, 15, "Adding 5 to 10 should result in 15")
	assert_eq(sample_script.get_value(), 15, "Value should be updated")

func test_multiply_value():
	var result = sample_script.multiply_value(3)
	assert_eq(result, 30, "Multiplying 10 by 3 should result in 30")
	assert_eq(sample_script.get_value(), 30, "Value should be updated")

func test_name_operations():
	sample_script.set_name("new_name")
	assert_eq(sample_script.get_name(), "new_name", "Name should be updated correctly")

func test_is_positive():
	assert_true(sample_script.is_positive(), "10 should be positive")
	
	sample_script = SampleScript.new(-5)
	assert_false(sample_script.is_positive(), "-5 should not be positive")

func test_is_negative():
	# This will create coverage for is_negative when value is positive
	assert_false(sample_script.is_negative(), "10 should not be negative")

func test_reset():
	sample_script.reset()
	assert_eq(sample_script.get_value(), 0, "Value should be reset to 0")
	assert_eq(sample_script.get_name(), "default", "Name should be reset to default")

func test_conditional_function_true_branch():
	# This will cover the true branch of conditional_function
	var result = sample_script.conditional_function(true)
	assert_eq(result, "Executed", "Should return 'Executed' when true")

# Note: We're not testing the false branch of conditional_function
# and we're not testing unused_function at all
# This will demonstrate partial coverage in the coverage report 