@tool
class_name MapButton extends Control


signal world_load_requested()


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: RichTextLabel = %Text

@export var town: TownResource
@export var position_fraction: Vector2

var town_values_shown: bool = false


func _ready() -> void:
	get_parent().resized.connect(reposition)
	reposition()
	
	$Button.pressed.connect(on_button_pressed)
	$Button.text = " "+town.name+" "


func init_town() -> void:
	town.random_weather()
	show_town_values()


func reposition() -> void:
	position = position_fraction * get_parent().size


func on_button_pressed() -> void:
	if town_values_shown:
		town_values_shown = false
		Global.town = town
		
		world_load_requested.emit()
	else:
		town_values_shown = true
		animation_player.play("display_town_values")


func show_town_values() -> void:
	var weather_name = WeatherManager.get_weather_name(town.weather)
	label.text = """Weather: %s
Temperature: %.2f°C
Population: %d
Opening hours: %.f hours""" % [
		weather_name, town.temperature, town.population, town.opening_hours
	]
