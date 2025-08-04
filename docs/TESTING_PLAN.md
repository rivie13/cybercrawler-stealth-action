# CyberCrawler Stealth Action - Comprehensive Testing Plan

## 📊 Current State Analysis

### Existing Test Infrastructure ✅
- **GUT Framework**: Properly configured with coverage analysis
- **Coverage System**: Working with strict coverage requirements
- **Hook Scripts**: Pre-run and post-run hooks for coverage instrumentation
- **Test Structure**: Organized into unit, integration, and system tests
- **CI/CD**: GitHub Actions workflow for automated testing

### Current Test Coverage Status ❌
- **Sample Tests Only**: Current tests are examples (`test_sample.gd`, `test_sample_script.gd`)
- **Missing Coverage**: Core gameplay systems have no tests
- **Low Coverage**: Actual code coverage is minimal despite infrastructure
- **Mock Organization Issue**: Mocks are in `scripts/mocks/` but should be in `tests/mocks/`

### Strict Coverage Requirements ⚠️
- **Per-File Coverage**: 50% OR 100 lines covered (whichever is lower)
- **Total Coverage**: 75% minimum when 90% of files have tests
- **Test Coverage**: 90% of files that should have tests must have tests
- **Validation**: Post-run hook enforces these requirements and fails tests if not met

### Complete Codebase Analysis

#### Core Systems (Need Unit Tests)
1. **Dependency Injection** (`core/di/DIContainer.gd`) - **25 lines** - Need 50% (13 lines)
2. **Main Game Controller** (`core/Main.gd`) - **91 lines** - Need 50% (46 lines)

#### Interface Contracts (Need Integration Tests)
3. **IPlayerInputBehavior** (`core/interfaces/IPlayerInput.gd`) - **21 lines** - NO TESTS NEEDED
4. **ICommunicationBehavior** (`core/interfaces/ICommunicationInterface.gd`) - **17 lines** - NO TESTS NEEDED
5. **ITerminalBehavior** (`core/interfaces/ITerminalSystem.gd`) - **25 lines** - NO TESTS NEEDED

#### Player Systems (Need Unit Tests)
6. **Player Controller** (`player/created_player.gd`) - **276 lines** - Need 50% (138 lines)
7. **Movement Component** (`player/components/PlayerMovementComponent.gd`) - **23 lines** - Need 50% (12 lines)
8. **Interaction Component** (`player/components/PlayerInteractionComponent.gd`) - **56 lines** - Need 50% (28 lines)
9. **Keyboard Input** (`player/input/KeyboardPlayerInput.gd`) - **54 lines** - Need 50% (27 lines)
10. **Input Setup** (`player/input/InputSetup.gd`) - **23 lines** - NO TESTS NEEDED (documentation only)

#### Terminal Systems (Need Unit Tests)
11. **Terminal Tile Identifier** (`terminals/TerminalTileIdentifier.gd`) - **47 lines** - Need 50% (24 lines)
12. **Terminal Spawner** (`terminals/TerminalSpawner.gd`) - **70 lines** - Need 50% (35 lines)
13. **Terminal Objects** (`terminals/TerminalObject.gd`) - **57 lines** - Need 50% (29 lines)
14. **Terminal Tile** (`terminals/TerminalTile.gd`) - **33 lines** - Need 50% (17 lines)
15. **Terminal Detector** (`terminals/TerminalDetector.gd`) - **86 lines** - Need 50% (43 lines)

#### UI Systems (Need Unit Tests)
16. **Cyberpunk Interaction UI** (`player/ui/CyberpunkInteractionUI.gd`) - **277 lines** - Need 50% (139 lines)

#### Mock Systems (Need to Move to Tests)
17. **Mock Implementations** (`scripts/mocks/`) - **130 lines total**
   - `MockCommunicationBehavior.gd` - **40 lines**
   - `MockPlayerInputBehavior.gd` - **36 lines**
   - `MockTerminalBehavior.gd` - **54 lines**

