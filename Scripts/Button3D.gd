extends StaticBody3D


signal on_click()


func on_start_interact() -> void:
	on_click.emit()
