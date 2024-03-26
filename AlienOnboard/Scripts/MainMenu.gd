extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#For now we can f around in the practiceRange ?
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://PracticeRange.tscn");

#this needs to change, to get back to the previous scene / menu.
func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://UI/OptionsMenu.tscn");


func _on_quit_button_pressed():
	get_tree().quit();
