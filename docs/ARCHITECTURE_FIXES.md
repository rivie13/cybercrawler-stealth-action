# Architecture Fixes - Proper Godot Patterns

## 🚨 Issues Identified

### **1. Wrong Interface Base Classes**
- **Problem**: `ITerminalSystem` extends `RefCounted` but uses signals
- **Issue**: Signals work best with `Node`-based classes
- **Fix**: Separate behavior contracts from signal contracts

### **2. DIContainer Too Restrictive** 
- **Problem**: Only accepts `RefCounted`, but implementations will be `Node`-based
- **Issue**: Real terminals will be `Area2D` nodes, player will be `CharacterBody2D`
- **Fix**: Make DI container work with any `Object`

### **3. Mixed Responsibilities**
- **Problem**: Interfaces try to combine signals + method contracts
- **Issue**: Creates confusion about inheritance hierarchy
- **Fix**: Separate concerns cleanly

## ✅ **Corrected Godot-Friendly Architecture**

### **Pattern 1: Behavior Contracts (RefCounted)**
```gdscript
# For pure behavior contracts - no signals, no scene tree dependencies
class_name ICommunicationBehavior
extends RefCounted

func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
    pass

func notify_alert_state(alert_level: int, context: Dictionary) -> void:
    pass
```

### **Pattern 2: Signal Interfaces (Node-based or Groups)**
```gdscript
# For signal-based communication - use Godot's group system
# No interface class needed - just documentation of expected signals

# Terminals should emit:  
# - terminal_accessed(terminal_type: String, context: Dictionary)
# - interaction_completed(success: bool, data: Dictionary)

# Players should emit:
# - movement_requested(direction: Vector2) 
# - interaction_requested(target: Node)
```

### **Pattern 3: Flexible DI Container**
```gdscript
class_name DIContainer
extends RefCounted

var _bindings: Dictionary = {}

# Accept any Object (Node or RefCounted)
func bind_interface(interface_name: String, implementation: Object) -> DIContainer:
    _bindings[interface_name] = implementation
    return self

func get_implementation(interface_name: String) -> Object:
    return _bindings.get(interface_name)
```

### **Pattern 4: Composition-Based Components**
```gdscript
# Instead of inheritance-heavy interfaces, use composition
class_name TerminalComponent
extends Node

@export var terminal_type: String
@export var interaction_data: Dictionary

signal interaction_started(terminal: Node, player: Node)
signal interaction_completed(success: bool, data: Dictionary)

var communication_behavior: ICommunicationBehavior

func _init(comm_behavior: ICommunicationBehavior = null):
    communication_behavior = comm_behavior
```

## 🎯 **Recommended Fixes**

### **Step 1: Simplify Interfaces**
- Remove signals from `RefCounted` interfaces
- Focus on pure behavior contracts
- Use Godot groups for signal-based communication

### **Step 2: Fix DI Container** 
- Accept `Object` instead of `RefCounted`
- Support both Node and RefCounted implementations

### **Step 3: Use Composition**
- Inject behavior through composition, not inheritance
- Leverage Godot's built-in systems (groups, signals)

### **Step 4: Test Architecture**
- Verify Node-based terminals work with DI
- Test signal flow without inheritance complexity

This approach follows Godot's philosophy of composition over inheritance and leverages the engine's strengths.