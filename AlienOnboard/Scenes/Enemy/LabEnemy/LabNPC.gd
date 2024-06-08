extends CharacterBody3D


const SPEED = 5.0
const GRAVITY = -9.8
var health = 6
var death = false
@onready var blood = %BloodEffect
@onready var bloodTimer = %BloodTimer
@onready var hit_effect_3 = %HitEffect3

@onready var VisionArea = %VisionArea
@onready var VisionRaycast = %VisionRaycast
@onready var VisionTimer = %VisionTimer
@onready var spotted_label = $SpottedLabel

var player_position = Vector3.ZERO

var damage_number = preload("res://Scenes/damagenumbers/damagenumbers.tscn")

func _ready():
	spotted_label.hide()									
	pass


func _physics_process(delta):
	moveAwayFromPlayer(delta)


func take_damage(damage):
	hit_effect_3.set_emitting(true)
	var damageNumber = damage_number.instantiate()
	get_parent().add_child(damageNumber)
	damageNumber.global_transform.origin = self.global_transform.origin
	damageNumber.set_damage(damage)
	#bloodTimer.start()
	#blood.show()
	health -= damage
	if health <= 0:
		die()

func die():
	print("lab NPC died")
	self.rotation_degrees.x = 90
	self.position.y = 0
	death = true



func _on_blood_timer_timeout():
	blood.hide()


func _on_vision_timer_timeout():
	if !death:
		var overlaps = %VisionArea.get_overlapping_bodies()
		if overlaps.size() > 0:
			for overlap in overlaps:
				if "Player" in overlap.name:
					var playerPosition = overlap.global_transform.origin
					var directionToPlayer = (playerPosition - global_transform.origin).normalized()
					var forwardDirection = -transform.basis.z
				
					var angle = acos(forwardDirection.dot(directionToPlayer))

					if angle < PI / 2:
						playerPosition.y -= 0.5
						$VisionRaycast.look_at(playerPosition, Vector3.UP)
						$VisionRaycast.force_raycast_update()

						if $VisionRaycast.is_colliding():
							var collider = $VisionRaycast.get_collider()

							if "Player" in collider.name:
								$VisionRaycast.debug_shape_custom_color = Color(174,8,0)
								print("I see you")
								spotted_label.show()
								player_position = playerPosition
								look_at(player_position, Vector3.UP)																
							else:
								$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
								print(collider.name)
								spotted_label.hide()								


func moveAwayFromPlayer(delta):
	if !death:
		var npc_position = self.global_transform.origin
		var target_position = player_position
		var distance_to_player = npc_position.distance_to(target_position)
		
		if distance_to_player < 8:
			var move_direction = (npc_position - target_position).normalized()
			move_direction.y = 0 #don't move up or down
			# self.global_transform.origin += move_direction * SPEED * delta 
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED
			look_at(target_position, Vector3.UP)
		else:
			velocity.x = 0
			velocity.z = 0
		# Apply gravity
		velocity.y += GRAVITY * delta

		# Move and slide
		move_and_slide()

