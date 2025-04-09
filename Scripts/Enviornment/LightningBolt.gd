extends MeshInstance3D


@export var shader_base: ShaderMaterial


func _ready() -> void:
	var shader = shader_base.duplicate(true)
