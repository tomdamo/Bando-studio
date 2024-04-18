extends ActionLeaf

var speed = 5
var _delta_time = 0.0

func _process(delta):
	_delta_time = delta

func tick(actor, blackboard: Blackboard):
	var overlaps = actor.find_child("VisionArea").get_overlapping_bodies()

	if overlaps.size() > 0:
		for overlap in overlaps:
			if "Player" in overlap.name:
				var playerPosition = overlap.global_transform.origin
				var distance = actor.global_transform.origin.distance_to(playerPosition)
				if (distance > 0.1):
					var direction = (playerPosition - actor.global_transform.origin).normalized()
					actor.global_transform.origin += direction * speed * _delta_time
				else:
					if distance > actor.attack_range:
						var direction = (playerPosition - actor.global_transform.origin).normalized()
						actor.global_transform.origin += direction * speed * _delta_time
					else:
						return SUCCESS
					return RUNNING
	return FAILURE
