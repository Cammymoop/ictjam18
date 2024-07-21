extends AnimatableBody3D

var started: = false
var sinking: = false

var accel: = 0.08

var sink_speed: = 2.2
var my_speed: = 0.0

func _ready() -> void:
	var grad: Gradient = $"tower-square".get_surface_override_material(0).detail_mask.gradient
	grad.set_color(0, Color.BLACK)
	grad.set_color(1, Color.BLACK)

func me_sink() -> void:
	if started:
		return
	started = true
	var grad: Gradient = $"tower-square".get_surface_override_material(0).detail_mask.gradient
	grad.set_color(0, Color.DIM_GRAY)
	grad.set_color(1, Color.DIM_GRAY)
	
	$Timer.start()

func _physics_process(delta: float) -> void:
	if not sinking:
		return
	my_speed = move_toward(my_speed, sink_speed, delta * accel)
	
	position.y -= my_speed


func _on_timer_timeout() -> void:
	sinking = true
	var grad: Gradient = $"tower-square".get_surface_override_material(0).detail_mask.gradient
	grad.set_color(0, Color.WHITE)
	grad.set_color(1, Color.WHITE)
