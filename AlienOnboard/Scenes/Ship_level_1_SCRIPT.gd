extends Node3D

@onready var waypoint_1 = $WAYPOINT1
@onready var player = $Player/PlayerCharacterBody3D
@onready var waypoint_2 = $WAYPOINT2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_waypoint_1_body_entered(body):
	if "Player" in body.name:
		waypoint_1.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_1.get_position()


func _on_waypoint_2_body_entered(body):
	if "Player" in body.name:
		waypoint_1.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_2.get_position()
