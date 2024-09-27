extends MeshInstance3D

func _ready() -> void:
	get_parent().get_parent().change_color.connect(change_color)

func change_color(material: StandardMaterial3D):
	print("it works")
	# code works however not implemented
