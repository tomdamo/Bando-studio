extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var health = 9
@onready var blood = %BloodEffect
@onready var bloodTimer = %BloodTimer

func _ready():
	pass


func _physics_process(delta):
	#TODO make the npc runaway if they see you?
	pass

func take_damage(damage):
	print("Damage taken")
	print(damage)	
	bloodTimer.start()
	blood.show() 
	health -= damage
	if health <= 0:
		die()

func die():
	print("im ded")
	self.rotation_degrees.x = 90
	self.position.y = 0 
	pass


func _on_blood_timer_timeout():
	blood.hide()
