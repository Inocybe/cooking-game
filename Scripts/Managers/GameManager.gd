class_name GameManager extends Node


const XR_system = preload("res://Scenes/vr/xr_system.tscn")


var player: Player = null
var food_truck: FoodTruck = null
var customer_walk_area: PointSampler = null
var customers: Array[Node3D] = []

var money: float = 0
var orders_complete: int = 0

var xr_manager: XRManager = null

enum VRMoveMode {
	CHAIR, WALK
}

var vr_move_mode: VRMoveMode = VRMoveMode.CHAIR

signal XR_detected()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	player = Global.current_scene.get_node_or_null("Player")
	food_truck = Global.current_scene.get_node_or_null("FoodTruck")
	customer_walk_area = Global.current_scene.get_node_or_null("CustomerWalkArea")
	
	check_XR()


func _process(_delta: float) -> void:
	if food_truck:
		call_ui_updates()


func return_player() -> CharacterBody3D:
	return player


func return_food_truck() -> Node3D:
	return food_truck


func call_ui_updates() -> void:
	food_truck.ui_3d.change_order_complete_count(orders_complete)
	food_truck.ui_3d.change_money(money)


func check_XR() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		xr_manager = XR_system.instantiate()
		xr_manager.xr_interface = xr_interface
		get_tree().get_root().add_child.call_deferred(xr_manager)
		XR_detected.emit.call_deferred()


func is_vr_avaliable() -> bool:
	return xr_manager != null and xr_manager.is_avaliable


func get_camera_node() -> Node3D:
	if is_vr_avaliable():
		return xr_manager.camera
	else:
		return player.camera


func get_xy_input() -> Vector2:
	if is_vr_avaliable():
		var direct_input = xr_manager.left_hand.get_vector2("primary")
		return Vector2(direct_input.x, -direct_input.y)
	else:
		return Input.get_vector("left", "right", "forward", "back")
