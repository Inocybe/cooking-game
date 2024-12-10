extends StaticBody3D


@export var liquid: SodaMachine.Liquid


signal on_click


func on_start_interact() -> void:
	on_click.emit(liquid)
