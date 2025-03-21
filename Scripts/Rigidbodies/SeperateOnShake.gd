extends Node3D


@export var shake_max_time: float = 0.2
@export var shake_required_speed: float = 5
@export var required_shake_angle: float = PI * 3 / 4

var last_position: Vector3
var velocity: Vector3 = Vector3.ZERO

var last_shake_speed_time: float = 0
var last_shake_velocity: Vector3


func _process(delta: float) -> void:
	velocity = (global_position - last_position) / delta
	last_position = global_position
	
	if velocity.length_squared() > shake_required_speed:
		var now: float = Time.get_unix_time_from_system()
		
		var move_not_expired: bool = last_shake_speed_time + shake_max_time > now
		var has_reversed = velocity.angle_to(last_shake_velocity) > required_shake_angle
		if move_not_expired and has_reversed:
			get_parent().unparent_all_children()
		
		last_shake_speed_time = now
		last_shake_velocity = velocity
