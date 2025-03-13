extends Node3D


var children: Array[Node] = []


func _ready() -> void:
	children = self.get_children()

func spray_particles(material: Material):
	for child in children:
		child.get_mesh().set_material(material)
		child.restart()
