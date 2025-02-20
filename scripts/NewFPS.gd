extends KinematicBody

var speed = 3 # or 5 for main scene
var mouse_senstivity = 0.30
var direction = Vector3()
var h_acceleration = 6
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
var gravity = 40
var jump = 5
onready var head = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)       #MOUSE_MODE_CAPTURED

func _input(event):
	#if event is InputEventScreenDrag:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_senstivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_senstivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	
	direction = Vector3()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
	else:
		gravity_vec = -get_floor_normal() * gravity
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z

	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
		
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
