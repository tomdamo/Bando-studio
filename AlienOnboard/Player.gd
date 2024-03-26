extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 20
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

#dashing
@export var dash_speed = 50  # Adjust the dash speed as needed
@export var dash_duration = 0.15  # Adjust the dash duration as needed
var target_velocity = Vector3.ZERO
var is_dashing = false
var dash_timer = 1

func _process(delta):
	handle_input(delta)
	update_dash(delta)

func handle_input(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()
		print("dashing")
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	if is_dashing:
		target_velocity.x = direction.x * dash_speed
		target_velocity.z = direction.z * dash_speed
	else:
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func start_dash():
	is_dashing = true
	dash_timer = dash_duration

func update_dash(delta):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
