extends Area3D



func _on_body_entered(body: Node3D) -> void:
	print("end goal")
	body.i_win()
	CheatSpawner.remove_location()
	
	var lvl = get_node_or_null("/root/LVL")
	if lvl:
		if len(lvl.next_level) < 1:
			SceneSwitcher.reload_scene(2)
		SceneSwitcher.switch_scene(2, lvl.next_level)
	else:
		print_debug("Can't get lvl node")
		SceneSwitcher.reload_scene(2)
