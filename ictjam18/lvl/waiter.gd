extends Node3D

var moving = false
@onready var source: Vector3 = global_position 
@onready var target: Vector3 = source + (Vector3.UP * 30)

var elapsed: = 0.0

const DURATION = 2.0
const EASING = 0.3

func _physics_process(delta: float) -> void:
	if not moving:
		print("not shmoving")
		return
	
	print("shmoving")
	elapsed += delta
	var progress = ease(elapsed/DURATION, EASING)
	
	global_position = lerp(source, target, progress)


func _on_timer_timeout() -> void:
	moving = true
