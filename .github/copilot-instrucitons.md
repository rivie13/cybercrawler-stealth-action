# GitHub Copilot Custom Instructions for CyberCrawler Stealth Action

## Core Project Information

**Project**: CyberCrawler Stealth Action - 2.5D stealth gameplay system for corporate infiltration
**Engine**: Godot 4.x with GDScript
**Architecture**: Dependency Injection (DI) with interface-driven design
**Testing**: GUT framework with 75% coverage requirement
**Scope**: Stealth action, terminal interaction, and alert system integration ONLY

## PR Review Guidelines

### Architecture & Design Principles
- **Dependency Injection First**: All systems must use DI container, no hard dependencies
- **Single Responsibility**: Each class does ONE thing well - no monolithic classes
- **Interface-Driven**: Systems communicate through abstractions, not direct imports
- **Composition over Inheritance**: Build systems by combining smaller components
- **Mock-Friendly**: Every external dependency must be mockable for testing

### Code Quality Standards
- **Modular Design**: Player logic ≠ AI logic ≠ Terminal logic ≠ Grid logic
- **Clear Separation**: Each system has distinct boundaries and responsibilities
- **Godot Best Practices**: Follow engine conventions and patterns
- **GDScript Standards**: Use proper naming conventions and structure
- **Error Handling**: Proper error messages and graceful degradation

### Testing Requirements
- **75% Coverage Minimum**: All new code must maintain or improve coverage
- **Unit Tests**: Every new class/function needs corresponding test
- **Mock Usage**: Use mocks for external dependencies in tests
- **Test Structure**: Follow existing patterns in `tests/unit/` directory
- **GUT Framework**: Use proper GUT test structure and assertions

### File Organization
- **Scripts Structure**: Follow existing `scripts/core/`, `scripts/player/`, `scripts/terminals/` pattern
- **Interface Location**: All interfaces go in `scripts/core/interfaces/`
- **Component Pattern**: Player components in `scripts/player/components/`
- **Test Location**: Tests mirror source structure in `tests/unit/`

### Naming Conventions
- **Classes**: PascalCase (e.g., `PlayerMovementComponent`, `TerminalObject`)
- **Variables**: snake_case (e.g., `input_behavior`, `terminal_type`)
- **Functions**: snake_case (e.g., `initialize()`, `handle_movement()`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `ISOMETRIC_OFFSET`)
- **Groups**: lowercase (e.g., `"players"`, `"terminals"`)

### Code Patterns to Follow
- **DI Integration**: Use `DIContainer` for all dependencies
- **Component Pattern**: Break complex classes into focused components
- **Signal Usage**: Use signals for cross-system communication
- **Error Handling**: Use `push_error()` for critical errors, print for debug
- **Cleanup**: Implement proper cleanup in `_exit_tree()` and `cleanup()`

### Code Patterns to Avoid
- **Monolithic Classes**: Don't create classes that do multiple things
- **Hard Dependencies**: Don't directly import other systems
- **God Classes**: Don't create classes that know about everything
- **Tight Coupling**: Don't create systems that can't be easily mocked
- **Mixed Responsibilities**: Don't mix UI, logic, and data in same class

### PR Review Checklist
- [ ] **Architecture**: Follows DI pattern and interface-driven design
- [ ] **Testing**: Includes unit tests with proper mocking
- [ ] **Coverage**: Maintains or improves 75% coverage threshold
- [ ] **Naming**: Follows established naming conventions
- [ ] **Organization**: Files in correct directories with proper structure
- [ ] **Documentation**: Code is self-documenting with clear comments
- [ ] **Error Handling**: Proper error messages and graceful failure
- [ ] **Performance**: No obvious performance issues or memory leaks
- [ ] **Integration**: Works with existing systems without breaking changes

### Specific System Guidelines

#### Player System
- Use `IPlayerInputBehavior` interface for input handling
- Break player into components: `PlayerMovementComponent`, `PlayerInteractionComponent`
- Player should not know about terminals directly - use interaction component
- Follow existing `CreatedPlayer` pattern for new player features

#### Terminal System
- All terminals implement `ITerminalBehavior` interface
- Use `TerminalObject` as base class for new terminals
- Terminals should be spawnable and configurable
- Follow existing `TerminalSpawner` pattern for placement

#### Core Systems
- All interfaces in `scripts/core/interfaces/`
- Use `DIContainer` for dependency management
- Follow existing `Main.gd` pattern for system initialization
- Mock implementations in `tests/mocks/` for testing

### Testing Guidelines
- **Test Structure**: Use `extends GutTest` and proper test naming
- **Mock Usage**: Use mocks from `tests/mocks/` for external dependencies
- **Assertions**: Use GUT assertions like `assert_eq()`, `assert_true()`
- **Coverage**: Ensure new code paths are tested
- **Integration**: Test component interactions, not just individual units

### Performance Considerations
- **Optimization**: Avoid excessive searching in `_physics_process()`
- **Memory**: Proper cleanup in `_exit_tree()` and component destruction
- **Efficiency**: Use cooldowns for expensive operations (like terminal searching)
- **Scalability**: Design for multiple terminals and complex interactions

### Documentation Standards
- **Code Comments**: Explain complex logic, not obvious code
- **Interface Documentation**: Clear contracts for all interfaces
- **Component Documentation**: Explain component responsibilities
- **Test Documentation**: Clear test descriptions and expected behavior

### Git Workflow
- **Branch Naming**: `feature/`, `bugfix/`, `issue/` prefixes
- **Commit Messages**: Descriptive, present tense, clear scope
- **PR Description**: Explain what, why, and how
- **Review Process**: Address all feedback before merge

### Integration Guidelines
- **Tower Defense**: Use interfaces for cross-system communication
- **Alert System**: Bidirectional communication through signals
- **Future Systems**: Design for easy integration with hub/safehouse and tower defense systems
- **External Dependencies**: Mock everything for testing isolation

## Review Focus Areas

### High Priority (Must Fix)
- Architecture violations (monolithic classes, hard dependencies)
- Missing tests or coverage drops
- Interface contract violations
- Performance issues or memory leaks
- Breaking changes to existing systems

### Medium Priority (Should Fix)
- Naming convention violations
- Code organization issues
- Missing error handling
- Documentation gaps
- Test quality issues

### Low Priority (Nice to Have)
- Code style improvements
- Additional comments
- Minor optimizations
- Extra test cases

Remember: This is a stealth action system focused on terminal interaction and alert integration. Keep changes focused on this scope and maintain the modular, testable architecture.
