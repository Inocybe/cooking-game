extends RigidBody3D



@onready var new_direction_timer: Timer = $NewDirectionTimer
@export var move_speed: float


var direction: Vector2
var locked_to_order: bool = true
var waiting_order_finish: bool = false
var created_order: bool = false
var stop_moving_because_ran_into_someone_buffer: float = 3.0



func _ready() -> void:
	direction = new_random_direction()
	


func new_random_direction() -> Vector2:
	return Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized() * move_speed


func _on_new_direction_timer_timeout() -> void:
	direction = new_random_direction()


func _process(delta: float) -> void:
	await get_tree().create_timer(0.2).timeout
	if !waiting_order_finish:
		if !locked_to_order:
			constant_force = Vector3(direction.x, 0, direction.y)
		else:
			var food_truck: Node3D = Global.game_manager.food_truck
			var food_truck_order_position: Vector3 = food_truck.ordering_position.global_position
			constant_force = Vector3(food_truck_order_position - global_position).normalized() * move_speed

func in_order_radius() -> void:
	if !created_order:
		waiting_order_finish = true
		Global.game_manager.food_truck.add_order()
		created_order = true
