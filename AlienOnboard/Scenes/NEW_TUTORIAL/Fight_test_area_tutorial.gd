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

@onready var intro = $Control/INTRO

var tiphasbeenshown = false
var player_total_kills
var tutorial_done_kills = 8

func _ready():
	control.mouse_filter = true
	$Control/IntroTextTimer.start()
	player.set_floor_max_angle(0.785398)

func _process(delta):
	if player.lab_kills >= 1 and !tiphasbeenshown:
		tip.show()
		tip_dna.show()
		tiphasbeenshown = true
	if player.lab_kills > 1 or player.evo_pressed_tip:
		tip.hide()
		tip_dna.hide()
	if player.guard_kills == 2:
		print("tutorial finished")
		if finish_timer.is_stopped():
			finish_timer.start()

func update_kill_count():
	print("kill count updated")
	player.lab_kills += player_total_kills
	player.guard_kills += player_total_kills

func _on_waypoint_1_body_entered(body):
	if "Player" in body.name:
		waypoint_1.hide()
		#Set respawn point/checkpoint
		player.respawn_point = waypoint_1.get_position()
#WAPOINT1.poisition
func _on_waypoint_2_body_entered(body):
	waypoint_2.hide()
	player.respawn_point = waypoint_2.get_position()

func _on_waypoint_3_body_entered(body):
	waypoint_3.hide()
	player.respawn_point = waypoint_3.get_position()


func _on_finish_timer_timeout():
	get_tree().change_scene_to_packed(POST_TUTORIAL_DIALOGUE)


func _on_intro_text_timer_timeout():
	intro.hide()

