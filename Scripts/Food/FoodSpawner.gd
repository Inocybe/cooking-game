extends Node3D


@export var dist_to_respawn: float = 0.5
@export var food_resource: Resource
@export var appear_angle: float = PI / 2

var last_food: Node3D = null


func _process(_delta: float) -> void:
	if last_food == null:
		spawn_food()
		return
	
	var camera: Node3D = Global.game_manager.get_camera_node()
	var rel_pos = global_position - camera.global_position
	if rel_pos.angle_to(camera.forward_vector()) < appear_angle:
		return
	
	if (last_food.global_position - global_position).length_squared() > dist_to_respawn ** 2:
		spawn_food()


func spawn_food() -> void:
	var food: Node3D = food_resource.instantiate()
	get_tree().get_root().add_child(food)
	food.global_position = global_position
	last_food = food
