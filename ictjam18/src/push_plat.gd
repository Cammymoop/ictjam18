extends Node3D

@export var dir: Vector3 = Vector3.MODEL_LEFT
@export var speed: float = 5.0

func _physics_process(delta: float) -> void:
	position += speed * delta * dir
