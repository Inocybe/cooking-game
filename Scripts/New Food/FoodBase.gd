class_name FoodBase extends Holdable


const force_amount: float = 0.005

@export var food_type: Menu.Item
@export var combine_range: Area3D = null

var childed_objects: Array[Holdable]
var recently_removed_child: Array[Holdable]

var game_manager: Node = null



func _ready() -> void:
	super()
	# connecting signal
	if combine_range:
		combine_range.connect("body_entered", _on_body_entered)
		combine_range.connect("body_exited", _on_body_exited)
	
	game_manager = Global.game_manager


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_children") and childed_objects.size() > 0:
		remove_all_objects()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("food") and body != self:
		if body.has_method("get_food_type") and !recently_removed_child.has(body):
			if food_type == body.get_food_type():
				combine_objects(body)


func _on_body_exited(body: Node) -> void:
	if body in recently_removed_child:
		recently_removed_child.erase(body)


func combine_objects(child: Holdable) -> void: 
	child.reparent(self)
	
	# get collider to disable it
	var collider: CollisionShape3D = child.get_node_or_null("CollisionShape3D")
	collider.disabled = true
	child.collision_layer = 0
	child.collision_mask = 0
	
	#child.freeze_mode = FREEZE_MODE_STATIC
	child.freeze = true
	
	# unhold the object
	game_manager.player.camera.drop_if_selected()
	
	# set positoin to the center of objectd
	child.global_position = global_position
	child.global_rotation = global_rotation
	
	# add to list of children
	childed_objects.append(child)


func remove_all_objects() -> void:
	for child in childed_objects:
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
		
		
	childed_objects.clear()


func object_removed(object: Holdable) -> void:
	recently_removed_child.append(object)


func get_food_type() -> Menu.Item:
	return food_type
