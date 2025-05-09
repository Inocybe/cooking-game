extends AnimatableBody3D

@onready var fan: Node3D = $fan

@export var fan_speed: float = 10

func _process(delta: float) -> void:
	fan.rotate_y(fan_speed * delta)
