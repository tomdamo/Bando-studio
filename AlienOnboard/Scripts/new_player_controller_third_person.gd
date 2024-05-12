extends CharacterBody3D

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export var enable_gravity = true

@onready var _camera: Camera3D

@onready var _player_visual: Node3D = %PlayerVisual

#Dash
@export var DASH_SPEED = 30
@export var DASH_TIME = 0.05
var dashing = false
var dash_direction = Vector3.ZERO
var dash_timer = 0.0
@onready var dash_cooldown_timer = %DashCooldownTimer
@onready var dash_sound = %DashSound

#Pause
var paused = false
@onready var pause_menu = %PauseMenu 

#Health and damage
@export var health = 9
@export var damage = 3
@onready var attack_range = %AttackRange
@export var player_died = false
const GAME_OVER_2 = preload("res://Scenes/UI/GameOver2.tscn")
var playerNormalMaterial = load("res://Scenes/Player/UPDATED_PC_PLAYER/normal_player_material.tres")
var playerDamageMaterial = load("res://Scenes/Player/UPDATED_PC_PLAYER/damaged_player_material.tres")
@onready var damage_timer = %DamageTimer
@onready var player_mesh_instance_3d = %PlayerMeshInstance3D
@onready var hit_sound = %HitSound


#Sense ability
var senseActive = false
const Sense_duration = 10.0
const Sense_Cooldown = 20.0
var sense_timer = 0.0
@onready var sense_cooldown_timer = %SenseCooldownTimer
@onready var active_sense_timer = %ActiveSenseTime
# Enemy material for the sense ability.
var enemyNormalMaterial = load("res://Textures/EnemyNormal.tres")
var enemyVisibleMaterial = load("res://Textures/EnemyVisible.tres")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 9.8
var movement_enabled: bool = true
var _physics_body_trans_last: Transform3D
var _physics_body_trans_current: Transform3D



func _ready() -> void:
	_camera = owner.get_node("%MainCamera3D")
	_player_visual.top_level = true


func _physics_process(delta: float) -> void:
	_physics_body_trans_last = _physics_body_trans_current
	_physics_body_trans_current = global_transform

	# Add the gravity.
	if enable_gravity and not is_on_floor():
		velocity.y -= gravity * delta

	if not movement_enabled: return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	if Input.is_action_just_pressed("pause"):
		_pauseMenu()

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	#See enemies layer through the walls
	if Input.is_action_just_pressed("SenseAbility") and not senseActive and sense_cooldown_timer.is_stopped():
		print("if for senseability passed")
		_activateSenseAbility()
	
	if Input.is_action_just_pressed("Attack"):
		attack()
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var cam_dir: Vector3 = -_camera.global_transform.basis.z
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("dash") and !dashing and dash_cooldown_timer.is_stopped():
		dashing = true
		dash_direction = cam_dir
		dash_timer = DASH_TIME
		dash_cooldown_timer.start()
		dash_sound.play()
	
	
	if dashing:
		velocity += dash_direction * DASH_SPEED
		dash_timer -= delta
		#check if dash time is over
		if dash_timer <= 0:
			dashing = false
			# Reset velocity to zero to prevent continued movement after dash
			velocity = Vector3.ZERO
	else:
		if direction:
			var move_dir: Vector3 = Vector3.ZERO
			move_dir.x = direction.x
			move_dir.z = direction.z

			move_dir = move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
			velocity.x = move_dir.x * SPEED
			velocity.z = move_dir.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	#sense Timer
	if senseActive:
		sense_timer -= delta
		if sense_timer <= 0:
			_deactivateSenseAbility()
	
func _activateSenseAbility():
	senseActive = true
	sense_timer = Sense_duration
	active_sense_timer.start()
	print("Sense activated")
	#TODO Get all enemies within the SenseRange collision shape
	#if senseRange:
		#var bodies = senseRange.get_overlapping_areas()
		#for area in areas:
			#if body.has_node("MeshInstance3D"):
				#var meshInstance = body.get_node("MeshInstance3D")
				#meshInstance.material_override = enemyVisibleMaterial
	#
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_node("MeshInstance3D"):
			var meshInstance = enemy.get_node("MeshInstance3D")
			meshInstance.material_override = enemyVisibleMaterial

func _deactivateSenseAbility():
	senseActive = false
	sense_cooldown_timer.start()
# Revert the material of enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_node("MeshInstance3D"):
			var meshInstance = enemy.get_node("MeshInstance3D")
			meshInstance.material_override = enemyNormalMaterial


func _process(_delta: float) -> void:
	_player_visual.global_transform = _physics_body_trans_last.interpolate_with(
		_physics_body_trans_current,
		Engine.get_physics_interpolation_fraction()
	)


#pause
func _pauseMenu():
	if paused:
		pause_menu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
	else:
		pause_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	paused = !paused

#Attack
func attack():
	var bodies = attack_range.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			
func take_damage(damageAmount):
	print("Damage taken")
	print(health)
	#bloodTimer.start()
	#blood.show() 
	health -= damage
	damage_timer.start()
	player_mesh_instance_3d.material_override = playerDamageMaterial
	hit_sound.play()
	if health <= 0:
		die()
	
func die():
	print("Player died")
	print(health)

func _on_damage_timer_timeout():
	player_mesh_instance_3d.material_override = playerNormalMaterial
