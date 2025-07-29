extends GutTest

# This is a simple test to verify the testing and coverage system is working
# This file demonstrates how to write tests with GUT and verify coverage

class_name TestSample

func test_basic_assertion():
	# Basic assertion test
	assert_true(true, "Basic assertion should pass")
	assert_false(false, "False assertion should pass")
	assert_eq(1 + 1, 2, "Math should work correctly")

func test_string_operations():
	var test_string = "Hello, World!"
	assert_eq(test_string.length(), 13, "String length should be correct")
	assert_true(test_string.begins_with("Hello"), "String should start with Hello")
	assert_true(test_string.ends_with("World!"), "String should end with World!")

func test_array_operations():
	var test_array = [1, 2, 3, 4, 5]
	assert_eq(test_array.size(), 5, "Array should have 5 elements")
	assert_has(test_array, 3, "Array should contain the number 3")
	assert_does_not_have(test_array, 10, "Array should not contain the number 10")

func test_dictionary_operations():
	var test_dict = {"name": "Test", "value": 42, "active": true}
	assert_eq(test_dict["name"], "Test", "Dictionary should contain correct name")
	assert_eq(test_dict["value"], 42, "Dictionary should contain correct value")
	assert_true(test_dict["active"], "Dictionary should contain correct active state")

# This test intentionally fails to show how failing tests look
func test_intentional_failure():
	# Comment out the next line to make all tests pass
	# assert_true(false, "This test is intentionally failing to demonstrate test output")
	pass  # This line makes the test pass instead 