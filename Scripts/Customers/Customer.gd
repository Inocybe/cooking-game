class_name Customer extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var move_speed: float = 2
@export var target_margin: float = 0.1
@export var traction: float = 4
@export var min_idle_time: float = 0
@export var max_idle_time: float = 0

var target: Vector3
var velocity: Vector3 = Vector3.ZERO
var is_awaiting_order_taken: bool = false
var has_active_order: bool = false
var wants_to_order: bool = false
var is_idle_in_position: bool = false

var dish_ordered: Node3D = null

func _ready() -> void:
	choose_random_target()


func move_to_foodcart() -> void:
	is_idle_in_position = false
	target = Global.game_manager.food_truck.get_order_position()


func get_target_offset() -> Vector2:
	return Vector2(target.x - global_position.x, target.z - global_position.z)


func is_at_target() -> bool:
	return get_target_offset().length_squared() < target_margin ** 2


func finish_idling() -> void:
	if not is_idle_in_position:
		return
	choose_random_target()
	is_idle_in_position = false


func choose_random_target() -> void:
	target = Global.game_manager.customer_walk_area.sample_point()


func start_idle() -> void:
	is_idle_in_position = true
	$IdleTimer.start(randf() * (max_idle_time - min_idle_time) + min_idle_time)


func _process(delta: float) -> void:
	if is_at_target():
		start_idle()
	
	var target_vel = Vector3.ZERO
	if not is_awaiting_order_taken and not is_idle_in_position:
		var target_vel_2d: Vector2 = get_target_offset().normalized() * move_speed
		target_vel = Vector3(target_vel_2d.x, 0, target_vel_2d.y)
	
	velocity = velocity.move_toward(target_vel, traction * delta)
	position += velocity * delta
	
	#if is_idle_in_position and is_at_target():
		#if dish_ordered.is_order_completed():
		#	collect_food()


func order_taken() -> void:
	if not has_active_order:
		Global.game_manager.food_truck.request_order_from(self)
		has_active_order = true


func finished_ordering() -> void:
	is_awaiting_order_taken = false
	choose_random_target()
	animation_player.play_backwards("awaiting order taken")


func on_start_interact() -> void:
	if wants_to_order:
		order_taken()
		finished_ordering()


func await_order_taken() -> void:
	is_awaiting_order_taken = true
	animation_player.play("awaiting order taken")


func collect_food() -> void:
	Global.order_manager.remove_order(dish_ordered)
