extends CharacterBody3D

const SPEED = 3.0
const GRAVITY = -9.8

var health = 20
var death = false
var damage_number = preload("res://Scenes/damagenumbers/damagenumbers.tscn")
@onready var animation_tree = $AnimationTree

@onready var blood = %BloodEffect
@onready var bloodTimer = %BloodTimer
@onready var hit_effect_2 = %HitEffect2

var can_be_eaten = false
@onready var eat_label = $EatLabel

@onready var VisionArea = %VisionArea
@onready var VisionRaycast = %VisionRaycast
@onready var VisionTimer = %VisionTimer

@onready var shot_timer = %ShotTimer
@onready var spotted_label = $SpottedLabel

var Bullet = preload("res://Scenes/Bullet/Bullet.tscn")

var player_position = Vector3.ZERO # global target

#patrolling related
@onready var navigation_agent = $NavigationAgent3D
var playerSpotted = false
@export var patrol_targets: Array[Vector3]
var current_patrol_target = 0
@onready var patrol_timer = $PatrolTimer
var reached_target = false

#search for player at last position
@onready var search_timer = $SearchTimer
var player_last_seen = false
var player_last_seen_position: Vector3
@onready var searching_label = $SearchingLabel
@onready var player = $"../Player/PlayerCharacterBody3D"


#moving away and close
var npc_position
var target_position
var distance_to_player
var min_distance = 3
var max_distance = 8
var target_rotation_degrees_y = 0.0

func _ready():
	target_rotation_degrees_y = rotation_degrees.y
	eat_label.hide()
	init_navigation()

func init_navigation():
	navigation_agent.set_target_position(patrol_targets[current_patrol_target])


func _physics_process(delta):
	if !death:
		npc_position = self.global_transform.origin
		target_position = player_position
		distance_to_player = npc_position.distance_to(target_position)
		target_rotation_degrees_y = rotation_degrees.y


		if !playerSpotted and !player_last_seen:
			patrol(delta)
		if playerSpotted:
			if distance_to_player < min_distance:
				moveAwayFromPlayer(delta)
			if distance_to_player > max_distance:
				moveCloser(delta)
		if !playerSpotted and player_last_seen:
			lookForPlayer(delta)


func take_damage(damage):
	if !death:
		hit_effect_2.set_emitting(true)
		var damageNumber = damage_number.instantiate()
		get_parent().add_child(damageNumber)
		damageNumber.global_transform.origin = self.global_transform.origin
		damageNumber.set_damage(damage)
	#bloodTimer.start()
	#blood.show()
		health -= damage
		if !playerSpotted:
			self.rotation_degrees.y += 180
		if health <= 0:
			die()

func die():
	print("im ded")
	animation_tree["parameters/conditions/IsWalking"] = false
	animation_tree["parameters/conditions/IsIdle"] = false
	animation_tree["parameters/conditions/IsAimMovingF"] = false
	animation_tree["parameters/conditions/IsAimMovingB"] = false
	animation_tree["parameters/conditions/IsDead"] = true
	animation_tree.get("parameters/playback").travel("Death")
	#self.rotation_degrees.x = 90
	#self.position.y = -1
	death = true
	#player.guard_kills += 1
	can_be_eaten = true

func showEatable():
	eat_label.show()

func dissapear():
	queue_free()

func _on_blood_timer_timeout():
	blood.hide()


func _on_vision_timer_timeout():
	if !death:
		var overlaps = %VisionArea.get_overlapping_bodies()
		if overlaps.size() > 0:
			for overlap in overlaps:
				if "Player" in overlap.name:
					player = overlap
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
								player_last_seen_position = player_position
								look_at(player_position, Vector3.UP)
								playerSpotted = true
								if(shot_timer.is_stopped()):
									shot_timer.start()
									$AudioStreamPlayer_Charge_gun.play()
							else:
								$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
								spotted_label.hide()
								playerSpotted = false



func _on_shot_timer_timeout():
	shootAtTarget()

func shootAtTarget():
	var bullet = Bullet.instantiate()
	get_parent().add_child(bullet)
	$AudioStreamPlayer_pew.play()
	npc_position = self.global_transform.origin
	npc_position.y += 1
	bullet.global_transform.origin = npc_position

	target_position = player_position
	distance_to_player = npc_position.distance_to(target_position)
	#print(distance_to_player)
	animation_tree["parameters/conditions/IsWalking"] = false
	animation_tree["parameters/conditions/IsIdle"] = false
	animation_tree["parameters/conditions/IsAimMovingB"] = false
	animation_tree["parameters/conditions/IsAimMovingF"] = false
	animation_tree["parameters/conditions/IsAiming"] = true
	animation_tree.get("parameters/playback").travel("Aim")
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
	player_last_seen = true
	player_last_seen_position = player_position

