extends Area3D

var objects: Array[Node3D]

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
	
func _on_body_entered(body: Node3D) -> void:
	objects.append(body)

func _on_body_exited(body: Node3D) -> void:
	if objects.has(body):
		objects.erase(body)
