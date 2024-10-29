class_name FoodBase extends CombinableBase


const FORCE_AMOUNT: float = 0.005

@export var food_type: Menu.Item
@export var food_component_type: Menu.FoodComponents
@export var combine_range: Area3D = null

var childed_objects: Array[Node3D] = []
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
	set_collider_and_state(child, true)
	

	# Drop the child object if it's currently selected
	game_manager.player.camera.drop_if_selected()

	# Align child's position and rotation with this node
	child.global_transform = global_transform
	
	# Add child to the list of childed objects
	childed_objects.append(child)


func remove_all_objects() -> void:
	remove_all_objects_in_array(childed_objects)
	childed_objects.clear()



func get_food_type() -> Menu.Item:
	return food_type


func get_food_component_type() -> Menu.FoodComponents:
	return food_component_type
