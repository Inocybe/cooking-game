extends CharacterBody3D


const MAX_SPEED = 5.0
const ACCELERATION = 20.0
const AIR_CONTROL = 0.4
const JUMP_VELOCITY = 3.5
const SENSITIVITY = 0.005

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var game_manager = null

var is_right_mouse_down := false
var prev_mouse_position := Vector2(0, 0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click_right"):
		is_right_mouse_down = true
		
	if event.is_action_released("click_right"):
		is_right_mouse_down = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_position = get_viewport().get_mouse_position()
		
		var mouse_delta = mouse_position - prev_mouse_position
		
		if is_right_mouse_down:
			rotate_y(-mouse_delta.x * SENSITIVITY)
			head.rotate_x(-mouse_delta.y * SENSITIVITY)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
		prev_mouse_position = mouse_position


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var local_dir2d: Vector2 = Input.get_vector("left", "right", "forward", "back")
	var dir3d: Vector3 = (transform.basis * Vector3(local_dir2d.x, 0, local_dir2d.y)).normalized()
	
	var target_vel2d: Vector2
	if dir3d:
		target_vel2d = Vector2(dir3d.x, dir3d.z) * MAX_SPEED
	else:
		target_vel2d = Vector2(0, 0)
	
	var traction: float = ACCELERATION
	if not is_on_floor():
		traction *= AIR_CONTROL
	
	var vel2d = Vector2(velocity.x, velocity.z)
	
	vel2d = vel2d.move_toward(target_vel2d, traction * delta)
	
	velocity.x = vel2d.x
	velocity.z = vel2d.y

	move_and_slide()
