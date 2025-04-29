extends CenterContainer


@export var center_min_radius: float = 1.0
@export var center_vw_radius: float = 1.0
@export var outline_radius_multiple: float = 2.0
@export var center_color: Color = Color.WHITE
@export var outline_color: Color = Color.BLACK


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var vw: float = get_viewport().size.x / 100.0
	var center_radius: float = max(center_min_radius, vw * center_vw_radius)
	var outline_radius: float = center_radius * outline_radius_multiple
	draw_circle(Vector2(0, 0), outline_radius, outline_color)
	draw_circle(Vector2(0, 0), center_radius, center_color)
