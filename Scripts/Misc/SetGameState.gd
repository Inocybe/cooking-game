extends Node


@export var game_state: Global.GameState


func _process(_delta: float) -> void:
	Global.set_game_state(game_state)
	queue_free()
