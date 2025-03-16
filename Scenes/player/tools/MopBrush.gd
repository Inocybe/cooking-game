extends Node3D


@export var cleaning_effectiveness: float = 0.3

var last_position: Vector3

var in_spills: Array[Spill] = []


func _process(_delta: float) -> void:
	in_spills = in_spills.filter(is_instance_valid)
	
	var movement = (global_position - last_position).length()
	last_position = global_position
	
	for spill: Spill in in_spills:
		spill.reduce_size(cleaning_effectiveness * movement)
	
	var pole_facing = %PoleMesh.global_basis.y
	var yrot = -atan2(pole_facing.z, pole_facing.x)
	global_rotation = Vector3(0, yrot, 0)


func on_area_entered(area: Area3D):
	if area is Spill:
		in_spills.append(area)


func on_body_exited(area: Area3D):
	in_spills.erase(area)
