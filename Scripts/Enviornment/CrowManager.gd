extends Node3D


const CROW = preload("res://Scenes/environment/crow.tscn")

@export var paths: Array[Path3D]


func _ready() -> void:
	add_new_crow.call_deferred()


func add_new_crow() -> void:
	var weather_type = Global.game_manager.weather_manager.weather_type
	if WeatherManager.get_raininess(weather_type) > 0:
		return
	
	var crow = CROW.instantiate()
	paths.pick_random().add_child(crow)
