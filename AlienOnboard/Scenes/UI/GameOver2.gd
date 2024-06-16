extends Control

@onready var PLAYER = $"../../PlayerCharacterBody3D"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_over_pressed():
	#if player.respawn_point == null:
		#var loadingScreen = load("res://Scenes/NEW_TUTORIAL/Fight_test_area.tscn")
		#get_tree().change_scene_to_packed(loadingScreen)
	#else:
		#player.respawn()	
	pass	
func _on_quit_pressed():
	print("test")
	get_tree().quit()
