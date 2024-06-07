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
@onready var dash_icon = %Dash_icon
@onready var dash_material : ShaderMaterial
#var dash_cd_value
#Pause
var paused = false
@onready var pause_menu = %PauseMenu 

#Health and damage
var health: float
@export var damage = 5
@onready var attack_range = %AttackRange
@export var player_died = false
const GAME_OVER_2 = preload("res://Scenes/UI/GameOver2.tscn")
@onready var damage_timer = %DamageTimer
@onready var player_mesh_instance_3d = %PlayerMeshInstance3D
@onready var hit_sound = %HitSound
@onready var healthbar = %Healthbar

var damage_number = preload("res://Scenes/damagenumbers/damagenumbers.tscn")



#Sense ability
var senseActive = false
@onready var Sense_Cooldown = %SenseCooldownTimer
@onready var active_sense_time = %ActiveSenseTime
@onready var sense_icon = %Sense_icon
@onready var sense_material : ShaderMaterial
@onready var sense_overlay = %Sense_overlay
 

# Enemy material for the sense ability.
var enemyNormalMaterial = load("res://Textures/EnemyNormal.tres")
var enemyVisibleMaterial = load("res://Textures/EnemyVisible.tres")
var NPC_SPOTTED_MATERIAL = load("res://Scenes/Enemy/Guard/NPCSpottedMaterial.tres")
var NPC_NORMAL_MATERIAL = load("res://Scenes/Enemy/Guard/NPCNormalMaterial.tres")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 9.8
var movement_enabled: bool = true
var _physics_body_trans_last: Transform3D
var _physics_body_trans_current: Transform3D

@onready var color_rect = $"../CanvasLayer/ColorRect"


func _ready():
	health = 100
	healthbar.init_health(health)
	_camera = owner.get_node("%MainCamera3D")
	_player_visual.top_level = true
	dash_material = dash_icon.get_material()
	sense_material = sense_icon.get_material()
	sense_overlay.mouse_filter = true
	#dash_cd_value = dash_material.get_shader_parameter("cooldown_progress")
	#print(dash_cd_value)


func _physics_process(delta: float) -> void:
	_physics_body_trans_last = _physics_body_trans_current
	_physics_body_trans_current = global_transform
	print(Sense_Cooldown.is_stopped())
	#icon UI stuff
	if !dash_cooldown_timer.is_stopped():
		var time_left = dash_cooldown_timer.get_time_left()
		var total_wait_time = dash_cooldown_timer.get_wait_time()
	
		var cooldown_progress = 1 - (time_left / total_wait_time)
		dash_material.set_shader_parameter("cooldown_progress", cooldown_progress)
		
	if !Sense_Cooldown.is_stopped():
		var sense_time_left = Sense_Cooldown.get_time_left()
		var sense_total_wait = Sense_Cooldown.get_wait_time()
		
		var sense_progress = 1 - (sense_time_left / sense_total_wait)
		sense_material.set_shader_parameter("cooldown_progress", sense_progress)
	
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
	
	#See enemies layer through the walls  and not senseActive and sense_cooldown_timer.is_stopped()
	if Input.is_action_just_pressed("SenseAbility") and !senseActive and Sense_Cooldown.is_stopped():
		senseActive = true		
		print("Sense if passed")		
		_activateSenseAbility()
		sense_material.set_shader_parameter("cooldown_progress", 0)		
	
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
		dash_material.set_shader_parameter("cooldown_progress", 0)  # Dash just used, so cooldown is 0
	
	if dashing:
		velocity += dash_direction * DASH_SPEED
		dash_timer -= delta
		# Update cooldown progress
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

func _on_dash_cooldown_timer_timeout():
	dash_material.set_shader_parameter("cooldown_progress", 1)  # Dash ready, so cooldown is 1
	
func _activateSenseAbility():
	active_sense_time.start()
	print("Sense activated")
	sense_overlay.show()
	#TODO Get all enemies within the SenseRange collision shape
	#if senseRange:
		#var bodies = senseRange.get_overlapping_areas()
		#for area in areas:
			#if body.has_node("MeshInstance3D"):
				#var meshInstance = body.get_node("MeshInstance3D")
				#meshInstance.material_override = enemyVisibleMaterial
	#
	for enemy in get_tree().get_nodes_in_group("enemies"):
		print(enemy)
		if enemy.has_node("MeshInstance3D"):
			var meshInstance = enemy.get_node("MeshInstance3D")
			print(meshInstance)
			#meshInstance.material_override = enemyVisibleMaterial
			meshInstance.set_surface_override_material(0, NPC_SPOTTED_MATERIAL)

func _deactivateSenseAbility():
	senseActive = false
	sense_overlay.hide()
	Sense_Cooldown.start()
# Revert the material of enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_node("MeshInstance3D"):
			var meshInstance = enemy.get_node("MeshInstance3D")
			#meshInstance.material_override = enemyNormalMaterial
			meshInstance.set_surface_override_material(0, NPC_NORMAL_MATERIAL)
			
func _on_sense_cooldown_timer_timeout():
	sense_material.set_shader_parameter("cooldown_progress", 1)

func _on_active_sense_time_timeout():
	_deactivateSenseAbility()


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
		color_rect.show()
	else:
		pause_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		color_rect.hide()
	paused = !paused

#Attack
func attack():
	var bodies = attack_range.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			
func take_damage(damageAmount):
	var damageNumber = damage_number.instantiate()
	get_parent().add_child(damageNumber)
	damageNumber.global_transform.origin = self.global_transform.origin
	damageNumber.set_damage(damageAmount)
	damage_timer.start()

	
	health -= damage
	hit_sound.play()
	healthbar.health = health 
	if health <= 0:
		die()
	
func die():
	print("Player died")
	print(health)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/UI/GameOver2.tscn")

	
