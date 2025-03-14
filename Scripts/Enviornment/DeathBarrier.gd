extends Area3D


var dishes_to_check: Array[Node3D] = []


func body_exit(node: Node3D):
	if node is Dish:
		dishes_to_check.append(node)


func _process(_delta: float) -> void:
	for dish in dishes_to_check:
		if not overlaps_body(dish):
			Global.order_manager.remove_order(dish)
			dish.queue_free()
