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

var player_position = Vector3.ZERO # global target

@onready var navigation_agent = $NavigationAgent3D
var playerSpotted = false
@onready var patrol_targets: Array[Vector3]
var current_patrol_target = 0
@onready var patrol_timer = $PatrolTimer

func _ready():
	pass


func _physics_process(delta):
	patrol(delta)
	
	
	#if(playerSpotted):
		#moveAwayFromPlayer(delta)
		#moveCloser(delta)

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
								playerSpotted = true
								if(shot_timer.is_stopped()):
									shot_timer.start()
							else:
								$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
								print(collider.name)
								#if(player_position != null):
									#lookForPlayer()
								#else:	
								spotted_label.hide()
								playerSpotted = false								


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
		
		if distance_to_player > 8:
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
		
func patrol(delta):
	if !death and !playerSpotted:
		if patrol_targets.size() > 0:
			var npc_position = self.global_transform.origin
			navigation_agent.target_position = patrol_targets[current_patrol_target]
			var next_path_position = navigation_agent.get_next_path_position()
			var direction = (next_path_position - npc_position).normalized()
			direction.y = 0 #don't move up or down
		
			var distance_to_target = npc_position.distance_to(next_path_position)
			var target_speed = SPEED * clamp(distance_to_target / 5.0, 0, 1) # Slow down when within 5 units of the target
			var target_velocity = direction * target_speed
		
			velocity = velocity.lerp(target_velocity, 0.1) # Interpolate towards the target velocity

			move_and_slide()

			if distance_to_target < 2:
				print("reached target" + str(current_patrol_target)) 
				patrol_timer.start()
				velocity.z = 0
				velocity.x = 0

	#move_and_slide()

func lookForPlayer():
	if !death:
		look_at(player_position)
		navigation_agent.target_position = player_position


func _on_patrol_timer_timeout():
	current_patrol_target = randi() % patrol_targets.size()

