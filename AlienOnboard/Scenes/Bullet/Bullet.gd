extends Node3D

var speed = 100
var direction = Vector3.ZERO
@onready var bulletRaycast = %BulletRaycast
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin += direction * speed * delta
	
	bulletRaycast.force_raycast_update()
	if bulletRaycast.is_colliding():
		var collider = bulletRaycast.get_collider()
		print(collider.name)
		if "Player" in collider.name:
			collider.take_damage(1)  # Assuming the player has a take_damage function
			queue_free()  # Destroy the bullet
