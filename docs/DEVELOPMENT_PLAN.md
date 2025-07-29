# Development Plan - Step by Step Implementation

## 🎯 **Current Goal: Phase 1A - Interface Foundation**

**Simple Objective**: Create the interface layer that defines how all systems will communicate, with mock implementations for testing.

## 📋 **Phase 1A: Interface Foundation** *START HERE*

### **Step 1: Create Directory Structure**
```
cybercrawler_basicstealthaction/
├── scripts/
│   ├── interfaces/          # Interface definitions
│   ├── mocks/              # Mock implementations  
│   ├── player/             # Player system (future)
│   ├── terminals/          # Terminal system (future)
│   ├── communication/      # Communication layer (future)
│   └── di/                 # Dependency injection
└── tests/
    ├── integration/        # Integration tests
    ├── unit/              # Unit tests
    └── mocks/             # Mock-specific tests
```

### **Step 2: Create Core Interfaces**

#### **2.1: ICommunicationInterface.gd**
*How stealth system talks to external systems (tower defense)*

```gdscript
class_name ICommunicationInterface
extends RefCounted

# Signals for external system communication
signal terminal_accessed(terminal_type: String, context: Dictionary)
signal alert_triggered(alert_level: int, location: Vector2)
signal mission_status_changed(status: String, data: Dictionary)

# Methods external systems implement
func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
    # Override in implementations
    pass

func notify_alert_state(alert_level: int, context: Dictionary) -> void:
    # Override in implementations  
    pass

func get_mission_context() -> Dictionary:
    # Override in implementations
    return {}
```

#### **2.2: IPlayerInput.gd**
*How input systems communicate with player*

```gdscript
class_name IPlayerInput
extends RefCounted

# Input event signals
signal move_requested(direction: Vector2)
signal interaction_requested(target: Node)
signal stealth_action_requested(action_type: String)

# Input query methods
func is_moving() -> bool:
    # Override in implementations
    return false

func get_current_input() -> Vector2:
    # Override in implementations
    return Vector2.ZERO
```

#### **2.3: ITerminalSystem.gd**
*How terminals communicate with other systems*

```gdscript
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
```

### **Step 3: Create Mock Implementations**

#### **3.1: MockCommunicationInterface.gd**
*Mock for testing and development*

```gdscript
class_name MockCommunicationInterface
extends ICommunicationInterface

# Track interactions for testing
var terminal_interactions: Array[Dictionary] = []
var alerts_triggered: Array[Dictionary] = []
var mission_context: Dictionary = {}

func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
    terminal_interactions.append({
        "type": terminal_type,
        "context": context,
        "timestamp": Time.get_time_dict_from_system()
    })

func notify_alert_state(alert_level: int, context: Dictionary) -> void:
    alerts_triggered.append({
        "level": alert_level,
        "context": context,
        "timestamp": Time.get_time_dict_from_system()
    })

func get_mission_context() -> Dictionary:
    return mission_context

# Testing helper methods
func set_mission_context(context: Dictionary) -> void:
    mission_context = context

func get_interaction_count() -> int:
    return terminal_interactions.size()

func get_last_interaction() -> Dictionary:
    if terminal_interactions.size() > 0:
        return terminal_interactions[-1]
    return {}
```

#### **3.2: MockPlayerInput.gd**
```gdscript
class_name MockPlayerInput
extends IPlayerInput

var _current_direction: Vector2 = Vector2.ZERO
var _is_moving: bool = false

func is_moving() -> bool:
    return _is_moving

func get_current_input() -> Vector2:
    return _current_direction

# Testing helper methods
func simulate_movement(direction: Vector2) -> void:
    _current_direction = direction
    _is_moving = direction != Vector2.ZERO
    move_requested.emit(direction)

func simulate_interaction(target: Node) -> void:
    interaction_requested.emit(target)

func simulate_stealth_action(action_type: String) -> void:
    stealth_action_requested.emit(action_type)
```

### **Step 4: Create DI Container**

