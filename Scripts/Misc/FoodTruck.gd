extends Node3D



@export var dish_positions: Array[Node3D]
var order_manager: OrderManager
var orders: Array[Node3D]


@onready var ordering_position: Node3D = $"OrderingPosition"




func _ready() -> void:
	order_manager = Global.order_manager

func add_order() -> void:
	for pos in dish_positions:
		if pos.get_child_count() == 0:
			var order: Node3D = order_manager.new_order()
			orders.append(order)
			order.reparent(pos)
			order.global_position = pos.global_position
			order.global_rotation = pos.global_rotation
			
			return


func remove_completed_orders() -> void:
	for order in orders:
		
		if order.has_method("is_order_complete"):
			if order.is_order_complete():
				print("made it here")
				orders.erase(order)
				order.free()


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_G):
		add_order()
