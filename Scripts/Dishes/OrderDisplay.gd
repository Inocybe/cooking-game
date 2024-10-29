extends Node3D

var player: CharacterBody3D = null

func _ready() -> void:
	player = Global.game_manager.player


func _process(delta: float) -> void:
	look_at(player.global_transform.origin, Vector3(0, 1, 0))
