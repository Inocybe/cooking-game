extends Holdable
class_name Dish


const GHOST_ORDER_CONTROLLER = preload("res://Scenes/orders/ghost_order_controller.tscn")
const force_amount: float = 0.005


var order: Array[Menu.Item]
var order_functions : OrderFunctions
# tracking of food on tray
var childed_objects: Array[Array] = [[], [], []]
var childed_ghosts: Array[Array] = [[], [], []]
var recently_removed_child: Array[Holdable]

@export var food_positions: Array[Node3D]




func _ready() -> void:
	super()
	
	# goes through order
	for i in range(order.size()):
		
		var scene_counter = 0
		
		# instantiates each item in the order thing yes (good comment ain't it)
		for scene in order_functions.get_food_item_scenes(order[i]):
			#instnatiate and add to childed objects
			var food: Node3D = instantiate_scene_from_path(scene)
			
			# add to childed objects array
			childed_ghosts[i].append(food)
			
			# combine object to the thing
			combine_objects(food, i)
			
			# add the ghost item
			add_ghost_order_controller(food)
			

			
			scene_counter += 1





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
	child.reparent(parent)
	
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



func add_ghost_order_controller(object: Node3D) -> void:
	# adding of ghost controller
	# it makes the object transparent and stuff
	var ghost_order_controller: Node = GHOST_ORDER_CONTROLLER.instantiate()
	object.add_child(ghost_order_controller)


# detecting of a food objet goes near tray
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("food") and not childed_ghosts.has(body):
		if body.has_method("get_food_type") and !recently_removed_child.has(body):
			check_order_and_add_object(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body in recently_removed_child and not childed_ghosts.has(body):
		recently_removed_child.erase(body)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_children") and childed_objects.size() > 0:
		remove_all_objects()
		pass


func check_order_and_add_object(body: Node3D) -> void:
	for i in range(order.size()):
		if body.get_food_type() == order[i]:
			combine_objects(body, i)
			childed_objects[i].append(body)
			disable_ghost_object(i)


func disable_ghost_object(index: int) -> void:
	for item: Holdable in childed_ghosts[index]:
		item.visible = false


func remove_all_objects() -> void:
	for i in range(childed_objects.size()):
		for child in childed_objects[i]:
			var collider = child.get_node_or_null("CollisionShape3D")
			
			child.reparent(Global.current_scene)
			object_removed(child)
			
			child.freeze = false
			
			#apply random direction of force
			var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
			apply_impulse(Vector3(), random_direction * force_amount)
			
			collider.disabled = false
			child.collision_layer = 1
			child.collision_mask = 1
			
	
	set_childed_objects_to_null()
		
	
func object_removed(object: Node3D) -> void:
	recently_removed_child.append(object)
	
	
func set_childed_objects_to_null() -> void:
	for i: int in range(childed_objects.size()):
		childed_objects[i].clear()
			
