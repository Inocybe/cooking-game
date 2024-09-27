extends Holdable


var childed_objects: Array[Node3D]


func _ready() -> void:
	super()
	# connecting signal
	connect("body_entered", _on_body_entered)


func _on_body_entered(body: Node) -> void:
	print(body)


func combine_objects(body: Node) -> void: 
	pass
