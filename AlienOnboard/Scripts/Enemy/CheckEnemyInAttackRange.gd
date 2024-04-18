extends ConditionLeaf

var _delta_time = 0.0
var speed: float = 5.0
func _process(delta):
	_delta_time = delta

func tick(actor, blackboard: Blackboard):
	var overlaps = actor.get_node("VisionArea").get_overlapping_bodies()

	var target
	if overlaps.size() > 0:
		for overlap in overlaps:
			var objectPosition = overlap.global_transform.origin
			actor.get_node("VisionRaycast").look_at(objectPosition, Vector3.UP)
			actor.get_node("VisionRaycast").force_raycast_update()
			if actor.get_node("VisionRaycast").is_colliding():
				var collider = actor.get_node("VisionRaycast").get_collider()
				if "Player" in collider.name:
					target = collider
					var playerPosition = overlap.global_transform.origin
					var distance_to_player = actor.global_transform.origin.distance_to(playerPosition)
					if distance_to_player <= actor.attack_range:
						print("is in range")
						return SUCCESS
					else:
						var direction = (playerPosition - actor.global_transform.origin).normalized()
						actor.global_transform.origin += direction * speed * _delta_time
						actor.look_at(playerPosition, Vector3.UP)
						print("Is not in range")
						return FAILURE
	if target == null:
		#print(target)
		return FAILURE

