extends Node3D


func _process(delta: float) -> void:
	var player: CharacterBody3D = Global.game_manager.player
	look_at(player.global_transform.origin, Vector3(0, 1, 0))
