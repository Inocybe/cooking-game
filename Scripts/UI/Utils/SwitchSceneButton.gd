extends Button


@export var new_scene: PackedScene


func _ready() -> void:
	pressed.connect(on_pressed)


func on_pressed() -> void:
	Global.switch_scenes(new_scene)
