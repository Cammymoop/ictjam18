extends Node

var dead_transition = preload("res://src/dead_transition.tscn")
var success_transition = preload("res://src/success_transition.tscn")

var switching: = false

func get_scene_path() -> String:
	return get_tree().current_scene.scene_file_path

func reload_scene(type: int) -> void:
	switch_scene(type, get_scene_path())

func switch_scene(type: int, next_scene: String) -> void:
	if switching:
		print_debug("Trying to switch but already switching %s" % next_scene)
		return
	switching = true
	var tr: Node = null
	if type == 1:
		tr = dead_transition.instantiate()
		TextureRememberer.won_with_num = -1
	elif type == 2:
		tr = success_transition.instantiate()
	else:
		TextureRememberer.won_with_num = -1
		get_tree().change_scene_to_file.bind(next_scene).call_deferred()
		
		await get_tree().process_frame
		CheatSpawner.quick = true
		scene_switched()
		return
	
	tr.next_scene = next_scene
	tr.switched.connect(scene_switched)
	get_node("/root").add_child(tr)

func scene_switched() -> void:
	switching = false
	CheatSpawner._on_scene_load()
	CheatSpawner.quick = false
