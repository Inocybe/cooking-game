class_name Customer extends AnimatableBody3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var min_move_speed: float = 1
@export var max_move_speed: float = 3
@export var target_pos_margin: float = 0.1
@export var target_speed_margin: float = 0.1
@export var traction: float = 4
@export var min_idle_time: float = 0
@export var max_idle_time: float = 0
@export var order_collect_speed_multiplier = 2

enum CustomerState {
	IDLING,
	RANDOM_MOVING,
	GOING_TO_ORDER,
	WANTS_TO_ORDER,
	PICKING_UP_DISH,
	ANIMATING_PICKUP
}

var manager: CustomerManager

var move_speed: float
var target: Vector3
var velocity: Vector3 = Vector3.ZERO
var state: CustomerState

var is_in_order_hitbox: bool = false
var dish_ordered: Node3D = null


func _ready() -> void:
	move_speed = randf() * (max_move_speed - min_move_speed) + min_move_speed
	choose_random_target()


func go_to_order() -> void:
	state = CustomerState.GOING_TO_ORDER
	target = Global.game_manager.food_truck.get_line_back_pos()


func move_to_pickup() -> void:
	state = CustomerState.PICKING_UP_DISH
	target = Global.game_manager.food_truck.get_pickup_pos()


func get_target_offset() -> Vector2:
	return Vector2(target.x - global_position.x, target.z - global_position.z)


func is_at_target() -> bool:
	return get_target_offset().length_squared() < target_pos_margin ** 2


func finish_idling() -> void:
	if state == CustomerState.IDLING:
		choose_random_target()


func choose_random_target() -> void:
	target = manager.choose_walk_point()
	state = CustomerState.RANDOM_MOVING


func start_idle() -> void:
	$IdleTimer.start(randf() * (max_idle_time - min_idle_time) + min_idle_time)
	state = CustomerState.IDLING


func get_current_move_speed() -> float:
	if state == CustomerState.PICKING_UP_DISH:
		return move_speed * order_collect_speed_multiplier
	else:
		return move_speed


func _process(delta: float) -> void:
	if is_at_target():
		if state == CustomerState.RANDOM_MOVING:
			start_idle()
		elif state == Customer.CustomerState.GOING_TO_ORDER:
			await_order_taken()
		elif state == Customer.CustomerState.PICKING_UP_DISH:
			collect_order()
	
	var speed: float = velocity.length()
	if is_at_target() and speed < target_speed_margin:
		return
	
	var stopping_time: float = speed / traction
	var dist_to_stop: float = speed * stopping_time - 0.5 * traction * stopping_time ** 2
	var target_offset: Vector2 = get_target_offset()
	
	var target_vel: Vector3
	if target_offset.length() > dist_to_stop:
		var target_vel_2d: Vector2 = target_offset.normalized() * get_current_move_speed()
		target_vel = Vector3(target_vel_2d.x, 0, target_vel_2d.y)
	else:
		target_vel = velocity.normalized() * -get_current_move_speed()
	
	velocity = velocity.move_toward(target_vel, traction * delta)
	position += velocity * delta


func finish_ordering() -> void:
	if not dish_ordered:
		Global.game_manager.order_manager.request_order_from(self)
		done_ordering()


func done_ordering() -> void:
	Global.game_manager.food_truck.exit_line(self)
	choose_random_target()
	animation_player.play_backwards("awaiting_order_taken")


func on_start_interact() -> void:
	if state == CustomerState.WANTS_TO_ORDER:
		finish_ordering()


func await_order_taken() -> void:
	if Global.game_manager.food_truck.enter_line(self):
		state = CustomerState.WANTS_TO_ORDER
		animation_player.play("awaiting_order_taken")
		$AngryOrderNotTakenTimer.start()
	else:
		choose_random_target()


func set_line_pos(pos: Vector3) -> void:
	if (state == CustomerState.WANTS_TO_ORDER 
		or state == CustomerState.GOING_TO_ORDER):
		target = pos


func collect_order() -> void:
	if (Global.game_manager.food_truck.check_dish_in_area(dish_ordered)
		and not dish_ordered.held and dish_ordered.is_order_complete()):
		
		var order_manager = Global.game_manager.order_manager
		
		animation_player.play("collect_order")
		order_manager.register_completed_dish(dish_ordered)
		order_manager.remove_order(dish_ordered)
		state = CustomerState.ANIMATING_PICKUP
		animation_player.animation_finished.connect(
			finished_collecting, ConnectFlags.CONNECT_ONE_SHOT)
		
	else:
		choose_random_target()


func finished_collecting(_animation: String) -> void:
	choose_random_target()