#### Utility Scripts (No Tests Needed)
18. **Test Tile Identification** (`test_tile_identification.gd`) - **59 lines** - NO TESTS NEEDED (debug script)
19. **Scene Files** (`.tscn`) - No testing needed

## 📝 Testing Strategy

### Unit Tests (Non-Interface Concrete Classes)

#### Phase 1: Core Infrastructure Tests (Priority: HIGH)
**Goal**: Ensure foundational systems work correctly

##### 1.1 Dependency Injection Tests
- **File**: `tests/unit/test_di_container.gd`
- **Coverage**: `core/di/DIContainer.gd` (25 lines) - Need 50% (13 lines)
- **Test Cases**:
  - `bind_interface()` - binding interfaces to implementations
  - `get_implementation()` - retrieving implementations safely
  - `has_binding()` - checking if interface exists
  - `clear_bindings()` - clearing all bindings
  - `get_behavior()` - safe casting to RefCounted
  - Error handling for unknown interfaces
  - Type safety with different object types

##### 1.2 Main Controller Tests
- **File**: `tests/unit/test_main_controller.gd`
- **Coverage**: `core/Main.gd` (91 lines) - Need 50% (46 lines)
- **Test Cases**:
  - `_ready()` - initialization sequence
  - `setup_dependency_injection()` - DI container setup
  - `initialize_player_system()` - player initialization
  - `setup_terminal_spawner()` - terminal spawner setup
  - `cleanup()` - cleanup procedures
  - `_notification()` - window close handling
  - Error handling for missing nodes
  - Mock scene tree dependencies

#### Phase 2: Player System Tests (Priority: HIGH)
**Goal**: Ensure player mechanics work correctly

##### 2.1 Player Movement Component Tests
- **File**: `tests/unit/test_player_movement_component.gd`
- **Coverage**: `player/components/PlayerMovementComponent.gd` (23 lines) - Need 50% (12 lines)
- **Test Cases**:
  - `update_movement()` - movement calculation with acceleration
  - `get_current_direction()` - direction tracking
  - `is_moving()` - movement state detection
  - Diagonal movement normalization
  - Acceleration and deceleration curves
  - Zero input handling
  - Edge cases with extreme values

##### 2.2 Player Interaction Component Tests
- **File**: `tests/unit/test_player_interaction_component.gd`
- **Coverage**: `player/components/PlayerInteractionComponent.gd` (56 lines) - Need 50% (28 lines)
- **Test Cases**:
  - `find_interaction_target()` - target finding logic
  - `set_tilemap()` - tilemap reference setting
  - `can_interact()` - interaction availability
  - `get_interaction_target()` - current target access
  - `create_terminal_object()` - terminal object creation
  - Range-based target selection
  - Multiple terminal scenarios
  - No terminal scenarios
  - Mock tilemap integration

##### 2.3 Keyboard Input Tests
- **File**: `tests/unit/test_keyboard_input.gd`
- **Coverage**: `player/input/KeyboardPlayerInput.gd` (54 lines) - Need 50% (27 lines)
- **Test Cases**:
  - `update_input()` - input processing
  - `is_moving()` - movement state
  - `get_current_input()` - current input direction
  - `get_interaction_target()` - interaction target
  - `is_stealth_action_active()` - stealth state
  - `set_interaction_target()` - target setting
  - Input mapping validation
  - Multiple key combinations
  - Stealth toggle functionality
  - Input state management

##### 2.4 Player Controller Tests
- **File**: `tests/unit/test_player_controller.gd`
- **Coverage**: `player/created_player.gd` (276 lines) - Need 50% (138 lines)
- **Test Cases**:
  - `initialize()` - DI container integration
  - `_physics_process()` - main game loop
  - `_handle_movement()` - movement handling
  - `_handle_interactions()` - interaction handling
  - `_perform_interaction()` - interaction execution
  - `_update_visual_effects()` - visual feedback
  - `_update_debug_info()` - debug information
  - Stealth mode visual effects
  - Interaction indicator display
  - Error handling for missing dependencies

