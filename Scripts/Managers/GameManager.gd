class_name GameManager extends Node


const XR_system = preload("res://Scenes/misc/xr_system.tscn")


var player: Player = null
var food_truck: FoodTruck = null
var customer_walk_area: PointSampler = null
var customers: Array[Node3D] = []

var money: float = 0
var orders_complete: int = 0

var is_vr: bool = false
var xr_manager: XRManager = null

enum VRMoveMode {
	CHAIR, WALK
}

var vr_move_mode: VRMoveMode = VRMoveMode.CHAIR

signal XR_detected()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	player = Global.current_scene.get_node("Player")
	food_truck = Global.current_scene.get_node("FoodTruck")
	customer_walk_area = Global.current_scene.get_node("CustomerWalkArea")
	
	check_XR()


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


func call_ui_updates() -> void:
	food_truck.ui_3d.change_order_complete_count(orders_complete)
	food_truck.ui_3d.change_money(money)


func check_XR() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		is_vr = true
		xr_manager = XR_system.instantiate()
		xr_manager.xr_interface = xr_interface
		get_tree().get_root().add_child.call_deferred(xr_manager)
		XR_detected.emit.call_deferred()


func get_xy_input() -> Vector2:
	if is_vr:
		if xr_manager.left_hand:
			var direct_input = xr_manager.left_hand.get_vector2("primary")
			return Vector2(direct_input.x, -direct_input.y)
		return Vector2.ZERO
	else:
		return Input.get_vector("left", "right", "forward", "back")
