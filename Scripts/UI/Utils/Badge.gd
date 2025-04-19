extends Control


const BORDER_RADIUS = 1000

@onready var btn: Button = $Button
@onready var font_scaler: FontScaler = $Button/FontScaler

@export var text: String
@export var bg_color: Color = Color.ORANGE
@export var hover_bg_color: Color = Color.DARK_ORANGE
@export var pressed_bg_color: Color = Color.DARK_GOLDENROD
@export var text_color: Color = Color.WHITE
@export var font_scale: float = 0.75
@export var clickable: bool = false


signal pressed()


func _ready() -> void:
	btn.resized.connect(button_resize)
	button_resize()
	btn.pressed.connect(pressed.emit)
	
	update_badge()


func button_resize() -> void:
	btn.custom_minimum_size.x = btn.size.y


func update_badge() -> void:
	var normal_box: StyleBoxFlat = StyleBoxFlat.new()
	normal_box.bg_color = bg_color
	normal_box.corner_radius_top_left = BORDER_RADIUS
	normal_box.corner_radius_top_right = BORDER_RADIUS
	normal_box.corner_radius_bottom_left = BORDER_RADIUS
	normal_box.corner_radius_bottom_right = BORDER_RADIUS
	btn.add_theme_stylebox_override("normal", normal_box)
	
	var hover_box: StyleBoxFlat = normal_box.duplicate()
	hover_box.bg_color = hover_bg_color
	btn.add_theme_stylebox_override("hover", hover_box)
	
	var pressed_box: StyleBoxFlat = hover_box.duplicate()
	pressed_box.bg_color = pressed_bg_color
	btn.add_theme_stylebox_override("pressed", pressed_box)
	btn.add_theme_stylebox_override("hover_pressed", pressed_box)
	
	btn.add_theme_color_override("font_color", text_color)
	btn.text = text
	font_scaler.font_scale = font_scale
	font_scaler.update_font_size()
	
	mouse_filter = MOUSE_FILTER_STOP if clickable else MOUSE_FILTER_IGNORE
	btn.mouse_filter = mouse_filter
