class_name SnowArea extends Node3D


func set_snowiness(snowiness: float) -> void:
	$GPUParticles3D.amount_ratio = snowiness
