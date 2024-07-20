extends StairsCharacter

@onready var char_model: Node3D = $CharModel

@onready var cam_pivot_root: Node3D = $CamPivotRoot
@onready var cam_target: Node3D = $CamPivotRoot/CamPivotHeight/CamSpring/CamTarget

@export var cam: NodePath

var mark = preload("res://src/marker.tscn")

const SPEED = 13.0
const ACCEL = 2.0
const DEACCEL = 6.0
const JUMP_VELOCITY = 29.5

const CAM_H_SPEED = 3.2

const JUMP_STRETCH = 1.24
const FALL_CUTOFF = -22
const BIG_FALL = -32

const CAYOTE_FRAMES = 23

var v_stretch: = 1.0

var prev_y_vel: = 0.0

var since_floor: = 0
var alive: = true
var last_cam_target: = Transform3D()

@onready var cam_root_y: = cam_pivot_root.position.y

func _process(delta: float) -> void:
	var cam_spin: = Input.get_axis("cam_left", "cam_right")
	if cam_spin != 0:
		cam_pivot_root.rotate_y(cam_spin * delta * CAM_H_SPEED)
	
	v_stretch = move_toward(v_stretch, 1.0, 1.1 * delta)
	char_model.set_v_stretch(v_stretch)
	
	if Input.is_action_just_pressed("mark_spawn"):
		$CheatTimer.start()
	
	if not Input.is_action_pressed("mark_spawn"):
		$CheatTimer.stop()

func _physics_process(delta: float) -> void:
	
	super._physics_process(delta)
	
	var ext_on_floor = grounded or was_grounded
	
	# Add the gravity.
	if not grounded:
		velocity += get_gravity() * delta
		if not ext_on_floor:
			char_model.play_jumping()
		since_floor += 1
	else:
		since_floor = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and since_floor < CAYOTE_FRAMES:
		v_stretch = JUMP_STRETCH
		velocity.y = JUMP_VELOCITY
		since_floor += CAYOTE_FRAMES
	else:
		if Input.is_action_just_pressed("jump"):
			print(since_floor)
	
	
	var reference_direction := Basis()
	if get_node_or_null(cam):
		var the_cam: Node3D = get_node(cam)
		var diff: = Vector3(global_position.x - the_cam.global_position.x, 0, global_position.z - the_cam.global_position.z)
		reference_direction = Basis.looking_at(diff)
		
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
	
	if grounded:
		var h_vel: = Vector2(velocity.x, velocity.z)
		if h_vel.length() > 0.04:
			char_model.play_running()
		else:
			char_model.play_idle()
		
		if prev_y_vel < FALL_CUTOFF:
			# just landed
			if prev_y_vel < BIG_FALL:
				v_stretch = 0.65
			else:
				v_stretch = 0.8
			#prints("LAND2", prev_y_vel)

	prev_y_vel = velocity.y
	desired_velocity = velocity
	move_and_stair_step()
	
	char_model.position.y = snap_adj
	cam_pivot_root.position.y = cam_root_y + snap_adj
	
	if global_position.y < -5:
		alive = false
	


func _on_cheat_timer_timeout() -> void:
	CheatSpawner.save_location(self)
	var m = mark.instantiate()
	get_parent().add_child(m)
	m.global_position = cam_pivot_root.global_position
