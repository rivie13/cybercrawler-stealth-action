class_name PlayerInteractionComponent
extends RefCounted

var interaction_range: float = 16.0  # reduced to 1 tile - must be closer to terminal
var current_target: Node = null
var tilemap: Object = null
var last_search_time: float = 0.0
var search_cooldown: float = 0.5  # Only log every 0.5 seconds
var _engine_system: Object = Engine  # Default to global Engine, but can be injected for testing
var _time_system: Object = Time  # Default to global Time, but can be injected for testing

func _init(engine_system: Object = null, time_system: Object = null):
	if engine_system != null:
		_engine_system = engine_system
	if time_system != null:
		_time_system = time_system

func set_tilemap(tm: Object) -> void:
	tilemap = tm

func find_interaction_target(player_position: Vector2) -> Node:
	# Find nodes in terminals group (these are the actual terminal objects)
	var terminals = _engine_system.get_main_loop().get_nodes_in_group("terminals")
	var closest_terminal: Node = null
	var closest_distance: float = max(interaction_range, 0.0)  # Handle negative ranges by treating as zero
	
	# Only log occasionally to prevent spam
	var current_time = _time_system.get_time_dict_from_system().get("second", 0)
	if current_time - last_search_time > search_cooldown:
		print("🔍 Searching for terminals in group 'terminals'. Found ", terminals.size(), " terminals")
		last_search_time = current_time
	
	for terminal in terminals:
		if terminal.has_method("get_global_position"):
			var distance = player_position.distance_to(terminal.get_global_position())
			if distance <= closest_distance:
				closest_distance = distance
				closest_terminal = terminal
				# Only log when we find a new closest terminal
				if current_time - last_search_time > search_cooldown:
					print("✅ Selected terminal '", terminal.name, "' as closest")
	
	current_target = closest_terminal
	if current_target and current_time - last_search_time > search_cooldown:
		print("🎯 Current interaction target: ", current_target.name, " at ", current_target.get_global_position())
	elif not current_target and current_time - last_search_time > search_cooldown:
		print("❌ No terminal found within interaction range")
	
	return current_target

func create_terminal_object(world_pos: Vector2, source_id: int) -> Node:
	# Create a simple object to represent the terminal tile
	var terminal = StaticBody2D.new()
	terminal.set_script(load("res://scripts/terminals/TerminalTile.gd"))
	terminal.global_position = world_pos
	terminal.terminal_type = "terminal_" + str(source_id)
	terminal.name = "Terminal_" + str(source_id) + "_" + str(world_pos.x) + "_" + str(world_pos.y)
	return terminal

func can_interact() -> bool:
	return current_target != null

func get_interaction_target() -> Node:
	return current_target