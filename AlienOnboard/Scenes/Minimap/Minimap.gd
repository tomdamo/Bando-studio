extends ColorRect

@export var target : NodePath
@export var camera_distance := 20.0

@onready var player := get_node(target)
@onready var camera := $SubViewportContainer/SubViewport/Camera3D

func _process(delta: float) -> void:
	var player_position = player.global_transform.origin
	if target:
		camera.size = camera_distance
		camera.position = Vector3(player_position.x, camera_distance, player_position.z)
		