#### **4.1: DIContainer.gd**
```gdscript
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
```

### **Step 5: Create Comprehensive Tests**

#### **5.1: test_interfaces.gd**
```gdscript
extends GutTest

class_name TestInterfaces

func test_communication_interface_contract():
    var interface = ICommunicationInterface.new()
    
    # Test that base interface exists and has required methods
    assert_true(interface.has_method("handle_terminal_interaction"))
    assert_true(interface.has_method("notify_alert_state"))
    assert_true(interface.has_method("get_mission_context"))

func test_mock_communication_interface():
    var mock = MockCommunicationInterface.new()
    var test_context = {"test": "data"}
    
    # Test terminal interaction tracking
    mock.handle_terminal_interaction("tower_placement", test_context)
    assert_eq(mock.get_interaction_count(), 1)
    
    var last_interaction = mock.get_last_interaction()
    assert_eq(last_interaction["type"], "tower_placement")
    assert_eq(last_interaction["context"], test_context)

func test_di_container():
    var container = DIContainer.new()
    var mock_comm = MockCommunicationInterface.new()
    
    # Test binding and retrieval
    container.bind_interface("ICommunicationInterface", mock_comm)
    
    var retrieved = container.get_implementation("ICommunicationInterface")
    assert_eq(retrieved, mock_comm)
    
    # Test unknown interface
    var unknown = container.get_implementation("UnknownInterface")
    assert_null(unknown)
```

### **Step 6: Create Simple Integration Test**

#### **6.1: test_interface_integration.gd**
```gdscript
extends GutTest

class_name TestInterfaceIntegration

var container: DIContainer
var mock_comm: MockCommunicationInterface
var mock_input: MockPlayerInput

func before_each():
    container = DIContainer.new()
    mock_comm = MockCommunicationInterface.new()
    mock_input = MockPlayerInput.new()
    
    container.bind_interface("ICommunicationInterface", mock_comm)
    container.bind_interface("IPlayerInput", mock_input)

func test_dependency_injection_flow():
    # Test that we can retrieve and use injected dependencies
    var comm_interface = container.get_implementation("ICommunicationInterface")
    var input_interface = container.get_implementation("IPlayerInput")
    
    assert_not_null(comm_interface)
    assert_not_null(input_interface)
    
    # Test communication flow
    comm_interface.handle_terminal_interaction("test_terminal", {"player": "test"})
    assert_eq(mock_comm.get_interaction_count(), 1)
    
    # Test input simulation
    input_interface.simulate_movement(Vector2.RIGHT)
    assert_eq(input_interface.get_current_input(), Vector2.RIGHT)
```

## ✅ **Success Criteria for Phase 1A**

When this phase is complete, you should have:

1. **✅ All interfaces defined** with clear contracts
2. **✅ Mock implementations** that are fully testable
3. **✅ DI container working** with proper binding/retrieval
4. **✅ Comprehensive tests** covering all interface contracts
5. **✅ 100% test coverage** for interface and mock code
6. **✅ Documentation** showing how to use the DI pattern

## 🔄 **Testing the Phase 1A Implementation**

Run tests to verify everything works:

```bash
cd cybercrawler_basicstealthaction
& "C:\Program Files\Godot\Godot_v4.4.1-stable_win64_console.exe" --headless --script addons/gut/gut_cmdln.gd -gexit
```

Expected output:
- All interface tests pass
- Mock implementations work correctly
- DI container functions properly
- High test coverage (90%+)

## 🚀 **After Phase 1A: What's Next**

Once the interface foundation is solid:

1. **Phase 1B**: Build basic PlayerController using the interfaces
2. **Phase 1C**: Create terminal system with BaseTerminal
3. **Integration**: Test everything working together

## 💡 **Key Principles to Remember**

1. **No hard dependencies** - everything goes through interfaces
2. **Test everything** - every interface, every mock, every interaction
3. **Keep it simple** - start with minimal functionality
4. **One responsibility per class** - no monolithic components

**Ready to start building the interface foundation?** 🎯