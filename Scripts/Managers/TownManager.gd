extends Node


var towns: Dictionary[int, String] = {
	0: "res://Scenes/towns/town_1.tscn"
}

func _ready() -> void:
	call_deferred("instantiate_town", 0)


func instantiate_town(town: int) -> void:
	var scene = ResourceLoader.load(towns[town])
	
