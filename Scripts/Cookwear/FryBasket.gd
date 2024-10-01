extends Holdable


@export var max_height: float = 0.75


func _ready() -> void:
	%"Frying Area".body_entered.connect(on_body_entered)
	%"Frying Area".body_exited.connect(on_body_exited)


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	position.y = min(position.y, max_height)


func _process(delta: float) -> void:
	freeze = not held
	
	if not held:
		linear_velocity = Vector3(0, 0, 0)


func on_body_entered(body: Node3D):
	if body.has_method("on_start_frying"):
		body.on_start_frying()


func on_body_exited(body: Node3D):
	if body.has_method("on_stop_frying"):
		body.on_stop_frying()
