extends Holdable


@export var min_temperature: float
@export var min_rotation: float
@export var max_temperature: float
@export var max_rotation: float
@export var rot_speed: float = 80

var monitoring: Cookable = null


func _ready() -> void:
	super()
	$ProbeArea.body_entered.connect(start_monitoring)
	$ProbeArea.body_exited.connect(stop_monitoring)


func start_monitoring(body: Node3D) -> void:
	var cookable = body.get_node_or_null("Cookable")
	if cookable != null:
		monitoring = cookable


func stop_monitoring(body: Node3D) -> void:
	var cookable = body.get_node_or_null("Cookable")
	if cookable == monitoring:
		monitoring = null


func _process(delta: float) -> void:
	var temp_ratio: float = 0
	if monitoring != null:
		var temperature = monitoring.get_temperature()
		var shown_temperature = clampf(temperature, min_temperature, max_temperature)
		temp_ratio = (shown_temperature - min_temperature) / (max_temperature - min_temperature)
	var angle_deg = min_rotation + temp_ratio * (max_rotation - min_rotation)
	var current_rot = %NeedleRotationPoint.global_rotation_degrees
	var new_rot = move_toward(current_rot, angle_deg, delta * rot_speed)
	%NeedleRotationPoint.global_rotation_degrees = new_rot
