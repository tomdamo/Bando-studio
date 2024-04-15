extends ConditionLeaf

var _delta_time = 0.0

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
#
				if "Player" in collider.name:
					target = collider
					return SUCCESS
	if target == null:
		#print(target)
		return FAILURE

