class_name RigidBodyBase extends RigidBody3D

const LINEAR_THRESHOLD: float = 0.01
const ANGULAR_THRESHOLD: float = 0.01

@export var max_speed: float = 5


func _physics_process(_delta: float) -> void:
	if linear_velocity.length_squared() > max_speed * max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
