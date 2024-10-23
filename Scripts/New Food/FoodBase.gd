class_name FoodBase extends Holdable

const FORCE_AMOUNT: float = 0.005

@export var food_type: Menu.Item
@export var food_component_type: Menu.FoodComponents
@export var combine_range: Area3D = null

var childed_objects: Array[Holdable] = []
var recently_removed_child: Array[Holdable] = []
var game_manager: Node = null

func _ready() -> void:
	super()
	# Connect combine range signals if present
	if combine_range:
		combine_range.connect("body_entered", _on_body_entered)
		combine_range.connect("body_exited", _on_body_exited)
	
	game_manager = Global.game_manager


func remove_children() -> void:
	# Remove children when "remove_children" is pressed
	if childed_objects.size() > 0:
		remove_all_objects()


func _on_body_entered(body: Node) -> void:
	# Ensure the body is a valid food object and can be combined
	if body.is_in_group("food") and body != self and not recently_removed_child.has(body):
		if body.has_method("get_food_type") and body.has_method("get_food_component_type"):
			if food_type == body.get_food_type() and food_component_type != body.get_food_component_type():
				combine_objects(body as Holdable)


func _on_body_exited(body: Node) -> void:
	# Remove the body from the recently removed list if it's no longer in range
	if body in recently_removed_child:
		recently_removed_child.erase(body)


func combine_objects(child: Holdable) -> void: 
	# Reparent the child under this node and disable its collider
	child.reparent(self)
	set_collider_state(child, true)
	
	child.freeze = true  # Freeze the child object

	# Drop the child object if it's currently selected
	game_manager.player.camera.drop_if_selected()

	# Align child's position and rotation with this node
	child.global_transform = global_transform
	
	# Add child to the list of childed objects
	childed_objects.append(child)


func remove_all_objects() -> void:
	for child in childed_objects:
		# Reparent the child back to the main scene and unfreeze it
		child.reparent(Global.current_scene)
		object_removed(child)

		child.freeze = false

		# Apply a random impulse to each child
		var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
		child.apply_impulse(Vector3(), random_direction * FORCE_AMOUNT)

		set_collider_state(child, false)

	# Clear the list of childed objects
	childed_objects.clear()


func object_removed(object: Holdable) -> void:
	# Keep track of recently removed objects
	recently_removed_child.append(object)


func set_collider_state(object: Holdable, disable: bool) -> void:
	# Enable/disable the collider of the object
	var collider: CollisionShape3D = object.get_node_or_null("CollisionShape3D")
	if collider:
		collider.disabled = disable

	# Update collision layers/masks based on the state
	if disable:
		object.collision_layer = 0
		object.collision_mask = 0
	else:
		object.collision_layer = 1
		object.collision_mask = 1


func get_food_type() -> Menu.Item:
	return food_type
	
func get_food_component_type() -> Menu.FoodComponents:
	return food_component_type
