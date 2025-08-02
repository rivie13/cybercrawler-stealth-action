class_name PlayerInteractionComponent
extends RefCounted

var interaction_range: float = 50.0
var current_target: Node = null

func find_interaction_target(player_position: Vector2) -> Node:
    # Use Godot groups to find terminals
    var terminals = Engine.get_main_loop().get_nodes_in_group("terminals")
    var closest_terminal: Node = null
    var closest_distance: float = interaction_range
    
    for terminal in terminals:
        if terminal.has_method("get_global_position"):
            var terminal_pos_3d = terminal.get_global_position()
            var terminal_pos_2d = Vector2(terminal_pos_3d.x, terminal_pos_3d.z)  # Convert 3D to 2D
            var distance = player_position.distance_to(terminal_pos_2d)
            if distance < closest_distance:
                closest_distance = distance
                closest_terminal = terminal
    
    current_target = closest_terminal
    return current_target

func can_interact() -> bool:
    return current_target != null and current_target.has_method("can_interact")

func get_interaction_target() -> Node:
    return current_target