extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_over_pressed():
	var loadingScreen = load("res://Scenes/UI/loading.tscn")
	get_tree().change_scene_to_packed(loadingScreen)


func _on_quit_pressed():
	print("test")
	get_tree().quit()
