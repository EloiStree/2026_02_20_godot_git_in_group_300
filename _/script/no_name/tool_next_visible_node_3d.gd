extends Node

## Array of 3D nodes that can be cycled through (usually visible one at a time)
@export var nodes_to_cycle: Array[Node3D] = []

## Currently selected / visible index
@export var current_index: int = 0 :
	set(value):
		var new_index = wrapi(value, 0, nodes_to_cycle.size())
		if new_index == current_index:
			return
			
		current_index = new_index
		_update_visibility()

# Alternative: you can also expose this read-only
var selected_node: Node3D:
	get:
		if nodes_to_cycle.is_empty():
			return null
		return nodes_to_cycle[current_index]


func _ready() -> void:
	# Make sure we start in a valid state
	if not nodes_to_cycle.is_empty():
		_update_visibility()


func next() -> void:
	current_index += 1


func previous() -> void:
	current_index -= 1


func set_index(new_index: int) -> void:
	current_index = new_index


## Most efficient way: hide everything except the selected one
func _update_visibility() -> void:
	if nodes_to_cycle.is_empty():
		return
		
	for i in nodes_to_cycle.size():
		var node = nodes_to_cycle[i]
		# Using visible instead of show()/hide() is usually preferred
		node.visible = (i == current_index)



func select_first() -> void:
	current_index = 0


func select_last() -> void:
	current_index = nodes_to_cycle.size() - 1 if not nodes_to_cycle.is_empty() else 0


func is_valid_index(idx: int) -> bool:
	return idx >= 0 and idx < nodes_to_cycle.size()


## Returns true if we actually changed selection
func try_select(node: Node3D) -> bool:
	var idx = nodes_to_cycle.find(node)
	if idx < 0:
		return false
		
	current_index = idx
	return true
