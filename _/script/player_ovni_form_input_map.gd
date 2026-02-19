class_name OvniPlayerFromInputMap extends Node

# Exposed vectors for other developers to use
@export var joystick_left_vertical_rotate: Vector2 = Vector2.ZERO
@export var joystick_right_move: Vector2 = Vector2.ZERO

# Keys (can be customized per developer if needed)
@export var key_move_forward: String = "move_forward"
@export var key_move_backward: String = "move_backward"
@export var key_move_left: String = "move_left"
@export var key_move_right: String = "move_right"
@export var key_move_up: String = "move_up"
@export var key_move_down: String = "move_down"
@export var key_turn_left: String= "turn_left"
@export var key_turn_right: String = "turn_right"

signal on_input_processed(left_joystick_vertical_rotation: Vector2, right_joystick_move: Vector2)

# Track pressed state manually since InputEvent is instantaneous
var pressed_keys: = {}

func _ready() -> void:
	# Initialize all tracked keys as not pressed
	pressed_keys = {
		key_move_forward: false,
		key_move_backward: false,
		key_move_left: false,
		key_move_right: false,
		key_move_up: false,
		key_move_down: false,
		key_turn_left: false,
		key_turn_right: false,
	}

	print("INPUT: "+ (" ".join([key_move_backward, key_move_forward, key_move_left, key_move_right, key_move_up, key_move_down, key_turn_left, key_turn_right])))



func _process(_delta: float) -> void:

	pressed_keys[key_move_forward] = Input.is_action_pressed(key_move_forward)
	pressed_keys[key_move_backward] = Input.is_action_pressed(key_move_backward)
	pressed_keys[key_move_left] = Input.is_action_pressed(key_move_left)
	pressed_keys[key_move_right] = Input.is_action_pressed(key_move_right)
	pressed_keys[key_move_up] = Input.is_action_pressed(key_move_up)
	pressed_keys[key_move_down] = Input.is_action_pressed(key_move_down)
	pressed_keys[key_turn_left] = Input.is_action_pressed(key_turn_left)
	pressed_keys[key_turn_right] = Input.is_action_pressed(key_turn_right)


	_process_input()

func _process_input() -> void:
	joystick_left_vertical_rotate = Vector2.ZERO
	joystick_right_move = Vector2.ZERO

	# Movement (X,Z plane)
	if pressed_keys[key_move_forward]:
		joystick_right_move.y += 1
	if pressed_keys[key_move_backward]:
		joystick_right_move.y -= 1
	if pressed_keys[key_move_left]:
		joystick_right_move.x -= 1
	if pressed_keys[key_move_right]:
		joystick_right_move.x += 1

	# Vertical
	if pressed_keys[key_move_up]:
		joystick_left_vertical_rotate.y += 1
	if pressed_keys[key_move_down]:
		joystick_left_vertical_rotate.y -= 1

	# Turning
	if pressed_keys[key_turn_left]:
		joystick_left_vertical_rotate.x -= 1
	if pressed_keys[key_turn_right]:
		joystick_left_vertical_rotate.x += 1

	on_input_processed.emit(joystick_left_vertical_rotate, joystick_right_move)
