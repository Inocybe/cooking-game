class_name Spill extends Area3D


var material: Material
var size: float

@export var min_size = 0.5
@export var max_size = 1
@export var disappear_threshold = 0.2
@export var position_range = 0.3


func _ready() -> void:
	size = randf_range(min_size, max_size)
	scale = Vector3(size, size, size)
	position += Vector3(
		randf_range(-position_range, position_range), 0, 
		randf_range(-position_range, position_range)
	)
	$MeshInstance3D.set_surface_override_material(0, material)


func reduce_size(amount: float):
	size -= amount
	scale = Vector3(size, size, size)
	if size < disappear_threshold:
		queue_free()
