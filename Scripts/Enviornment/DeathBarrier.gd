extends Area3D


func body_exit(node: Node3D):
	if node is Dish:
		node.queue_free()
	# TODO: add removal from list of active orders
