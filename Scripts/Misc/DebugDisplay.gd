class_name DebugDisplay extends CanvasItem


class ScreenRay:
	var from: Vector2
	var to: Vector2
	var color: Color
	var width: float
	
	func _init(from: Vector2, to: Vector2, color: Color, width: float) -> void:
		self.from = from
		self.to = to
		self.color = color
		self.width = width


var rays: Array[ScreenRay] = []


func add_ray(from: Vector2, to: Vector2, color: Color, width: float):
	rays.append(ScreenRay.new(from, to, color, width))


func _draw() -> void:
	for ray in rays:
		draw_line(ray.from, ray.to, ray.color, ray.width)
	rays.clear()


func _process(_delta):
	queue_redraw()
