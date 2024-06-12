extends CharacterBody3D


const SPEED = 5.0
const GRAVITY = -9.8
@export var health = 6
@export var death = false
@onready var blood = %BloodEffect
@onready var bloodTimer = %BloodTimer
@onready var hit_effect_3 = %HitEffect3

@onready var VisionArea = %VisionArea
@onready var VisionRaycast = %VisionRaycast
@onready var VisionTimer = %VisionTimer
@onready var spotted_label = $SpottedLabel
var playerSpotted = false
var player_position = Vector3.ZERO
@onready var mesh_instance_3d = $Body/RootNode/Skeleton3D/MeshInstance3D

var damage_number = preload("res://Scenes/damagenumbers/damagenumbers.tscn")
var enemyVisibleMaterial: Material = load("res://Textures/EnemyVisible.tres")
@onready var player = %PlayerCharacterBody3D

var target_rotation_degrees_y = 0.0

func _ready():
	spotted_label.hide()									
	target_rotation_degrees_y = rotation_degrees.y
	


func _physics_process(delta):
	moveAwayFromPlayer(delta)
	

func take_damage(damage):
	if !death:
		hit_effect_3.set_emitting(true)
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
	print("lab NPC died")
	self.rotation_degrees.x = 90
	self.position.y = -1
	death = true
	player.player_kills += 1



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
					player = overlap
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
								playerSpotted = true								
								spotted_label.show()
								player_position = playerPosition
								look_at(player_position, Vector3.UP)																
							else:
								$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
								playerSpotted = false																
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

