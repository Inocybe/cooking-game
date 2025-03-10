class_name RigidBodyBase extends RigidBody3D


const CONTINUOUS_CD_SPEED_CUTOFF: float = 0.5

@export var max_speed: float = 5

var body_state: PhysicsDirectBodyState3D


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.linear_velocity.length_squared() > max_speed ** 2:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	
	continuous_cd = linear_velocity.length_squared() > CONTINUOUS_CD_SPEED_CUTOFF ** 2
	
	body_state = state
