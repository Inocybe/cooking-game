class_name GameManager extends Node


const CUSTOMER = preload("res://Scenes/misc/customer.tscn")

var player: CharacterBody3D = null
var food_truck: FoodTruck = null
var customer_walk_area: PointSampler = null
var starting_customer_count: int = 20

var customers: Array[Node3D]


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	player = Global.current_scene.get_node("Player")
	food_truck = Global.current_scene.get_node("FoodTruck")
	customer_walk_area = Global.current_scene.get_node("CustomerWalkArea")
	
	for i in range(starting_customer_count):
		create_customer()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func return_player() -> CharacterBody3D:
	return player


func return_food_truck() -> Node3D:
	return food_truck


func create_customer() -> void:
	var customer = CUSTOMER.instantiate()
	customers.append(customer)
	
	customer.position = customer_walk_area.sample_point() + Vector3(0, 1, 0)
	Global.current_scene.add_child.call_deferred(customer)


func make_customer_order() -> void:
	customers.pick_random().move_to_foodcart()
