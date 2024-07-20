extends Node3D

@onready var anim_tree: AnimationTree = $characterMedium/AnimationTree
@onready var character_medium: Node3D = $characterMedium

const COND = "parameters/conditions/"

@onready var base_scale: = character_medium.scale.x

func _unset() -> void:
	anim_tree.set(COND + "gr_idle", false)
	anim_tree.set(COND + "gr_running", false)
	anim_tree.set(COND + "jumping", false)

func play_idle() -> void:
	_unset()
	anim_tree.set(COND + "gr_idle", true)

func play_running() -> void:
	_unset()
	anim_tree.set(COND + "gr_running", true)

func play_jumping() -> void:
	_unset()
	anim_tree.set(COND + "jumping", true)

func set_v_stretch(amount: float):
	character_medium.scale.y = base_scale * amount
	
	character_medium.scale.x = base_scale / amount
	character_medium.scale.z = base_scale / amount
