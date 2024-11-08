extends Area3D


@export var min_size = 0.5
@export var max_size = 1
@export var position_range = 0.3


func _ready() -> void:
	var size: float = randf_range(min_size, max_size)
	scale = Vector3(size, size, size)
	position += Vector3(
		randf_range(-position_range, position_range), 0, 
		randf_range(-position_range, position_range)
	)


func set_material(material: StandardMaterial3D) -> void:
	$MeshInstance3D.set_surface_override_material(0, material)
