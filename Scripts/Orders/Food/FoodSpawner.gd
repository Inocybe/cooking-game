extends Node3D


@onready var min_respawn_timer = $MinRespawnTimer

@export var respawn_bound: Area3D
@export var food_component: Menu.FoodComponent
@export var appear_angle: float = PI / 2

var food_resource: Resource
var last_food: Node3D = null


func _ready() -> void:
	food_resource = load(Menu.get_food_component_scene_path(food_component))


func _process(_delta: float) -> void:
	if last_food == null:
		spawn_food()
		return
	
	if min_respawn_timer.time_left > 0:
		return
	
	var camera: Node3D = Global.game_manager.get_camera_node()
	var rel_pos = global_position - camera.global_position
	if rel_pos.angle_to(camera.forward_vector()) < appear_angle:
		return
	
	if not respawn_bound.overlaps_body(last_food):
		spawn_food()


func spawn_food() -> void:
	if Global.game_manager.try_use_food(food_component):
		var food: Node3D = food_resource.instantiate()
		get_tree().current_scene.add_child(food)
		food.global_position = global_position
		last_food = food
		min_respawn_timer.start()
	else:
		# we're out of this type of food
		queue_free()
