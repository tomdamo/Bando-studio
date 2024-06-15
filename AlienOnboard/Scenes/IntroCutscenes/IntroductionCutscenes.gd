extends Node3D

@onready var text_nodes = [%Text1, %Text2, %Text3, %Text4, %Text5, %Text6]
var current_dialogue = 0

func _process(delta):
	
	if Input.is_action_just_pressed("Jump"):
		# Hide the current dialogue
		text_nodes[current_dialogue].hide()

		# Increment the counter
		current_dialogue += 1

		# If there's a next dialogue, show it
		if current_dialogue < text_nodes.size():
			text_nodes[current_dialogue].show()
		else:
			var loadingScreen = load("res://Scenes/UI/loading.tscn")
			get_tree().change_scene_to_packed(loadingScreen)
			
func _ready():
	current_dialogue = 1
	text_nodes[current_dialogue].show()
