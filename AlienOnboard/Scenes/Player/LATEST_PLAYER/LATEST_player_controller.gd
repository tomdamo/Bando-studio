extends CharacterBody3D

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export var enable_gravity = true
@onready var _camera: Camera3D
@onready var _player_visual: Node3D = %PlayerVisual

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 9.8
var movement_enabled: bool = true
var _physics_body_trans_last: Transform3D
var _physics_body_trans_current: Transform3D

var animation_tree = null

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


#Pause
var paused = false
@onready var pause_menu = %PauseMenu

#Health, damage etc.
var health: float
@export var player_damage = 5
@onready var attack_range = %AttackRange
@export var player_died = false
const GAME_OVER_2 = preload("res://Scenes/UI/GameOver2.tscn")
@onready var damage_timer = %DamageTimer
@onready var hit_sound = %HitSound
@onready var healthbar = %Healthbar
var damage_number = preload("res://Scenes/damagenumbers/damagenumbers.tscn")
@onready var eat_timer = %EatTimer
var eating = false
@onready var blood_vignette = %blood_vignette
@onready var attack_timer = %AttackTimer
@onready var hit_effect = %HitEffect
@onready var health_amount = %Health_number
var max_health = 100

#Evolution
@export var lab_kills = 0
@export var guard_kills = 0
@export var lab_points = 0
@export var guard_points = 0
@onready var evolution_menu = %EvolutionMenu
var evol_open = false
var evo_pressed_tip = false
var crit_on_unaware = false

#Sense ability
var senseActive = false
@onready var Sense_Cooldown = %SenseCooldownTimer
@onready var active_sense_time = %ActiveSenseTime
@onready var sense_icon = %Sense_icon
@onready var sense_material : ShaderMaterial
@onready var sense_overlay = %Sense_overlay
@onready var color_rect = $"../CanvasLayer/ColorRect"
var enemyNormalMaterial: Material = load("res://Textures/EnemyNormal.tres")
var enemyVisibleMaterial: Material = load("res://Textures/EnemyVisible.tres")
var enemyNormalMaterialGuard: Material = load("res://Scenes/Enemy/Guard/NPCNormalMaterial.tres")
@onready var fight_test_area = $"../*"

#Checkpoint system
#TODO: upon dying, respawn to the latest checkpoint.
var respawn_point : Vector3
@onready var respawn_timer = %RespawnTimer


func _ready() -> void:
	_camera = owner.get_node("%MainCamera3D")
	_player_visual.top_level = true
	animation_tree = _player_visual.get_node_or_null("AnimationTree")
	animation_tree
	health = max_health
	healthbar.init_health(health)
	health_amount.set_text(str(health))
	dash_material = dash_icon.get_material()
	sense_material = sense_icon.get_material()
	sense_overlay.mouse_filter = true
