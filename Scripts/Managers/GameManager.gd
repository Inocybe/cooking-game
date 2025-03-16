class_name GameManager extends Node


const XR_SYSTEM = preload("res://Scenes/player/vr/xr_system.tscn")

var player: Player = null
var food_truck: FoodTruck = null
@onready var order_manager: OrderManager = $OrderManager
var customer_manager: CustomerManager = null

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
	
	var current_scene = get_tree().current_scene
	player = current_scene.get_node_or_null("Player")
	food_truck = current_scene.get_node_or_null("FoodTruck")
	customer_manager = current_scene.get_node_or_null("CustomerManager")
	
	check_XR()


func _process(_delta: float) -> void:
	if food_truck:
		call_ui_updates()


func call_ui_updates() -> void:
	return
	food_truck.ui_3d.change_order_complete_count(orders_complete)
	food_truck.ui_3d.change_money(money)


func check_XR() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		xr_manager = XR_SYSTEM.instantiate()
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
