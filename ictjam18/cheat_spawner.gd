extends Node

var location: = Vector3.ZERO
var path: NodePath = ""
var quick: = false

func save_location(n: Node3D) -> void:
	location = n.global_position
	path = n.get_path()

func remove_location() -> void:
	location = Vector3.ZERO

func _on_scene_load() -> void:
	if path and get_node_or_null(path):
		if location != Vector3.ZERO:
			if Input.is_action_pressed("reset") and not quick:
				location = Vector3.ZERO
			else:
				get_node(path).global_position = location

#func reload() -> void:
	#get_tree().reload_current_scene.call_deferred()
	#
	#await get_tree().process_frame
	#_on_scene_load()
