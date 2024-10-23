extends Holdable
class_name Dish

const GHOST_ORDER_CONTROLLER = preload("res://Scenes/orders/ghost_order_controller.tscn")

@export var food_positions: Array[Node3D]

var order: Array[Menu.Item]
var order_functions: OrderFunctions
var childed_objects: Array[Array] = [[], [], []]
var childed_ghosts: Array[Array] = [[], [], []]
var recently_removed_child: Array[Holdable] = []

var combining_and_removing_functions: CombiningAndRemoving = CombiningAndRemoving.new()

func _ready() -> void:
	super()
	# Instantiate each item in the order
	for i in range(order.size()):
		for scene in order_functions.get_food_item_scenes(order[i]):
			var food = instantiate_scene_from_path(scene) as Node3D
			if food:
				childed_ghosts[i].append(food)
				combine_objects(food, i)
				add_ghost_order_controller(food)


func instantiate_scene_from_path(scene_path: String) -> Node:
	var scene = load(scene_path)
	var instance = scene.instantiate()
	return instance


func combine_objects(child: Holdable, food_position: int) -> void:
	var parent = food_positions[food_position]
	
	parent.add_child(child)
	child.reparent(parent)
		
	combining_and_removing_functions.set_collider_and_state(child, true)
	child.global_transform = parent.global_transform


func add_ghost_order_controller(object: Node3D) -> void:
	var ghost_order_controller = GHOST_ORDER_CONTROLLER.instantiate()
	object.add_child(ghost_order_controller)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("food") and not recently_removed_child.has(body):
		if body.has_method("get_food_type"):
			check_order_and_add_object(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body in recently_removed_child:
		recently_removed_child.erase(body)


func remove_children() -> void:
	if childed_objects.size() > 0:
		remove_all_objects()


func check_order_and_add_object(body: Node3D) -> void:
	for i in range(childed_ghosts.size()):
		if childed_objects[i].size() == 0:
			for ghost in childed_ghosts[i]:
				if ghost.get_food_type() == body.get_food_type():
					combine_objects(body, i)
					childed_objects[i].append(body)
					disable_ghost_object(i)
					break


func disable_ghost_object(index: int) -> void:
	for ghost in childed_ghosts[index]:
		ghost.visible = false


func enable_ghost_objects() -> void:
	for ghosts in childed_ghosts:
		for ghost in ghosts:
			ghost.visible = true


func remove_all_objects() -> void:
	for objects in childed_objects:
		combining_and_removing_functions.remove_all_objects_in_array(self, objects)
	enable_ghost_objects()
	reset_child_arrays()
	

func reset_child_arrays() -> void:
	for objects in childed_objects:
		objects.clear()
