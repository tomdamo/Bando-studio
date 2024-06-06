extends Control

@onready var options_menu = $Control/OptionsMenu
@onready var player = $"../../PlayerCharacterBody3D"
@onready var pause_margin_container = $Control/PauseMarginContainer


func _ready():
	options_menu.hide()

func _on_resume_pressed():
	player._pauseMenu()

func _on_options_pressed():
	options_menu.show()
	pause_margin_container.hide()


func _on_quit_pressed():
	get_tree().quit()
