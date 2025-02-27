extends StaticBody3D


@onready var ui3d: UIController = $UI3D


func do_interact_at(pos: Vector3) -> void:
	ui3d.do_interact_at(pos)
