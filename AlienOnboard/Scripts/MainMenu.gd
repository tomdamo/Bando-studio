extends Control

@onready var loadTime = $LoadTime

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loadTime.is_stopped():
		get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn");
	
func _on_start_button_pressed():
	loadTime.start()
	
#this needs to change, to get back to the previous scene / menu.
func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://OptionsMenu.tscn");


func _on_quit_button_pressed():
	get_tree().quit();
