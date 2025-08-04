class_name MockTime
extends RefCounted

var mock_time_dict: Dictionary = {"second": 0}

func get_time_dict_from_system() -> Dictionary:
	return mock_time_dict

func set_time_dict(time_dict: Dictionary):
	mock_time_dict = time_dict

func set_second(second: int):
	mock_time_dict["second"] = second

func clear():
	mock_time_dict = {"second": 0} 