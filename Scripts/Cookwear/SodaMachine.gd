extends Node3D

var inside_machine: Array[Node3D] = []
var drink_index: int = 0
@export var drinks: Array[StandardMaterial3D]

signal change_color(material: StandardMaterial3D)

func _ready() -> void:
	$LeftButton.on_click.connect(left_button_clicked)
	$RightButton.on_click.connect(right_button_clicked)
	
	$"Cup Fill Area".body_entered.connect(on_body_entered)
	$"Cup Fill Area".body_exited.connect(on_body_exited)

func left_button_clicked():
	for obj in inside_machine:
		if obj.has_method("set_liquid"):
			obj.set_liquid(drinks[drink_index % 3])
			change_color.emit(drinks[drink_index % 3])
			drink_index += 1
			print("set liq")

func right_button_clicked():
	for obj in inside_machine:
		if obj.has_method("play_fill_animation"):
			obj.play_fill_animation()
			print("play fill")

func on_body_entered(body: Node3D):
	print("body entered")
	inside_machine.append(body)
	
func on_body_exited(body: Node3D):
	print("body exited")
	inside_machine.erase(body)
