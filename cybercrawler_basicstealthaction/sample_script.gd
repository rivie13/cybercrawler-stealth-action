class_name SampleScript
extends RefCounted

# This is a sample script to demonstrate code coverage
# Some functions will be called by tests, others won't

var value: int = 0
var name: String = ""

func _init(initial_value: int = 0, initial_name: String = "default"):
	value = initial_value
	name = initial_name

func add_value(amount: int) -> int:
	value += amount
	return value

func multiply_value(multiplier: int) -> int:
	value *= multiplier
	return value

func get_value() -> int:
	return value

func set_name(new_name: String) -> void:
	name = new_name

func get_name() -> String:
	return name

func is_positive() -> bool:
	return value > 0

func is_negative() -> bool:
	return value < 0

func reset() -> void:
	value = 0
	name = "default"

# This function won't be called by tests - should show up as uncovered
func unused_function() -> String:
	return "This function is not used by any tests"

# This function has a branch that won't be tested
func conditional_function(should_execute: bool) -> String:
	if should_execute:
		return "Executed"
	else:
		# This branch won't be covered in our tests
		return "Not executed" 