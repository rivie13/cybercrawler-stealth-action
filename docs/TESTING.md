# Testing Documentation

## Overview

This project uses **GUT (Godot Unit Test)** framework with **code coverage** analysis to ensure code quality and maintainability.

## Testing Framework

- **GUT 9.4.0**: Unit testing framework for Godot
- **Code Coverage**: Line-by-line coverage analysis using [godot-code-coverage](https://github.com/jamie-pate/godot-code-coverage)
- **Coverage Targets**: Strict requirements enforced by post-run hook

## Test Structure

```
cybercrawler_basicstealthaction/
├── tests/
│   ├── pre_run_hook.gd          # Coverage setup (runs before tests)
│   ├── post_run_hook.gd         # Coverage validation (runs after tests)
│   ├── test_sample.gd           # Example basic tests
│   └── test_sample_script.gd    # Example coverage tests
├── .gutconfig.json              # GUT configuration
└── sample_script.gd             # Example script with coverage
```

## Running Tests

### Manual Test Execution

```bash
# Navigate to the Godot project directory
cd cybercrawler_basicstealthaction

# Run all tests with coverage
& "C:\Program Files\Godot\Godot_v4.4.1-stable_win64_console.exe" --headless --script addons/gut/gut_cmdln.gd -gexit
```

### Test Output

The test runner will show:
- **Pre-run Hook**: Coverage instrumentation setup
- **Test Results**: Individual test pass/fail status
- **Post-run Hook**: Coverage validation and reporting
- **Exit Code**: 0 for success, 1 for failure

## Coverage System

### What Gets Covered

- **Included**: All `.gd` scripts in `res://` (except exclusions)
- **Excluded**: 
  - `res://addons/*` (GUT, coverage addons)
  - `res://tests/*` (test scripts themselves)
  - `res://scenes/*` (scene files)
  - `res://tools/*` (utility tools)

### Coverage Reports

The system provides detailed coverage information:

```
🔥🔥🔥 COVERAGE ANALYSIS 🔥🔥🔥
📊 Files that should have tests: 12
✅ Files with tests: 8 (66.7%)
❌ Files without tests: 4
📊 Total coverage (files that should have tests): 45.2% (234/518 lines)
🔥🔥🔥 END COVERAGE ANALYSIS 🔥🔥🔥

--- Files with Tests and Coverage ---
✅ 85.2% DIContainer.gd (17/20 lines) - Required: 50.0%
✅ 72.1% Main.gd (62/86 lines) - Required: 50.0%
❌ 35.4% created_player.gd (98/277 lines) - Required: 50.0%

--- Files Missing Tests ---
❌ PlayerMovementComponent.gd (23 lines) - NEEDS TEST
❌ PlayerInteractionComponent.gd (56 lines) - NEEDS TEST
❌ KeyboardPlayerInput.gd (54 lines) - NEEDS TEST
❌ TerminalTileIdentifier.gd (47 lines) - NEEDS TEST
```

### Coverage Requirements

**Strict Requirements** (enforced by post-run hook):
- **Per-File Coverage**: 50% OR 100 lines covered (whichever is lower)
- **Total Coverage**: 75% minimum when 90% of files have tests
- **Test Coverage**: 90% of files that should have tests must have tests

**Files That Should Have Tests**:
- Concrete classes (non-interface implementations)
- Core systems (DIContainer, Main, Player components, Terminal systems, UI systems)

**Files That Should NOT Have Tests**:
- Interface contracts (IPlayerInputBehavior, ICommunicationBehavior, ITerminalBehavior)
- Documentation files (InputSetup.gd)
- Debug scripts (test_tile_identification.gd)
- Scene files (.tscn)

## Writing Tests

### Basic Test Structure

```gdscript
extends GutTest

class_name TestYourClass

func test_basic_assertion():
    # Arrange
    var expected = true
    
    # Act
    var result = some_function()
    
    # Assert
    assert_true(result, "Function should return true")
```

### Coverage-Friendly Tests

```gdscript
extends GutTest

var sample_script: SampleScript

func before_each():
    # Setup before each test
    sample_script = SampleScript.new()

func test_function_coverage():
    # Test different code paths to increase coverage
    var result1 = sample_script.add_value(5)
    var result2 = sample_script.multiply_value(2)
    
    assert_eq(result1, 5, "Addition should work")
    assert_eq(result2, 10, "Multiplication should work")
```

## Configuration Files

### .gutconfig.json

```json
{
    "dirs": ["res://tests/"],
    "should_print_to_console": true,
    "should_print_failures": true,
    "should_print_passing": true,
    "log_level": 2,
    "pre_run_script": "res://tests/pre_run_hook.gd",
    "post_run_script": "res://tests/post_run_hook.gd",
    "test_timeout": 30,
    "double_strategy": "partial"
}
```

### Hook Scripts

**Pre-run Hook** (`tests/pre_run_hook.gd`):
- Extends `GutHookScript`
- Initializes coverage system
- Instruments all scripts for coverage analysis

**Post-run Hook** (`tests/post_run_hook.gd`):
- Extends `GutHookScript` 
- Validates coverage requirements
- Generates coverage reports
- **Fails tests if requirements not met**

## Best Practices

### Test Organization

1. **One test file per script**: `MyScript.gd` → `test_my_script.gd`
2. **Descriptive test names**: `test_player_takes_damage_when_hit()`
3. **Use setup/teardown**: `before_each()` / `after_each()`

### Coverage Best Practices

1. **Test different code paths**: if/else branches, loops, error conditions
2. **Test edge cases**: null values, empty arrays, boundary conditions
3. **Focus on critical code**: business logic, algorithms, data processing
4. **Aim for 50% coverage**: OR 100 lines per file (whichever is lower)

### Common Assertions

```gdscript
# Basic assertions
assert_true(condition, "Message")
assert_false(condition, "Message") 
assert_eq(actual, expected, "Message")
assert_ne(actual, unexpected, "Message")

# Collection assertions
assert_has(collection, item, "Message")
assert_does_not_have(collection, item, "Message")

# Type assertions
assert_typeof(value, TYPE_STRING, "Message")
```

## Troubleshooting

### Common Issues

**Coverage not working**:
- Check that scripts are not in excluded paths
- Verify coverage hooks are running (look for 🔥 emoji messages)
- Ensure GUT configuration points to correct hook files

**Tests not running**:
- Verify `.gutconfig.json` points to correct test directory
- Check that test files start with `test_` prefix
- Make sure test classes extend `GutTest`

**Coverage requirements not met**:
- Add more test cases covering different code paths
- Test error conditions and edge cases
- Check for unreachable or dead code
- Ensure 90% of files that should have tests actually have tests

### Debug Information

The pre-run hook shows detailed debug information:
- Total scripts found vs. instrumented
- List of excluded files
- Coverage setup confirmation

The post-run hook shows:
- Files that should have tests vs. files with tests
- Individual file coverage percentages
- Missing test files
- Validation results

## Integration

### GitHub Actions / CI

The coverage system is designed to work with CI/CD:
- **Exit code 0**: All tests pass, coverage requirements met
- **Exit code 1**: Test failures or insufficient coverage
- **Detailed output**: Coverage reports in console

### Future Enhancements

When the codebase matures, you can:
1. Increase coverage requirements (75% total, 50% per-file)
2. Add integration tests alongside unit tests
3. Generate HTML coverage reports
4. Set up coverage tracking over time

## Examples

The repository includes example files:
- `sample_script.gd`: Example script with various functions
- `test_sample_script.gd`: Comprehensive tests showing coverage
- `test_sample.gd`: Basic GUT test examples

Study these files to understand the testing patterns and coverage approach used in this project. 