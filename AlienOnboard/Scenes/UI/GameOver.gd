extends Control

@onready var player = %PlayerCharacterBody3D

func _on_resume_pressed():
	player._pauseMenu()


func _on_quit_pressed():
	get_tree().quit()


func _on_startover_pressed():
	var _reload = get_tree().reload_current_scene() 
