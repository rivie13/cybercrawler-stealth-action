class_name DIContainer
extends RefCounted

var _bindings: Dictionary = {}

# Accept any Object (Node or RefCounted) - follows Godot's flexible approach
func bind_interface(interface_name: String, implementation: Object) -> DIContainer:
    # Allow null implementations for flexibility
    if implementation == null:
        _bindings[interface_name] = null
        return self
    
    # For non-null implementations, ensure they are Node or RefCounted
    if not (implementation is Node or implementation is RefCounted):
        push_error("DIContainer: Implementation for '%s' must be a Node or RefCounted, got %s. This ensures compatibility with Godot's scene tree and memory management." % [interface_name, typeof(implementation)])
        return self
    
    _bindings[interface_name] = implementation
    return self

func get_implementation(interface_name: String) -> Object:
    return _bindings.get(interface_name)

func has_binding(interface_name: String) -> bool:
    return _bindings.has(interface_name)

func clear_bindings() -> void:
    _bindings.clear()

# Helper for safe casting
func get_behavior(interface_name: String) -> RefCounted:
    var impl = get_implementation(interface_name)
    if impl is RefCounted:
        return impl as RefCounted
    return null