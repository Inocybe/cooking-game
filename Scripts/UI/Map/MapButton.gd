@tool
class_name MapButton extends Control


signal world_load_requested()

const ICON = preload("res://Scenes/ui/icon.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: RichTextLabel = %Text

# FORCAST BUTTONS
@onready var button_1: Button = $TextHolder/PanelContainer/VBoxContainer/DaySelectionButtons/Button
@onready var button_2: Button = $TextHolder/PanelContainer/VBoxContainer/DaySelectionButtons/Button2
@onready var button_3: Button = $TextHolder/PanelContainer/VBoxContainer/DaySelectionButtons/Button3


@export var town: TownResource
@export var position_fraction: Vector2

var town_values_shown: bool = false
var icons: Array[Control]

func _ready() -> void:
	get_parent().resized.connect(reposition)
	reposition()
	
	button_1.connect("button_down", show_town_values.bind(0))
	button_2.connect("button_down", show_town_values.bind(1))
	button_3.connect("button_down", show_town_values.bind(2))
	
	$Button.pressed.connect(on_button_pressed)
	$Button.text = " "+town.name+" "


func init_town() -> void:
	town.random_forcast(ProgressManager.day)
	show_town_values(0)


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



func show_town_values(day: int) -> void:
	var weather_name = WeatherManager.get_weather_name(town.weather_forcast[day])
	label.text = """Weather: %s
Temperature: %.2f°C
Population: %d
Opening hours: %.f hours""" % [
		weather_name, town.temp_forcast[day], town.population, town.opening_hours
	]
