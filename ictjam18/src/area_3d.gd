extends Area3D

var splat_scn: = preload("res://src/splat.tscn")

var splatted: = false



func _on_body_entered(body: Node3D) -> void:
	if splatted:
		return
	splatted = true
	
	#print("SPLOOSH")
	var pos = body.global_position
	pos.y = global_position.y
	
	var sp = splat_scn.instantiate()
	add_child(sp)
	sp.global_position = pos
	
	var tm = Timer.new()
	tm.wait_time = 1.5
	tm.one_shot = true
	tm.timeout.connect(ded)
	add_child(tm)
	tm.start()

func ded() -> void:
	SceneSwitcher.reload_scene(1)
