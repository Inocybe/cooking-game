extends Area3D


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)


func _on_body_entered(body: Node3D):
	if body is Customer:
		body.is_in_order_hitbox = true


func _on_body_exited(body: Node3D):
	if body is Customer:
		body.is_in_order_hitbox = false
