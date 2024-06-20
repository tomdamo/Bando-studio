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
@onready var animation_tree = $AnimationTree

var damage_number = preload("res://Scenes/damagenumbers/damagenumbers.tscn")
var enemyVisibleMaterial: Material = load("res://Textures/EnemyVisible.tres")

@onready var player = $"../../PlayerCharacterBody3D"
var can_be_eaten = false
@onready var eat_label = $EatLabel

var target_rotation_degrees_y = 0.0

func _ready():
	spotted_label.hide()
	eat_label.hide()
	target_rotation_degrees_y = rotation_degrees.y

func _physics_process(delta):
	moveAwayFromPlayer(delta)
	if can_be_eaten:
		showEatable()

func take_damage(damage):
	if !death:
		hit_effect_3.set_emitting(true)
		var damageNumber = damage_number.instantiate()
		get_parent().add_child(damageNumber)
		damageNumber.global_transform.origin = self.global_transform.origin
		damageNumber.set_damage(damage)
		health -= damage

		if !playerSpotted:
			self.rotation_degrees.y += 180

		if health <= 0:
			die()

func die():
	print("NPC died")
	animation_tree.get("parameters/playback").travel("Death")
	self.rotation_degrees.x = 90
	self.position.y = -1
	death = true
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
								spotted_label.hide()

func moveAwayFromPlayer(delta):
	if !death:
		var npc_position = self.global_transform.origin
		var target_position = player_position
		var distance_to_player = npc_position.distance_to(target_position)

		if distance_to_player < 8:
			var move_direction = (npc_position - target_position).normalized()
			move_direction.y = 0 # Don't move up or down

			# Check relative position to determine 180 degree turn
			var relative_position = target_position - npc_position
			if relative_position.x * move_direction.x < 0 or relative_position.z * move_direction.z < 0:
				# If relative positions along x or z axes are opposite signs, turn 180 degrees
				var new_rotation = self.rotation_degrees.y + 180.0
				self.rotation_degrees.y = new_rotation
				look_at(target_position, Vector3.UP)

				# Trigger the turn animation
				animation_tree.get("parameters/playback").travel("Turn")
			else:
				# Otherwise, face the player directly
				look_at(target_position, Vector3.UP)

				# Trigger the run animation
				animation_tree.get("parameters/playback").travel("Run")

			# Apply movement based on direction
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED

		else:
			# Stop moving
			velocity.x = 0
			velocity.z = 0

			# Face the initial direction (optional, adjust as needed)
			look_at(target_position, Vector3.UP)

			# Play idle animation
			animation_tree.get("parameters/playback").travel("Idle")

		# Apply gravity
		velocity.y += GRAVITY * delta

		# Move and slide
		move_and_slide()
