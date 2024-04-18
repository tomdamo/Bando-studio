extends "player_controller.gd"

@onready var _player_pcam: PhantomCamera3D = %PlayerPhantomCamera3D
@onready var _aim_pcam: PhantomCamera3D = %PlayerAimPhantomCamera3D
@onready var _model: Node3D = $PlayerModel
#TODO fix crosshair on aiming, it breaks if you have if statements at the phys process with checking priority, also at aim method..
@onready var _crosshair: TextureRect = %PlayerCharacterBody3D/Control/Crosshair
@export var mouse_sensitivity: float = 0.05
@export var controller_sensitivity_horizontal: float = 0.5
@export var controller_sensitivity_vertical: float = 0.3

@export var min_yaw: float = -89.9
@export var max_yaw: float = 50

@export var min_pitch: float = 0
@export var max_pitch: float = 360



func _ready() -> void:
	super()
	if _player_pcam.get_follow_mode() == _player_pcam.Constants.FollowMode.THIRD_PERSON:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_crosshair.hide()

func _physics_process(delta: float) -> void:
	super(delta)

	if velocity.length() > 0.2 and not dashing and is_on_floor():
		var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
		_model.rotation.y = look_direction.angle()
		

func _unhandled_input(event: InputEvent) -> void:
	if _player_pcam.get_follow_mode() == _player_pcam.Constants.FollowMode.THIRD_PERSON:
		var active_pcam: PhantomCamera3D

		if is_instance_valid(_aim_pcam):
			_set_pcam_rotation(_player_pcam, event)
			_set_pcam_rotation(_aim_pcam, event)
			if _player_pcam.get_priority() > _aim_pcam.get_priority():
				_toggle_aim_pcam(event)
			else:
				_toggle_aim_pcam(event)


func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
	var pcam_rotation_degrees: Vector3

	# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
	pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()

	# Get the joystick input
	var right_input = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")
	var up_input = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	# Change the X rotation
	pcam_rotation_degrees.x -= up_input * controller_sensitivity_vertical

	# Change the Y rotation value
	pcam_rotation_degrees.y -= right_input * controller_sensitivity_horizontal


	if event is InputEventMouseMotion:
		# Change the X rotation
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity

		# Change the Y rotation value
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity

	# Clamp the rotation in the X axis so it go over or under the target
	pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_yaw, max_yaw)

	# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
	pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_pitch, max_pitch)

	# Change the SpringArm3D node's rotation and rotate around its target
	pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)

func _toggle_aim_pcam(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.is_pressed() \
		and event.button_index == 2 \
		and (_player_pcam.is_active() or _aim_pcam.is_active()):
		if _player_pcam.get_priority() > _aim_pcam.get_priority():
			_aim_pcam.set_priority(30)
		else:
			_aim_pcam.set_priority(0)
