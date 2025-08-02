class_name Main
extends Node2D

# DI Container
var di_container: DIContainer

func _ready():
	print("🚀 CyberCrawler Stealth Action - Phase 1B")
	
	# Test tile identification system
	test_tile_identification()
	
	# Setup DI container
	setup_dependency_injection()
	
	# Initialize player system
	initialize_player_system()
	
	# Setup terminal spawner
	setup_terminal_spawner()

func test_tile_identification():
	print("\n🧪 Testing Tile Identification System...")
	
	# Test TerminalTileIdentifier directly
	if TerminalTileIdentifier:
		TerminalTileIdentifier.debug_print_terminals()
		
		# Test specific coordinates
		var test_coords = Vector2i(9, 1)
		var is_terminal = TerminalTileIdentifier.is_terminal_tile(test_coords)
		var terminal_type = TerminalTileIdentifier.get_terminal_type_from_atlas(test_coords)
		print("✅ Test coordinate ", test_coords, ": is_terminal=", is_terminal, ", type=", terminal_type)
	else:
		print("❌ TerminalTileIdentifier not found - reload project")

func setup_dependency_injection():
	print("\n🔧 Setting up Dependency Injection...")
	di_container = DIContainer.new()
	
	# Bind interfaces to implementations
	di_container.bind_interface("ICommunicationBehavior", MockCommunicationBehavior.new())
	di_container.bind_interface("IPlayerInputBehavior", KeyboardPlayerInput.new())
	di_container.bind_interface("ITerminalBehavior", MockTerminalBehavior.new())
	
	print("✅ DI container setup complete")

func initialize_player_system():
	print("\n🎮 Initializing Player System...")
	# Get the CreatedPlayer node
	var player = $CreatedPlayer
	if player and player.has_method("initialize"):
		player.initialize(di_container)
		print("✅ CreatedPlayer initialized with DI container")
	else:
		push_error("❌ CreatedPlayer not found or missing initialize method")

func setup_terminal_spawner():
	print("\n🎯 Setting up Terminal Spawner...")
	# Create terminal spawner
	var spawner = TerminalSpawner.new()
	spawner.di_container = di_container
	spawner.tilemap = $TileMapLayer
	add_child(spawner)
	print("✅ Terminal spawner set up") 