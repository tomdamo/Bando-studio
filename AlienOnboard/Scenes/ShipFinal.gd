extends Node3D

@onready var animation_player = $Rooms/Labroom/LabroomCutscene/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("LabCutscene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !animation_player.is_playing():
		var loadingScreen = load("res://Scenes/Ship_level_1.tscn") 
		get_tree().change_scene_to_packed(loadingScreen)
		 
