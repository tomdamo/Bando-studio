@tool
extends MeshInstance3D
@export_range(0.0, 1.0) var ang_speed:float = 0.0
var _rotation: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_rotation+=delta*ang_speed
	mesh.material.set_shader_parameter("revolutions", _rotation)
