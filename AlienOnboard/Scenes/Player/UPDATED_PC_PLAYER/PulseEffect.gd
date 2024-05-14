extends MeshInstance3D

# Internal Variables.
var distance := 15.0
var is_running := false

# Play with these variables.
@export var max_distance := 20.0
@export var speed := 2.0

# Get the reference to the material to pass data to shader parameters.
@onready var SHADER: ShaderMaterial = self.get_active_material(0)

# Don't forget to assign the start point node to this variable.
@export_node_path("Node3D") var origin_point
@onready var pulse_effect = %PulseEffect
@onready var sense_cooldown_timer = %SenseCooldownTimer
@onready var active_sense_time = %ActiveSenseTime



func _ready():
	# Set the start point of the effect in the shader to the world position of
	# of the origin_point.
	SHADER.set_shader_parameter("start_point", get_node(origin_point).get_global_transform())
	pulse_effect.hide()

func _process(delta):
	if is_running:
		distance += delta * speed
		if distance > max_distance:
			is_running = false
			# Set distance to 0 to stop shader from rendering the effect.
			distance = 0.0
		SHADER.set_shader_parameter("radius", distance)
	
	if Input.is_action_just_pressed("SenseAbility") and sense_cooldown_timer.is_stopped():
		pulse_effect.show()
		active_sense_time.start()
		SHADER.set_shader_parameter("start_point", get_node(origin_point).get_global_transform())		
		is_running = true
		distance = 0.0
	
	if active_sense_time.is_stopped():
		pulse_effect.hide()
		sense_cooldown_timer.start()
		
