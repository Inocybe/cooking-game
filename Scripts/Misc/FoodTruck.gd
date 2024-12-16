class_name FoodTruck extends Node3D


@export var dish_spawnpoints: Array[Node3D] = []

@onready var ordering_position: Node3D = $"OrderingPosition"


@onready var finished_order_position: Area3D = $Areas/FinishedOrderPosition


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


# Raycasts down to make sure the dish is in the area, and if it is then returns true
func check_dish_in_area(dish: Node3D) -> bool:
	return finished_order_position.objects.has(dish)


func do_order_hitbox_entered(body: Node3D) -> void:
	if body is Customer:
		if body.state == Customer.CustomerState.GOING_TO_ORDER:
			body.await_order_taken()
		elif body.state == Customer.CustomerState.PICKING_UP_DISH:
			body.collect_order()


func get_order_position() -> Vector3:
	return ordering_position.global_position
