@tool
extends PathFollow3D


var last_pos: Vector3

@export var speed: float = 5

var animator: AnimationPlayer


func _ready() -> void:
	animator = $Model.get_node("AnimationPlayer")
	animator.animation_finished.connect(start_flap)
	start_flap()


func start_flap(_s=null) -> void:
	animator.play("ArmatureAction")


func _process(delta: float) -> void:
	var parent = get_parent()
	if parent is not Path3D:
		return
	
	progress += delta * speed
	
	var curve: Curve3D = parent.curve
	var up_vector: Vector3 = curve.sample_baked_up_vector(progress, true)
	var offset: Vector3 = position - last_pos
	if not offset.is_zero_approx():
		look_at(position + offset, up_vector)
	
	last_pos = position
	
	if is_equal_approx(progress_ratio, 1):
		if Engine.is_editor_hint():
			progress = 0
		else:
			queue_free()
