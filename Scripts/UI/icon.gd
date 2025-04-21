@tool
extends Control

@export var icon_location: String
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.texture
