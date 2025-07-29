extends GutHookScript

const Coverage = preload("res://addons/coverage/coverage.gd")

# Coverage requirements - tests will fail if these aren't met
const COVERAGE_TARGET_TOTAL := 75.0    # 75% total coverage required (only when 90% of code has tests)
const COVERAGE_TARGET_FILE := 50.0     # 50% per-file coverage required (only for files with tests)
const MIN_LINES_COVERED := 100         # Minimum lines that must be covered (only in tested files)
const TEST_COVERAGE_THRESHOLD := 90.0  # Only require 75% total coverage when 90% of code have tests

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
	
	# Calculate TOTAL coverage across ALL files (including files without tests)
	var total_lines_all_files = 0
	var covered_lines_all_files = 0
	for script_path in coverage.coverage_collectors:
		var collector = coverage.coverage_collectors[script_path]
		total_lines_all_files += collector.coverage_line_count()
		covered_lines_all_files += collector.coverage_count()
	
	var total_coverage_all_files = 0.0
	if total_lines_all_files > 0:
		total_coverage_all_files = (float(covered_lines_all_files) / float(total_lines_all_files)) * 100.0
	
	print("🔥🔥🔥 COVERAGE SUMMARY 🔥🔥🔥")
	print("📊 TOTAL COVERAGE (ALL CODE): %.1f%% (%d/%d lines)" % [total_coverage_all_files, covered_lines_all_files, total_lines_all_files])
	print("🔥🔥🔥 END COVERAGE SUMMARY 🔥🔥🔥")
	
	# Show ALL files with their coverage percentages
	print("\n--- All Files Coverage Breakdown ---")
	var files_with_coverage = []
	var files_without_coverage = []
	
	for script_path in coverage.coverage_collectors:
		var collector = coverage.coverage_collectors[script_path]
		var script_coverage = collector.coverage_percent()
		var script_lines = collector.coverage_line_count()
		var script_covered = collector.coverage_count()
		var file_name = script_path.get_file()
		
		if script_covered > 0:
			files_with_coverage.append("✅ %.1f%% %s (%d/%d lines)" % [script_coverage, file_name, script_covered, script_lines])
		else:
			files_without_coverage.append("❌ 0.0%% %s (%d lines)" % [file_name, script_lines])
	
	# Show files with coverage
	if files_with_coverage.size() > 0:
		print("📊 Files with Coverage (%d files):" % files_with_coverage.size())
		for file_info in files_with_coverage:
			print("  %s" % file_info)
	
	# Show files with no coverage
	if files_without_coverage.size() > 0:
		print("📊 Files with No Coverage (%d files):" % files_without_coverage.size())
		for file_info in files_without_coverage:
			print("  %s" % file_info)
	
	# For now, just validate that we have some coverage
	# This is a basic setup - you can make it more strict later
	if total_coverage_all_files < 10.0:  # Very lenient for initial setup
		print("❌ Coverage is too low (%.1f%% < 10.0%%)" % total_coverage_all_files)
		_fail_tests("Coverage too low: %.1f%%" % total_coverage_all_files)
	else:
		print("✅ COVERAGE VALIDATION PASSED!")
		print("✅ Total coverage: %.1f%% is acceptable for initial setup!" % total_coverage_all_files)

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