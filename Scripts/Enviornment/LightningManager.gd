class_name LightningManager extends Node


@export var spawn_range: Rect2

var spawn_chance: float = 0

const BOLT = preload("res://Scenes/environment/lightning_bolt.tscn")


func maybe_spawn_lightning() -> void:
	if randf() > spawn_chance:
		return
	
	var bolt = BOLT.instantiate()
	
	bolt.position = Vector3(
		randf_range(spawn_range.position.x, spawn_range.end.x),
		0,
		randf_range(spawn_range.position.y, spawn_range.end.y)
	)
	
	add_child(bolt)


func set_lightning_chance(chance: float) -> void:
	spawn_chance = chance
