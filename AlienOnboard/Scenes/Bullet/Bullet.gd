extends Node3D

var speed = 60
var direction = Vector3.ZERO
@onready var Hitarea = $HitArea
# Called when the node enters the scene tree for the first time.
@onready var bullet_life_timer = $BulletLifeTimer

func _ready():
	bullet_life_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin += direction * speed * delta

func _on_hit_area_body_entered(body):
	print(body.name)
	if "Player" in body.name:
		body.take_damage(10)  
		queue_free() 
	# destroy bullet if it hits walls
	if "Body" in body.name:
		queue_free()


func _on_bullet_life_timer_timeout():
	queue_free()
