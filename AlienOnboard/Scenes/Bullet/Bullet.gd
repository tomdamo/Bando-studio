extends Node3D

var speed = 100
var direction = Vector3.ZERO
# @onready var bulletRaycast = %BulletRaycast	
@onready var Hitarea = $HitArea
# Called when the node enters the scene tree for the first time.
@onready var bullet_life_timer = $BulletLifeTimer

func _ready():
	bullet_life_timer.start() 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin += direction * speed * delta
	
	# bulletRaycast.force_raycast_update()
	# if bulletRaycast.is_colliding():
	# 	var collider = bulletRaycast.get_collider()
	# 	print(collider.name)
	# 	if "Player" in collider.name:
	# 		collider.take_damage(1)  
	# 		queue_free()  # Destroy the bullet


func _on_hit_area_body_entered(body):
	print(body.name)
	if "Player" in body.name:
		body.take_damage(1)  
		queue_free()  # Destroy the bullet
	# destroy bullet if it hits walls
	if "Body" in body.name:
		queue_free()  # Destroy the bullet


func _on_bullet_life_timer_timeout():
	queue_free()  # Destroy the bullet
