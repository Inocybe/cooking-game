extends Camera3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func shoot_ray() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_position)
	var to = from + project_local_ray_normal(mouse_position) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	
