class_name GameManager extends Node


const DAY_LENGTH = 300
const DAY_OVER_SCENE_PATH = "res://Scenes/mains/day_over_menu.tscn"

@onready var order_manager: OrderManager = $OrderManager
@onready var weather_manager: WeatherManager = $WeatherManager
@onready var town_manager: TownManager = $TownManager

var player: Player = null
var food_truck: FoodTruck = null
var customer_manager: CustomerManager = null

var money: float = 0
var orders_complete: int = 0

var time_remaining: float = 0


func _ready() -> void:
	Global.game_manager = self
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
	var current_scene = get_tree().current_scene
	player = current_scene.get_node_or_null("Player")
	food_truck = current_scene.get_node_or_null("FoodTruck")
	customer_manager = current_scene.get_node_or_null("CustomerManager")
	
	if Global.town != null:
		town_manager.load_town(Global.town)


func _process(delta: float) -> void:
	if not get_tree().paused:
		time_remaining -= delta
		if time_remaining < 0:
			day_time_expired()


func day_time_expired() -> void:
	Global.switch_scenes_with_path(DAY_OVER_SCENE_PATH)


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
