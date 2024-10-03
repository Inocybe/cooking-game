extends Node3D

var inside_machine: Array[Node3D] = []
var drink_index: int = 0
@export var drinks: Array[StandardMaterial3D]

func update_drink() -> void:
	$"LeftButton/Mesh".set_material(current_drink())

func _ready() -> void:
	$LeftButton.on_click.connect(left_button_clicked)
	$RightButton.on_click.connect(right_button_clicked)
	
	$"Cup Fill Area".body_entered.connect(on_body_entered)
	$"Cup Fill Area".body_exited.connect(on_body_exited)
	
	update_drink()

func current_drink() -> StandardMaterial3D:
	return drinks[drink_index % 3]

func left_button_clicked():
	drink_index += 1
	update_drink()

func right_button_clicked():
	for obj in inside_machine:
		if obj.has_method("do_fill"):
			obj.do_fill(current_drink())

func on_body_entered(body: Node3D):
	print("body entered")
	inside_machine.append(body)
	
func on_body_exited(body: Node3D):
	print("body exited")
	inside_machine.erase(body)
