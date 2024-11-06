class_name Dish extends CombinableBase

const GHOST_ORDER_CONTROLLER = preload("res://Scenes/orders/ghost_order_controller.tscn")

@export var food_positions: Array[Node3D]

var order: Array[Menu.Item]
var order_functions: OrderFunctions
var childed_ghosts: Array[Array] = [[], [], []]


func _ready() -> void:
	super()
	# Instantiate each item in the order
	for i in range(order.size()):
		for component in Menu.get_item_components(order[i]):
			var food = Menu.make_food_component_scene(component)
			childed_ghosts[i].append(food)
			combine_objects(food, i)
			add_ghost_order_controller(food)
			set_food_position_height(food, food_positions[i])


func combine_objects(child: Holdable, food_position: int) -> void:
	var parent = food_positions[food_position]
	
	parent.add_child(child)
	child.reparent(parent)
	
	set_dependance(child, true)
	child.global_transform = parent.global_transform


func add_ghost_order_controller(object: Node3D) -> void:
	var ghost_order_controller = GHOST_ORDER_CONTROLLER.instantiate()
	object.add_child(ghost_order_controller)


func check_order_and_add_object(body: Node3D) -> void:
	for i in range(childed_ghosts.size()):
		if children[i].size() == 0:
			for ghost in childed_ghosts[i]:
				if ghost.get_food_type() == body.get_food_type():
					combine_objects(body, i)
					children[i].append(body)
					disable_ghost_object(i)
					break


func disable_ghost_object(index: int) -> void:
	for ghost in childed_ghosts[index]:
		ghost.visible = false


func enable_ghost_objects() -> void:
	for ghosts in childed_ghosts:
		for ghost in ghosts:
			ghost.visible = true


func set_food_position_height(food: Node3D, food_position: Node3D) -> void:
	var collision: CollisionShape3D = food.get_node_or_null("CollisionShape3D")
	
	var collision_height: float = 0.0
	
	if collision.shape is BoxShape3D:
		var box_shape: BoxShape3D = collision.shape as BoxShape3D
		# Apply both the shape's size and mesh's scale for height
		collision_height = box_shape.size.y / 5
	elif collision.shape is CylinderShape3D:
		var cylinder_shape: CylinderShape3D = collision.shape as CylinderShape3D
		# Apply both the shape's height and mesh's scale for height
		collision_height = (cylinder_shape.get_height() / 2)
	
	# Adjust food position by the calculated height
	if food_position.position.y < collision_height:
		food_position.position.y = collision_height
