extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var health = 3

func _physics_process(delta):
	#TODO make the npc runaway if they see you?
	pass

func take_damage(damage):
	print("Damage taken")
	print(damage)	
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
