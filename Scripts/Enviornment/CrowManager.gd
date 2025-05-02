extends Node3D


const CROW = preload("res://Scenes/environment/crow.tscn")

@export var paths: Array[Path3D]


func _ready() -> void:
	add_new_crow.call_deferred()


func add_new_crow() -> void:
	var crow = CROW.instantiate()
	paths.pick_random().add_child(crow)
