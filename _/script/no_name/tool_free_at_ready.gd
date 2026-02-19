extends Node


@export var parent_node_to_free:Node
@export var free_on_ready: bool = true

func _ready() -> void:
	if parent_node_to_free and free_on_ready:
		parent_node_to_free.queue_free()
	
	
