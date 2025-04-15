class_name TownManager extends Node


var towns: Dictionary[int, String] = {
	0: "res://Scenes/towns/town_1.tscn"
}

func _ready() -> void:
	for i in towns.size():
		ResourceLoader.load_threaded_request(towns[i])


func load_town(town: int) -> void:
	var town_scene: PackedScene = ResourceLoader.load_threaded_get(towns[town])
	var instance: Node3D = town_scene.instantiate()
	get_tree().current_scene.add_child(instance)
