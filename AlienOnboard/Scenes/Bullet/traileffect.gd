extends MeshInstance3D

var _points = []
var _widths = []
var _lifePoints = []

@export var _trailEnabled : bool = true

@export var _fromWidth : float = 0.5
@export var _toWidth : float = 0.0
@export_range(0.5, 1.5) var _scaleAcceleration : float = 1.0

@export var _motionDelta : float = 0.1
@export var _lifeSpan : float = 1.0

@export var _startColor : Color = Color(1, 0, 0, 0)
@export var _endColor : Color = Color(1, 1, 1, 0)

var _oldPos : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	_oldPos = global_transform.origin
	mesh = ImmediateMesh.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(_oldPos - global_transform.origin).length() > _motionDelta and _trailEnabled:
		AppendPoint()
		_oldPos = global_transform.origin
	
	var p = 0
	var max_p = _points.size()
	while p < max_p:
		_lifePoints[p] += delta
		if _lifePoints[p] > _lifeSpan:
			RemovePoint(p)
			max_p -= 1
			if(p < 0): p = 0

		max_p = _points.size()
		p += 1

	mesh.clear_surfaces()
		
	if _points.size() < 2:
		return

	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(_points.size()):
		var t = float(i) / float(_points.size() - 1.0)
		var currColor = _startColor.lerp(_endColor, 1 - t)
		mesh.surface_set_color(currColor)

		var currWidth = _widths[i][0] + pow(1 -t, _scaleAcceleration) * _widths[i][1]

		var t0 = i / _points.size()
		var t1 = t

		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_add_vertex(_points[i] + currWidth)
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(_points[i] - currWidth))
	mesh.surface_end()
	
func AppendPoint():
	_points.append(global_transform.origin)
	_widths.append([
		get_global_transform().basis.x * _fromWidth,
		get_global_transform().basis.y * _fromWidth - get_global_transform().basis.y * _toWidth
	])
	_lifePoints.append(0.0)

func RemovePoint(i):
	_points.remove(i)
	_widths.remove(i)
	_lifePoints.remove(i)
