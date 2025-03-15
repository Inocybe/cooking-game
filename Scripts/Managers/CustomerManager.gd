class_name CustomerManager extends Node3D


const STARTING_CUSTOMER_COUNT: int = 20

const CUSTOMER = preload("res://Scenes/misc/customer.tscn")

@export var customer_spawn_radius: float = 20

var customers: Array[Node3D] = []


func _ready() -> void:
	spawn_customers.call_deferred()


func choose_walk_point() -> Vector3:
	var r: float = sqrt(randf()) * customer_spawn_radius
	var theta: float = randf() * 2 * PI
	return Vector3(cos(theta) * r, 0, sin(theta) * r) + global_position


func spawn_customers() -> void:
	for i in range(STARTING_CUSTOMER_COUNT):
		var customer = CUSTOMER.instantiate()
		customer.manager = self
		add_child(customer)
		customer.global_position = choose_walk_point() + Vector3(0, 1, 0)
		customers.append(customer)
