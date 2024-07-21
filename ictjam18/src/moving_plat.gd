extends Node3D

var moving: = false
var part1: = true

@export var easing: = 1.4

@onready var loc_a: Vector3 = global_position
@onready var loc_b: Vector3 = $Marker3D.global_position

func _ready() -> void:
	start()

func start() -> void:
	moving = true
	part1 = true
	$Timer1.start()

func _physics_process(delta: float) -> void:
	if not moving:
		return
	var tm: Timer = $Timer1 if part1 else $Timer2
	var a = loc_a if part1 else loc_b
	var b = loc_b if part1 else loc_a
	
	var progress = 1 - (tm.time_left / tm.wait_time)
	progress = ease(progress, easing)
	
	global_position = lerp(a, b, progress)


func _on_timer_1_timeout() -> void:
	$Wait1.start()
	moving = false

func _on_timer_2_timeout() -> void:
	$Wait2.start()
	moving = false

func _on_wait_1_timeout() -> void:
	$Timer2.start()
	moving = true
	part1 = false

func _on_wait_2_timeout() -> void:
	$Timer1.start()
	moving = true
	part1 = true