#### Phase 3: Terminal System Tests (Priority: MEDIUM)
**Goal**: Ensure terminal mechanics work correctly

##### 3.1 Terminal Tile Identifier Tests
- **File**: `tests/unit/test_terminal_tile_identifier.gd`
- **Coverage**: `terminals/TerminalTileIdentifier.gd` (47 lines) - Need 50% (24 lines)
- **Test Cases**:
  - `is_terminal_tile()` - terminal detection
  - `get_terminal_type_from_atlas()` - type mapping
  - `get_all_terminal_coords()` - coordinate listing
  - `debug_print_terminals()` - debug functionality
  - All known terminal coordinates
  - Invalid coordinate handling
  - Edge cases with boundary values

##### 3.2 Terminal Spawner Tests
- **File**: `tests/unit/test_terminal_spawner.gd`
- **Coverage**: `terminals/TerminalSpawner.gd` (70 lines) - Need 50% (35 lines)
- **Test Cases**:
  - `spawn_terminals()` - terminal spawning logic
  - `_ready()` - initialization
  - Tilemap integration
  - DI container integration
  - Terminal object creation
  - Collision shape setup
  - Group assignment
  - Error handling for missing dependencies
  - Mock tilemap scenarios

##### 3.3 Terminal Object Tests
- **File**: `tests/unit/test_terminal_objects.gd`
- **Coverage**: `terminals/TerminalObject.gd` (57 lines) + `terminals/TerminalTile.gd` (33 lines) - Need 50% (45 lines)
- **Test Cases**:
  - `interact_with_player()` - interaction logic
  - `get_terminal_type()` - type retrieval
  - `can_interact()` - interaction availability
  - `set_terminal_behavior()` - behavior assignment
  - Visual representation setup
  - Collision detection
  - Group membership
  - Error handling

##### 3.4 Terminal Detector Tests
- **File**: `tests/unit/test_terminal_detector.gd`
- **Coverage**: `terminals/TerminalDetector.gd` (86 lines) - Need 50% (43 lines)
- **Test Cases**:
  - `detect_and_mark_terminals()` - detection logic
  - `create_terminal_indicator()` - indicator creation
  - `clear_indicators()` - cleanup
  - `_input()` - input handling
  - Visual indicator management
  - Tilemap scanning
  - Mock tilemap integration

#### Phase 4: UI System Tests (Priority: LOW)
**Goal**: Ensure UI systems work correctly

##### 4.1 Cyberpunk UI Tests
- **File**: `tests/unit/test_cyberpunk_ui.gd`
- **Coverage**: `player/ui/CyberpunkInteractionUI.gd` (277 lines) - Need 50% (139 lines)
- **Test Cases**:
  - `show_interaction_ui()` - UI display
  - `hide_ui()` - UI hiding
  - `position_ui_above_terminal()` - positioning
  - `_on_glitch_timer_timeout()` - glitch effects
  - `_on_hacking_complete()` - completion handling
  - `start_cyberpunk_glitch_animation()` - animation
  - `cleanup_tweens()` - cleanup
  - Animation sequences
  - Camera effects
  - Error handling

### Integration Tests (Interface Implementations & System Interactions)

#### Phase 5: Interface Integration Tests (Priority: MEDIUM)
**Goal**: Ensure interface contracts work correctly

##### 5.1 Mock Implementation Tests
- **File**: `tests/integration/test_mock_implementations.gd`
- **Coverage**: All mock implementations
- **Test Cases**:
  - MockCommunicationBehavior contract compliance
  - MockPlayerInputBehavior contract compliance
  - MockTerminalBehavior contract compliance
  - Interface method signatures
  - Behavior consistency
  - State tracking accuracy

##### 5.2 DI Integration Tests
- **File**: `tests/integration/test_di_integration.gd`
- **Coverage**: Complete DI flow with real implementations
- **Test Cases**:
  - End-to-end DI container usage
  - Mock vs real implementation switching
  - Lifecycle management
  - Error handling in integration
  - Performance under load

