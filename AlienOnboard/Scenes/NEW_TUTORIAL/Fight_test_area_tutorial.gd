extends Node3D

@onready var waypoint_1 = $WAYPOINT1
@onready var waypoint_2 = $WAYPOINT2
@onready var waypoint_3 = $WAYPOINT3
@onready var control = $Control
@onready var quest_2 = $Control/Quest2
@onready var finish_timer = $FinishTimer
@onready var tip = $Control/Tip
@onready var tip_dna = $Control/TipDNA
@onready var player = $Player/PlayerCharacterBody3D
const POST_TUTORIAL_DIALOGUE = preload("res://Scenes/NEW_TUTORIAL/PostTutorialDialogue.tscn")

var tiphasbeenshown = false
var player_total_kills
var tutorial_done_kills = 8

func _ready():
	control.mouse_filter = true
	
func _process(delta):
	if player.lab_kills >= 1 and !tiphasbeenshown:
		tip.show()
		tip_dna.show()
		tiphasbeenshown = true
	if player.lab_kills > 1 or player.evo_pressed_tip: 
		tip.hide()
		tip_dna.hide()
	if player_total_kills == tutorial_done_kills and finish_timer.is_stopped():
		print("tutorial finished")
		finish_timer.start()
		
func update_kill_count():
	print("kill count updated")
	player.lab_kills += player_total_kills
	player.guard_kills += player_total_kills
	
func _on_waypoint_1_body_entered(body):
	if "Player" in body.name:
		waypoint_1.hide()


func _on_waypoint_2_body_entered(body):
	waypoint_2.hide()


func _on_waypoint_3_body_entered(body):
	waypoint_3.hide()


func _on_finish_timer_timeout():
	get_tree().change_scene_to_packed(POST_TUTORIAL_DIALOGUE)
