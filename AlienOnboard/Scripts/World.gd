extends Node3D

@onready var player = %PlayerCharacterBody3Dd
@onready var StateLevel2 = preload("res://Scripts/AlarmSystem/StateMachine/StateLevel2.gd")

func _ready():
	#StateMachine._set_state(StateLevel2.new(self, self))
	pass
