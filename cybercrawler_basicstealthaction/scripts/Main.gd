class_name Main
extends Node2D

# DI Container
var di_container: DIContainer

func _ready():
	_setup_di()
	_initialize_player()

func _setup_di():
	di_container = DIContainer.new()
	
	# Bind interfaces to implementations
	di_container.bind_interface("ICommunicationBehavior", MockCommunicationBehavior.new())
	di_container.bind_interface("IPlayerInputBehavior", KeyboardPlayerInput.new())
	di_container.bind_interface("ITerminalSystem", MockTerminalBehavior.new())

func _initialize_player():
	# Get the CreatedPlayer node
	var player = $CreatedPlayer
	if player and player.has_method("initialize"):
		player.initialize(di_container)
		print("CreatedPlayer initialized with DI container")
	else:
		push_error("CreatedPlayer not found or missing initialize method") 