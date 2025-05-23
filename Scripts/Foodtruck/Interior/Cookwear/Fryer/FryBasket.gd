extends Holdable


@export var max_height: float = 0.55


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	position.y = min(position.y, max_height)


func _process(_delta: float) -> void:
	freeze = not held
	
	if not held:
		linear_velocity = Vector3(0, 0, 0)
