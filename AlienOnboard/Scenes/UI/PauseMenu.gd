extends Control

@onready var player = %PlayerCharacterBody3D

func _on_resume_pressed():
	player._pauseMenu()


func _on_options_pressed():
	get_tree().change_scene_to_file("res://UI/OptionsMenu.tscn");


func _on_quit_pressed():
	get_tree().quit()
