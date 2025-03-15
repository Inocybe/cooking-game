extends Area3D


func body_exit(node: Node3D):
	if node is Dish and not node.freeze:
		Global.order_manager.remove_order(node)
		node.queue_free()
