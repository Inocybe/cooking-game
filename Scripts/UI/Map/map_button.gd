extends Button

const SCENE_ATTACHED: String = "res://Scenes/mains/world.tscn"

@onready var resource: town = town.new()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: TextEdit = $TextEdit

var displaying: bool = false

func start() -> void:
	resource.random_everything()
	set_town_values()


func _on_pressed() -> void:
	print("pressed")
	if !displaying:
		displaying = true
		animation_player.play("display_town_values")
	else:
		displaying = false
		Global.switch_scenes(SCENE_ATTACHED)



func set_town_values() -> void:
	label.set_line(0, "Weather: " + str(resource.weather))
	label.set_line(1, "Tempurature: " + str(resource.tempurature) + "°C")
	label.set_line(2, "Population: " + str(resource.population))
	
	
