extends Node


const PLAYER_SCENE = preload("res://Scenes/player/player.tscn")
var player : CharacterBody3D = null

var selected_object = null


func _ready() -> void:
	set_process_input(true)
	instantate_player()


func instantate_player() -> void:
	player = PLAYER_SCENE.instantiate()
	add_child(player)
	player.game_manager = self
	player.camera.mouse_raycast.connect(handle_interaction)


# Kinda hard coded ngl, but basically when mouse up, calls the objects function of not interact
# selected object can assume to have the function on_stop_interact() because will just add to every
# object we want an interaction too
func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		if selected_object != null:
			selected_object.on_stop_interact()
		selected_object = null


func handle_interaction(raycast_result: Dictionary) -> void:
	if raycast_result and raycast_result.collider.is_in_group("interactable"):
		selected_object = raycast_result.collider
		if selected_object.has_method("on_interact"):
			selected_object.on_interact()