func moveAwayFromPlayer(delta):
	#print("moving away")
	navigation_agent.target_position = target_position

	if distance_to_player < 3:
		var move_direction = (npc_position - target_position).normalized()
		move_direction.y = 0 #don't move up or down
		velocity.x = move_direction.x * SPEED
		velocity.z = move_direction.z * SPEED
		look_at(target_position, Vector3.UP)
		animation_tree["parameters/conditions/IsAimStanding"] = false
		animation_tree["parameters/conditions/IsWalking"] = false
		animation_tree["parameters/conditions/IsAimMovingF"] = false
		animation_tree["parameters/conditions/IsAimMovingB"] = true
		animation_tree.get("parameters/playback").travel("AimMovingBackward")
	else:
		velocity.x = 0
		velocity.z = 0
	# Apply gravity
	#velocity.y += GRAVITY * delta
	# Move and slide
	move_and_slide()

func moveCloser(delta):
	#print("moving closer")
	navigation_agent.target_position = target_position

	if distance_to_player > 8:
		var move_direction = (target_position - npc_position).normalized()
		move_direction.y = 0 #don't move up or down
		velocity.x = move_direction.x * SPEED
		velocity.z = move_direction.z * SPEED
		look_at(target_position, Vector3.UP)
		animation_tree["parameters/conditions/IsAimStanding"] = false
		animation_tree["parameters/conditions/IsWalking"] = false
		animation_tree["parameters/conditions/IsAimMovingB"] = false
		animation_tree["parameters/conditions/IsAimMovingF"] = true
		animation_tree.get("parameters/playback").travel("AimMovingForward")
	else:
		velocity.x = 0
		velocity.z = 0
		animation_tree["parameters/conditions/IsWalking"] = false
		animation_tree["parameters/conditions/IsIdle"] = false
		animation_tree["parameters/conditions/IsAimMovingB"] = false
		animation_tree["parameters/conditions/IsAimMovingF"] = false
		animation_tree["parameters/conditions/IsAiming"] = true
		animation_tree.get("parameters/playback").travel("Aim")
	move_and_slide()

func patrol(delta):
	#print("patrolling")
	if patrol_targets.size() > 0:
		npc_position = self.global_transform.origin
		navigation_agent.target_position = patrol_targets[current_patrol_target]
		var next_path_position = navigation_agent.get_next_path_position()
		var direction = (next_path_position - npc_position).normalized()
		look_at(direction)
		animation_tree["parameters/conditions/IsIdle"] = false
		animation_tree["parameters/conditions/IsAiming"] = false
		animation_tree["parameters/conditions/IsAimMovingB"] = false
		animation_tree["parameters/conditions/IsAimMovingF"] = false
		animation_tree["parameters/conditions/IsWalking"] = true
		animation_tree.get("parameters/playback").travel("Walk")
		var distance_to_target = npc_position.distance_to(next_path_position)
		var target_speed = SPEED * clamp(distance_to_target / 2.0, 0, 5) # Slow down when within 5 units of the target
		var target_velocity = direction * target_speed

		velocity = velocity.lerp(target_velocity, 0.1) # Interpolate towards the target velocity
		move_and_slide()
		if distance_to_target < 0.5 and !reached_target:
			print("reached target" + str(current_patrol_target))
			animation_tree["parameters/conditions/IsDead"] = false
			animation_tree["parameters/conditions/IsWalking"] = false
			animation_tree["parameters/conditions/IsAiming"] = false
			animation_tree["parameters/conditions/IsAiming"] = true
			animation_tree.get("parameters/playback").travel("Walk")
			patrol_timer.start()
			reached_target = true
			velocity.z = 0
			velocity.x = 0

func lookForPlayer(delta):
	#print("looking for player")
	if (search_timer.is_stopped()):
			search_timer.start()
	npc_position = self.global_transform.origin
	navigation_agent.target_position = player_last_seen_position
	navigation_agent.get_next_path_position()
	var direction = (player_last_seen_position - npc_position).normalized()
	look_at(player_last_seen_position)
	animation_tree["parameters/conditions/IsIdle"] = false
	animation_tree["parameters/conditions/IsAiming"] = false
	animation_tree["parameters/conditions/IsAimMovingB"] = false
	animation_tree["parameters/conditions/IsAimMovingF"] = true
	animation_tree["parameters/conditions/IsWalking"] = false
	animation_tree.get("parameters/playback").travel("AimMovingForward")
	var target_speed = SPEED
	var target_velocity = direction * target_speed
	move_and_slide()
	distance_to_player = npc_position.distance_to(player_last_seen_position)
	#start timer if npc is at last seen location
	if distance_to_player < 1:
		look_around()

func _on_patrol_timer_timeout():
	patrol_timer.stop()
	current_patrol_target = (current_patrol_target + 1) % patrol_targets.size()
	reached_target = false

func _on_search_timer_timeout():
	playerSpotted = false
	player_last_seen = false

func look_around():
	pass
	#Walk circle or do a 360 basically haha
