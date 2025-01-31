class_name FoodTruck extends Node3D


@export var dish_spawnpoints: Array[Node3D] = []

@onready var ordering_position: Node3D = $"OrderingPosition"
@onready var finished_order_position: Area3D = $Areas/FinishedOrderPosition
@onready var ui_3d: Node3D = $UI3D


func _ready() -> void:
	Customer.spawn_customers()


func is_dish_position_occupied(pos: Node3D) -> bool:
	var from: Vector3 = pos.global_position
	var to: Vector3 = from + Vector3.DOWN
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var raycast = space.intersect_ray(ray_query)
	if raycast == null:
		return false
	if not raycast.has("collider"):
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
	return finished_order_position.overlaps_body(dish)


func get_order_position() -> Vector3:
	return ordering_position.global_position
