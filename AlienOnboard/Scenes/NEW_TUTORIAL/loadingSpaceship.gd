extends Control
var progress = []
var sceneName
var sceneLoadStatus = 0

@onready var countdown = $Panel/countdown

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneName = "res://Scenes/NEW_TUTORIAL/Fight_test_area.tscn"
	ResourceLoader.load_threaded_request(sceneName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sceneLoadStatus = ResourceLoader.load_threaded_get_status(sceneName,progress)
	countdown.text = str(floor(progress[0]*100)) + "%"
	if sceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
