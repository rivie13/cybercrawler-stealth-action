class_name ITerminalSystem
extends RefCounted

# Terminal event signals
signal terminal_interaction_started(terminal: Node, player: Node)
signal terminal_interaction_ended(terminal: Node, success: bool)

# Terminal interface methods
func can_interact(player: Node) -> bool:
    # Override in implementations
    return false

func start_interaction(player: Node) -> void:
    # Override in implementations
    pass

func end_interaction(success: bool) -> void:
    # Override in implementations
    pass