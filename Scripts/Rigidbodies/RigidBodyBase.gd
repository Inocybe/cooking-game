class_name RigidBodyBase extends RigidBody3D


const CONTINUOUS_CD_SPEED_CUTOFF: float = 0.5

@export var max_speed: float = 5


func _physics_process(_delta: float) -> void:
	if linear_velocity.length_squared() > max_speed * max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
		
		continuous_cd = linear_velocity.length_squared() > CONTINUOUS_CD_SPEED_CUTOFF ** 2
