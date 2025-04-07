class_name RainArea extends Node3D


func set_raininess(raininess: float) -> void:
	$GPUParticles3D.amount_ratio = raininess
