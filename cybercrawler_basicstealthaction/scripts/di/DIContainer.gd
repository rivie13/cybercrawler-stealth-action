class_name DIContainer
extends RefCounted

var _bindings: Dictionary = {}

func bind_interface(interface_name: String, implementation: RefCounted) -> DIContainer:
    _bindings[interface_name] = implementation
    return self

func get_implementation(interface_name: String) -> RefCounted:
    if _bindings.has(interface_name):
        return _bindings[interface_name]
    else:
        push_error("No binding found for interface: " + interface_name)
        return null

func has_binding(interface_name: String) -> bool:
    return _bindings.has(interface_name)

func clear_bindings() -> void:
    _bindings.clear()