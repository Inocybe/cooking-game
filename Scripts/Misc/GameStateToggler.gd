extends Node


enum HideMode {
	Destroy,
	Visibility
}


@export var enabled_with: Global.GameState
@export var hide_mode: HideMode = HideMode.Destroy


func _ready() -> void:
	Global.game_state_set.connect(on_game_state_set)


func on_game_state_set() -> void:
	if Global.game_state == enabled_with:
		if hide_mode == HideMode.Visibility:
			set("visible", true)
	else:
		if hide_mode == HideMode.Visibility:
			set("visible", false)
		elif hide_mode == HideMode.Destroy:
			queue_free()
		
