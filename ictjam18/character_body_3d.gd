extends CharacterBody3D

@onready var char_model: Node3D = $CharModel

@onready var cam_pivot_root: Node3D = $CamPivotRoot
@onready var cam_target: Node3D = $CamPivotRoot/CamPivotHeight/CamSpring/CamTarget

@export var cam: NodePath

const SPEED = 13.0
const ACCEL = 2.0
const DEACCEL = 6.0
const JUMP_VELOCITY = 29.5

const CAM_H_SPEED = 3.2

var alive: = true
var last_cam_target: = Transform3D()

func _process(delta: float) -> void:
	var cam_spin: = Input.get_axis("cam_left", "cam_right")
	if cam_spin != 0:
		cam_pivot_root.rotate_y(cam_spin * delta * CAM_H_SPEED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		char_model.play_jumping()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var reference_direction := Basis()
	if get_node_or_null(cam):
		var the_cam: Node3D = get_node(cam)
		var diff: = Vector3(global_position.x - the_cam.global_position.x, 0, global_position.z - the_cam.global_position.z)
		reference_direction = Basis().looking_at(diff)
		
		if alive:
			last_cam_target = cam_target.global_transform
		the_cam.global_transform = the_cam.global_transform.interpolate_with(last_cam_target, 0.1)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: = Vector2.ZERO
	if alive:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: = (reference_direction * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCEL)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, DEACCEL)
		velocity.z = move_toward(velocity.z, 0, DEACCEL)
	
	# Rotate model
	var facing_vec: = Vector3(velocity.x, 0, velocity.z)
	if facing_vec.length_squared() > 0:
		char_model.transform.basis = char_model.transform.basis.slerp(Basis.looking_at(facing_vec, Vector3.UP, true), 0.17)
	
	if is_on_floor():
		var h_vel: = Vector2(velocity.x, velocity.z)
		if h_vel.length() > 0.04:
			char_model.play_running()
		else:
			char_model.play_idle()

	move_and_slide()
	
	if global_position.y < -5:
		alive = false
