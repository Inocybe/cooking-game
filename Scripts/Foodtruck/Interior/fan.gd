extends AnimatableBody3D


const fan_speed: float = 10


func _physics_process(delta: float) -> void:
	rotate_y(fan_speed * delta)
