extends Node3D



@export var dish_positions: Array[Node3D]
var order_manager: OrderManager



func _ready() -> void:
	order_manager = Global.order_manager

func add_order() -> void:
	for pos in dish_positions:
		if pos.get_child_count() == 0:
			var order: Node3D = order_manager.new_order()
			order.reparent(pos)
			order.global_position = pos.global_position
			order.global_rotation = pos.global_rotation
			
			return

#func _input(event: InputEvent) -> void:
#	if Input.is_key_pressed(KEY_G):
#		add_order()
