extends ActionLeaf
@onready var basic_guard = "$BasicGuard"

@export var _waypoints: Array[Vector3]
@export var speed: float = 5.0
@export var _waitTime : float = 1.0
@export var _waitCounter : float = 0.0
var _waiting :bool = true
var _currentWaypointIndex : int = 0

var _actor
var _blackboard

func _process(delta):
	if (_waiting):
		_waitCounter += delta
		if (_waitCounter >= _waitTime):
			_waiting = false
	else:
		var wp :Vector3 = _waypoints[_currentWaypointIndex]
		var distance = _actor.global_transform.origin.distance_to(wp)
		if (distance < 0.01):
			_actor.global_transform.origin = wp
			_waitCounter= 0.0
			_waiting = true
			_currentWaypointIndex = (_currentWaypointIndex +1) % _waypoints.size()
		else:
			var direction = (wp - _actor.global_transform.origin).normalized()
			_actor.global_transform.origin += direction * speed * delta

func tick(actor, blackboard: Blackboard):
	_actor =actor
	_blackboard = blackboard
	return RUNNING
