extends GutTest

class_name TestTerminalTypesAndCommunication

var mock_communication: MockTerminalCommunication
var terminal_object: TerminalObject

func before_each():
	mock_communication = MockTerminalCommunication.new()
	terminal_object = TerminalObject.new()
	terminal_object.set_terminal_communication(mock_communication)

func after_each():
	terminal_object.queue_free()
	mock_communication.clear_sent_interactions()

func test_terminal_type_identification():
	# Test that terminal types are correctly identified
	assert_eq(TerminalTileIdentifier.get_terminal_type_from_atlas(Vector2i(9, 1)), "main_terminal")
	assert_eq(TerminalTileIdentifier.get_terminal_type_from_atlas(Vector2i(11, 1)), "tower_terminal")
	assert_eq(TerminalTileIdentifier.get_terminal_type_from_atlas(Vector2i(9, 3)), "mine_terminal")
	assert_eq(TerminalTileIdentifier.get_terminal_type_from_atlas(Vector2i(11, 3)), "upgrade_terminal")

func test_terminal_descriptions():
	# Test that terminal descriptions are correct
	assert_eq(TerminalTileIdentifier.get_terminal_description("main_terminal"), "Main Terminal - Release data packet into enemy network")
	assert_eq(TerminalTileIdentifier.get_terminal_description("tower_terminal"), "Tower Terminal - Deploy defensive towers in cyberspace")
	assert_eq(TerminalTileIdentifier.get_terminal_description("mine_terminal"), "Mine Terminal - Place tactical mines and devices")
	assert_eq(TerminalTileIdentifier.get_terminal_description("upgrade_terminal"), "Upgrade Terminal - Enhance existing towers and systems")

func test_terminal_icons():
	# Test that terminal icons are correct
	assert_eq(TerminalTileIdentifier.get_terminal_icon("main_terminal"), "🎯")
	assert_eq(TerminalTileIdentifier.get_terminal_icon("tower_terminal"), "🏗️")
	assert_eq(TerminalTileIdentifier.get_terminal_icon("mine_terminal"), "💣")
	assert_eq(TerminalTileIdentifier.get_terminal_icon("upgrade_terminal"), "⚡")

func test_terminal_enum_conversion():
	# Test enum conversion from string
	assert_eq(TerminalTileIdentifier.get_terminal_enum_from_string("main_terminal"), TerminalTileIdentifier.TerminalType.MAIN_TERMINAL)
	assert_eq(TerminalTileIdentifier.get_terminal_enum_from_string("tower_terminal"), TerminalTileIdentifier.TerminalType.TOWER_TERMINAL)
	assert_eq(TerminalTileIdentifier.get_terminal_enum_from_string("mine_terminal"), TerminalTileIdentifier.TerminalType.MINE_TERMINAL)
	assert_eq(TerminalTileIdentifier.get_terminal_enum_from_string("upgrade_terminal"), TerminalTileIdentifier.TerminalType.UPGRADE_TERMINAL)
	assert_eq(TerminalTileIdentifier.get_terminal_enum_from_string("unknown"), TerminalTileIdentifier.TerminalType.UNKNOWN_TERMINAL)

func test_terminal_interaction_communication():
	# Test that terminal interaction sends data to parent repo
	terminal_object.terminal_type = "main_terminal"
	terminal_object.terminal_id = "test_terminal_1"
	terminal_object.global_position = Vector2(100, 200)
	
	# Create a mock player
	var mock_player = Node2D.new()
	mock_player.global_position = Vector2(110, 210)
	
	# Trigger interaction
	terminal_object.interact_with_player(mock_player)
	
	# Verify communication was sent
	var sent_interactions = mock_communication.get_sent_interactions()
	assert_eq(sent_interactions.size(), 1)
	
	var interaction_data = sent_interactions[0]
	assert_eq(interaction_data.terminal_type, "main_terminal")
	assert_eq(interaction_data.terminal_position, Vector2(100, 200))
	assert_eq(interaction_data.player_position, Vector2(110, 210))
	assert_eq(interaction_data.terminal_id, "test_terminal_1")
	assert_eq(interaction_data.interaction_type, "interact")
	
	mock_player.queue_free()

func test_terminal_communication_failure():
	# Test behavior when communication fails
	mock_communication.simulate_communication_failure()
	
	terminal_object.terminal_type = "tower_terminal"
	terminal_object.global_position = Vector2(300, 400)
	
	var mock_player = Node2D.new()
	mock_player.global_position = Vector2(310, 410)
	
	# Trigger interaction
	terminal_object.interact_with_player(mock_player)
	
	# Verify no communication was sent
	var sent_interactions = mock_communication.get_sent_interactions()
	assert_eq(sent_interactions.size(), 0)
	
	mock_player.queue_free()

func test_terminal_object_methods():
	# Test terminal object helper methods
	terminal_object.terminal_type = "mine_terminal"
	
	assert_eq(terminal_object.get_terminal_type(), "mine_terminal")
	assert_eq(terminal_object.get_terminal_description(), "Mine Terminal - Place tactical mines and devices")
	assert_eq(terminal_object.get_terminal_icon(), "💣")

func test_terminal_tile_identification():
	# Test that terminal tiles are correctly identified
	assert_true(TerminalTileIdentifier.is_terminal_tile(Vector2i(9, 1)))
	assert_true(TerminalTileIdentifier.is_terminal_tile(Vector2i(11, 1)))
	assert_true(TerminalTileIdentifier.is_terminal_tile(Vector2i(9, 3)))
	assert_true(TerminalTileIdentifier.is_terminal_tile(Vector2i(11, 3)))
	assert_false(TerminalTileIdentifier.is_terminal_tile(Vector2i(0, 0)))
	assert_false(TerminalTileIdentifier.is_terminal_tile(Vector2i(5, 5)))

func test_all_terminal_coords():
	# Test that all terminal coordinates are returned
	var all_coords = TerminalTileIdentifier.get_all_terminal_coords()
	assert_eq(all_coords.size(), 4)
	assert_true(Vector2i(9, 1) in all_coords)
	assert_true(Vector2i(11, 1) in all_coords)
	assert_true(Vector2i(9, 3) in all_coords)
	assert_true(Vector2i(11, 3) in all_coords) 