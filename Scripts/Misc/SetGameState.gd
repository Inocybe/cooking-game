extends Node


@export var game_state: Global.GameState


func _ready() -> void:
	Global.set_game_state(game_state)
