extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = -9.8

var health = 6
var death = false
@onready var blood = %BloodEffect
@onready var bloodTimer = %BloodTimer

@onready var VisionArea = %VisionArea
@onready var VisionRaycast = %VisionRaycast
@onready var VisionTimer = %VisionTimer

@onready var shot_timer = %ShotTimer
@onready var spotted_label = $SpottedLabel

var Bullet = preload("res://Scenes/Bullet/Bullet.tscn")
var player_position = Vector3.ZERO # target

@onready var navigation_agent = $NavigationAgent3D


func _ready():
	pass


func _physics_process(delta):
	moveAwayFromPlayer(delta)
	moveCloser(delta)

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
								if(shot_timer.is_stopped()):
									shot_timer.start()
							else:
								$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
								print(collider.name)
								spotted_label.hide()								


func _on_shot_timer_timeout():
	shootAtTarget()
	
func shootAtTarget():
	if !death:
		var bullet = Bullet.instantiate()
		get_parent().add_child(bullet)
		var npc_position = self.global_transform.origin
		npc_position.y += 1
		bullet.global_transform.origin = npc_position
		
		var target_position = player_position
		var distance_to_player = npc_position.distance_to(target_position)
		print(distance_to_player)

		if distance_to_player < 3:
			target_position.y -= 0.52
		elif distance_to_player < 5:
			target_position.y -= 0.4
		else:
			target_position.y -= 0.3
		var direction = (target_position - self.global_transform.origin).normalized()
		#take the direction of the raycast -> does not work
		#var direction = $VisionRaycast.to_global($VisionRaycast.cast_to).normalized()
		bullet.direction = direction

func moveAwayFromPlayer(delta):
	if !death:
		var npc_position = self.global_transform.origin
		var target_position = player_position
		var distance_to_player = npc_position.distance_to(target_position)
		
		if distance_to_player < 2:
			var move_direction = (npc_position - target_position).normalized()
			move_direction.y = 0 #don't move up or down
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

func moveCloser(delta):
	if !death:
		var npc_position = self.global_transform.origin
		var target_position = player_position
		var distance_to_player = npc_position.distance_to(target_position)
		
		if distance_to_player > 10:
			var move_direction = (target_position - npc_position).normalized()
			move_direction.y = 0 #don't move up or down
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED
			look_at(target_position, Vector3.UP)

		else:
			velocity.x = 0
			velocity.z = 0
			
		velocity.y += GRAVITY * delta
		
		move_and_slide()
		
