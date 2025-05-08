class_name SunManager extends Node3D


@export var angle_at_end: float = -15

@export var degrees_per_minute: float = 0.12


func _process(_delta: float) -> void:
	rotation_degrees.x = angle_at_end - (
		degrees_per_minute * Global.game_manager.time_remaining
	)


func set_brightness(energy: float) -> void:
	if $LightSun != null:
		$LightSun.light_energy = energy
