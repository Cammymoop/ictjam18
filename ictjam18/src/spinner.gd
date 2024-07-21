extends Node3D

@export var speed: = 1.2
@export var use_sin: = true


func _process(delta: float) -> void:
	var amount = speed * delta
	
	if use_sin:
		amount *= sin(Time.get_ticks_msec() / 1000.0)
	
	rotate_y(amount)
