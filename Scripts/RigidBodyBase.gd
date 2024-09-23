class_name RigidBodyBase extends RigidBody3D


@export var max_speed: float = 7.5


signal integrate_forces(state: PhysicsDirectBodyState3D)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.linear_velocity.length_squared() > max_speed * max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	
	integrate_forces.emit(state)