##### 5.3 Player-Terminal Integration Tests
- **File**: `tests/integration/test_player_terminal_integration.gd`
- **Coverage**: Player + Terminal interaction flows
- **Test Cases**:
  - Complete interaction sequences
  - Communication between systems
  - Error handling in integration
  - Performance under load
  - Real terminal spawning and interaction

## 📋 Implementation Plan

### Week 1: Core Infrastructure & Mock Reorganization
**Days 1-2**: Mock Reorganization and Core Tests
- Move mocks from `scripts/mocks/` to `tests/mocks/`
- Create `tests/unit/test_di_container.gd`
- Create `tests/unit/test_main_controller.gd`
- Achieve 50% coverage on core systems

**Days 3-4**: Player Component Tests
- Create `tests/unit/test_player_movement_component.gd`
- Create `tests/unit/test_player_interaction_component.gd`
- Create `tests/unit/test_keyboard_input.gd`

**Day 5**: Player Controller Tests
- Create `tests/unit/test_player_controller.gd`
- Mock scene tree dependencies
- Test complex player logic

### Week 2: Terminal Systems
**Days 1-2**: Terminal Identification and Spawner
- Create `tests/unit/test_terminal_tile_identifier.gd`
- Create `tests/unit/test_terminal_spawner.gd`
- Mock tilemap for testing

**Days 3-4**: Terminal Objects and Detector
- Create `tests/unit/test_terminal_objects.gd`
- Create `tests/unit/test_terminal_detector.gd`
- Test terminal interaction flows

**Day 5**: UI System Tests
- Create `tests/unit/test_cyberpunk_ui.gd`
- Test UI animations and effects
- Mock camera and scene tree

### Week 3: Integration Tests
**Days 1-2**: Mock Integration Tests
- Create `tests/integration/test_mock_implementations.gd`
- Test interface contract compliance
- Verify mock behavior accuracy

**Days 3-4**: System Integration Tests
- Create `tests/integration/test_di_integration.gd`
- Create `tests/integration/test_player_terminal_integration.gd`
- Test complete workflows

**Day 5**: Performance and Edge Cases
- Performance testing under load
- Edge case testing
- Error scenario testing

### Week 4: Polish and Documentation
**Days 1-2**: Coverage Optimization
- Identify uncovered code paths
- Add missing test cases
- Optimize test performance

**Days 3-4**: Documentation and Standards
- Update test documentation
- Create testing standards document
- Establish team testing patterns

**Day 5**: Final Review
- Ensure all tests pass
- Achieve target coverage
- Review and refactor as needed

## 🎯 Coverage Targets

### Unit Test Targets (Concrete Classes)
- **DIContainer**: 50% coverage (13/25 lines)
- **Main Controller**: 50% coverage (46/91 lines)
- **Player Movement Component**: 50% coverage (12/23 lines)
- **Player Interaction Component**: 50% coverage (28/56 lines)
- **Keyboard Input**: 50% coverage (27/54 lines)
- **Player Controller**: 50% coverage (138/276 lines)
- **TerminalTileIdentifier**: 50% coverage (24/47 lines)
- **TerminalSpawner**: 50% coverage (35/70 lines)
- **Terminal Objects**: 50% coverage (45/90 lines)
- **Terminal Detector**: 50% coverage (43/86 lines)
- **Cyberpunk UI**: 50% coverage (139/277 lines)

### Integration Test Targets (Interface Implementations)
- **Mock Implementations**: 50% coverage (65/130 lines)
- **DI Integration**: 50% coverage
- **Player-Terminal Integration**: 50% coverage

### Overall Project Target
- **Files with Tests**: 90% of files that should have tests
- **Total Coverage**: 75% minimum (when 90% of files have tests)
- **Per-File Coverage**: 50% OR 100 lines (whichever is lower)

## 🛠️ Testing Tools and Patterns

## Running Tests

### Manual Test Execution

```bash
# Navigate to the Godot project directory
cd cybercrawler_basicstealthaction

# Run all tests with coverage
& "C:\Program Files\Godot\Godot_v4.4.1-stable_win64_console.exe" --headless --script addons/gut/gut_cmdln.gd -gexit
```


