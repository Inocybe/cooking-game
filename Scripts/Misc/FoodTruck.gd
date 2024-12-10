class_name FoodTruck extends Node3D


@export var dish_spawnpoints: Array[Node3D] = []

@onready var ordering_position: Node3D = $"OrderingPosition"


func is_dish_position_occupied(pos: Node3D) -> bool:
	var from: Vector3 = pos.global_position
	var to: Vector3 = from + Vector3.DOWN
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var raycast = space.intersect_ray(ray_query)
	if raycast == null:
		return false
	if raycast["collider"] == null:
		return false
	return raycast["collider"].get_name() != "Truck Body"


func choose_best_dish_spawnpoint() -> Node3D:
	for pos in dish_spawnpoints:
		if not is_dish_position_occupied(pos):
			return pos
	return dish_spawnpoints.pick_random()

func check_dish_in_area(dish: Node3D) -> bool:
	for spawnpoint in dish_spawnpoints:
		var from: Vector3 = spawnpoint.global_position
		var to: Vector3 = from + Vector3.DOWN
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.create(from, to)
		var raycast = space.intersect_ray(ray_query)
		if raycast["collider"] == dish.get_node("CollisionShape3D"):
			return true
	return false

func do_order_hitbox_entered(body: Node3D) -> void:
	if body.has_method("await_order_taken"):
		if body.wants_to_order:
			body.await_order_taken()


func get_order_position() -> Vector3:
	return ordering_position.global_position
