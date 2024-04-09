extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_vision_timer_timeout():
	var overlaps = $VisionArea.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if "Player" in overlap.name:
				var playerPosition = overlap.global_transform.origin
				$VisionRaycast.look_at(playerPosition, Vector3.UP) 
				$VisionRaycast.force_raycast_update()
				
				if $VisionRaycast.is_colliding():
					var collider = $VisionRaycast.get_collider()
					
					if "Player" in collider.name:
						$VisionRaycast.debug_shape_custom_color = Color(174,8,0)
						print("I see you")
					else:
						$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
						print(collider.name)
						

