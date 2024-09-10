extends Node

var is_game_paused = false
var player_input_enabled = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pause_game() -> void:
	is_game_paused = true
	get_tree().paused = true
	
func resume_game() -> void:
	is_game_paused = false
	get_tree().paused = false
