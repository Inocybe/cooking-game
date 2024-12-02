class_name GameManager extends Node

var player: CharacterBody3D = null
var food_truck: Node3D = null


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	player = Global.current_scene.get_node("Player")
	food_truck = Global.current_scene.get_node("FoodTruck")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func return_player() -> CharacterBody3D:
	return player


func return_food_truck() -> Node3D:
	return food_truck
