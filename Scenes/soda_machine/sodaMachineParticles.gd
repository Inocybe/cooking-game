extends Node3D

var children: Array[Node] = []

func _ready() -> void:
	children = self.get_children()
	set_particles()

func set_particles():
	for child in children:
		#child.set_mesh()
		pass
