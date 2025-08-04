class_name MockInput
extends RefCounted

var pressed_actions: Dictionary = {}
var just_pressed_actions: Dictionary = {}

func is_action_pressed(action_name: String) -> bool:
	return pressed_actions.get(action_name, false)

func is_action_just_pressed(action_name: String) -> bool:
	return just_pressed_actions.get(action_name, false)

func set_action_pressed(action_name: String, pressed: bool):
	pressed_actions[action_name] = pressed

func set_action_just_pressed(action_name: String, just_pressed: bool):
	just_pressed_actions[action_name] = just_pressed

func clear_all():
	pressed_actions.clear()
	just_pressed_actions.clear() 