extends CharacterBody3D

@export var speed = 6
@export var gravity = 32

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# Set the desired backward velocity directly
	target_velocity.x = -10  # Move 10 meters backward

	# Apply speed and gravity
	target_velocity.x = target_velocity.x * speed
	target_velocity.y = target_velocity.y * speed

	# Move and slide
	velocity = target_velocity
	move_and_slide()
