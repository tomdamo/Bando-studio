extends Node


var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "res://settings.cfg"

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("KEYBINDING", "MOVE_UP", "W")
		config.set_value("KEYBINDING", "MOVE_DOWN", "S")
		config.set_value("KEYBINDING", "MOVE_LEFT", "A")
		config.set_value("KEYBINDING", "MOVE_RIGHT", "D")
		config.set_value("KEYBINDING", "ATTACK", "mouse_1")
		config.set_value("KEYBINDING", "INTERACT", "E")

		config.set_value("VIDEO", "FULLSCREEN", true)
		config.set_value("VIDEO", "SCREEN_SHAKE", false)

		config.set_value("AUDIO", "master_volume", 1.0)
		config.set_value("AUDIO", "sfx_volume", 1.0)
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_video_settings(key: String, value):
	config.set_value("VIDEO", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("VIDEO"):
		video_settings[key] = config.get_value("VIDEO",key)
	return video_settings

func save_audio_settings(key: String, value):
	config.set_value("AUDIO", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("AUDIO"):
		audio_settings[key] = config.get_value("AUDIO",key)
	return audio_settings

func save_keybinding(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)

	config.set_value("KEYBINDING", action, event_str)
	config.save(SETTINGS_FILE_PATH)

func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("KEYBINDING")
	for key in keys:
		var input_event
		var event_str = config.get_value("KEYBINDING", key)

		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)

		keybindings[key] = input_event
	return keybindings






