extends Node


const PLAYER_SCENE = preload("res://Scenes/player/player.tscn")
var player = null

var selected_object = null


func _ready() -> void:
	set_process_input(true)
	instantate_player()
	


func instantate_player() -> void:
	player = PLAYER_SCENE.instantiate()
	add_child(player)
	player.game_manager = self
	player.camera.connect("mouse_raycast", handle_interaction)


func handle_interaction(raycast_result) -> void:
	if raycast_result and raycast_result.collider.is_in_group("interactable"):
		selected_object = raycast_result.collider
		if selected_object.has_method("on_interact"):
			selected_object.on_interact()
		else:
			selected_object = null
	else:
		selected_object = null
		
