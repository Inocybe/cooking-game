class_name TownManager extends Node


const MINUTES_PER_HOUR = 60


var town_scene_paths: Dictionary[int, String] = {
	0: "res://Scenes/towns/town_1.tscn",
	1: "res://Scenes/towns/town_2.tscn",
	2: "res://Scenes/towns/town_3.tscn"
}


func load_town(town: TownResource) -> void:
	Global.game_manager.weather_manager.set_from_town(town)
	
	Global.game_manager.time_remaining = town.opening_hours * MINUTES_PER_HOUR
	
	var path = town_scene_paths[town.town_int]
	ResourceLoader.load_threaded_request(path, "", true)
	var town_scene: PackedScene = ResourceLoader.load_threaded_get(path)
	var instance: Node3D = town_scene.instantiate()
	get_tree().current_scene.add_child.call_deferred(instance)
