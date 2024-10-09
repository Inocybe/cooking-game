extends Node3D

var in_machine: Array[Node3D] = []

func _ready() -> void:
	$"Cup Fill Area".body_entered.connect(on_body_entered)
	$"Cup Fill Area".body_exited.connect(on_body_exited)
	$WaterButton.on_click.connect(ButtonPressed)
	$LeanButton.on_click.connect(ButtonPressed)
	$ColaButton.on_click.connect(ButtonPressed)

func ButtonPressed(button_node: Node3D):
	var button_material = button_node.get_child(0).get_mesh().get_material()
	for obj in in_machine:
		if obj.has_method("do_fill"):
			obj.do_fill(button_material)

func on_body_entered(object: Node3D):
	in_machine.append(object)

func on_body_exited(object: Node3D):
	in_machine.erase(object)
