extends CharacterBody3D

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export var enable_gravity = true
@export var DASH_SPEED = 30
@export var DASH_TIME = 0.05

var dashing = false
var dash_direction = Vector3.ZERO
var dash_timer = 0.0
@onready var dash_cooldown_timer = $DashCooldownTimer

@onready var _camera: Camera3D = %MainCamera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 9.8


#Health and damage
var health
var damage = 1 

#Sense Ability, see enemies through walls
var senseActive = false
const Sense_duration = 10.0
const Sense_Cooldown = 20.0
var sense_timer = 0.0
@onready var sense_cooldown_timer = $SenseCooldownTimer
@onready var active_sense_timer = $ActiveSenseTime
# Enemy material
var enemyNormalMaterial = load("res://Textures/EnemyNormal.tres")
var enemyVisibleMaterial = load("res://Textures/EnemyVisible.tres")


const KEY_STRINGNAME: StringName = "Key"
const ACTION_STRINGNAME: StringName = "Action"
const JUMP_STRINGNAME: StringName = "Jump"
const SENSE_ABILITY_STRINGNAME: StringName = "Sense"
const DASH_STRINGNAME: StringName = "Dash"

const INPUT_MOVE_UP_STRINGNAME: StringName = "move_forward"
const INPUT_MOVE_DOWM_STRINGNAME: StringName = "move_back"
const INPUT_MOVE_LEFT_STRINGNAME: StringName = "move_left"
const INPUT_MOVE_RIGHT_STRINGNAME: StringName = "move_right"

var InputMovementDic: Dictionary = {
	INPUT_MOVE_UP_STRINGNAME: {
		KEY_STRINGNAME: KEY_W,
		ACTION_STRINGNAME: INPUT_MOVE_UP_STRINGNAME
	},
	INPUT_MOVE_DOWM_STRINGNAME: {
		KEY_STRINGNAME: KEY_S,
		ACTION_STRINGNAME: INPUT_MOVE_DOWM_STRINGNAME
	},
	INPUT_MOVE_LEFT_STRINGNAME: {
		KEY_STRINGNAME: KEY_A,
		ACTION_STRINGNAME: INPUT_MOVE_LEFT_STRINGNAME
	},
	INPUT_MOVE_RIGHT_STRINGNAME: {
		KEY_STRINGNAME: KEY_D,
		ACTION_STRINGNAME: INPUT_MOVE_RIGHT_STRINGNAME
	},
}


func _ready() -> void:
	for input in InputMovementDic:
		var key_val = InputMovementDic[input].get(KEY_STRINGNAME)
		var action_val = InputMovementDic[input].get(ACTION_STRINGNAME)

		var movement_input = InputEventKey.new()
		movement_input.physical_keycode = key_val
		InputMap.add_action(action_val)
		InputMap.action_add_event(action_val, movement_input)
		


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if enable_gravity and not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector(
		INPUT_MOVE_LEFT_STRINGNAME,
		INPUT_MOVE_RIGHT_STRINGNAME,
		INPUT_MOVE_UP_STRINGNAME,
		INPUT_MOVE_DOWM_STRINGNAME
	)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
		
	#See enemies layer through the walls
	if Input.is_action_just_pressed("SenseAbility") and not senseActive and sense_cooldown_timer.is_stopped():
		print("if for senseability passed")
		_activateSenseAbility()
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			

	var cam_dir: Vector3 = -_camera.global_transform.basis.z

	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# shift to dash
	if Input.is_action_just_pressed("dash") and not dashing and dash_cooldown_timer.is_stopped():
		dash_direction = cam_dir #TODO fix dash direction? what feels nice..
		dashing = true
		dash_timer = DASH_TIME
		dash_cooldown_timer.start()

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
	#update sense timer
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
