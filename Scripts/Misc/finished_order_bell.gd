extends Node3D


var game_manager: GameManager = null
var food_truck: Node3D = null


func _read() -> void:
	game_manager = Global.game_manager
	if game_manager:
		food_truck = game_manager.food_truck


func on_start_interact() -> void:
	pass