### Mock Organization (FIXED)
```gdscript
# Move from scripts/mocks/ to tests/mocks/
# Structure:
tests/
├── mocks/
│   ├── MockCommunicationBehavior.gd
│   ├── MockPlayerInputBehavior.gd
│   └── MockTerminalBehavior.gd
├── unit/
└── integration/
```

### Mock Strategy for Godot
```gdscript
# Example mock pattern for testing
class_name MockTileMap
extends TileMap

var mock_cells: Dictionary = {}

func get_used_cells() -> Array:
    return mock_cells.keys()

func get_cell_atlas_coords(pos: Vector2i) -> Vector2i:
    return mock_cells.get(pos, Vector2i.ZERO)

func set_mock_cell(pos: Vector2i, atlas_coords: Vector2i):
    mock_cells[pos] = atlas_coords
```

### Test Organization
```gdscript
# Example test structure
extends GutTest

class_name TestPlayerMovement

var player_movement: PlayerMovementComponent

func before_each():
    player_movement = PlayerMovementComponent.new()

func after_each():
    player_movement = null

func test_movement_in_direction():
    # Arrange
    var input_direction = Vector2.RIGHT
    var delta = 0.016
    
    # Act
    var velocity = player_movement.update_movement(delta, input_direction)
    
    # Assert
    assert_true(velocity.x > 0, "Should move right")
    assert_true(player_movement.is_moving(), "Should be moving")
```

### Coverage Best Practices
1. **Test Different Paths**: if/else branches, loops, error conditions
2. **Edge Cases**: null values, empty arrays, boundary conditions
3. **Integration Points**: Where systems interact
4. **Error Handling**: Exception paths and error recovery

## 📈 Success Metrics

### Quantitative Metrics
- **Coverage Percentage**: 75% minimum total coverage (when 90% of files have tests)
- **Per-File Coverage**: 50% OR 100 lines (whichever is lower)
- **Test Count**: 100+ meaningful test cases
- **Test Execution Time**: < 60 seconds for full suite
- **Test Reliability**: 100% pass rate on clean builds

### Qualitative Metrics
- **Code Quality**: Tests reveal and fix bugs
- **Maintainability**: Tests make refactoring safer
- **Documentation**: Tests serve as living documentation
- **Confidence**: Team confidence in making changes

## 🚨 Risk Mitigation

### Common Testing Challenges
1. **Godot-Specific Issues**: Scene tree dependencies, signal testing
2. **Performance**: Large test suites, memory leaks
3. **Flaky Tests**: Timing issues, async operations
4. **Maintenance**: Keeping tests up to date with code changes

### Mitigation Strategies
1. **Mock Dependencies**: Use mocks for scene tree and external systems
2. **Test Isolation**: Each test should be independent
3. **Async Testing**: Use GUT's async testing capabilities
4. **Regular Review**: Weekly test maintenance sessions

## 📝 Next Steps

### Immediate Actions (This Week)
1. **Move Mocks**: Relocate mocks from `scripts/mocks/` to `tests/mocks/`
2. **Create Core Test Files**: Start with DI container tests
3. **Set Up Test Data**: Create mock objects and test fixtures
4. **Establish Patterns**: Define testing patterns for the team

### Short Term (Next 2 Weeks)
1. **Complete Core Tests**: Finish all core system tests
2. **Player System Tests**: Implement player movement and interaction tests
3. **Coverage Monitoring**: Set up coverage tracking
4. **CI Integration**: Ensure tests run in CI/CD pipeline

### Long Term (Next Month)
1. **Full Test Suite**: Complete all planned tests
2. **Performance Testing**: Add performance benchmarks
3. **Test Automation**: Automated test generation where possible
4. **Team Training**: Ensure team understands testing practices

---

**Note**: This plan implements strict coverage requirements: 50% or 100 lines per file (whichever is lower) for files that should have tests, and 75% total coverage when 90% of files have tests. The post-run hook enforces these requirements and will fail tests if not met. 