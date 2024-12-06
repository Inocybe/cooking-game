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


func add_order() -> void:
	var pos: Node3D = choose_best_dish_spawnpoint()
	
	var order: Dish = Global.order_manager.new_order()
	order.global_position = pos.global_position
	order.global_rotation = pos.global_rotation
	
	return


func add_order_from(customer: Customer):
	add_order()
	customer.finished_ordering()


func remove_completed_orders() -> void:
	for order in Global.order_manager.active_orders:
		if order.is_order_complete():
			Global.order_manager.remove_order(order)


func maybe_invoke_ordering() -> void:
	if randf() < 0.5 ** Global.order_manager.active_orders.size():
		Global.game_manager.make_customer_order()


func do_order_hitbox_entered(body: Node3D) -> void:
	if body.has_method("try_to_order"):
		body.try_to_order()


func get_order_position() -> Vector3:
	return ordering_position.global_position
