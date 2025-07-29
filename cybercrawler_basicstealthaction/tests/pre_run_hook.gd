extends GutHookScript

const Coverage = preload("res://addons/coverage/coverage.gd")

# Exclude paths from coverage analysis
const exclude_paths = [
	"res://addons/*",          # Exclude all addons (GUT, coverage, etc.)
	"res://tests/*",           # Exclude test scripts themselves
	"res://scenes/*",          # Exclude scene files (we only want script coverage)
	"res://tools/*"            # Exclude utility tools
]

func run():
	print("🔥 PRE-RUN HOOK IS RUNNING! 🔥")
	print("=== Initializing Code Coverage ===")
	
	# Create coverage instance with scene tree and exclusions
	print("DEBUG: Creating Coverage instance...")
	Coverage.new(gut.get_tree(), exclude_paths)
	
	if !Coverage.instance:
		print("❌ CRITICAL: Coverage instance is still null after Coverage.new()!")
		return
	
	# Instrument all scripts in the project (excluding the paths above)
	print("DEBUG: Instrumenting scripts in res://...")
	Coverage.instance.instrument_scripts("res://")

	# Debug output: print all instrumented scripts
	print("DEBUG: Instrumented scripts:")
	for script_path in Coverage.instance.coverage_collectors.keys():
		print("  - ", script_path)
	print("DEBUG: Total instrumented scripts: %d" % Coverage.instance.coverage_collectors.size())

	# List all .gd scripts in res:// for comparison
	var all_scripts = []
	_list_all_gd_scripts("res://", all_scripts)
	print("DEBUG: Total .gd scripts in res://: %d" % all_scripts.size())
	for script in all_scripts:
		if script not in Coverage.instance.coverage_collectors:
			print("  (NOT instrumented): ", script)
	
	print("✓ Coverage instrumentation complete")
	print("✓ Monitoring coverage for: res://")
	print("✓ Excluded paths: ", exclude_paths)
	
	print("\n✓ Coverage system ready - validation will occur after tests complete\n")

# Helper to recursively list all .gd scripts in a directory
func _list_all_gd_scripts(directory: String, all_scripts: Array):
	var dir = DirAccess.open(directory)
	if !dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = directory + "/" + file_name
		if dir.current_is_dir():
			_list_all_gd_scripts(full_path, all_scripts)
		elif file_name.ends_with(".gd"):
			all_scripts.append(full_path)
		file_name = dir.get_next() 