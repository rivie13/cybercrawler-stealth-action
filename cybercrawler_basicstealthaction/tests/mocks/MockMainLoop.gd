class_name MockMainLoop
extends RefCounted

var mock_nodes_in_group: Dictionary = {}

func get_nodes_in_group(group_name: String) -> Array:
	return mock_nodes_in_group.get(group_name, [])

func set_nodes_in_group(group_name: String, nodes: Array):
	mock_nodes_in_group[group_name] = nodes

func clear():
	mock_nodes_in_group.clear() 