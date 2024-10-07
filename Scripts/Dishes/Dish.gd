extends Holdable
class_name Dish


const FOOD_ITEM = preload("res://Scenes/orders/food_item.tscn")

var order: Array[Menu.Item]
var order_functions : OrderFunctions

@export var food_positions: Array[Node3D]


func _ready() -> void:
	super()
	
	# goes through order
	for i in range(order.size()):
		
		# instantiates each item in the order thing yes (good comment ain't it)
		for scene in order_functions.get_food_item_scenes(order[i]):
			var food: Node = instantiate_scene_from_path(scene)
			combine_objects(food, i)
			


func instantiate_scene_from_path(scene_path: String) -> Node:
	# Load the scene from the given path
	var scene = load(scene_path)
	
	# Check if the scene is valid
	if scene == null:
		print("Error: Scene not found at path: ", scene_path)
		return null
	
	# Instantiate the scene
	var instance = scene.instantiate()
	
	return instance


func combine_objects(child: Holdable, food_position: int) -> void:
	var parent: Node3D = food_positions[food_position]
	parent.add_child(child)
	
	# get collider to disable it
	var collider: CollisionShape3D = child.get_node_or_null("CollisionShape3D")
	if collider:
		collider.disabled = true
	child.collision_layer = 0
	child.collision_mask = 0
	
	#child.freeze_mode = FREEZE_MODE_STATIC
	child.freeze = true
	
	# set positoin to the center of objectd
	child.global_position = parent.global_position
	child.global_rotation = parent.global_rotation
