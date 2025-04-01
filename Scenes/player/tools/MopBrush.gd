extends Node3D


@export var cleaning_effectiveness: float = 0.3

@export var swish_sound_speed: float = 0.5

var last_position: Vector3

var in_spills: Array[Spill] = []


func _process(delta: float) -> void:
	in_spills = in_spills.filter(is_instance_valid)
	
	var movement = (global_position - last_position).length()
	last_position = global_position
	
	var speed = movement / delta
	if in_spills.size() > 0 and speed > swish_sound_speed:
		play_swish_sound()
	
	for spill: Spill in in_spills:
		spill.reduce_size(cleaning_effectiveness * movement)
	
	var pole_facing = %PoleMesh.global_basis.y
	var yrot = -atan2(pole_facing.z, pole_facing.x)
	global_rotation = Vector3(0, yrot, 0)


func play_swish_sound() -> void:
	if not $SwishSoundPlayer.playing:
		$SwishSoundPlayer.play()


func on_area_entered(area: Area3D):
	if area is Spill:
		in_spills.append(area)


func on_body_exited(area: Area3D):
	in_spills.erase(area)
