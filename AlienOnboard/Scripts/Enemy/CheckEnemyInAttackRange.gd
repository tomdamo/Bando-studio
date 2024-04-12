extends ConditionLeaf

var _delta_time = 0.0

func _process(delta):
	_delta_time = delta

func tick(actor, blackboard: Blackboard):
	var overlaps = actor.find_child("VisionArea").get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			var player :String = "Player"
			if player in overlap.name:
				var playerPosition = overlap.global_transform.origin
				var distance = actor.global_transform.origin.distance_to(playerPosition)
				var direction = (playerPosition - actor.global_transform.origin).normalized()
				actor.find_child("VisionRaycast").look_at(playerPosition, Vector3.UP)
				actor.find_child("VisionRaycast").force_raycast_update()
				print(self)
				return SUCCESS
	return FAILURE
