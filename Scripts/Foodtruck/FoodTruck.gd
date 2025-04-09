class_name FoodTruck extends Node3D


@export var dish_spawnpoints: Array[Node3D] = []
@export var dish_check_height: float = 1
@export var ordering_positions: Array[Node3D] = []

@onready var finished_order_position: Area3D = %FinishedOrderPosition
@onready var pickup_position: Node3D = %PickupPosition
@onready var ui_3d: Node3D = %TV

var customers_in_line: Array[Customer] = []


func is_dish_position_occupied(pos: Node3D) -> bool:
	var from: Vector3 = pos.global_position + Vector3.UP * dish_check_height
	var to: Vector3 = from + Vector3.DOWN * (dish_check_height * 2)
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var raycast = space.intersect_ray(ray_query)
	if raycast == null:
		return false
	if not raycast.has("collider"):
		return false
	if raycast["collider"] == null:
		return false
	return raycast["collider"].get_name() != "TreyPositionCollision"

 
func choose_best_dish_spawnpoint() -> Node3D:
	for pos in dish_spawnpoints:
		if not is_dish_position_occupied(pos):
			return pos
	return dish_spawnpoints.pick_random()


func check_dish_in_area(dish: Node3D) -> bool:
	return finished_order_position.overlaps_body(dish)


func get_line_back_pos() -> Vector3:
	return ordering_positions[-1].global_position


func get_pickup_pos() -> Vector3:
	return pickup_position.global_position


func update_customer_line_positions() -> void:
	for i in range(len(customers_in_line)):
		var ordering_position = ordering_positions[i].global_position
		customers_in_line[i].set_line_pos(ordering_position)


func enter_line(customer: Customer) -> bool:
	if len(customers_in_line) == len(ordering_positions):
		return false
	customers_in_line.append(customer)
	update_customer_line_positions()
	return true


func exit_line(customer: Customer) -> void:
	customers_in_line.erase(customer)
	update_customer_line_positions()
