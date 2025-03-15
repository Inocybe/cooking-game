extends Area3D


func body_exit(node: Node3D):
	if node is Dish and not node.freeze and not node.is_queued_for_deletion():
		Global.game_manager.order_manager.remove_order(node)
