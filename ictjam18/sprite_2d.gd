extends Sprite2D

func _ready() -> void:
	transform
	var new_xform = transform.basis_xform($Sprite2D2.transform)
