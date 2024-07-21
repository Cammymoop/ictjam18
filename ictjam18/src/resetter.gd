extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("real_reset"):
		get_tree().change_scene_to_packed(load("res://lvl/0.tscn"))
	elif Input.is_action_just_pressed("reset"):
		SceneSwitcher.reload_scene(0)
