extends ConditionLeaf

@onready var player = $Player
var _transform : Transform3D
var _collider3D : CollisionObject3D

var vision_area = self.get_children()

func tick(actor, blackboard: Blackboard):
	var overlaps = actor.find_child("VisionArea").get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if "Player" in overlap.name:
				var playerPosition = overlap.global_transform.origin
				actor.find_child("VisionRaycast").look_at(playerPosition, Vector3.UP)
				actor.find_child("VisionRaycast").force_raycast_update()

				if actor.find_child("VisionRaycast").is_colliding():
					var collider = actor.find_child("VisionRaycast").get_collider()
					if "Player" in collider.name:
						actor.find_child("VisionRaycast").debug_shape_custom_color = Color(174,8,0)
						print(self)
				return SUCCESS
	return FAILURE
