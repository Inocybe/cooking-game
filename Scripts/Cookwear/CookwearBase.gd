class_name CookwearBase extends StaticBody3D


@export var cooking_area: Area3D = null

func _ready() -> void:
	if cooking_area:
		cooking_area.body_entered.connect(on_body_entered)
		cooking_area.body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D):
	if body.has_method("on_start_cooking"):
		body.on_start_cooking()


func on_body_exited(body: Node3D):
	if body.has_method("on_stop_cooking"):
		body.on_stop_cooking()
