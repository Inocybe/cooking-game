extends Node


const PLAYER_SCENE = preload("res://Scenes/player/player.tscn")
var player : CharacterBody3D = null


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	instantate_player()


func instantate_player() -> void:
	player = PLAYER_SCENE.instantiate()
	add_child(player)
	player.game_manager = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
