extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Jump"):
		print("clicked")
		var loadingScreen = load("res://Scenes/NEW_TUTORIAL/loadingSpaceship.tscn") 
		get_tree().change_scene_to_packed(loadingScreen)
