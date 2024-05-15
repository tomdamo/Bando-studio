extends ConditionLeaf

const SPEED = 5.0
const GRAVITY = -9.8

var health = 6
var death = false
@onready var blood = %BloodEffect
@onready var bloodTimer = %BloodTimer

@onready var VisionArea = %VisionArea
@onready var VisionRaycast = %VisionRaycast
@onready var VisionTimer = %VisionTimer

@onready var shot_timer = %ShotTimer
@onready var spotted_label = $SpottedLabel

var Bullet = preload("res://Scenes/Bullet/Bullet.tscn")
var player_position = Vector3.ZERO # target

@onready var navigation_agent = $NavigationAgent3D

func tick(actor, blackboard: Blackboard):
	if !death:
		var overlaps = %VisionArea.get_overlapping_bodies()
		if overlaps.size() > 0:
			for overlap in overlaps:
				if "Player" in overlap.name:
					var playerPosition = overlap.global_transform.origin
					var directionToPlayer = (playerPosition - actor.global_transform.origin).normalized()
					var forwardDirection = -actor.transform.basis.z
				
					var angle = acos(forwardDirection.dot(directionToPlayer))

					if angle < PI / 2:
						playerPosition.y -= 0.5
						$VisionRaycast.look_at(playerPosition, Vector3.UP)
						$VisionRaycast.force_raycast_update()

						if $VisionRaycast.is_colliding():
							var collider = $VisionRaycast.get_collider()

							if "Player" in collider.name:
								$VisionRaycast.debug_shape_custom_color = Color(174,8,0)
								print("I see you")
								spotted_label.show()
								player_position = playerPosition
								actor.look_at(player_position, Vector3.UP)																
								return SUCCESS
							else:
								$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
								print(collider.name)
								spotted_label.hide()								
