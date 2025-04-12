extends Button

const SCENE_ATTACHED: String = "res://Scenes/mains/world.tscn"

@onready var resource: TownResource = TownResource.new()
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
	var weather_name = WeatherManager.get_weather_name(resource.weather)
	label.set_line(0, "Weather: " + weather_name)
	label.set_line(1, "Temperature: " + str(resource.temperature) + "°C")
	label.set_line(2, "Population: " + str(resource.population))
	
	
