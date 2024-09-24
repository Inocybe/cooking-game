class_name RigidBodyBase extends RigidBody3D

const LINEAR_THRESHOLD: float = 0.01
const ANGULAR_THRESHOLD: float = 0.01

@export var max_speed: float = 5


signal integrate_forces(state: PhysicsDirectBodyState3D)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.linear_velocity.length_squared() > max_speed * max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	
	integrate_forces.emit(state)
	
	# checking if not moving to set continuse colision detection to false
	# basically optimization I guess?
	if state.linear_velocity.length() > LINEAR_THRESHOLD or state.angular_velocity.length() > ANGULAR_THRESHOLD:
		continuous_cd = false
