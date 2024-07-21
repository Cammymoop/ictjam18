extends Area3D



func _on_body_entered(body: Node3D) -> void:
	print("end goal")
	body.i_win()
	SceneSwitcher.reload_scene(2)
