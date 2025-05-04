class_name SodaMachine extends Node3D


enum Liquid {
	WATER = 0,
	LEAN = 1,
	COLA = 2
}


@export var liquid_materials: Array[Material] = []

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
	var liquid_material: Material = get_liquid_material(liquid)
	for obj in in_machine:
		if obj.has_method("do_fill"):
			obj.do_fill(liquid_material)
	
	$Particles.spray_particles(liquid_material)
	$PourAudioPlayer.fade_in()
	$PourAudioPlayer.play()
	
	await get_tree().create_timer(1).timeout
	$PourAudioPlayer.fade_out()


func on_body_entered(object: Node3D):
	in_machine.append(object)


func on_body_exited(object: Node3D):
	in_machine.erase(object)
