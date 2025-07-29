# CyberCrawler Stealth Action - Architecture Design Document

## 🎯 **Simple Core Goal**
**Create a simple player character in a 2.5D world that can interact with different terminals to interface with the tower defense game - using proper DI architecture for future parent repo integration.**

## 🏗️ **Architectural Principles**

### **1. Dependency Injection (DI) First**
- **No hard dependencies** between systems
- **Interface-driven design** - everything communicates through abstractions
- **Composition over inheritance** - build systems by combining smaller components
- **Mock-friendly** - every external dependency can be mocked for testing

### **2. Single Responsibility Principle**
- Each class does **ONE thing well**
- **No monolithic classes** - if a class needs to do X and Y, create two classes
- **Clear boundaries** between systems

### **3. Interface Segregation**
- **Small, focused interfaces** rather than large monolithic ones
- **Client-specific interfaces** - each system only depends on what it needs
- **Loose coupling** between all systems

## 🔧 **Core Architecture Components**

### **1. Interfaces Layer** (`scripts/interfaces/`)
*These define the contracts between systems*

```gdscript
# ICommunicationInterface.gd - How stealth talks to external systems
class_name ICommunicationInterface
extends RefCounted

signal terminal_accessed(terminal_type: String, context: Dictionary)
signal alert_triggered(alert_level: int, location: Vector2)
signal mission_status_changed(status: String, data: Dictionary)

# External systems will implement these methods
func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
    pass

func notify_alert_state(alert_level: int, context: Dictionary) -> void:
    pass
```

```gdscript
# IPlayerInput.gd - How input systems talk to player
class_name IPlayerInput
extends RefCounted

signal move_requested(direction: Vector2)
signal interaction_requested(target: Node)
signal stealth_action_requested(action_type: String)
```

```gdscript
# ITerminalSystem.gd - How terminals communicate
class_name ITerminalSystem 
extends RefCounted

signal terminal_interaction_started(terminal: Node, player: Node)
signal terminal_interaction_ended(terminal: Node, success: bool)

func can_interact(player: Node) -> bool:
    pass

func start_interaction(player: Node) -> void:
    pass
```

### **2. Player System** (`scripts/player/`)
*Single responsibility: Player character behavior*

```gdscript
# PlayerController.gd - Coordinates player behavior
class_name PlayerController
extends CharacterBody2D

var movement_component: PlayerMovementComponent
var interaction_component: PlayerInteractionComponent
var stealth_component: PlayerStealthComponent
var input_handler: IPlayerInput

func _init(p_input_handler: IPlayerInput):
    input_handler = p_input_handler
    _setup_components()

func _setup_components():
    movement_component = PlayerMovementComponent.new()
    interaction_component = PlayerInteractionComponent.new()
    stealth_component = PlayerStealthComponent.new()
```

```gdscript
# PlayerMovementComponent.gd - Only handles movement
class_name PlayerMovementComponent
extends RefCounted

var speed: float = 200.0
var current_direction: Vector2 = Vector2.ZERO

func update_movement(delta: float, character: CharacterBody2D) -> void:
    if current_direction != Vector2.ZERO:
        character.velocity = current_direction * speed
        character.move_and_slide()
```

### **3. Terminal System** (`scripts/terminals/`)
*Single responsibility: Terminal interactions*

```gdscript
# TerminalManager.gd - Coordinates all terminals
class_name TerminalManager
extends Node

var communication_interface: ICommunicationInterface
var active_terminals: Array[BaseTerminal]

func _init(p_communication_interface: ICommunicationInterface):
    communication_interface = p_communication_interface

func register_terminal(terminal: BaseTerminal) -> void:
    active_terminals.append(terminal)
    terminal.interaction_completed.connect(_on_terminal_interaction_completed)
```

```gdscript
# BaseTerminal.gd - Base class for all terminals
class_name BaseTerminal
extends Area2D

signal interaction_started(terminal: BaseTerminal, player: Node)
signal interaction_completed(terminal: BaseTerminal, success: bool, data: Dictionary)

var terminal_type: String
var is_accessible: bool = true
var interaction_data: Dictionary = {}

func can_interact(player: Node) -> bool:
    return is_accessible and _check_specific_requirements(player)

func start_interaction(player: Node) -> void:
    if can_interact(player):
        interaction_started.emit(self, player)
        _perform_interaction(player)

# Override in derived classes
func _check_specific_requirements(player: Node) -> bool:
    return true

func _perform_interaction(player: Node) -> void:
    # Override in derived classes
    pass
```

### **4. Communication Layer** (`scripts/communication/`)
*Single responsibility: Cross-system communication*

```gdscript
# CommunicationHub.gd - Central communication coordinator
class_name CommunicationHub
extends Node

var external_interface: ICommunicationInterface
var terminal_manager: TerminalManager
var alert_manager: AlertManager

func _init(p_external_interface: ICommunicationInterface):
    external_interface = p_external_interface
    _setup_systems()

func _setup_systems():
    terminal_manager = TerminalManager.new(external_interface)
    alert_manager = AlertManager.new(external_interface)
```

### **5. Mock Layer** (`scripts/mocks/`)
*For development and testing*

```gdscript
# MockCommunicationInterface.gd - Mock for testing
class_name MockCommunicationInterface
extends ICommunicationInterface

var terminal_interactions: Array[Dictionary] = []
var alerts_triggered: Array[Dictionary] = []

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
```

## 📋 **Development Plan - Phase by Phase**

