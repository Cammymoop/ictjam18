extends Node3D

@onready var anim_tree: AnimationTree = $characterMedium/AnimationTree
@onready var character_medium: Node3D = $characterMedium

const COND = "parameters/conditions/"

@onready var base_scale: = character_medium.scale.x

var tex_num: = -1

var possible_textures: Array[CompressedTexture2D] = [
	preload("res://texture/player/alienB.png"),
	preload("res://texture/player/astroMaleA.png"),
	preload("res://texture/player/athleteMaleRed.png"),
	preload("res://texture/player/businessMaleA.png"),
	preload("res://texture/player/casualFemaleB.png"),
	preload("res://texture/player/casualMaleA.png"),
	preload("res://texture/player/fantasyMaleB.png"),
	preload("res://texture/player/farmerA.png"),
	preload("res://texture/player/militaryFemaleB.png"),
	preload("res://texture/player/militaryMaleA.png"),
	preload("res://texture/player/militaryMaleB.png"),
	preload("res://texture/player/racerBlueFemale.png"),
	preload("res://texture/player/racerRedMale.png"),
	preload("res://texture/player/robot2.png"),
	preload("res://texture/player/zombieB.png"),
]

func _ready() -> void:
	random_texture()

func random_texture() -> void:
	if TextureRememberer.last_tex_num < 0:
		TextureRememberer.last_tex_num = randi_range(0, len(possible_textures) - 1)
		print(TextureRememberer.last_tex_num)
	if TextureRememberer.won_with_num >= 0:
		tex_num = TextureRememberer.won_with_num
		return
	
	while tex_num < 0 or tex_num == TextureRememberer.last_tex_num:
		tex_num = randi_range(0, len(possible_textures) - 1)
	prints("now", tex_num)
	TextureRememberer.last_tex_num = tex_num
	set_tex()

func set_tex() -> void:
	var m = $characterMedium/Root/Skeleton3D/characterMedium
	m.get_surface_override_material(0).albedo_texture = possible_textures[tex_num]

func we_won() -> void:
	TextureRememberer.won_with_num = tex_num

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
