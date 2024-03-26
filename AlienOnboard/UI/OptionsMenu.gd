extends Control


@onready var fullscreen_checkbox = $PanelContainer/MarginContainer/VBoxContainer2/FullScreenCheck
@onready var screen_shake_checkbox = $PanelContainer/MarginContainer/VBoxContainer2/ScreenShakeCheck
@onready var master_volume_slider = $PanelContainer/MarginContainer/VBoxContainer2/HBoxContainer2/VBoxContainer/MasterVolumeSlider
@onready var sfx_volume_slider = $PanelContainer/MarginContainer/VBoxContainer2/HBoxContainer2/VBoxContainer2/SFXVolumeSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	var videoSettings = ConfigFileHandler.load_video_settings()
	fullscreen_checkbox.button_pressed = videoSettings.FULLSCREEN
	screen_shake_checkbox.button_pressed = videoSettings.SCREEN_SHAKE
	var audioSettings = ConfigFileHandler.load_audio_settings()
	master_volume_slider.value = min(audioSettings.master_volume, 1.0) * 100
	sfx_volume_slider.value = min(audioSettings.sfx_volume, 1.0) * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_full_screen_check_toggled(toggled_on):
	ConfigFileHandler.save_video_settings("FULLSCREEN", toggled_on)


func _on_screen_shake_check_toggled(toggled_on):
	ConfigFileHandler.save_video_settings("SCREEN_SHAKE", toggled_on)


func _on_master_volume_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume",master_volume_slider.value / 100)


func _on_sfx_volume_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", sfx_volume_slider.value / 100)

func _on_config_keybinds_pressed():
		get_tree().change_scene_to_file("res://UI/InputSettings/InputSettings.tscn");


