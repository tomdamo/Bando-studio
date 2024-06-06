extends Node3D

var speed = 3
var direction = Vector3.UP

@onready var damage_label = %damageLabel
@onready var damagetext_timer = %damagetextTimer


func _ready():
	print("damage instantiatedd")
	damagetext_timer = %damagetextTimer
	damagetext_timer.start()

func _process(delta):
	global_transform.origin += direction * speed * delta




func set_damage(damage):
	damage_label.text = str(damage)


func _on_damagetext_timer_timeout():
	queue_free()
