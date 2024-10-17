extends StaticBody3D


signal on_click(Node3D)


func on_start_interact() -> void:
	on_click.emit(self)
