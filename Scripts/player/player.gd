extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
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
		var mouse_position : Vector2 = get_viewport().get_mouse_position()
		
		var mouse_delta : Vector2 = mouse_position - prev_mouse_position
		
		if is_right_mouse_down:
			rotate_y(-mouse_delta.x * SENSITIVITY)
			head.rotate_x(-mouse_delta.y * SENSITIVITY)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
		prev_mouse_position = mouse_position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
