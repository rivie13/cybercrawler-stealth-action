extends GutHookScript

const Coverage = preload("res://addons/coverage/coverage.gd")

# Coverage requirements - tests will fail if these aren't met
const COVERAGE_TARGET_TOTAL := 75.0    # 75% total coverage required (only when 90% of code has tests)
const COVERAGE_TARGET_FILE := 50.0     # 50% per-file coverage required (only for files with tests)
const MIN_LINES_COVERED := 100         # Minimum lines that must be covered (only in tested files)
const TEST_COVERAGE_THRESHOLD := 90.0  # Only require 75% total coverage when 90% of code have tests

# Files that should have tests (concrete classes, not interfaces)
const FILES_THAT_SHOULD_HAVE_TESTS = [
	"core/di/DIContainer.gd",
	"core/Main.gd",
	"player/created_player.gd",
	"player/components/PlayerMovementComponent.gd",
	"player/components/PlayerInteractionComponent.gd",
	"player/input/KeyboardPlayerInput.gd",
	"terminals/TerminalTileIdentifier.gd",
	"terminals/TerminalSpawner.gd",
	"terminals/TerminalObject.gd",
	"terminals/TerminalTile.gd",
	"terminals/TerminalDetector.gd",
	"player/ui/CyberpunkInteractionUI.gd"
]

# Files that should NOT have tests (interfaces, documentation, debug scripts)
const FILES_THAT_SHOULD_NOT_HAVE_TESTS = [
	"core/interfaces/IPlayerInput.gd",
	"core/interfaces/ICommunicationInterface.gd",
	"core/interfaces/ITerminalSystem.gd",
	"player/input/InputSetup.gd",
	"test_tile_identification.gd"
]

func run():
	print("🔥 POST-RUN HOOK IS RUNNING! 🔥")
	print("=== Final Coverage Validation ===")
	
	# Validate coverage requirements now that tests have run
	_validate_coverage_requirements()
	
	# Finalize coverage system and show report
	Coverage.finalize(Coverage.Verbosity.NONE)
	print("=== Coverage Validation Complete ===")

