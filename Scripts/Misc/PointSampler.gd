class_name PointSampler extends Node3D


@export var max_radius: float = 20


func sample_point() -> Vector3:
	var r: float = sqrt(randf()) * max_radius
	var theta: float = randf() * 2 * PI
	return Vector3(cos(theta) * r, 0, sin(theta) * r) + global_position
