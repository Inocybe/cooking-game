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

func return_holdable_inside_me() -> Node3D:
	for object in objects:
		if object.is_in_group("holdable"):
			return object
	return null
