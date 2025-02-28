extends Node3D


@onready var min_respawn_timer = $MinRespawnTimer

@export var respawn_bound: Area3D

@export var food_resource: Resource
@export var appear_angle: float = 0 # PI / 2

var last_food: Node3D = null


func _process(_delta: float) -> void:
	if last_food == null:
		spawn_food()
		return
	
	if min_respawn_timer.
	
	var camera: Node3D = Global.game_manager.get_camera_node()
	var rel_pos = global_position - camera.global_position
	if rel_pos.angle_to(camera.forward_vector()) < appear_angle:
		return
	
	if not respawn_bound.overlaps_body(last_food):
		print(last_food)
		spawn_food()


func spawn_food() -> void:
	var food: Node3D = food_resource.instantiate()
	get_tree().get_root().add_child(food)
	food.global_position = global_position
	last_food = food
	min_respawn_timer.start()
