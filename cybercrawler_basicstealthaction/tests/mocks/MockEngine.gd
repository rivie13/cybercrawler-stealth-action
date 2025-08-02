class_name MockEngine
extends RefCounted

var mock_main_loop: MockMainLoop = null
var mock_nodes_in_group: Array = []

func get_main_loop() -> MockMainLoop:
	if mock_main_loop == null:
		mock_main_loop = MockMainLoop.new()
		mock_main_loop.set_nodes_in_group("terminals", mock_nodes_in_group)
	return mock_main_loop

func set_nodes_in_group(group_name: String, nodes: Array):
	mock_nodes_in_group = nodes
	if mock_main_loop:
		mock_main_loop.set_nodes_in_group(group_name, nodes)

func clear():
	mock_main_loop = null
	mock_nodes_in_group.clear() 