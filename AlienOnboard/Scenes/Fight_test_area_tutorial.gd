extends Node3D


@onready var player = %PlayerChar

@onready var waypoint_1 = $WAYPOINT1
@onready var waypoint_2 = $WAYPOINT2
@onready var waypoint_3 = $WAYPOINT3
@onready var control = $Control
@onready var quest_2 = $Control/Quest2
@onready var finish_timer = $FinishTimer

func _ready():
	player = get_node("Player/PlayerCharacterBody3D")
	control.mouse_filter = true
	
func _process(delta):
	
	if player.player_kills >= 7:
		quest_2.show()
		if !finish_timer.is_stopped():
			finish_timer.start()
		
		
func _on_waypoint_1_body_entered(body):
	if "Player" in body.name:
		waypoint_1.hide()


func _on_waypoint_2_body_entered(body):
	waypoint_2.hide()


func _on_waypoint_3_body_entered(body):
	waypoint_3.hide()


func _on_finish_timer_timeout():
	pass
