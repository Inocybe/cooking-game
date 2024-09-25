extends Holdable


@export var max_height: float = 0.75

@onready var locked_pos: Vector3 = position


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	position.y = min(position.y, max_height)
	
	if held:
		return
	
	position = locked_pos
	linear_velocity = Vector3(0, 0, 0)


func on_stop_interact() -> void:
	super()
	locked_pos = position
