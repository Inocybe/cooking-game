class_name SodaMachine extends Node3D


enum Liquid {
	WATER = 0,
	LEAN = 1,
	COLA = 2
}


@export var liquid_materials: Array[StandardMaterial3D] = []

var in_machine: Array[Node3D] = []


func get_liquid_material(liquid: Liquid):
	return liquid_materials[liquid]


func _ready() -> void:
	$"Cup Fill Area".body_entered.connect(on_body_entered)
	$"Cup Fill Area".body_exited.connect(on_body_exited)
	$WaterButton.on_click.connect(button_pressed)
	$LeanButton.on_click.connect(button_pressed)
	$ColaButton.on_click.connect(button_pressed)


func button_pressed(liquid: Liquid):
	var liquid_material: StandardMaterial3D = get_liquid_material(liquid)
	for obj in in_machine:
		if obj.has_method("do_fill"):
			obj.do_fill(liquid_material)
	$Particles.set_particles(liquid_material)


func on_body_entered(object: Node3D):
	in_machine.append(object)


func on_body_exited(object: Node3D):
	in_machine.erase(object)
