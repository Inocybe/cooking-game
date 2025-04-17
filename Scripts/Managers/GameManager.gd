class_name GameManager extends Node


@onready var order_manager: OrderManager = $OrderManager
@onready var weather_manager: WeatherManager = $WeatherManager
@onready var town_manager: TownManager = $TownManager

var player: Player = null
var food_truck: FoodTruck = null
var customer_manager: CustomerManager = null

var money: float = 0
var orders_complete: int = 0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	var current_scene = get_tree().current_scene
	player = current_scene.get_node_or_null("Player")
	food_truck = current_scene.get_node_or_null("FoodTruck")
	customer_manager = current_scene.get_node_or_null("CustomerManager")
	
	Global.game_manager = self
	
	if Global.town != null:
		town_manager.load_town(Global.town)


func get_camera_node() -> Node3D:
	if Global.is_vr_avaliable():
		return Global.xr_manager.camera
	else:
		return player.camera


func get_xy_input() -> Vector2:
	if Global.is_vr_avaliable():
		var direct_input = Global.xr_manager.left_hand.get_vector2("primary")
		return Vector2(direct_input.x, -direct_input.y)
	else:
		return Input.get_vector("left", "right", "forward", "back")
