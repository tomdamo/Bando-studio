extends Node3D

@onready var waypoint_1 = $WAYPOINT1
@onready var waypoint_2 = $WAYPOINT2
@onready var waypoint_3 = $WAYPOINT3
@onready var gas_timer = $GasTimer
@onready var gas_area_3d = $GasArea3D
@onready var waypoint_4 = $WAYPOINT4
@onready var waypointfinal = $WAYPOINTFINAL

#quests
@onready var quest_1 = $Control/Quest1
@onready var quest_2 = $Control/Quest2
@onready var quest_3 = $Control/Quest3
@onready var quest_4 = $Control/Quest4
@onready var quest_5 = $Control/Quest5
@onready var quest_6 = $Control/Quest6

@onready var player = $Player/PlayerCharacterBody3D
@onready var player_cam = $Player/MainCamera3D

@onready var door_closed_lab = $Rooms/Labroom/RootNode/DoorClosedLab

@onready var security_door = $Rooms/sleep/RootNode/SECURITY_DOOR
var security_door_open = false
var gaurd_kills_goal = 4

func _ready():
	gas_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.guard_kills == gaurd_kills_goal and !security_door_open:
		security_door.queue_free()
		door_closed_lab.queue_free()
		security_door_open = true

func _on_waypoint_1_body_entered(body):
	if "Player" in body.name:
		waypoint_1.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_1.get_position()
		quest_2.hide()
		quest_3.show()

func _on_waypoint_2_body_entered(body):
	if "Player" in body.name:
		waypoint_2.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_2.get_position()
		quest_4.hide()
		quest_5.show()

#UIT DE GASSSSSSSS
func _on_waypoint_first_body_entered(body):
	if "Player" in body.name:
		waypoint_3.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_3.get_position()
		$Control/Quest1.hide()
		$Control/Quest2.show()
		
		$VentCutscene/Camera3D.set_current(true)
		$VentCutscene/AnimationPlayer.play("VentCutscene")
		
		player.global_transform.origin = $Vent_enter.get_position()
		
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


func _on_waypoint_final_body_entered(body):
	if "Player" in body.name:
		waypointfinal.hide()
		get_tree().change_scene_to_file("res://END.tscn")


func _on_animation_player_animation_finished(anim_name):
		$VentCutscene/Camera3D.set_current(false)
		player_cam.set_current(true)
