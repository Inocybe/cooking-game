class_name GameManager extends Node


const XR_SYSTEM = preload("res://Scenes/player/vr/xr_system.tscn")

@onready var order_manager: OrderManager = $OrderManager
@onready var weather_manager: WeatherManager = $WeatherManager

var player: Player = null
var food_truck: FoodTruck = null
var customer_manager: CustomerManager = null

var money: float = 0
var orders_complete: int = 0

var xr_manager: XRManager = null

enum VRMoveMode {
	CHAIR, WALK
}

var vr_move_mode: VRMoveMode = VRMoveMode.CHAIR

signal has_XR_detected(has_XR: bool)


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	var current_scene = get_tree().current_scene
	player = current_scene.get_node_or_null("Player")
	food_truck = current_scene.get_node_or_null("FoodTruck")
	customer_manager = current_scene.get_node_or_null("CustomerManager")
	
	Global.game_manager = self
	
	check_XR()


func check_XR() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		xr_manager = XR_SYSTEM.instantiate()
		xr_manager.xr_interface = xr_interface
		get_tree().get_root().add_child.call_deferred(xr_manager)
		has_XR_detected.emit.call_deferred(true)
	else:
		has_XR_detected.emit.call_deferred(false)


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
