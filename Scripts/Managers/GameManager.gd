class_name GameManager extends Node


const CUSTOMER = preload("res://Scenes/misc/customer.tscn")

var player: CharacterBody3D = null
var food_truck: FoodTruck = null
var customer_walk_area: PointSampler = null
var starting_customer_count: int = 20

var customers: Array[Node3D]


var money: float = 0
var orders_complete: int = 0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	player = Global.current_scene.get_node("Player")
	food_truck = Global.current_scene.get_node("FoodTruck")
	customer_walk_area = Global.current_scene.get_node("CustomerWalkArea")
	
	for i in range(starting_customer_count):
		create_customer()


func _process(_delta: float) -> void:
	call_ui_updates()


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




func call_ui_updates() -> void:
	food_truck.ui_3d.change_order_complete_count(orders_complete)
	food_truck.ui_3d.change_money(money)
