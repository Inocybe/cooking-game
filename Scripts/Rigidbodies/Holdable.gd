class_name Holdable extends RigidBodyBase


@export var standard_angular_damp: float = 1
@export var held_angular_damp: float = 2
@export var move_line_acceleration: float = 30
@export var move_plane_acceleration: float = 16
@export_range(0, 1) var undershoot_amount: float = 0.75
@export var freeze_dist: float = 0.02
@export var freeze_vel: float = 0.3

@export var rotational_acceleration: float = 10
@export var vertical_freeze_angle: float = (PI / 180) * 1
@export var forward_freeze_angle: float = (PI / 180) * 1
@export var freeze_angular_speed: float = 4

var held: bool = false
var target_pos: Vector3
var target_rot: float
var default_gravity_scale: float


func _ready() -> void:
	angular_damp = standard_angular_damp
	default_gravity_scale = gravity_scale
	can_sleep = false


func facing_direction():
	return global_transform.basis.y


func _physics_process(delta: float) -> void:
	if not held:
		return
	
	do_rotational_correction(delta)
	
	do_position_correction(delta)


func do_rotational_correction(delta: float) -> void:
	var remaining_angle_to_up: float = facing_direction().angle_to(Vector3.UP)
	var remaining_angle_to_forward: float = fmod(target_rot - global_rotation.y + PI, 2 * PI) - PI
	
	var target_angular_speed: float = 0
	var target_angular_axis: Vector3 = Vector3(0, 0, 0)
	
	if remaining_angle_to_up > vertical_freeze_angle:
		target_angular_speed = sqrt(2 * remaining_angle_to_up * rotational_acceleration)
		target_angular_axis = facing_direction().cross(Vector3.UP).normalized()
	elif abs(remaining_angle_to_forward) > forward_freeze_angle:
		target_angular_speed = (sqrt(2 / abs(remaining_angle_to_forward) * rotational_acceleration)
			* remaining_angle_to_forward)
		target_angular_axis = Vector3.UP
	elif angular_velocity.length_squared() < freeze_angular_speed ** 2:
		angular_velocity = Vector3(0, 0, 0)
		return
	
	var target_angular_vel: Vector3 = target_angular_axis * target_angular_speed
	var torque_direction: Vector3 = (target_angular_vel - angular_velocity).normalized()
	var torque: Vector3 = torque_direction * rotational_acceleration * delta
	angular_velocity += torque


func do_position_correction(delta: float) -> void:
	var offset: Vector3 = target_pos - global_position
	var offset_dist: float = offset.length()
	
	if offset_dist < freeze_dist and linear_velocity.length_squared() < freeze_vel ** 2:
		linear_velocity = Vector3(0, 0, 0)
		return
	
	var offset_dir: Vector3 = offset.normalized()
	
	var line_vel: float = linear_velocity.dot(offset_dir)
	var line_acceleration_dir: float
	if line_vel > 0:
		var line_pos_at_stop: float = line_vel ** 2 / move_line_acceleration / 2
		line_acceleration_dir = sign(offset_dist - line_pos_at_stop/undershoot_amount)
	else:
		line_acceleration_dir = 1
	apply_central_force(mass * line_acceleration_dir * move_line_acceleration * offset_dir)
	
	var plane_vel: Vector3 = linear_velocity - line_vel * offset_dir
	var plane_impulse: Vector3 = plane_vel.normalized() * -move_plane_acceleration * delta
	if plane_impulse.length_squared() > plane_vel.length_squared():
		plane_impulse = -plane_vel
	apply_central_impulse(mass * plane_impulse)


func on_start_interact() -> void:
	held = true
	gravity_scale = 0
	angular_damp = held_angular_damp
	sleeping = false


func on_stop_interact() -> void:
	held = false
	gravity_scale = default_gravity_scale
	angular_damp = standard_angular_damp


func set_held_position(pos: Vector3, rot: float) -> void:
	target_pos = pos
	target_rot = rot
