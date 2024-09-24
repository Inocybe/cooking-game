class_name Holdable extends RigidBodyBase


@export var standard_angular_damp: float = 1
@export var held_angular_damp: float = 7.5
@export var move_line_force: float = 30
@export var move_plane_force: float = 16
@export_range(0, 1) var undershoot_amount: float = 0.9
@export var freeze_dist: float = 0.1
@export var freeze_vel: float = 0.1

var held: bool = false
var target_pos: Vector3
var default_gravity_scale: float


func _ready() -> void:
	angular_damp = standard_angular_damp
	default_gravity_scale = gravity_scale


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	super(state)
	
	if not held:
		return

	var offset: Vector3 = target_pos - global_position
	var offset_dist: float = offset.length()
	
	if offset_dist < freeze_dist and state.linear_velocity.length_squared() < freeze_vel ** 2:
		state.linear_velocity = Vector3(0, 0, 0)
		return
	
	var offset_dir: Vector3 = offset.normalized()
	
	var line_vel: float = state.linear_velocity.dot(offset_dir)
	var line_force_dir: float
	if line_vel > 0:
		var line_pos_at_stop: float = line_vel ** 2 / move_line_force / 2
		line_force_dir = sign(offset_dist - line_pos_at_stop/undershoot_amount)
	else:
		line_force_dir = 1
	state.apply_central_force(line_force_dir * move_line_force * offset_dir)
	
	var plane_vel: Vector3 = state.linear_velocity - line_vel * offset_dir
	state.apply_central_force(plane_vel.normalized() * -move_plane_force)


func on_start_interact() -> void:
	held = true
	can_sleep = false
	gravity_scale = 0
	angular_damp = held_angular_damp
	
	# prevent clipping (I think)
	continuous_cd = true


func on_stop_interact() -> void:
	held = false
	can_sleep = true
	gravity_scale = default_gravity_scale
	angular_damp = standard_angular_damp
	
	sleeping = false



func set_held_position(pos: Vector3) -> void:
	target_pos = pos
