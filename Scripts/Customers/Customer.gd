class_name Customer extends AnimatableBody3D


@export var move_speed: float = 2
@export var target_margin: float = 0.1
@export var traction: float = 4
@export var min_idle_time: float = 0
@export var max_idle_time: float = 0

var target: Vector3
var velocity: Vector3 = Vector3.ZERO
var currently_placing_order: bool = false
var has_active_order: bool = false
var is_idle_in_position: bool = false


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
	if not currently_placing_order and not is_idle_in_position:
		var target_vel_2d: Vector2 = get_target_offset().normalized() * move_speed
		target_vel = Vector3(target_vel_2d.x, 0, target_vel_2d.y)
		Global.debug_ray(global_position, target-global_position)
	
	velocity = velocity.move_toward(target_vel, traction * delta)
	position += velocity * delta


func try_to_order() -> void:
	if not has_active_order:
		currently_placing_order = true
		Global.game_manager.food_truck.add_order_from(self)
		has_active_order = true


func finished_ordering() -> void:
	currently_placing_order = false
	choose_random_target()
