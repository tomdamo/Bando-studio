extends Node3D


@onready var pause_menu = $OptionsMenu

var game_paused = false;
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			Engine.time_scale = 1
			pause_menu.visible = false

		else:
			Engine.time_scale = 0
			pause_menu.visible = true
		get_tree().root.get_viewport().set_input_as_handled()
