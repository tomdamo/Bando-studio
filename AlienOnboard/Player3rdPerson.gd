extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DASH_SPEED = 17.0
const DASH_TIME = 0.2

var dashing = false
var dash_direction = Vector3.ZERO
var dash_timer = 0.0

@onready var pivot = $CamOrigin
@export var sens = 0.5
@onready var dash_cooldown_timer = $DashCooldownTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Quit game on ESC, debug purposes.
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	# Space to dash
	if Input.is_action_just_pressed("dash") and not dashing and dash_cooldown_timer.is_stopped():
		dash_direction = direction
		dashing = true
		dash_timer = DASH_TIME
		dash_cooldown_timer.start()

	if dashing:
		velocity = dash_direction * DASH_SPEED
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false

	else:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
