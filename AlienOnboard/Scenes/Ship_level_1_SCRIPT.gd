extends Node3D

@onready var waypoint_1 = $WAYPOINT1
@onready var player = $Player/PlayerCharacterBody3D
@onready var waypoint_2 = $WAYPOINT2
@onready var waypoint_3 = $WAYPOINT3
@onready var gas_timer = $GasTimer
@onready var gas_area_3d = $GasArea3D
@onready var waypoint_4 = $WAYPOINT4

# Called when the node enters the scene tree for the first time.
func _ready():
	gas_timer.start()


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
		waypoint_2.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_2.get_position()


func _on_waypoint_first_body_entered(body):
	if "Player" in body.name:
		waypoint_3.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_3.get_position()
		$Control/Quest1.hide()
		$Control/Quest2.show()
		
func _on_gas_timer_timeout():
	var overlaps = gas_area_3d.get_overlapping_bodies()
	for body in overlaps:
		if body.is_in_group("Player"):
			player.die()
			gas_timer.start()


func _on_gas_area_3d_body_entered(body):
	if "Player" in body.name:
		if gas_timer.is_stopped():
			player.die()
			gas_timer.start()
		else:
			print("Get yo ass outta the gas")


func _on_waypoint_start_body_entered(body):
	if "Player" in body.name:
		waypoint_4.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_4.get_position()
