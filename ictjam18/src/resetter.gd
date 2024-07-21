extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		SceneSwitcher.reload_scene(0)
