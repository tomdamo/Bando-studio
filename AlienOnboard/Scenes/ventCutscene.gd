extends Node3D

@onready var animation_player = $VentCutscene/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("LabCutscene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !animation_player.is_playing():
		pass