### **Phase 1A: Interface Foundation** 🚧 *START HERE*
*Goal: Define all interfaces and mock implementations*

**Tasks:**
1. Create interface definitions (`ICommunicationInterface`, `IPlayerInput`, `ITerminalSystem`)
2. Create mock implementations for all interfaces
3. Set up dependency injection container/pattern
4. Write comprehensive tests for interfaces

**Success Criteria:**
- All interfaces defined with clear contracts
- Mock implementations work and are testable
- DI pattern established and documented

### **Phase 1B: Basic Player System**
*Goal: Simple player that moves in 2.5D space*

**Tasks:**
1. Create `PlayerController` with injected dependencies
2. Implement `PlayerMovementComponent` (movement only)
3. Create basic input handling through `IPlayerInput`
4. Simple 2.5D scene with player character

**Success Criteria:**
- Player moves in 2.5D space
- All dependencies injected (no hard coupling)
- Comprehensive test coverage

### **Phase 1C: Terminal Foundation**
*Goal: Basic terminal interaction system*

**Tasks:**
1. Create `BaseTerminal` class
2. Implement `TerminalManager` with DI
3. Create first terminal type (basic terminal)
4. Test terminal detection and interaction

**Success Criteria:**
- Player can detect and interact with terminals
- Terminal system uses only injected dependencies
- All interactions go through communication interface

### **Phase 2: Multi-Terminal Implementation**
*Goal: All terminal types functional*

**Tasks:**
1. `MainTerminal` - data packet release
2. `TowerPlacementTerminal` - tower deployment interface
3. `MineDeploymentTerminal` - mine placement interface
4. `UpgradeTerminal` - tower enhancement interface
5. Terminal-specific UI components

### **Phase 3: Integration Layer**
*Goal: Communication with external systems*

**Tasks:**
1. `CommunicationHub` implementation
2. `AlertManager` for cross-system alerts
3. State management for mission context
4. Event routing and message passing

## 🧪 **Testing Strategy with DI**

### **Unit Testing Pattern**
```gdscript
extends GutTest

var player_controller: PlayerController
var mock_input: MockPlayerInput
var mock_communication: MockCommunicationInterface

func before_each():
    # Inject mocks - no hard dependencies!
    mock_input = MockPlayerInput.new()
    mock_communication = MockCommunicationInterface.new()
    
    player_controller = PlayerController.new(mock_input)
    # Any other dependencies injected here

func test_player_movement():
    # Test player movement through injected input
    mock_input.emit_signal("move_requested", Vector2.RIGHT)
    
    # Assert behavior without coupling to implementation
    assert_true(player_controller.is_moving())
```

### **Integration Testing**
- Test real interfaces with mock backends
- Test communication flow between systems
- Test full terminal interaction workflows

## 🔄 **DI Container Pattern**

```gdscript
# DIContainer.gd - Simple dependency injection
class_name DIContainer
extends RefCounted

var _bindings: Dictionary = {}

func bind_interface(interface_class: String, implementation: RefCounted) -> DIContainer:
    _bindings[interface_class] = implementation
    return self

func get_implementation(interface_class: String) -> RefCounted:
    if _bindings.has(interface_class):
        return _bindings[interface_class]
    else:
        push_error("No binding found for interface: " + interface_class)
        return null
```

### **Usage Example:**
```gdscript
# In main game setup
func setup_game():
    var container = DIContainer.new()
    
    # For development - use mocks
    container.bind_interface("ICommunicationInterface", MockCommunicationInterface.new())
    container.bind_interface("IPlayerInput", KeyboardPlayerInput.new())
    
    # Create systems with injected dependencies
    var player = PlayerController.new(container.get_implementation("IPlayerInput"))
    var comm_hub = CommunicationHub.new(container.get_implementation("ICommunicationInterface"))
```

## 🎯 **Integration Points for Parent Repo**

When the parent repo integrates this stealth action system:

### **Real Interface Implementation:**
```gdscript
# In parent repo: RealCommunicationInterface.gd  
extends ICommunicationInterface

var tower_defense_system: TowerDefenseSystem

func handle_terminal_interaction(terminal_type: String, context: Dictionary) -> void:
    # REAL implementation that talks to TD system
    match terminal_type:
        "tower_placement":
            tower_defense_system.open_tower_placement_mode(context)
        "main_terminal":
            tower_defense_system.start_mission(context)
```

### **Parent Repo Setup:**
```gdscript
# In parent repo main scene
func setup_integrated_game():
    var container = DIContainer.new()
    
    # Use REAL implementations
    container.bind_interface("ICommunicationInterface", RealCommunicationInterface.new())
    
    # Stealth system uses real interfaces
    var stealth_system = load("res://submodules/stealth-action/scenes/StealthSystem.tscn").instantiate()
    stealth_system.initialize(container)
```

## ✅ **Why This Architecture is Superior**

1. **Testable**: Every component can be tested in isolation
2. **Maintainable**: Clear boundaries, single responsibilities
3. **Flexible**: Easy to swap implementations
4. **Scalable**: Add new terminal types without changing existing code
5. **Integration-Ready**: Parent repo can inject real implementations seamlessly

## 🚀 **Next Steps**

1. **Review this architecture** - does it align with your vision?
2. **Start with Phase 1A** - build the interface foundation
3. **Test everything** - ensure each component works in isolation
4. **Iterate and improve** - refine based on what you learn

This architecture ensures you'll never build monolithic classes, everything is testable, and the parent repo integration will be seamless!

**Are you ready to start building the interface foundation?** 🎯