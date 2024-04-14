extends ConditionLeaf
@onready var StateLevel2 = preload("res://Scripts/AlarmSystem/StateMachine/StateLevel2.gd")

var _delta_time = 0.0

func _process(delta):
	_delta_time = delta

func tick(actor, blackboard: Blackboard):
	var overlaps = actor.get_node("VisionArea").get_overlapping_bodies()

	#if overlaps.size() > 0:
		#for overlap in overlaps:
			#var objectPosition = overlap.global_transform.origin
			#actor.get_node("VisionRaycast").look_at(objectPosition, Vector3.UP)
			#actor.get_node("VisionRaycast").force_raycast_update()
#
			#if actor.get_node("VisionRaycast").is_colliding():
				#var collider = actor.get_node("VisionRaycast").get_collider()
#
				#if "Player" in collider.name:
					#actor.get_node("VisionRaycast").debug_shape_custom_color = Color(174, 8, 0)
					#return SUCCESS
				#else:
					#actor.get_node("VisionRaycast").debug_shape_custom_color = Color(0,255,0)
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
					var playerPosition = overlap.global_transform.origin
					target = collider
					print("in fov range")
					if StateMachine._current_state != StateLevel2:
						StateMachine._set_state(StateLevel2.new(self, self, playerPosition))
					return SUCCESS
	if target == null:
		#print(target)
		return FAILURE

