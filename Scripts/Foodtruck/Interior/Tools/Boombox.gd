extends Node3D


@export var muted_material: Material
@export var audible_material: Material

@export var indicator_material_idx: int

var is_muted: bool = false


func _ready() -> void:
	show_is_mute()


func on_start_interact() -> void:
	is_muted = not is_muted
	if is_muted:
		$MusicManager.stop_music()
	else:
		$MusicManager.play_next()
	show_is_mute()


func show_is_mute() -> void:
	$MeshInstance3D.set_surface_override_material(
		indicator_material_idx,
		muted_material if is_muted else audible_material
	)
