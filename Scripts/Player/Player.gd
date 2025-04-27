class_name Player extends CharacterBody3D


@export var max_speed = 5.0
@export var vr_max_speed = 3.0
@export var acceleration = 20.0
@export_range(0, 1) var AIR_CONTROL = 0.4
@export var JUMP_VELOCITY = 3.5

@onready var head: Node3D = %Head
@onready var camera: PlayerCamera = %Camera3D
@onready var debug_display: DebugDisplay = %DebugDisplay
@onready var feet: Node3D = %Feet

var is_right_mouse_down := false


signal movement()

signal look_around()


func _ready() -> void:
	Global.notify_has_XR(on_has_XR_detected)


func on_has_XR_detected(has_XR: bool) -> void:
	if has_XR:
		max_speed = vr_max_speed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("interact"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click_right"):
		is_right_mouse_down = true
		
	if event.is_action_released("click_right"):
		is_right_mouse_down = false
	
	if event is InputEventMouseMotion:
		var mouse_delta: Vector2 = event.relative
		if not mouse_delta.is_zero_approx():
			look_around.emit()
		
		var sensitivity: float = SettingsManager.mouse_sensitivity * 0.0002
		rotate_y(-mouse_delta.x * sensitivity)
		head.rotate_x(-mouse_delta.y * sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	
	var is_on_floor_now: bool = is_on_floor()
	if Input.is_action_pressed("jump") and is_on_floor_now:
		velocity.y = JUMP_VELOCITY
	
	var local_dir2d: Vector2 = Global.game_manager.get_xy_input()
	var local_dir3d: Vector3 = Vector3(local_dir2d.x, 0, local_dir2d.y)
	var dir3d: Vector3 = (transform.basis * local_dir3d).normalized()
	
	var traction: float = acceleration
	var target_vel2d: Vector2
	if dir3d.is_zero_approx():
		target_vel2d = Vector2(0, 0)
		if not is_on_floor_now:
			traction = 0
	else:
		movement.emit()
		target_vel2d = Vector2(dir3d.x, dir3d.z) * max_speed
		if not is_on_floor_now:
			traction *= AIR_CONTROL
	
	var vel2d = Vector2(velocity.x, velocity.z)
	
	vel2d = vel2d.move_toward(target_vel2d, traction * delta)
	
	velocity.x = vel2d.x
	velocity.z = vel2d.y
	
	move_and_slide()
