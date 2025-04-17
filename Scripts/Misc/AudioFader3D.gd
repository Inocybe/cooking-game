class_name AudioFader3D extends AudioStreamPlayer3D


@export var fade_in_time: float = 0.1
@export var fade_out_time: float = 0.4

var initiated: bool = false
var is_audible: bool = false
var full_volume: float


func _ready() -> void:
	if not initiated:
		init()


func fade_in() -> void:
	if not initiated:
		init()
	if is_audible:
		return
	if not get_tree():
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_linear", full_volume, fade_in_time)
	is_audible = true


func fade_out() -> void:
	if not initiated:
		init()
	if not is_audible:
		return
	if not get_tree():
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_linear", 0, fade_out_time)
	is_audible = false


func init() -> void:
	initiated = true
	full_volume = volume_linear
	volume_linear = 0
