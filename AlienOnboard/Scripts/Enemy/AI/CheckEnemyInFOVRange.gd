extends ConditionLeaf

@onready var player = $Player
var _transform : Transform3D
var _collider3D : CollisionObject3D


func tick(actor, blackboard: Blackboard):

	if player == null:
		var colliders : Array[CollisionObject3D]


	return SUCCESS

