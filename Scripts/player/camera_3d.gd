extends Camera3D


var should_raycast: bool = false


signal mouse_raycast(raycast_result : Array[Dictionary])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		should_raycast = true


func _physics_process(delta: float) -> void:
	if should_raycast:
		should_raycast = false
		shoot_ray()


func shoot_ray() -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var ray_length = 25
	var from: Vector3 = project_ray_origin(mouse_position)
	var to: Vector3 = from + project_ray_normal(mouse_position) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var raycast_result = space.intersect_ray(ray_query)
	emit_signal("mouse_raycast", raycast_result)
