extends Control

signal switched

var next_scene = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("transition")

func now_out() -> void:
	get_tree().change_scene_to_file(next_scene)
	
	await get_tree().process_frame
	switched.emit()
	loaded()

func loaded() -> void:
	$AnimationPlayer.play("transition_out")
