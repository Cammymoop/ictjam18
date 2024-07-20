extends Node3D

@onready var spinner: Node3D = $Scaler/Spinner

@export var spin_speed: = 12.0

func _physics_process(delta: float) -> void:
	spinner.rotate_x(delta * spin_speed / 16.0)
