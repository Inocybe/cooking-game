extends StaticBody3D


func _ready() -> void:
	$CookingArea.body_entered.connect(on_body_entered)
	$CookingArea.body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D):
	if body.has_method("on_start_cooking"):
		body.on_start_cooking()


func on_body_exited(body: Node3D):
	if body.has_method("on_stop_cooking"):
		body.on_stop_cooking()
