class_name Player extends CharacterBody3D


@export var max_speed = 5.0
@export var vr_max_speed = 3.0
@export var acceleration = 20.0
@export_range(0, 1) var AIR_CONTROL = 0.4
@export var JUMP_VELOCITY = 3.5
@export var sensitivity = 0.005
@export var vr_radius_multiplier = 0.4

@onready var head: Node3D = %Head
@onready var camera: Camera3D = %Camera3D
@onready var debug_display: DebugDisplay = %"Debug Display"
@onready var feet: Node3D = %Feet

var is_right_mouse_down := false


func _ready() -> void:
	Global.game_manager.XR_detected.connect(on_XR_detected)


func on_XR_detected() -> void:
	max_speed = vr_max_speed
	$CollisionShape3D.shape.radius *= vr_radius_multiplier

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click_right"):
		is_right_mouse_down = true
		
	if event.is_action_released("click_right"):
		is_right_mouse_down = false
	
	if event is InputEventMouseMotion:
		var mouse_delta: Vector2 = event.relative
		
		rotate_y(-mouse_delta.x * sensitivity * 0.01)
		head.rotate_x(-mouse_delta.y * sensitivity * 0.01)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	
	var is_on_floor_now: bool = is_on_floor()
	if Input.is_action_pressed("jump") and is_on_floor_now:
		velocity.y = JUMP_VELOCITY
	
	var local_dir2d: Vector2 = Global.game_manager.get_xy_input()
	var dir3d: Vector3 = (transform.basis * Vector3(local_dir2d.x, 0, local_dir2d.y)).normalized()
	
	var traction: float = acceleration
	var target_vel2d: Vector2
	if dir3d:
		target_vel2d = Vector2(dir3d.x, dir3d.z) * max_speed
		if not is_on_floor_now:
			traction *= AIR_CONTROL
	else:
		target_vel2d = Vector2(0, 0)
		if not is_on_floor_now:
			traction = 0
	
	var vel2d = Vector2(velocity.x, velocity.z)
	
	vel2d = vel2d.move_toward(target_vel2d, traction * delta)
	
	velocity.x = vel2d.x
	velocity.z = vel2d.y
	
	move_and_slide()
