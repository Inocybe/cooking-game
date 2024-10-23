class_name GameManager extends Node


const PLAYER_SCENE = preload("res://Scenes/player/player.tscn")
var player: Player = null


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	instantate_player()


func instantate_player() -> void:
	player = PLAYER_SCENE.instantiate()
	add_child(player)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
