class_name PlayerInteractionComponent
extends RefCounted

var interaction_range: float = 32.0  # reduced to 2 tiles - must be closer to terminal
var current_target: Node = null
var tilemap: TileMapLayer = null

func set_tilemap(tm: TileMapLayer) -> void:
	tilemap = tm

func find_interaction_target(player_position: Vector2) -> Node:
	# Find nodes in terminals group (these are the actual terminal objects)
	var terminals = Engine.get_main_loop().get_nodes_in_group("terminals")
	var closest_terminal: Node = null
	var closest_distance: float = interaction_range
	
	print("🔍 Searching for terminals in group 'terminals'. Found ", terminals.size(), " terminals")
	
	for terminal in terminals:
		if terminal.has_method("get_global_position"):
			var distance = player_position.distance_to(terminal.get_global_position())
			print("🎯 Terminal '", terminal.name, "' at distance: ", distance, " (range: ", interaction_range, ")")
			if distance < closest_distance:
				closest_distance = distance
				closest_terminal = terminal
				print("✅ Selected terminal '", terminal.name, "' as closest")
	
	current_target = closest_terminal
	if current_target:
		print("🎯 Current interaction target: ", current_target.name, " at ", current_target.get_global_position())
	else:
		print("❌ No terminal found within interaction range")
	
	return current_target

func create_terminal_object(world_pos: Vector2, source_id: int) -> Node:
	# Create a simple object to represent the terminal tile
	var terminal = Node2D.new()
	terminal.set_script(load("res://scripts/TerminalTile.gd"))
	terminal.global_position = world_pos
	terminal.terminal_type = "terminal_" + str(source_id)
	terminal.name = "Terminal_" + str(source_id) + "_" + str(world_pos.x) + "_" + str(world_pos.y)
	return terminal

func can_interact() -> bool:
	return current_target != null

func get_interaction_target() -> Node:
	return current_target