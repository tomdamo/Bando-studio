extends ActionLeaf

@onready var basic_guard = "$BasicGuard"

@export var _waypoints: Array[Vector3]
var speed: float = 5.0
var _waitTime : float = 1.0
var _waitCounter : float = 0.0
var _waiting :bool = true
var _currentWaypointIndex = 0

var _delta_time = 0.0

func _process(delta):
	_delta_time = delta

func tick(actor, blackboard: Blackboard):
	if (_waiting):
		_waitCounter += _delta_time
		if (_waitCounter >= _waitTime):
			_waiting = false
			return RUNNING
	else:
		var wp :Vector3 = _waypoints[_currentWaypointIndex]
		var distance = actor.global_transform.origin.distance_to(wp)
		if (distance < 0.1):
			actor.global_transform.origin = wp
			_waitCounter= 0.0
			_waiting = true
			_currentWaypointIndex = (_currentWaypointIndex +1) % _waypoints.size()
			return SUCCESS
		else:
			var direction = (wp - actor.global_transform.origin).normalized()
			actor.global_transform.origin += direction * speed * _delta_time

	return RUNNING
