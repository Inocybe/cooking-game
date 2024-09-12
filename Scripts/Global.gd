extends Node


var player_input_enabled = true


func _ready() -> void:
	pass


func pause_game() -> void:
	get_tree().paused = true

	
func resume_game() -> void:
	get_tree().paused = false
