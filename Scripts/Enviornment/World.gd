extends Node3D


func _ready() -> void:
	if Global.town != null:
		Global.game_manager.town_manager.load_town(Global.town.town_int)
