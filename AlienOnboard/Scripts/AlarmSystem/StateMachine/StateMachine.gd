extends Node3D

var StateLevel0 = preload("res://Scripts/AlarmSystem/StateMachine/StateLevel0.gd")
var _current_state

func _ready():
	_set_state(StateLevel0.new())

func _set_state(state):
	if _current_state != null:
		_current_state.exit()
	_current_state = state
	if _current_state != null:
		_current_state.enter()

func get_current_state():
	return _current_state

func update(delta):
	if _current_state != null:
		_current_state.update(delta)
