extends Node3D


var children: Array[Node] = []


func _ready() -> void:
	children = self.get_children()

func set_particles(material: StandardMaterial3D):
	for child in children:
		child.get_mesh().set_material(material)
		child.restart()
