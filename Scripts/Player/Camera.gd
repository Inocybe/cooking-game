extends Camera3D


var should_raycast: bool = false


signal mouse_raycast(raycast_result : Dictionary)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		shoot_ray()


func shoot_ray() -> void:
	var center_of_screen: Vector2 = get_viewport().get_size() / 2
	var ray_length: float = 25
	var from: Vector3 = global_position
	var to: Vector3 = from - get_global_transform().basis.z * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var raycast_result: Dictionary = space.intersect_ray(ray_query)
	mouse_raycast.emit(raycast_result)
