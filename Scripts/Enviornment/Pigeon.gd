extends Node3D


@export var min_peck_interval: float = 3
@export var max_peck_interval: float = 8
@export var movement_time: float = 0.5
@export var rotate_time: float = 0.1

var animator: AnimationPlayer

var movement_tween: Tween
var moving: bool = false


func _ready() -> void:
	animator = $Model.get_node("AnimationPlayer")
	start_action_timer()


func start_action_timer() -> void:
	$ActionTimer.start(randf_range(min_peck_interval, max_peck_interval))


func do_action() -> void:
	if not moving:
		animator.play("PeckAction")
	start_action_timer()


func walk_to(point: Vector3) -> void:
	moving = true
	point = Vector3(point.x, global_position.y, point.z)
	
	var offset: Vector3 = point - global_position
	var target_y: float = atan2(offset.x, offset.z)
	var target_rot: Vector3 = Vector3(0, target_y, 0)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_rotation", target_rot, rotate_time)
	tween.tween_property(self, "global_position", point, movement_time)
	tween.finished.connect(func(): moving = false)


func obj_enter_notice_area(obj: Node3D) -> void:
	if obj is Customer and not moving:
		var target: Vector3 = 2 * global_position - obj.global_position
		walk_to(target)
