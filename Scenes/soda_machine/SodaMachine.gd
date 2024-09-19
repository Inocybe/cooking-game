extends Node3D


func _ready() -> void:
	$LeftButton.on_click.connect(left_button_clicked)
	$RightButton.on_click.connect(right_button_clicked)


func left_button_clicked():
	pass


func right_button_clicked():
	pass
