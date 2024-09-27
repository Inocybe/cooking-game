extends Holdable

@export var food_type: Menu.Item
@export var combine_range: Area3D

var childed_objects: Array[Node3D]

var game_manager: Node


func _ready() -> void:
	super()
	# connecting signal
	combine_range.connect("body_entered", _on_body_entered)
	
	# get game manager
	game_manager = Global.game_manager


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("food"):
		if body.has_method("get_food_type"):
			if food_type == body.get_food_type():
				combine_objects(body)


func combine_objects(body: Node) -> void: 
	add_child(body)
	
	# get collider to disable it
	var collider: CollisionShape3D = body.get_node_or_null("CollisionShape3D")
	collider.disabled = true
	body.collision_layer = 0
	body.collision_mask = 0
	
	
	# unhold the object
	# this code is the most awful thing I feel I have ever written
	if game_manager.player.camera.selected_object:
		game_manager.player.camera.drop_selected()
	
	# set positoin to the center of objectd
	body.global_position = global_position
	body.global_rotation = global_rotation
	
