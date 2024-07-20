extends Node

var location: = Vector3.ZERO
var path: NodePath = ""


func save_location(n: Node3D) -> void:
	location = n.global_position
	path = n.get_path()

func _on_scene_load() -> void:
	if path and get_node_or_null(path):
		if location != Vector3.ZERO:
			get_node(path).global_position = location

func reload() -> void:
	get_tree().reload_current_scene()
	
	await get_tree().process_frame
	_on_scene_load()
