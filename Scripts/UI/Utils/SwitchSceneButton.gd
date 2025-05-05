extends Button


@export var new_scene: String


func _ready() -> void:
	pressed.connect(on_pressed)


func on_pressed() -> void:
	get_tree().paused = false
	Global.switch_scenes_with_path(new_scene)
