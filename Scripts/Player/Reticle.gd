extends CenterContainer


@export var dot_min_radius: float = 1.0
@export var dot_vw_radius: float = 1.0
@export var dot_color: Color = Color.WHITE


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var vw: float = get_viewport().size.x / 100.0
	var radius: float = max(dot_min_radius, vw * dot_vw_radius)
	draw_circle(Vector2(0, 0), radius, dot_color)
