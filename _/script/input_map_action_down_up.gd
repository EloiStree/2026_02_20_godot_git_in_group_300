class_name InputMapActionDownUp
extends Node

signal on_down_up(pressed: bool)
signal on_down()
signal on_up()

@export var action_name: String
@export var listening_enabled:bool = true

@export_group("For Debugging")
@export var input_state: bool = false


func _ready() -> void:
	if action_name.is_empty():
		push_warning("NesInputMapActionDownUp: action_name is empty.")
		return

	if not InputMap.has_action(action_name):
		push_error("NesInputMapActionDownUp: Input action '%s' does not exist." % action_name)

func _input(event):
	if not listening_enabled:
		return
	if action_name.is_empty():
		return
	if not InputMap.has_action(action_name):
		return
	if not event.is_action(action_name):
		return
	if event.is_pressed():
		input_state = true
		on_down_up.emit( true)
		on_down.emit()
	else:
		input_state = false
		on_down_up.emit( false)
		on_up.emit()