func _validate_coverage_requirements():
	var coverage = Coverage.instance
	if !coverage:
		print("❌ No coverage instance found!")
		_fail_tests("Coverage system not initialized")
		return
	
	# Analyze files that should have tests
	var files_that_should_have_tests = _get_files_that_should_have_tests()
	var files_with_tests = []
	var files_without_tests = []
	var total_lines_should_have_tests = 0
	var covered_lines_should_have_tests = 0
	
	print("🔍 Analyzing files that should have tests...")
	
	for script_path in coverage.coverage_collectors:
		var file_name = script_path.get_file()
		var relative_path = _get_relative_path(script_path)
		
		# Check if this file should have tests
		if _should_have_tests(relative_path):
			var collector = coverage.coverage_collectors[script_path]
			var script_lines = collector.coverage_line_count()
			var script_covered = collector.coverage_count()
			var script_coverage = collector.coverage_percent()
			
			total_lines_should_have_tests += script_lines
			covered_lines_should_have_tests += script_covered
			
			if script_covered > 0:
				files_with_tests.append({
					"name": file_name,
					"path": relative_path,
					"coverage": script_coverage,
					"lines": script_lines,
					"covered": script_covered
				})
			else:
				files_without_tests.append({
					"name": file_name,
					"path": relative_path,
					"lines": script_lines
				})
	
	# Calculate percentages
	var total_files_should_have_tests = files_with_tests.size() + files_without_tests.size()
	var percentage_files_with_tests = 0.0
	if total_files_should_have_tests > 0:
		percentage_files_with_tests = (float(files_with_tests.size()) / float(total_files_should_have_tests)) * 100.0
	
	var total_coverage_should_have_tests = 0.0
	if total_lines_should_have_tests > 0:
		total_coverage_should_have_tests = (float(covered_lines_should_have_tests) / float(total_lines_should_have_tests)) * 100.0
	
	# Print analysis
	print("🔥🔥🔥 COVERAGE ANALYSIS 🔥🔥🔥")
	print("📊 Files that should have tests: %d" % total_files_should_have_tests)
	print("✅ Files with tests: %d (%.1f%%)" % [files_with_tests.size(), percentage_files_with_tests])
	print("❌ Files without tests: %d" % files_without_tests.size())
	print("📊 Total coverage (files that should have tests): %.1f%% (%d/%d lines)" % [total_coverage_should_have_tests, covered_lines_should_have_tests, total_lines_should_have_tests])
	print("🔥🔥🔥 END COVERAGE ANALYSIS 🔥🔥🔥")
	
	# Show files with tests and their coverage
	if files_with_tests.size() > 0:
		print("\n--- Files with Tests and Coverage ---")
		for file_info in files_with_tests:
			var status = "✅"
			# Calculate required coverage: 50% of lines or 100 lines, whichever is less
			var required_lines = min(file_info.lines * COVERAGE_TARGET_FILE / 100.0, MIN_LINES_COVERED)
			var required_coverage_percent = (required_lines / float(file_info.lines)) * 100.0
			if file_info.coverage < required_coverage_percent:
				status = "❌"
			
			print("%s %.1f%% %s (%d/%d lines) - Required: %.1f%%" % [
				status, file_info.coverage, file_info.name, 
				file_info.covered, file_info.lines, required_coverage_percent
			])
	
	# Show files without tests
	if files_without_tests.size() > 0:
		print("\n--- Files Missing Tests ---")
		for file_info in files_without_tests:
			print("❌ %s (%d lines) - NEEDS TEST" % [file_info.name, file_info.lines])
	
	# Validate requirements
	var validation_passed = true
	var failure_reasons = []
	
	# Check if we have enough files with tests (90% threshold)
	if percentage_files_with_tests < TEST_COVERAGE_THRESHOLD:
		validation_passed = false
		failure_reasons.append("Only %.1f%% of files have tests (need 90%%)" % percentage_files_with_tests)
	
	# Check total coverage (only if we have 90% of files with tests)
	if percentage_files_with_tests >= TEST_COVERAGE_THRESHOLD:
		if total_coverage_should_have_tests < COVERAGE_TARGET_TOTAL:
			validation_passed = false
			failure_reasons.append("Total coverage %.1f%% < %.1f%%" % [total_coverage_should_have_tests, COVERAGE_TARGET_TOTAL])
	
	# Check individual file coverage
	for file_info in files_with_tests:
		# Calculate required coverage: 50% of lines or 100 lines, whichever is less
		var required_lines = min(file_info.lines * COVERAGE_TARGET_FILE / 100.0, MIN_LINES_COVERED)
		var required_coverage_percent = (required_lines / float(file_info.lines)) * 100.0
		if file_info.coverage < required_coverage_percent:
			validation_passed = false
			failure_reasons.append("%s: %.1f%% coverage < %.1f%% required" % [file_info.name, file_info.coverage, required_coverage_percent])
	
	# Report results
	if validation_passed:
		print("\n✅ COVERAGE VALIDATION PASSED!")
		if percentage_files_with_tests >= TEST_COVERAGE_THRESHOLD:
			print("✅ Total coverage: %.1f%% >= %.1f%%" % [total_coverage_should_have_tests, COVERAGE_TARGET_TOTAL])
		else:
			print("✅ Building up test coverage: %.1f%% of files have tests" % percentage_files_with_tests)
	else:
		print("\n❌ COVERAGE VALIDATION FAILED!")
		for reason in failure_reasons:
			print("❌ %s" % reason)
		_fail_tests("Coverage requirements not met: " + ", ".join(failure_reasons))

func _should_have_tests(relative_path: String) -> bool:
	# Check if this file should have tests
	for file_path in FILES_THAT_SHOULD_HAVE_TESTS:
		if relative_path.ends_with(file_path):
			return true
	
	# Check if this file should NOT have tests
	for file_path in FILES_THAT_SHOULD_NOT_HAVE_TESTS:
		if relative_path.ends_with(file_path):
			return false
	
	# Default: if it's a .gd file and not in excluded paths, it should have tests
	return true

func _get_files_that_should_have_tests() -> Array:
	return FILES_THAT_SHOULD_HAVE_TESTS

func _get_relative_path(script_path: String) -> String:
	# Convert absolute path to relative path from res://
	if script_path.begins_with("res://"):
		return script_path.substr(6)  # Remove "res://"
	return script_path

func _fail_tests(reason: String):
	# Log the coverage failure prominently
	print("🚫 COVERAGE VALIDATION FAILED: %s" % reason)
	print("❌ Tests will be FAILED due to insufficient coverage!")
	
	# Push error for logging
	push_error("COVERAGE VALIDATION FAILED: " + reason)
	
	print("🔥 FORCING IMMEDIATE EXIT WITH CODE 1")
	
	# Force immediate exit with code 1 - this should make GitHub Actions fail
	if gut and gut.get_tree():
		gut.get_tree().quit(1)
	else:
		# Fallback: force exit with code 1
		OS.kill(OS.get_process_id()) 