func _physics_process(delta: float) -> void:
	_physics_body_trans_last = _physics_body_trans_current
	_physics_body_trans_current = global_transform

	# Add the gravity.
	if enable_gravity and not is_on_floor():
		velocity.y -= gravity * delta

	if not movement_enabled: return
	if eating:
		movement_enabled = false

	# Handle input actions.
	if Input.is_action_just_pressed("pause") and !evol_open:
		_pauseMenu()

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if Input.is_action_just_pressed("evolution_menu"):
		evo_pressed_tip = true
		_evolutionMenu()

	if Input.is_action_just_pressed("SenseAbility") and !senseActive and Sense_Cooldown.is_stopped():
		senseActive = true
		print("Sense if passed")
		_activateSenseAbility()
		sense_material.set_shader_parameter("cooldown_progress", 0)

	if Input.is_action_just_pressed("Interact") and !eating:
		eat()

	if Input.is_action_just_pressed("Jump") and is_on_floor() and !eating:
		velocity.y = JUMP_VELOCITY
		animation_tree.get("parameters/playback").travel("Jump")

	if Input.is_action_just_pressed("dash") and !dashing and dash_cooldown_timer.is_stopped() and !eating:
		dashing = true
		dash_direction = -_camera.global_transform.basis.z
		dash_timer = DASH_TIME
		dash_cooldown_timer.start()
		dash_sound.play()
		dash_material.set_shader_parameter("cooldown_progress", 0)  # Dash just used, so cooldown is 0

	if dashing:
		velocity += dash_direction * DASH_SPEED
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false
			velocity = Vector3.ZERO  # Reset velocity to prevent continued movement after dash

	# Get the input direction for movement.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Attack action check.
	if Input.is_action_just_released("Attack") and !eating and attack_timer.is_stopped():
		attack()
		print("attack")
	else:
		# Handle movement and animations.
		if direction:
			var move_dir: Vector3 = Vector3.ZERO
			move_dir.x = direction.x
			move_dir.z = direction.z
			move_dir = move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
			velocity.x = move_dir.x * SPEED
			velocity.z = move_dir.z * SPEED
			if not dashing:
				animation_tree.get("parameters/playback").travel("Walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			if not dashing:
				animation_tree.get("parameters/playback").travel("Idle")

	move_and_slide()

	# Icon UI updates.
	if not dash_cooldown_timer.is_stopped():
		var time_left = dash_cooldown_timer.get_time_left()
		var total_wait_time = dash_cooldown_timer.get_wait_time()
		var cooldown_progress = 1 - (time_left / total_wait_time)
		dash_material.set_shader_parameter("cooldown_progress", cooldown_progress)

	if not Sense_Cooldown.is_stopped():
		var sense_time_left = Sense_Cooldown.get_time_left()
		var sense_total_wait = Sense_Cooldown.get_wait_time()
		var sense_progress = 1 - (sense_time_left / sense_total_wait)
		sense_material.set_shader_parameter("cooldown_progress", sense_progress)



func _process(_delta: float) -> void:
	_player_visual.global_transform = _physics_body_trans_last.interpolate_with(
		_physics_body_trans_current,
		Engine.get_physics_interpolation_fraction()
	)


func _on_dash_cooldown_timer_timeout():
	dash_material.set_shader_parameter("cooldown_progress", 1)  # Dash ready, so cooldown is 1

func _activateSenseAbility():
	active_sense_time.start()
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
			var meshInstance : MeshInstance3D = enemy.get_node("MeshInstance3D")
			meshInstance.set_surface_override_material(1, enemyVisibleMaterial)
		if enemy.has_node("MeshInstance3DG"):
			var meshInstanceGuard : MeshInstance3D = enemy.get_node("MeshInstance3DG")
			meshInstanceGuard.set_surface_override_material(0, enemyVisibleMaterial)


func _deactivateSenseAbility():
	senseActive = false
	sense_overlay.hide()
	Sense_Cooldown.start()
# Revert the material of enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_node("MeshInstance3D"):
			var meshInstance = enemy.get_node("MeshInstance3D")
			meshInstance.set_surface_override_material(1, enemyNormalMaterial)
		if enemy.has_node("MeshInstance3DG"):
			var meshInstanceGuard = enemy.get_node("MeshInstance3DG")
			meshInstanceGuard.set_surface_override_material(0, enemyNormalMaterialGuard)

func _on_sense_cooldown_timer_timeout():
	sense_material.set_shader_parameter("cooldown_progress", 1)

func _on_active_sense_time_timeout():
	_deactivateSenseAbility()

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

#Evolution
func _evolutionMenu():
	if evol_open:
		evolution_menu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
	else:
		evolution_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	evol_open = !evol_open
#Attack
func attack():
	animation_tree.get("parameters/playback").travel("Attack")
	var bodies = attack_range.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(player_damage)
		#if body.health <= 0:
			#eat()
func eat():
	var bodies = attack_range.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			if body.can_be_eaten:
				var damageNumber = damage_number.instantiate()
				get_parent().add_child(damageNumber)
				damageNumber.global_transform.origin = self.global_transform.origin
				damageNumber.set_damage("nom nom nom")
				eat_timer.start()
				animation_tree.get("parameters/playback").travel("Eat")
				eating = true
func take_damage(damageAmount):
	hit_effect.set_emitting(true)
	var damageNumber = damage_number.instantiate()
	get_parent().add_child(damageNumber)
	damageNumber.global_transform.origin = self.global_transform.origin
	damageNumber.set_damage(damageAmount)
	blood_vignette.show()
	if damage_timer.is_stopped():
		damage_timer.start()
	health -= damageAmount
	hit_sound.play()
	healthbar.health = health
	health_amount.set_text(str(health))
	if health <= 0:
		die()

func die():
	print("Player died")
	print(health)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#get_tree().change_scene_to_file("res://Scenes/UI/GameOver2.tscn")
	if respawn_timer.is_stopped():
		respawn_timer.start()
		%Respawn_Label.show()
	if respawn_point == null:
		if get_tree():
			get_tree().reload_current_scene()
	else:
		respawn()

func _on_respawn_timer_timeout():
	%Respawn_Label.hide()


func respawn():
	health = max_health
	healthbar.init_health(health)
	health_amount.set_text(str(health))
	global_transform.origin = respawn_point
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#var newhealthbar = healthbar.instantiate()
	#get_parent().add_child(newhealthbar)

func _on_eat_timer_timeout():
	print("Eating started. Current kills: ", guard_kills, ", ", lab_kills)
	eating = false;
	movement_enabled = true
	var damageNumber = damage_number.instantiate()
	get_parent().add_child(damageNumber)
	damageNumber.global_transform.origin = self.global_transform.origin
	damageNumber.set_damage("delicious!")
	var bodies = attack_range.get_overlapping_bodies()
	print("Bodies detected: ", bodies.size())
	for body in bodies:
		if body.has_method("take_damage"):
			if body.can_be_eaten and body.is_in_group("lab"):
				damageNumber.global_transform.origin = self.global_transform.origin
				damageNumber.set_damage("Lab DNA +1")
				lab_kills += 1
				lab_points += 1
				print(str(lab_kills))
				if health < max_health:
					health += 5
				healthbar.health = health
				health_amount.set_text(str(health))
				body.dissapear()
				if fight_test_area != null:
					fight_test_area.update_kill_count()
			if body.can_be_eaten and body.is_in_group("guard"):
				damageNumber.global_transform.origin = self.global_transform.origin
				damageNumber.set_damage("Guard DNA +1")
				guard_kills += 1
				guard_points += 1
				print(str(guard_kills))
				if health < max_health:
					health += 10
				healthbar.health = health
				health_amount.set_text(str(health))
				body.dissapear()
				if fight_test_area != null:
					fight_test_area.update_kill_count()
	print("Eating ended. Final kills: ", guard_kills,", ", lab_kills)


func _on_damage_timer_timeout():
	if health > 10:
		blood_vignette.hide()
	else:
		blood_vignette.show()



