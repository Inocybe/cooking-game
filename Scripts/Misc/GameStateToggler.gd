extends Node


@export var enabled_with: Global.GameState


func _ready() -> void:
	Global.game_state_set.connect(on_game_state_set)


func on_game_state_set() -> void:
	if Global.game_state != enabled_with:
		queue_free()
