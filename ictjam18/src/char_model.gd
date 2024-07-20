extends Node3D

@onready var anim_tree: AnimationTree = $characterMedium/AnimationTree

const COND = "parameters/conditions/"

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
